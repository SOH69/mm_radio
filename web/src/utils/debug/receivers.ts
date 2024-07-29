import { Receive, Send } from "@enums/events"
import { DebugEventCallback } from "@typings/events"
import { DebugEventReceive, DebugEventSend } from "@utils/eventsHandlers"

/**
 * These Receivers will emulate what the client receives from the UI.
 * The purpose of this is to test the UI without having to run the client.
 * You are supposed to pretend to process the data you receive here and return.
 */
const ReceiveDebuggers: DebugEventCallback[] = [
    {
        action: Send.join,
        handler: (channel: string) => {
            DebugEventSend(Receive.updateRadio, {
                onRadio: true,
                channel: Number(channel),
                volume: 30,
                favourite: [420, 54.1, 57.3, 58.6, 59.8, 56.2, 54.1, 57.3, 58.6, 59.8],
                recomended: [420, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0],
                userData: {
                    name: "Uday Shetty",
                    overlaySizeMultiplier: 50,
                    radioSizeMultiplier: 50,
                    playerlist: {
                        show: true,
                        coords: {
                            x: 15,
                            y: 40,
                        },
                    },
                    radio: {
                        coords: {
                            x: 10,
                            y: 15,
                        },
                    }
                },
                time: '18:46',
                street: 'Alta Street',
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
                    "ui.save": "SAVE",
                    "ui.radio_settings": "Radio Settings",
                    "ui.move_radio": "Move Radio",
                    "ui.allow_move": "Allow Move",
                    "ui.overlay_settings": "Overlay Settings",
                    "ui.enableClicks": "Radio Clicks"
                },
                channelName: 'MRPD CHANNEL #1',
                insideJammerZone: false,
                battery: 100
            })
        },
    },
    {
        action: Send.leave,
        handler: () => {
            DebugEventSend(Receive.updateRadio, {
                onRadio: false,
                channel: 0,
                volume: 30,
                favourite: [420, 54.1, 57.3, 58.6, 59.8, 56.2, 54.1, 57.3, 58.6, 59.8],
                recomended: [420, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0],
                userData: {
                    name: "Uday Shetty",
                    overlaySizeMultiplier: 50,
                    radioSizeMultiplier: 50,
                    playerlist: {
                        show: true,
                        coords: {
                            x: 15,
                            y: 40,
                        },
                    },
                    radio: {
                        coords: {
                            x: 10,
                            y: 15,
                        },
                    }
                },
                time: '18:46',
                street: 'Alta Street',
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
                    "ui.save": "SAVE",
                    "ui.radio_settings": "Radio Settings",
                    "ui.move_radio": "Move Radio",
                    "ui.allow_move": "Allow Move",
                    "ui.overlay_settings": "Overlay Settings",
                    "ui.enableClicks": "Radio Clicks"
                },
                channelName: 'MRPD CHANNEL #1',
                insideJammerZone: false,
                battery: 100
            })
        }
    }
]

export default ReceiveDebuggers

/**
 * Initialise the debug receivers
 */
export function InitialiseDebugReceivers(): void {
    for (const debug of ReceiveDebuggers) {
        DebugEventReceive(debug.action, debug.handler)
    }
}
