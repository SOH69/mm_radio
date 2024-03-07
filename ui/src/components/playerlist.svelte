<script lang="ts">
    import { ReceiveNUI } from '../utils/ReceiveNUI'
    import { RADIODATA, SHOWPLAYERLIST, PLAYERLIST } from "@store/stores";
    import { SendNUI } from '../utils/SendNUI'
    export let changeTab;

    ReceiveNUI<any>('updateRadioTalking', (data: any) => {
		$PLAYERLIST[data.radioId].isTalking = data.radioTalking
	})

    function showPlayerList() {
        SHOWPLAYERLIST.set(!$SHOWPLAYERLIST)
        SendNUI('showPlayerList', $SHOWPLAYERLIST)
    }

</script>

{#if $PLAYERLIST != null}
    <div class="w-full h-[23.2vh] drop-shadow-md p-4">
        <div class="w-full h-full bg-[#18162F] rounded-[0.3vw] text-white font-bold overflow-scroll no-scrollbar">
            {#each Object.entries($PLAYERLIST) as [id, player], index (id)}
                <div class="w-full h-[3vh] flex items-center gap-[1vh] px-4">
                    <div class="w-[1.2vh] h-[1.2vh] rounded-full" style="background-color: {player.isTalking? "white":"#212146"}"></div>
                    <span class="text-[1vh]">{player.name}</span>
                </div>
            {/each}
        </div>
    </div>

    <div class="w-full pb-4 px-4 flex gap-2">
        <button class="w-[70%] py-3 bg-[#18162F] flex justify-center items-center gap-[1vh] text-white text-[1vh] rounded-[0.3vw] font-bold drop-shadow-md" on:click={()=> showPlayerList()}>{$SHOWPLAYERLIST? $RADIODATA.locale['ui.hide_overlay']:$RADIODATA.locale['ui.show_overlay']}</button>
        <button class="w-[25%] py-3 bg-[#18162F] flex justify-center items-center gap-[1vh] text-white text-[1vh] rounded-[0.3vw] font-bold drop-shadow-md" on:click={changeTab('setting')}>
            <i class="fa-solid fa-gear text-[1.3vh]"></i>
        </button>
    </div>
{/if}