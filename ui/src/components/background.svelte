<script lang='ts'>
    import radio from '../public/overlay.png'
	import Radio from './radio.svelte'
    import { tweened } from 'svelte/motion';
    import { VISIBILITY, SHOW } from '@store/stores';

    let visible: boolean = false;

    const bottom = tweened(visible? 1:-61, {
		duration: 300,
	});

    SHOW.subscribe((visible: boolean) => {
		bottom.set(visible? 1:-61);
	});

    bottom.subscribe((value: number) => {
        if (value === -61 && visible) {
            VISIBILITY.set(false);
        }
    });
</script>

<div class="w-[17vw] h-[61vh] absolute right-0 px-10" style="bottom: {$bottom}vh;">
    <img alt='bg' src={radio} class="z-[8] relative w-full h-full">
    <Radio  />
</div>