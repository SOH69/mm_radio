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
							channel: "420",
							volume: 80,
							favourite: [420, 54.1, 57.3, 58.6, 59.8, 56.2, 54.1, 57.3, 58.6, 59.8],
							recomended: [420, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0],
							userData: {
								name: "Uday Shetty",
								playerlist: {
									show: true,
									coords: {
										x: 15,
										y: 40,
									},
								},
							},
							channelName: {
								"1": "MRPD CHANNEL 1",
								"2": "MRPD CHANNEL 2",
								"420": "MAFIA"
							},
							time: "18:46",
							street: "Mirror Park Boulevard",
							maxChannel: 500,
							locale: {
								"ui.header": "IN RADIO",
								"ui.frequency": "Frequency",
								"ui.disconnect": "DISCONNECT",
								"ui.notconnected": "NOT CONNECTED",
								"ui.channels": "Channels",
								"ui.radio": "Radio",
								"ui.members": "Members",
								"ui.favorites": "Favorites",
								"ui.recommended": "Recommended",
								"ui.clear": "CLEAR",
								"ui.hide_overlay": "HIDE OVERLAY",
								"ui.show_overlay": "SHOW OVERLAY",
								"ui.save": "SAVE"
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
				component: 'Overlay ',
				actions : [
					{
						name: "Show",
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
					},
					{
						name: "hide",
						action: "updateRadioList",
						data: [],
					}
				]
		},
		{
				component: 'Notify',
				actions : [
					{
						name: "toggle",
						action: "notify",
						data: 'Hello World',
					}
				]
		}

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