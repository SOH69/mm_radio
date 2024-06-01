<script lang="ts">
    import { ReceiveEvent } from "@utils/eventsHandlers";
    import { RADIODATA, SHOWPLAYERLIST, PLAYERLIST } from "@stores/stores";
    import { SendEvent } from "@utils/eventsHandlers";
    import { Receive, Send } from "@enums/events";
    export let changeTab;

    ReceiveEvent(Receive.updateRadioTalking, (data: any) => {
		$PLAYERLIST[data.radioId].isTalking = data.radioTalking
	})

    function showPlayerList() {
        SHOWPLAYERLIST.set(!$SHOWPLAYERLIST)
        SendEvent(Send.showPlayerList, $SHOWPLAYERLIST)
    }

</script>

{#if $PLAYERLIST != null}
    <div class="w-full h-[230px] drop-shadow-md p-4">
        <div class="w-full h-full bg-[#18162F] rounded-[6px] text-white font-bold overflow-scroll no-scrollbar">
            {#each Object.entries($PLAYERLIST) as [id, player], index (id)}
                <div class="w-full h-[32px] flex items-center gap-[11px] px-4">
                    <div class="w-[13px] h-[13px] rounded-full" style="background-color: {player.isTalking? "white":"#212146"}"></div>
                    <span class="text-[11px]">{player.name}</span>
                </div>
            {/each}
        </div>
    </div>

    <div class="w-full pb-4 px-4 flex gap-2">
        {#if $RADIODATA.overlay != 'never'}
            <button class="w-[70%] py-3 bg-[#18162F] flex justify-center items-center gap-[11px] text-white text-[11px] rounded-[6px] font-bold drop-shadow-md" on:click={()=> showPlayerList()}>{$SHOWPLAYERLIST? $RADIODATA.locale['ui.hide_overlay']:$RADIODATA.locale['ui.show_overlay']}</button>
        {/if}
        <button class="w-[25%] py-3 bg-[#18162F] flex justify-center items-center gap-[11px] text-white text-[11px] rounded-[6px] font-bold drop-shadow-md" on:click={changeTab('setting')}>
        <i class="fa-solid fa-gear text-[14px]"></i>
        </button>
    </div>
{/if}