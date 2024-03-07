<script lang="ts">
	import Body from "./body.svelte"
	import Channel from "./channel.svelte"
	import Connect from "./connect.svelte"
    import Header from "./header.svelte"
	import Playerlist from "./playerlist.svelte"
    import { SHOW, SHOWFORCEPLAYERLIST } from "@store/stores"
	import Setting from "./setting.svelte"

    let tab = 'home'

    function changeTab(tabName: string) {
        tab = tabName
        if (tabName == 'members') 
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

<div class='w-[9vw] h-[27.3vh] bg-[#212146] relative left-[2.7vw] bottom-[35.5vh] z-[9] flex flex-col rounded-b-lg'>
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
</div>

{#if tab!='home'}
    <button class="button w-[3vw] h-[2vh] absolute right-[7vw] bottom-[4.3vh] z-[11]" on:click={returnTab}></button>
{/if}