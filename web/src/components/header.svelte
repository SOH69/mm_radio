<script lang="ts">
    import { RADIODATA } from '@stores/stores'
	import { ReceiveEvent } from '@utils/eventsHandlers';
    import { slide } from 'svelte/transition';
    import MarqueeTextWidget from "svelte-marquee-text-widget";
    import { Receive } from '@enums/events';
    let showmsg: string = null;
    let timeoutTick = null

    ReceiveEvent(Receive.notify, (data: any) => {
        showmsg = data.msg
        clearTimeout(timeoutTick)
        timeoutTick = setTimeout(() => {
            showmsg = null
            timeoutTick = null
        }, data.duration || 5000)
    })

    function fadeSlide(node, options) {
		const slideTrans = slide(node, options)
		return {
			duration: options.duration,
            ...slideTrans
		};
	}
</script>

{#if showmsg}
    <div class="relative w-full h-[33px] bg-[#18162F] flex items-center justify-between px-4 text-white text-[16px] overflow-hidden whitespace-nowrap">
        {#if showmsg.length >= 26}
            <MarqueeTextWidget>
                <div class="mr-4 font-bold w-full text-center text-[12px]">
                    {showmsg}
                </div>
            </MarqueeTextWidget>
        {:else}
            <span transition:fadeSlide="{{duration: 300}}" class="font-bold w-full text-center text-[12px] overflow-hidden">{showmsg}</span>
        {/if}
    </div>
{:else}
    <div transition:fadeSlide="{{duration: 300}}" class="relative w-full h-[32px] bg-[#18162F] flex items-center justify-between px-4 text-white text-[16px]">
        {#if $RADIODATA.insideJammerZone}
            <i class="fa-solid fa-triangle-exclamation animate-pulse animate-infinite animate-duration-100 text-red-500"></i>
        {:else}
            <i class="fa-solid fa-satellite-dish animate-pulse animate-infinite animate-duration-100 text-white"></i>
        {/if}
        <span class="font-bold">{$RADIODATA.time}</span>
        {#if $RADIODATA.battery >= 80}
            <i class="fa-solid fa-battery-full"></i>
        {:else if $RADIODATA.battery >= 60}
            <i class="fa-solid fa-battery-three-quarters"></i>
        {:else if $RADIODATA.battery >= 40}
            <i class="fa-solid fa-battery-half"></i>
        {:else if $RADIODATA.battery >= 20}
            <i class="fa-solid fa-battery-quarter text-yellow-500"></i>
        {:else}
            <i class="fa-solid fa-battery-empty text-red-500 animate-pulse"></i>
        {/if}
    </div>
{/if}
