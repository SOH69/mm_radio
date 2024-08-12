<script lang="ts">
    import { ReceiveEvent } from "@utils/eventsHandlers";
    import { RADIODATA, SHOWPLAYERLIST, PLAYERLIST } from "@stores/stores";
    import { SendEvent } from "@utils/eventsHandlers";
    import { Receive, Send } from "@enums/events";
    import { onMount } from "svelte";
    import { writable } from "svelte/store";
    export let changeTab;

    const muted = writable<boolean[]>([]);

    ReceiveEvent(Receive.updateRadioTalking, (data: any) => {
		$PLAYERLIST[data.radioId].isTalking = data.radioTalking
	})

    function showPlayerList() {
        SHOWPLAYERLIST.set(!$SHOWPLAYERLIST)
        SendEvent(Send.showPlayerList, $SHOWPLAYERLIST)
    }

    function mutePlayer(id: string) {
        SendEvent(Send.togglemutePlayer, Number(id)).then((data: boolean[]| null) => {
            if (data == null) return;
            muted.set(data);
        })
    }

    onMount(() => {
        SendEvent(Send.getMutedList).then((data: any) => {
            muted.set(data);
        })
    })

</script>

{#if $PLAYERLIST != null}
    <div class="w-full h-[230px] p-4">
        <div class="w-full h-full bg-[#18162F] rounded-[6px] text-white font-bold overflow-scroll no-scrollbar shadow-md shadow-[#18162F]/40">
            {#each Object.entries($PLAYERLIST) as [id, player], index (id)}
                <div class="flex justify-between w-full h-[32px] items-center px-4">
                    <div class="flex items-center gap-[11px]">
                        <div class="w-[13px] h-[13px] rounded-full" style="background-color: {player.isTalking? "white":"#212146"}"></div>
                        <span class="text-[11px]">{player.name}</span>
                    </div>
                    <button on:click={()=> mutePlayer(id)}><i class="fa-solid fa-microphone-slash text-[10px]" style="color: {$muted[Number(id)-1] ? "white":"#616161"}"></i></button>
                </div>
            {/each}
        </div>
    </div>

    <div class="w-full pb-4 px-4 flex gap-2">
        <button class="w-[70%] py-3 bg-[#18162F] flex justify-center items-center gap-[11px] text-white text-[11px] rounded-[6px] font-bold shadow-md shadow-[#18162F]/40" on:click={()=> showPlayerList()}>{$SHOWPLAYERLIST? $RADIODATA.locale['ui.hide_overlay']:$RADIODATA.locale['ui.show_overlay']}</button>
        <button class="w-[25%] py-3 bg-[#18162F] flex justify-center items-center gap-[11px] text-white text-[11px] rounded-[6px] font-bold shadow-md shadow-[#18162F]/40" on:click={changeTab('setting')}>
            <i class="fa-solid fa-gear text-[14px]"></i>
        </button>
    </div>
{/if}