<script lang="ts">
    import { SendNUI } from '../utils/SendNUI'
    export let channels = []
	import Marquee from './marquee.svelte'
</script>

<div class="w-full h-full overflow-scroll no-scrollbar">
    {#each channels as channel}
        <div class="flex justify-between border-b-[1px] border-[#9696968a] text-white px-4 items-center">
            <div class="w-[5vw] h-[3.5vh] font-bold flex items-center overflow-hidden whitespace-nowrap">
                <Marquee channel={channel}/>
            </div>
            <i class="fa-solid fa-circle-arrow-right cursor-pointer" on:click={(e) => SendNUI('join', channel)}></i>
        </div>
    {/each}
</div>