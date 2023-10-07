<script lang="ts">
    import { SendNUI } from '../utils/SendNUI'
    export let channels = []
</script>

<div class="w-full h-full overflow-scroll no-scrollbar">
    {#each channels as channel}
        <div class="flex justify-between border-b-[1px] border-[#9696968a] text-white px-4 items-center">
            <div class="w-full h-[3.5vh] font-bold flex items-center">{channel} MHz</div>
            <i class="fa-solid fa-circle-arrow-right cursor-pointer" on:click={(e) => SendNUI('join', channel)}></i>
        </div>
    {/each}
</div>