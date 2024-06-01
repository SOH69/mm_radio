import { IsEnvBrowser } from '@utils/eventsHandlers';
import { get, writable } from 'svelte/store';

interface IPLAYERLIST {
    [key: string]: {
        name: string,
        isTalking: boolean,
    }
}

interface IRADIODATA {
    onRadio: boolean,
    channel: number,
    volume: number,
    favourite: Number[],
    recomended: Number[],
    maxChannel: number,
    channelName: {
        [key: string]: string
    },
    userData: {
        name: string,
        overlaySizeMultiplier: number,
        radioSizeMultiplier: number,
        favourite: Number[],
        allowMovement: boolean,
        playerlist: {
			show: boolean,
			coords: {
				x: number,
				y: number
			}
		},
        radio: {
            coords: {
                x: number,
                y: number
            }
        }
    },
    time: string,
    street: string,
    insideJammerZone: boolean,
    battery: number,
    overlay: 'default' | 'always' | 'never',
    locale: {
        [key: string]: string
    }
}


export const CONFIG = writable<any>({

    /** Fallback resource name for when the resource name cannot be found. */
    fallbackResourceName: 'debug',

    /** Whether the escape key should make visibility false. */
    allowEscapeKey: true,
});

/**
 * The name of the resource. This is used for the resource manifest.
 * @type {Writable<string>}
 */
export const RESOURCE_NAME = writable<string>(
    (window as any).GetParentResourceName
        ? (window as any).GetParentResourceName()
        : get(CONFIG).DEBUG_RESOURCE_NAME,
);

/**
 * Whether the current environment is the browser or the client.
 * @type {Writable<boolean>}
 */
export const IS_BROWSER = writable<boolean>(!(window as any).invokeNative);

/**
 * Whether the debug menu is visible or not.
 * @type {Writable<boolean>}
 */
export const VISIBLE = writable<boolean>(false);
export const SHOW = writable<boolean>(false);
export const SHOWPLAYERLIST = writable<boolean>(false);
export const PLAYERLIST = writable<IPLAYERLIST[]>([]);
export const SHOWFORCEPLAYERLIST = writable<boolean>(false);
export const RADIODATA = writable<IRADIODATA>(null);
export const BROWSER_MODE = writable<boolean>(false);
export const MOVERADIO = writable<boolean>(false);
