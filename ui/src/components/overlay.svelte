<script lang="ts">
    import { ReceiveNUI } from '../utils/ReceiveNUI'
    import { RADIODATA, SHOW, SHOWPLAYERLIST, PLAYERLIST } from "@store/stores";

    let isPlayerListVisible: boolean

    SHOWPLAYERLIST.subscribe((visible: boolean) => {
		isPlayerListVisible = visible
	})

    ReceiveNUI<any>('updateRadioList', (data: any) => {
		PLAYERLIST.set(data)
	})

    ReceiveNUI<any>('updateRadioTalking', (data: any) => {
		$PLAYERLIST[data.radioId].isTalking = data.radioTalking
	})

    RADIODATA.subscribe((data) => {
        if (data != null && !data.onRadio) 
            PLAYERLIST.set([])
    })
    
    function dragMe(node: any) {
        let moving = false;
        let right = parseInt((node.style.right).replace('px', ''));
        let top = parseInt((node.style.top).replace('px', ''));
        
        node.style.position = 'absolute';
        node.style.top = `${top}px`;
        node.style.right = `${right}px`;
        node.style.userSelect = 'none';
        
        node.addEventListener('mousedown', () => {
            if ($SHOW) 
            moving = true;
        });
        
        window.addEventListener('mousemove', (e) => {
            if (moving) {
                right -= e.movementX;
                top += e.movementY;
                node.style.top = `${top}px`;
                node.style.right = `${right}px`;
            }
        });
        
        window.addEventListener('mouseup', () => {
            moving = false;
        });
    }
</script>

{#if isPlayerListVisible}
    {#if $RADIODATA.onRadio}
        <div class="w-[15vw] absolute z-[1000] text-right select-none" style="top: 40px; right: 15px;cursor:{$SHOW? 'move':'no-drop'}" use:dragMe>
            {#each Object.entries($PLAYERLIST) as [id, player], index (id)}
                {#if player.isTalking}
                    <div class="text-[1.7vh] font-bold px-2 text-white">{player.name}</div>
                {/if}
            {/each}
        </div>
    {/if}
{/if}