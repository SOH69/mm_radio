<script lang="ts">
    import '@fortawesome/fontawesome-free/css/all.min.css'
    import { SendNUI } from '../utils/SendNUI'
    import { RADIODATA } from "@store/stores";

    let channelnumber = "";

    function appendNumber(val: string) {
        let lastval = channelnumber
        channelnumber += val;
        let curChannel = parseFloat(channelnumber);
        if (curChannel > $RADIODATA.maxChannel) {
            channelnumber = lastval
        }
    }

    function removeNumber() {
        channelnumber = channelnumber.slice(0, -1);
    }
    
</script>

<div class="w-full h-[24.6vh] flex flex-col p-4 gap-[0.8vh]">
    <div class="w-full rounded-[0.3vw] h-[3.5vh] bg-[#18162F] drop-shadow-md flex items-center justify-between text-white px-4">
        <div class="font-bold text-[2vh] min-w-[1vw]">{channelnumber}</div>
        {#if channelnumber.length >= 1}
            <i class="fa-solid fa-circle-arrow-right text-[1.5vh] cursor-pointer" on:click={() => SendNUI('join', channelnumber)}></i>
        {/if}
    </div>

    <div class="w-full h-[21.3vh] flex flex-wrap gap-[0.1vw] justify-between text-white font-bold">
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("1")}>
            <span>1</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("2")}>
            <span>2</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("3")}>
            <span>3</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("4")}>
            <span>4</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("5")}>
            <span>5</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("6")}>
            <span>6</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("7")}>
            <span>7</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("8")}>
            <span>8</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("9")}>
            <span>9</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber(".")}>
            <span>.</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("0")}>
            <span>0</span>
        </button>
        <button class="w-[4.5vh] h-[4.5vh] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => removeNumber()}>
            <span class="text-[1vh]">{$RADIODATA.locale['ui.clear']}</span>
        </button>
    </div>
</div>