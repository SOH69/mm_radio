import { Receive } from '@enums/events'
import { DebugEventSend } from '@utils/eventsHandlers'
/**
 * The debug response for the visibility debug action.
 */
export function toggleVisible(visible: boolean): void {
    DebugEventSend(Receive.visible, visible)
}
