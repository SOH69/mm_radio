<script lang="ts">
    import { SendEvent } from '@utils/eventsHandlers';
    import { RADIODATA } from "@stores/stores";
    import { Send } from '@enums/events';

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

<div class="w-full h-[265px] flex flex-col p-4 gap-[9px]">
    <div class="w-full rounded-[6px] h-[38px] bg-[#18162F] shadow-md shadow-[#18162F]/40 flex items-center justify-between text-white px-4">
        <div class="font-bold text-[22px] min-w-[19px]">{channelnumber}</div>
        {#if channelnumber.length >= 1}
            <i class="fa-solid fa-circle-arrow-right text-[16px] cursor-pointer" 
            on:click={() => SendEvent(Send.join, channelnumber)}
            role="button"
            tabindex="0"
            on:keydown={(event) => { if (event.key === 'Enter') SendEvent(Send.join, channelnumber); }}
        ></i>
        {/if}
    </div>

    <div class="w-full h-[230px] flex flex-wrap gap-[2px] justify-between text-white font-bold">
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("1")}>
            <span>1</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("2")}>
            <span>2</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("3")}>
            <span>3</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("4")}>
            <span>4</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("5")}>
            <span>5</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("6")}>
            <span>6</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("7")}>
            <span>7</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("8")}>
            <span>8</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("9")}>
            <span>9</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber(".")}>
            <span>.</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => appendNumber("0")}>
            <span>0</span>
        </button>
        <button class="w-[49px] h-[49px] rounded-full bg-[#18162F] flex justify-center items-center" on:click={() => removeNumber()}>
            <span class="text-[1vh]">{$RADIODATA.locale['ui.clear']}</span>
        </button>
    </div>
</div>