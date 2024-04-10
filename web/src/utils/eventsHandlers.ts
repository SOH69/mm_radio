import { get } from 'svelte/store';
import { IS_BROWSER, RESOURCE_NAME } from '../stores/stores';
import type { DebugEvent, NuiMessage } from '../typings/events';
import { onDestroy, onMount } from 'svelte';

const isBrower = get(IS_BROWSER);
const resourceName = get(RESOURCE_NAME);

const debugEventListeners: DebugEvent[] = [];

/**
 * Get the current environment. Whether it's the browser or the client
 */
export const IsEnvBrowser = (): boolean => !(window as any).invokeNative;

/**
 * Send an event to the Client
 * @param eventName The name of the event to send
 * @param data The data to send with the event
 * @returns {Promise<T>} The callback response from the Client
 **/
export async function SendEvent<T = any, P = any>(
    eventName: string,
    data: T = {} as T,
): Promise<P> {
    if (isBrower == true) {
        const debugReturn = await DebugEventCallback<T>(eventName, data);
        return Promise.resolve(debugReturn);
    }
    const options = {
        method: 'post',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data),
    };

    const resp: Response = await fetch(
        `https://${resourceName}/${eventName}`,
        options,
    );
    return await resp.json();
}

/**
 * Listen for an event from the Client
 * @param action The name of the event to listen for
 * @param handler The callback to run when the event is received
 * @returns {void}
 **/
export function ReceiveEvent<T = unknown>(
    action: string,
    handler: (data: T) => void,
) {
    const eventListener = (event: MessageEvent<NuiMessage<T>>) => {
        const { action: eventAction, data } = event.data;

        eventAction === action && handler(data);
    };

    // Add the event listener on mount and remove it on unmount
    onMount(() => window.addEventListener('message', eventListener));
    onDestroy(() => window.removeEventListener('message', eventListener));
}

/**
 * Listen for an event from the Client
 * YOU NEED TO BE SURE TO REMOVE THE LISTENER WHEN YOU'RE DONE WITH IT
 * @param action The name of the event to listen for
 * @param handler The callback to run when the event is received
 * @returns {function}
 **/
export function TempReceiveEvent<T = unknown>(
    action: string,
    handler: (data: T) => void,
): {removeListener: () => void} {
    const eventListener = (event: MessageEvent<NuiMessage<T>>) => {
        const { action: eventAction, data } = event.data;

        eventAction === action && handler(data);
    };

    function removeListener() {
        window.removeEventListener('message', eventListener);
    }

    // Add the event listener on mount and remove it on unmount
    window.addEventListener('message', eventListener)
    return {removeListener};
}


/**
 * Emulate an event sent from the Client
 * @param action The name of the event to send
 * @param data The data to send with the event
 * @param timer The time to wait before sending the event (in ms)
 * @returns {void}
 **/
export async function DebugEventSend<P>(action: string, data?: P, timer = 0) {
    if (!isBrower) return;
    setTimeout(() => {
        const event = new MessageEvent('message', {
            data: { action, data },
        });
        window.dispatchEvent(event);
    }, timer);
}

/**
 * Emulate an NUICallback in the Client
 * @param action The name of the event to listen for
 * @param handler The callback to run when the event is received
 * @returns {void}
 **/
export async function DebugEventReceive<T>(
    action: string,
    handler?: (data: T) => unknown,
) {
    if (!isBrower) return;

    if (debugEventListeners[action] !== undefined) {
        console.log(
            `%c[DEBUG] %c${action} %cevent already has a debug receiver.`,
            'color: red; font-weight: bold;',
            'color: green',
            '', // Empty CSS style string to reset the color
        );
        return;
    }

    debugEventListeners[action] = handler;
}

/**
 * Emulate an NUICallback in the Client
 * @private
 * @param action The name of the event to listen for
 * @param data The data to send with the event
 * @returns {Promise<T>} The callback response from the Client
 */
export async function DebugEventCallback<T>(action: string, data?: T) {
    if (!isBrower) return;

    const handler = debugEventListeners[action];
    if (handler === undefined) {
        console.log(`[DEBUG] ${action} event does not have a debugger.`);
        return {};
    }

    const result = await handler(data);
    return result;
}