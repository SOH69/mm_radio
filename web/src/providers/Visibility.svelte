<script lang="ts">
    import { Receive, Send } from '@enums/events';
    import { VISIBLE, CONFIG, SHOW, RADIODATA, SHOWPLAYERLIST, SHOWFORCEPLAYERLIST } from '@stores/stores';
    import { ReceiveEvent, SendEvent } from '@utils/eventsHandlers';
    import { onMount } from 'svelte';

    ReceiveEvent(Receive.radioVisible, (data: any) => {
		VISIBLE.set(true)
		SHOW.set(true)
		RADIODATA.set(data)
		SHOWPLAYERLIST.set(data.userData.playerlist.show)
	});

	ReceiveEvent(Receive.updateRadio, (data: any) => {
		RADIODATA.set(data)
		SHOWPLAYERLIST.set(data.userData.playerlist.show)
	});

	ReceiveEvent(Receive.updateTime, (data: string) => {
		RADIODATA.update((old: any) => {
			return { ...old, time: data }
		})
	});

	ReceiveEvent(Receive.radioHide, () => {
		SHOW.set(false)
	});

	ReceiveEvent(Receive.jammer, (state: boolean) => {
		RADIODATA.update((old: any) => {
			return { ...old, insideJammerZone: state }
		})
	});

    onMount(() => {
        if (!$CONFIG.allowEscapeKey) return;

        const keyHandler = (e: KeyboardEvent) => {
            if ($VISIBLE && ['Escape'].includes(e.code)) {
                SendEvent(Send.hide);
                SHOW.set(false)
				SHOWFORCEPLAYERLIST.set(false)
            }
        };
        window.addEventListener('keydown', keyHandler);
        return () => window.removeEventListener('keydown', keyHandler);
    });
</script>

{#if $VISIBLE}
    <main>
        <slot />
    </main>
{/if}

<style>
    main {
        position: absolute;
        left: 0;
        top: 0;
        z-index: 100;
        user-select: none;
        box-sizing: border-box;
        padding: 0;
        margin: 0;
        height: 100vh;
        width: 100vw;
    }
</style>
