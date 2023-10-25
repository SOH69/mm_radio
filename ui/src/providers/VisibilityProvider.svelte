<script lang="ts">
	import { ReceiveNUI } from '../utils/ReceiveNUI'
	import { SendNUI } from '../utils/SendNUI'
	import { onMount } from 'svelte'
	import { BROWSER_MODE, VISIBILITY, SHOW, RADIODATA,SHOWFORCEPLAYERLIST, SHOWPLAYERLIST } from '../store/stores'
	import Background from '@components/background.svelte'
	import Overlay from '@components/overlay.svelte'

	let isVisible: boolean
	let isBrowser: boolean

	BROWSER_MODE.subscribe((browser: boolean) => {
		isBrowser = browser
	})

	VISIBILITY.subscribe((visible: boolean) => {
		isVisible = visible
	})
	
	ReceiveNUI<any>('setRadioVisible', (data: any) => {
		VISIBILITY.set(true)
		SHOW.set(true)
		RADIODATA.set(data)
		SHOWPLAYERLIST.set(data.userData.playerlist.show)
	})

	ReceiveNUI<any>('updateRadio', (data: any) => {
		RADIODATA.set(data)
		SHOWPLAYERLIST.set(data.userData.playerlist.show)
	})

	ReceiveNUI<string>('UpdateTime', (data: string) => {
		RADIODATA.update((old: any) => {
			return { ...old, time: data }
		})
	})

	ReceiveNUI<boolean>('setRadioHide', () => {
		SHOW.set(false)
	})

	ReceiveNUI('setBrowserMode', (data: boolean) => {
		BROWSER_MODE.set(data)
		console.log('browser mode enabled')
	})

	onMount(() => {
		const keyHandler = (e: KeyboardEvent) => {
			if (isVisible && ['Escape'].includes(e.code)) {
				SendNUI('hideUI')
				SHOW.set(false)
				SHOWFORCEPLAYERLIST.set(false)
			}
			if (
				!isVisible &&
				['Escape'].includes(e.code) &&
				isBrowser === true
			) {
				VISIBILITY.set(true)
			}
		}

		window.addEventListener('keydown', keyHandler)

		return () => window.removeEventListener('keydown', keyHandler)
	})
</script>

{#if isVisible}
	<main>
		<Background />
	</main>
	<!-- <BackdropFix /> -->
{/if}


<Overlay />

<style>
	main {
		position: absolute;
		left: 0;
		top: 0;
		z-index: 100;
		user-select: none;
		box-sizing: border-box;
		padding: 0;
		margin: 0;
		height: 100vh;
		width: 100vw;
	}
</style>
