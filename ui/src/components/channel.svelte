<script lang="ts">
	import ChannelTab from "./channelTab.svelte"
    import { RADIODATA } from "@store/stores";

    let currenttab = 'favourite'

    function changeTab(tab: string) {
        currenttab = tab
    }
</script>

<div class="w-full h-[20.8vh] flex flex-col p-4 gap-[0.5vh] grow-0 shrink-0">
    <div class="w-full h-full rounded-[0.3vw] bg-[#18162F] flex flex-col gap-[1vh] drop-shadow-md">
        <ChannelTab channels={$RADIODATA[currenttab]}/>
    </div>
</div>

<div class="w-full h-[4.2vh] bg-[#18162F] flex px-4 pt-2 gap-[1vh] grow-0 shrink-0">
    <button class="flex flex-col items-center justify-center grow gap-[0.2vh]" style="color: {currenttab=='favourite'? "white":"#212146"};" on:click={() => changeTab('favourite')}>
        <i class="fa-solid fa-star text-[1.8vh]"></i>
        <span class="text-[0.8vh]">{$RADIODATA.locale['ui.favorites']}</span>
    </button> 
    <button class="flex flex-col items-center justify-center grow gap-[0.2vh]" style="color: {currenttab=='recomended'? "white":"#212146"};" on:click={() => changeTab('recomended')}>
        <i class="fa-solid fa-clock text-[1.8vh]"></i>
        <span class="text-[0.8vh]">{$RADIODATA.locale['ui.recommended']}</span>
    </button>  
</div>