import { writable } from "svelte/store";

export const VISIBILITY = writable<boolean>(false);
export const SHOW = writable<boolean>(false);
export const SHOWPLAYERLIST = writable<boolean>(false);
export const PLAYERLIST = writable<any>(null);
export const SHOWFORCEPLAYERLIST = writable<boolean>(false);
export const RADIODATA = writable<any>(null);
export const BROWSER_MODE = writable<boolean>(false);
export const RESOURCE_NAME = writable<string>("");