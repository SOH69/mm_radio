<script lang='ts'>
    import { Send } from "@enums/events";
    export let changeTab: (tabName: string) => void
    import { MOVERADIO, RADIODATA } from "@stores/stores";
    import { SendEvent } from "@utils/eventsHandlers";
    let inputValue = $RADIODATA.userData.name;
    let overlaySize = $RADIODATA.userData.overlaySizeMultiplier;
    let radioSize = $RADIODATA.userData.radioSizeMultiplier;

    function saveData() {
        SendEvent(Send.saveData, {name: inputValue, radioId: $RADIODATA.radioId})
        changeTab('members')
    }

    function changeOverlaySize(event: any) {
        overlaySize = event.target.value;
        RADIODATA.update((data: any) => {
            data.userData.overlaySizeMultiplier = overlaySize;
            return data;
        })
    }

    function changeRadioSize(event: any) {
        radioSize = event.target.value;
        RADIODATA.update((data: any) => {
            data.userData.radioSizeMultiplier = radioSize;
            return data;
        })
    }

    function handleSliderRelease() {
        SendEvent(Send.updateRadioSize, { overlay: overlaySize, radio: radioSize })
    }

    function toggleRadioMove(event: any) {
        MOVERADIO.set(event.target.checked);
    }

    function toggleMovement(event: any) {
        RADIODATA.update((data: any) => {
            data.userData.allowMovement = event.target.checked;
            return data;
        })
        SendEvent(Send.allowMovement, event.target.checked);
    }

    function toggleClicks(event: any) {
        RADIODATA.update((data: any) => {
            data.userData.enableClicks = event.target.checked;
            return data;
        })
        SendEvent(Send.enableClicks, event.target.checked);
    }
    
</script>

<div class="w-full h-[223.5px] p-4">
    <div class="w-full h-full bg-[#18162F] rounded-[6px] text-white font-bold overflow-scroll no-scrollbar px-4 py-2 shadow-md shadow-[#18162F]/40">
        <div class="flex flex-col w-full gap-2 border-b-[1px] border-gray-700 pb-4">
            <span class="text-[14px]">{$RADIODATA.locale['ui.radio_settings']}</span>
            <div class="flex gap-2">
                <div class="h-[20px] w-[18px] rounded-md flex justify-center items-center bg-[#0e0d1a]">
                    <i class="fa-solid fa-up-right-and-down-left-from-center text-[8px]"></i>
                </div>
                <div class="h-[20px] w-[106px] flex justify-center items-center">
                    <input type="range" bind:value={radioSize} class="h-2 w-[106px] bg-gray-200 rounded-lg appearance-none cursor-pointer dark:bg-gray-700" on:input={changeRadioSize} on:mouseup={handleSliderRelease} disabled={$MOVERADIO} min="25" max="75"/>
                </div>
            </div>
            <div class="flex gap-2">
                <div class="h-[20px] w-[18px] rounded-md flex justify-center items-center bg-[#0e0d1a] gap-2">
                    <i class="fa-solid fa-maximize text-[8px]"></i>
                </div>
                <span class="text-[10px] flex justify-center items-center">{$RADIODATA.locale['ui.move_radio']}</span>
                <div class="h-[20px] flex items-center pl-6">
                    <label class="inline-flex items-center cursor-pointer">
                        <input type="checkbox" value="" class="sr-only peer" checked={$MOVERADIO} on:input={toggleRadioMove}>
                        <div class="relative w-11 h-6 bg-gray-200 rounded-full peer peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                    </label>
                </div>
            </div>
            <div class="flex gap-2">
                <div class="h-[20px] w-[18px] rounded-md flex justify-center items-center bg-[#0e0d1a] gap-2">
                    <i class="fa-solid fa-maximize text-[8px]"></i>
                </div>
                <span class="text-[10px] flex justify-center items-center">{$RADIODATA.locale['ui.allow_move']}</span>
                <div class="h-[20px] flex items-center pl-6">
                    <label class="inline-flex items-center cursor-pointer">
                        <input type="checkbox" value="" class="sr-only peer" checked={$RADIODATA.userData.allowMovement} on:input={toggleMovement}>
                        <div class="relative w-11 h-6 bg-gray-200 rounded-full peer peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                    </label>
                </div>
            </div>
            <div class="flex gap-2">
                <div class="h-[20px] w-[18px] rounded-md flex justify-center items-center bg-[#0e0d1a] gap-2">
                    <i class="fa-solid fa-volume-high text-[8px]"></i>
                </div>
                <span class="text-[10px] flex justify-center items-center">{$RADIODATA.locale['ui.enableClicks']}</span>
                <div class="h-[20px] flex items-center pl-6">
                    <label class="inline-flex items-center cursor-pointer">
                        <input type="checkbox" value="" class="sr-only peer" checked={$RADIODATA.userData.enableClicks} on:input={toggleClicks}>
                        <div class="relative w-11 h-6 bg-gray-200 rounded-full peer peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                    </label>
                </div>
            </div>
        </div>

        {#if $RADIODATA.overlay != 'never'}
            <div class="flex flex-col w-full gap-4 pb-4 pt-4">
                <span class="text-[14px]">{$RADIODATA.locale['ui.overlay_settings']}</span>
                <div class="flex gap-2">
                    <div class="h-[20px] w-[18px] rounded-md flex justify-center items-center bg-[#0e0d1a]">
                        <i class="fa-solid fa-user text-[8px]"></i>
                    </div>
                    <input type="text" class="h-[20px] w-[106px] bg-[#212146] text-white px-4 rounded-md text-[10px]" bind:value={inputValue} />
                </div>
                <div class="flex gap-2">
                    <div class="h-[20px] w-[18px] rounded-md flex justify-center items-center bg-[#0e0d1a]">
                        <i class="fa-solid fa-up-right-and-down-left-from-center text-[8px]"></i>
                    </div>
                    <div class="h-[20px] w-[106px] flex justify-center items-center">
                        <input type="range" bind:value={overlaySize} class="h-2 w-[106px] bg-gray-200 rounded-lg appearance-none cursor-pointer dark:bg-gray-700" on:input={changeOverlaySize} on:mouseup={handleSliderRelease} disabled={$MOVERADIO} min="25" max="75"/>
                    </div>
                </div>
            </div>
        {/if}
    </div>
</div>

<div class="w-full h-[4] px-4 flex gap-2 pb-4">
    <button class="w-full py-3 bg-[#18162F] flex justify-center items-center gap-[11px] text-white text-[11px] rounded-[6px] font-bold shadow-md shadow-[#18162F]/40" on:click={() => saveData()}>{$RADIODATA.locale['ui.save']}</button>
</div>