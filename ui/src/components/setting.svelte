<script lang='ts'>
    export let changeTab: (tabName: string) => void
    import { RADIODATA } from "@store/stores";
    import { SendNUI } from '../utils/SendNUI';
    let inputValue = $RADIODATA.userData.name;

    function saveData() {
        SendNUI('saveData', inputValue)
        changeTab('members')
    }
</script>

<div class="w-full h-[23.2vh] drop-shadow-md p-4">
    <div class="w-full h-full bg-[#18162F] rounded-[0.3vw] text-white font-bold overflow-scroll no-scrollbar px-4">
        <div class="flex w-full h-[5vh] justify-center items-center gap-2">
            <div class="h-[2.5vh] w-[3vh] rounded-md flex justify-center items-center bg-[#0e0d1a]">
                <i class="fa-solid fa-user text-[0.6vw]"></i>
            </div>
            <input type="text" class="h-[2.5vh] w-[5.5vw] bg-[#212146] text-white px-4 rounded-md text-[0.6vw]" bind:value={inputValue} />
        </div>
    </div>
</div>

<div class="w-full h-[4] px-4 flex gap-2 pb-4">
    <button class="w-full py-3 bg-[#18162F] flex justify-center items-center gap-[1vh] text-white text-[1vh] rounded-[0.3vw] font-bold drop-shadow-md" on:click={() => saveData()}>{$RADIODATA.locale['ui.save']}</button>
</div>