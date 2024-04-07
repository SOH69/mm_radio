import { writable } from "svelte/store";

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
    locale: {
        [key: string]: string
    }
}

export const VISIBILITY = writable<boolean>(false);
export const SHOW = writable<boolean>(false);
export const SHOWPLAYERLIST = writable<boolean>(false);
export const PLAYERLIST = writable<IPLAYERLIST[]>([]);
export const SHOWFORCEPLAYERLIST = writable<boolean>(false);
export const RADIODATA = writable<IRADIODATA>(null);
export const BROWSER_MODE = writable<boolean>(false);
export const RESOURCE_NAME = writable<string>("");
export const MOVERADIO = writable<boolean>(false);