import { Receive } from '@enums/events'
import { DebugItem } from '@typings/events'
import { DebugEventSend } from '@utils/eventsHandlers'

/**
 * The debug actions that will show up in the debug menu.
 */

let radioData = {
    onRadio: true,
    channel: "420",
    volume: 80,
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
    channelName: {
        "1": "MRPD CHANNEL 1",
        "2": "MRPD CHANNEL 2",
        "420": "MAFIA"
    },
    time: "18:46",
    street: "Mirror Park Boulevard",
    maxChannel: 500,
    insideJammerZone: false,
    battery: 100,
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
    }
}

let overlayData = {
    "1": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "2": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "3": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "4": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "5": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "6": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "7": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "8": {
        name: "Uday Shetty", 
        isTalking: true
    },
    "9": {
        name: "Uday Shetty", 
        isTalking: true
    }
}

const SendDebuggers: DebugItem[] = [
    {
        label: 'Visibility',
        actions: [
            {
                label: 'Show',
                action: () =>
                    DebugEventSend(Receive.radioVisible, radioData)
            },
            {
                label: 'Hide',
                action: () =>
                    DebugEventSend(Receive.radioHide, false)
            }
        ],
    },
    {
        label: 'Overlay',
        actions: [
            {
                label: 'Show',
                action: () =>
                    DebugEventSend(Receive.updateRadioList, overlayData)
            },
            {
                label: 'Hide',
                action: () =>
                    DebugEventSend(Receive.updateRadioList, [])
            }
        ],
    },
    {
        label: 'Jammer',
        actions: [
            {
                label: 'Inside',
                action: () =>
                    DebugEventSend(Receive.jammer, true)
            },
            {
                label: 'Outside',
                action: () =>
                    DebugEventSend(Receive.jammer, false)
            }
        ],
    },
    {
        label: 'Notify',
        actions: [
            {
                label: 'Toggle',
                action: () =>
                    DebugEventSend(Receive.notify, {
                        msg: 'Hello World',
                        duration: 5000
                    })
            }
        ],
    }
]

export default SendDebuggers
