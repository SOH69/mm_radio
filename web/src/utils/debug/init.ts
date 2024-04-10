import { DebugAction } from '@typings/events'
import { toggleVisible } from './visibility'

/**
 * The initial debug actions to run on startup
 */
const InitDebug: DebugAction[] = [
    {
        label: 'Visible',
        action: () => toggleVisible(true),
        delay: 500,
    },
]

export default InitDebug


export function InitialiseDebugSenders(): void {
    for (const debug of InitDebug) {
        setTimeout(() => {
            debug.action()
        }, debug.delay || 0)
    }
}
