<script lang="ts">
	import ChannelTab from "./channelTab.svelte"
    import { RADIODATA } from "@stores/stores";

    let currenttab = 'favourite'

    function changeTab(tab: string) {
        currenttab = tab
    }
</script>

<div class="w-full h-[220px] flex flex-col p-4 gap-[5.5px] grow-0 shrink-0">
    <div class="w-full h-full rounded-[6px] bg-[#18162F] flex flex-col gap-[11px] shadow-md shadow-[#18162F]/40">
        <ChannelTab channels={$RADIODATA[currenttab]}/>
    </div>
</div>

<div class="w-full h-[45px] bg-[#18162F] flex px-4 pt-2 gap-[11px] grow-0 shrink-0">
    <button class="flex flex-col items-center justify-center grow gap-[2px]" style="color: {currenttab=='favourite'? "white":"#212146"};" on:click={() => changeTab('favourite')}>
        <i class="fa-solid fa-star text-[19.5px]"></i>
        <span class="text-[9px]">{$RADIODATA.locale['ui.favorites']}</span>
    </button> 
    <button class="flex flex-col items-center justify-center grow gap-[2px]" style="color: {currenttab=='recomended'? "white":"#212146"};" on:click={() => changeTab('recomended')}>
        <i class="fa-solid fa-clock text-[19.5px]"></i>
        <span class="text-[9px]">{$RADIODATA.locale['ui.recommended']}</span>
    </button>  
</div>