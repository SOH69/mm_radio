<script lang="ts">
	import VisibilityProvider from '@providers/VisibilityProvider.svelte'
	import { BROWSER_MODE, RESOURCE_NAME } from '@store/stores'
	import DebugBrowser from '@providers/DebugBrowser.svelte'
	import AlwaysListener from '@providers/AlwaysListener.svelte'

	$RESOURCE_NAME = 'mm_radio' // Change this to your resource name (case sensitive)
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
		background-image: url('https://i.imgur.com/3pzRj9n.png');
		background-size: cover;
		background-repeat: no-repeat;
		background-position: center;
	}
</style>