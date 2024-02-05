<script lang="ts">
    import { RADIODATA } from '@store/stores'
    import '@fortawesome/fontawesome-free/css/all.min.css'
	import { ReceiveNUI } from '@utils/ReceiveNUI'
    import { slide } from 'svelte/transition';
    import MarqueeTextWidget from "svelte-marquee-text-widget";
    let showmsg: string = null;
    let timeoutTick = null

    ReceiveNUI('notify', (data: any) => {
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
    <div class="w-full h-[3vh] bg-[#18162F] flex items-center justify-between px-4 text-white text-[1.5vh] rounded-t-md overflow-hidden whitespace-nowrap">
        {#if showmsg.length >= 39}
            <MarqueeTextWidget>
                <div class="mr-4 font-bold w-full text-center text-[0.6vw]">
                    {showmsg}
                </div>
            </MarqueeTextWidget>
        {:else}
            <span transition:fadeSlide="{{duration: 300}}" class="font-bold w-full text-center text-[0.6vw] overflow-hidden">{showmsg}</span>
        {/if}
    </div>
{:else}
    <div transition:fadeSlide="{{duration: 300}}" class="w-full h-[3vh] bg-[#18162F] flex items-center justify-between px-4 text-white text-[1.5vh] rounded-t-lg">
        <i class="fa-solid fa-satellite-dish animate-pulse animate-infinite animate-duration-100"></i>
        <span class="font-bold">{$RADIODATA.time}</span>
        <i class="fa-solid fa-battery-full"></i>
    </div>
{/if}
