<script lang='ts'>
	import Radio from '@components/radio.svelte';
    import { tweened } from 'svelte/motion';
    import { VISIBLE, SHOW, RADIODATA, MOVERADIO } from '@stores/stores';
    import { SendEvent } from '@utils/eventsHandlers';
    import { Send } from '@enums/events';
    import radioBgImg from '@assets/overlay.png'

    let visible: boolean = false;

    const bottom = tweened(visible? $RADIODATA.userData.radio.coords.y:-61, {
		duration: 300,
	});

    SHOW.subscribe((visible: boolean) => {
		bottom.set(visible? $RADIODATA.userData.radio.coords.y:-61);
	});

    bottom.subscribe((value: number) => {
        if (value === -61 && visible) {
            VISIBLE.set(false);
        }
    });

    function dragMe(node: any) {
        let moving = false;
        let right = parseInt((node.style.right).replace('px', ''));
        let bottom = parseInt((node.style.bottom).replace('px', ''));
        
        node.style.position = 'absolute';
        node.style.bottom = `${bottom}px`;
        node.style.right = `${right}px`;
        node.style.userSelect = 'none';
        
        node.addEventListener('mousedown', () => {
            if ($MOVERADIO) 
            moving = true;
        });
        
        window.addEventListener('mousemove', (e) => {
            if (moving) {
                right -= e.movementX;
                bottom -= e.movementY;

                right = Math.min(Math.max(right, 0), window.innerWidth - node.offsetWidth);
                bottom = Math.min(Math.max(bottom, 0), window.innerHeight - node.offsetHeight);

                node.style.bottom = `${bottom}px`;
                node.style.right = `${right}px`;

                RADIODATA.update((old: any) => {
                    return { ...old, userData: { ...old.userData, radio: { ...old.userData.radio, coords: { x: right, y: bottom } } } }
                })
            }
        });
        
        window.addEventListener('mouseup', () => {
            moving = false;
            SendEvent(Send.updateRadioPosition, $RADIODATA.userData.radio.coords)
        });
    }
</script>

<div class="w-[326px] h-[660px] absolute px-10 select-none" 
    style="transform: scale({($RADIODATA.userData.radioSizeMultiplier*2)/100}); bottom: {$SHOW?$RADIODATA.userData.radio.coords.y:-9999}px; right: {$RADIODATA.userData.radio.coords.x}px; cursor:{$MOVERADIO? 'move':'pointer'};" 
    use:dragMe
>
    <img alt='bg' src={radioBgImg} class="z-[8] relative w-full h-full" draggable="false">
    <Radio  />
</div>