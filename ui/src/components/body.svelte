<script lang="ts">
    import { SendNUI } from '../utils/SendNUI'
    import { RADIODATA } from '@store/stores';
    import '@fortawesome/fontawesome-free/css/all.min.css'
	import Marquee from './marquee.svelte'

    export let changeTab;

    let volume = 30;

    function changeVolume(event: any) {
        volume = event.target.value;
    }

    function togglefav(status: boolean) {
        if (status){
            RADIODATA.update((data: any) => {
                data.favourite.push(data.channel)
                data.userData.favourite.push(data.channel)
                return data
            })
            SendNUI('addFav', $RADIODATA.channel)
        } else {
            RADIODATA.update((data: any) => {
                data.favourite.pop(data.channel)
                data.userData.favourite.pop(data.channel)
                return data
            })
            SendNUI('removeFav', $RADIODATA.channel)
        }
    }

    function handleSliderRelease(event: any) {
        if (!$RADIODATA.onRadio) return;
        SendNUI('volumeChange', event.target.value);
    }
</script>

<div class="w-full h-[24.8vh] flex flex-col p-4 gap-[0.5vh]">
    <div class="w-full h-[10vh] rounded-[0.3vw] bg-[#18162F] flex flex-col p-4 gap-[1vh] drop-shadow-md">
        <div class="text-white text-[1.5vh] font-bold flex gap-[0.5vw]">
            <i class="fa-brands fa-bluetooth-b"></i>
            {#if $RADIODATA.onRadio}
                <i class="fa-solid fa-tower-cell" style="animation: pulse 0.2s cubic-bezier(0.4, 0, 0.6, 1) infinite;"></i>
                <i class="fa-solid fa-server"></i>
                {#if ($RADIODATA.favourite).indexOf($RADIODATA.channel) === -1}
                    <i class="fa-regular fa-star ml-auto cursor-pointer text-yellow-400" on:click={() => togglefav(true)}></i>
                {:else}
                    {#if ($RADIODATA.userData.favourite).indexOf($RADIODATA.channel) === -1}
                        <i class="fa-solid fa-star ml-auto cursor-not-allowed text-yellow-600"></i>
                    {:else}
                        <i class="fa-solid fa-star ml-auto cursor-pointer text-yellow-400" on:click={() => togglefav(false)}></i>
                    {/if}
                {/if}
            {/if}
            
        </div>
        <div class="flex flex-col">
            {#if $RADIODATA.onRadio}
                <div class="text-white text-[1.5vh] font-bold">{$RADIODATA.locale['ui.header']}</div>
                <div class="text-white text-[1vh] font-medium flex justify-between w-full overflow-hidden">
                    <div class="w-[40%]">{$RADIODATA.locale['ui.frequency']}:</div>
                    <div class="whitespace-nowrap w-[56%] overflow-hidden">
                        <Marquee channel={$RADIODATA.channel}/> 
                    </div>
                </div>
                <button class="bg-[#FF453AFF] w-full h-[2vh] text-white rounded-[0.3vw] font-bold flex justify-center items-center text-[1vh] mt-1" on:click={() => SendNUI('leave')}>{$RADIODATA.locale['ui.disconnect']}</button>
            {:else}
                <div class="text-white text-[1.5vh] font-bold">{$RADIODATA.locale['ui.notconnected']}</div>
            {/if}
        </div>
    </div>

    <div class="w-full rounded-[0.3vw] bg-[#18162F] flex justify-center items-center p-4 text-white text-[1vh] drop-shadow-md gap-[0.3vw]">
        {#if volume > 70}
            <i class="fa-solid fa-volume-high"></i>
        {:else if volume > 35}
            <i class="fa-solid fa-volume-low"></i>
        {:else if volume > 0}
            <i class="fa-solid fa-volume-off"></i>
        {:else}
            <i class="fa-solid fa-volume-mute"></i>
        {/if}
        <input id="vol-range" type="range" value={$RADIODATA.volume} class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer dark:bg-gray-700" disabled="{!$RADIODATA.onRadio}" on:change={changeVolume} on:mouseup={handleSliderRelease}>
    </div>

    <div class="w-full rounded-[0.3vw] bg-[#18162F] flex py-4 text-white drop-shadow-md justify-between">
        <button class="grow flex flex-col justify-center items-center gap-[0.5vh]" on:click={changeTab('channel')}>
            <i class="fa-solid fa-list-ul"></i>
            <span class="text-[0.8vh]">{$RADIODATA.locale['ui.channels']}</span>
        </button>
        <button class="grow flex flex-col justify-center items-center gap-[0.5vh]" on:click={changeTab('connect')}>
            <i class="fa-solid fa-walkie-talkie"></i>
            <span class="text-[0.8vh]">{$RADIODATA.locale['ui.radio']}</span>
        </button>
        <button class="grow flex flex-col justify-center items-center gap-[0.5vh]" style="color:{$RADIODATA.onRadio? 'white':'#AAAFB4'}" disabled="{!$RADIODATA.onRadio}" on:click={changeTab('members')}>
            <i class="fa-solid fa-user-tag"></i>
            <span class="text-[0.8vh]">{$RADIODATA.locale['ui.members']}</span>
        </button>
    </div>

    <div class="w-full rounded-[0.3vw] bg-[#18162F] flex justify-center items-center py-4 text-white text-[1vh] drop-shadow-md gap-[0.3vw]">
        <i class="fa-solid fa-location-arrow mt-1"></i>
        <span>{$RADIODATA.street}</span>
    </div>
</div>