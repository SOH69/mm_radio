<script lang="ts">
    import { SendEvent } from '@utils/eventsHandlers';
    import { RADIODATA } from '@stores/stores';
	import Marquee from './marquee.svelte'
    import { Send } from '@enums/events';

    export let changeTab;

    let volume = $RADIODATA.volume || 30;
    let lastVolume = volume;

    function changeVolume(event: any) {
        volume = event.target.value;
        lastVolume = volume;
        RADIODATA.update((data: any) => {
            data.volume = event.target.value;
            return data;
        });
    }

    function toggleMute() {
        if (!$RADIODATA.onRadio) return;
        volume = volume === 0 ? lastVolume : 0;
        RADIODATA.update((data: any) => {
            data.volume = data.volume === 0 ? lastVolume : 0;
            return data;
        });
        SendEvent(Send.mute, $RADIODATA.volume);
    }

    function togglefav(status: boolean) {
        if (status){
            RADIODATA.update((data: any) => {
                data.favourite.push(data.channel)
                data.userData.favourite.push(data.channel)
                return data
            })
            SendEvent(Send.addFavorite, $RADIODATA.channel)
        } else {
            RADIODATA.update((data: any) => {
                data.favourite.pop(data.channel)
                data.userData.favourite.pop(data.channel)
                return data
            })
            SendEvent(Send.removeFavorite, $RADIODATA.channel)
        }
    }

    function handleSliderRelease(event: any) {
        if (!$RADIODATA.onRadio) return;
        SendEvent(Send.volumeChange, event.target.value);
    }
</script>

<div class="w-full h-[270px] flex flex-col p-4 gap-[5.5px]">
    <div class="w-full h-[108px] rounded-[6px] bg-[#18162F] flex flex-col p-4 gap-[11px] shadow-md shadow-[#18162F]/40">
        <div class="text-white text-[16px] font-bold flex gap-[10px]">
            <i 
                class={$RADIODATA.volume == 0 ? "fa-solid fa-volume-xmark focus-fix" : "fa-brands fa-bluetooth-b focus-fix"}
                on:click={toggleMute}
                role="button"
                tabindex="0"
                on:keydown={(event) => { if (event.key === 'Enter') toggleMute(); }}
            ></i>
            {#if $RADIODATA.onRadio}
                {#if $RADIODATA.insideJammerZone}
                    <i class="fa-solid fa-ban text-red-500 focus-fix" style="animation: pulse 0.2s cubic-bezier(0.4, 0, 0.6, 1) infinite;"></i>
                {:else}
                    <i class="fa-solid fa-tower-cell focus-fix" style="animation: pulse 0.2s cubic-bezier(0.4, 0, 0.6, 1) infinite;"></i>
                    <i class="fa-solid fa-server focus-fix"></i>
                {/if}
                {#if ($RADIODATA.favourite).indexOf($RADIODATA.channel) === -1}
                    <i 
                        class="fa-regular fa-star ml-auto cursor-pointer text-yellow-400 focus-fix" 
                        on:click={() => togglefav(true)} 
                        role="button"
                        tabindex="0" 
                        on:keydown={(event) => { if (event.key === 'Enter') togglefav(true); }}
                    ></i>
                {:else}
                    {#if ($RADIODATA.userData.favourite).indexOf($RADIODATA.channel) === -1}
                        <i class="fa-solid fa-star ml-auto cursor-not-allowed text-yellow-600 focus-fix"></i>
                    {:else}
                        <i 
                            class="fa-solid fa-star ml-auto cursor-pointer text-yellow-400 focus-fix" 
                            on:click={() => togglefav(false)}
                            role="button"
                            tabindex="0"
                            on:keydown={(event) => { if (event.key === 'Enter') togglefav(false); }}
                        ></i>
                    {/if}
                {/if}
            {/if}
            
        </div>
        <div class="flex flex-col">
            {#if $RADIODATA.onRadio}
                <div class="text-white text-[16px] font-bold focus-fix">{$RADIODATA.locale['ui.header']}</div>
                <div class="text-white text-[11px] font-medium flex justify-between w-full overflow-hidden">
                    <div class="w-[40%] focus-fix">{$RADIODATA.locale['ui.frequency']}:</div>
                    <div class="whitespace-nowrap w-[56%] overflow-hidden focus-fix">
                        <Marquee channel={String($RADIODATA.channel)}/> 
                    </div>
                </div>
                <button class="bg-[#FF453AFF] w-full h-[22px] text-white rounded-[6px] font-bold flex justify-center items-center text-[11px] mt-1 focus-fix" on:click={() => SendEvent(Send.leave)}>{$RADIODATA.locale['ui.disconnect']}</button>
            {:else}
                <div class="text-white text-[16px] font-bold">{$RADIODATA.locale['ui.notconnected']}</div>
            {/if}
        </div>
    </div>

    <div class="w-full rounded-[6px] bg-[#18162F] flex justify-center items-center p-4 text-white text-[11px] shadow-md shadow-[#18162F]/40 gap-[6px]">
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

    <div class="w-full rounded-[6px] bg-[#18162F] flex py-4 text-white shadow-md shadow-[#18162F]/40 justify-between">
        <button class="grow flex flex-col justify-center items-center gap-[6px]" on:click={changeTab('channel')}>
            <i class="fa-solid fa-list-ul"></i>
            <span class="text-[9px]">{$RADIODATA.locale['ui.channels']}</span>
        </button>
        <button class="grow flex flex-col justify-center items-center gap-[6px]" on:click={changeTab('connect')}>
            <i class="fa-solid fa-walkie-talkie"></i>
            <span class="text-[9px]">{$RADIODATA.locale['ui.radio']}</span>
        </button>
        {#if $RADIODATA.overlay == 'never'}
            <button class="grow flex flex-col justify-center items-center gap-[6px]" on:click={changeTab('setting')}>
                <i class="fa-solid fa-gear"></i>
                <span class="text-[9px]">{$RADIODATA.locale['ui.settings']}</span>
            </button>
        {:else}
            <button class="grow flex flex-col justify-center items-center gap-[6px]" style="color:{$RADIODATA.onRadio? 'white':'#AAAFB4'}" disabled="{!$RADIODATA.onRadio}" on:click={changeTab('members')}>
                <i class="fa-solid fa-user-tag"></i>
                <span class="text-[9px]">{$RADIODATA.locale['ui.members']}</span>
            </button>
        {/if}
    </div>

    <div class="w-full rounded-[6px] bg-[#18162F] flex justify-center items-center py-3 text-white text-[11px] shadow-md shadow-[#18162F]/40 gap-[6px]">
        <i class="fa-solid fa-location-arrow mt-1"></i>
        <span>{$RADIODATA.street}</span>
    </div>
</div>