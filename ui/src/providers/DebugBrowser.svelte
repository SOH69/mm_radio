<script>
    import { debugData } from '../utils/debugData';

	let show = false;
    //EXAMPLE
    
    // debugData([
	// 	{
	// 		action: 'setVisible',
	// 		data: true,
	// 	},
	// ])

	let options = [
		{
				component: 'Show',
				actions : [
					{
						name: "show",
						action: "setRadioVisible",
						data: {
							onRadio: true,
							channel: "89.65",
							volume: 80,
							favourite: [56.2, 54.1, 57.3, 58.6, 59.8, 56.2, 54.1, 57.3, 58.6, 59.8],
							recomended: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0],
							userData: {
								playerlist: {
									show: true,
									coords: {
										x: 15,
										y: 40,
									},
								},
							},
							time: "18:46",
							street: "Mirror Park Boulevard",
							maxChannel: 500,
							locale: {
								"header": "IN RADIO",
								"frequency": "Frequency",
								"disconnect": "DISCONNECT",
								"notconnected": "NOT CONNECTED",
								"channels": "Channels",
								"radio": "Radio",
								"members": "Members",
								"favorites": "Favorites",
								"recommended": "Recommended",
								"clear": "CLEAR",
								"hide_overlay": "HIDE OVERLAY",
								"show_overlay": "SHOW OVERLAY"
							}
						},
					},
					{
						name: "hide",
						action: "setRadioHide",
						data: false,
					},
				]
		},
		{
				component: 'Notify',
				actions : [
					{
						name: "toggle",
						action: "updateRadioList",
						data: {
							"1": {
								name: "Uday Shetty", 
								isTalking: true
							},
							"2": {
								name: "Uday Shetty", 
								isTalking: true
							}
						},
					}
				]
		},

	]
</script>


<div class="absolute top-0 left-1/2 z-[1000]">
	<button class="bg-red-500 text-white p-2"
		on:click={() => {
			show = !show;
		}}
	>
	Show
	</button>
	{#if show}
	<div class="w-fit h-fit bg-gray-600 p-2 ">
		{#each options as option}
		<div class="flex flex-row gap-2 items-center m-1">
			<p class="text-white">{option.component}</p>
			{#each option.actions as action}
			<button class="bg-blue-500 text-white p-2"
				on:click={() => {

					if (action.custom == true) {
						action.customFunction();
						return
					}
					debugData([
						{
							action: action.action,
							data: action.data,
						},
					])
				}}
			>
			{action.name}
			</button>
			{/each}
		</div>
		{/each}
	</div>
	{/if}
</div>