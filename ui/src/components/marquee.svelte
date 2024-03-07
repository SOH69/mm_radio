<script lang="ts">
    import MarqueeTextWidget from "svelte-marquee-text-widget";
    import { RADIODATA } from '@store/stores';
    export let channel = "0";
    let enabled = false;
    let channelName = null

    function convertToPattern(value: number|string): string {
        value = value.toString();
        const parts = value.split('.');
        if (parts.length === 2 && parts[1].length >= 1) {
            return parts[0] + '.%';
        } else {
            return value;
        }
    }

    $: {
        let channelnumber = channel;
        channel = convertToPattern(channel);
        if ($RADIODATA.channelName[channel] || $RADIODATA.channelName[channelnumber]) {
            enabled = true;
            channelName = $RADIODATA.channelName[channel]+' ['+channelnumber+' MHz]';
        } else {
            enabled = false;
            channelName = channelnumber+' MHz';
        }
    }
</script>

{#if enabled}
    <MarqueeTextWidget>
        <div class="mr-4">
            {channelName}
        </div>
    </MarqueeTextWidget>
{:else}
    {channelName}
{/if}