<script lang="ts">
	import VisibilityProvider from '@providers/VisibilityProvider.svelte'
	import { BROWSER_MODE, RESOURCE_NAME } from '@store/stores'
	import DebugBrowser from '@providers/DebugBrowser.svelte'
	import AlwaysListener from '@providers/AlwaysListener.svelte'

	$RESOURCE_NAME = 'radio' // Change this to your resource name (case sensitive)
</script>

<VisibilityProvider>
	<!-- PUT STUFF HERE  -->
</VisibilityProvider>


<AlwaysListener />
{#if $BROWSER_MODE}
	<DebugBrowser />
	<div class="absolute w-screen h-screen top-0 left-0 dev-image" />
{/if}


<style>
	.dev-image {
		background-image: url('https://cdn.discordapp.com/attachments/1068663854143389788/1074878298498281554/HUD_-_Target_Menu.png');
		background-size: cover;
		background-repeat: no-repeat;
		background-position: center;
	}
</style>