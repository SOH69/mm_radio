<script lang="ts">
	import Body from "./body.svelte"
	import Channel from "./channel.svelte"
	import Connect from "./connect.svelte"
    import Header from "./header.svelte"
	import Playerlist from "./playerlist.svelte"
    import { SHOW, SHOWFORCEPLAYERLIST, MOVERADIO, RADIODATA } from "@store/stores"
	import Setting from "./setting.svelte"

    let tab = 'home'

    function changeTab(tabName: string) {
        tab = tabName
        MOVERADIO.set(false);
        if (tabName == 'members' || tabName == 'setting') 
            SHOWFORCEPLAYERLIST.set(true)
        else
            SHOWFORCEPLAYERLIST.set(false)
        
    }

    function returnTab() {
        tab = 'home'
        SHOWFORCEPLAYERLIST.set(false)
    }

    SHOW.subscribe((visible: boolean) => {
		if (!visible) 
            tab = 'home'
	})

</script>

<div class='w-[173px] h-[296px] bg-[#212146] relative left-[52px] bottom-[384px] z-[9] flex flex-col rounded-b-lg'>
    {#if $RADIODATA.battery > 0}
        <Header />
        {#if tab=='home'}
            <Body changeTab={changeTab}/>
        {:else if tab=='channel'}
            <Channel />
        {:else if tab=='connect'}
            <Connect />
        {:else if tab=='members'}
            <Playerlist changeTab={changeTab}/>
        {:else if tab=='setting'}
            <Setting changeTab={changeTab}/>
        {/if}
    {:else}
        <div class='w-full h-full bg-[#18182b] flex flex-col justify-center items-center'>
            <i class="fa-solid fa-battery-empty text-[35px] text-red-700 animate-pulse animate-infinite animate-duration-500"></i>
            <span class='text-[8px] text-red-700 font-bold'>NO CHARGE</span>
        </div>
    {/if}
</div>

{#if tab!='home'}
    <button class="button w-[58px] h-[22px] absolute right-[135px] bottom-[46px] z-[11]" on:click={returnTab}></button>
{/if}