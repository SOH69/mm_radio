import { Receive } from "@enums/events"
import { DebugEventCallback } from "@typings/events"
import { ReceiveEvent } from "./eventsHandlers"

const AlwaysListened: DebugEventCallback[] = [
    {
        action: Receive.visible,
        handler: (data: string) => {
            console.log("This is always listened to because it is in the AlwaysListened array.")
        }
    }
]

export default AlwaysListened



export function InitialiseListen() {
    for (const debug of AlwaysListened) {
        ReceiveEvent(debug.action, debug.handler);
    }
}