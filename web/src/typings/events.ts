export interface NuiMessage<T = any> {
    action: string
    data: T
}

export interface DebugEvent<T = any> {
    action: string
    data: T
}

export interface DebugEventCallback<T = any> {
    action: string
    handler?: (data: T) => unknown
}

export interface CommonActionProperties {
    label: string
    action: (...args: any[]) => any
    delay?: number
}

export type ButtonAction = CommonActionProperties & {
    type?: 'button'
}

export type CheckboxAction = CommonActionProperties & {
    type: 'checkbox'
    value?: boolean
}

export type SliderAction = CommonActionProperties & {
    type: 'slider'
    max?: number
    min?: number
    step?: number
    value?: number
}

export type TextAction = CommonActionProperties & {
    type: 'text'
    placeholder?: string
    value?: any
}

export type DebugAction =
    | ButtonAction
    | CheckboxAction
    | SliderAction
    | TextAction

export interface DebugItem {
    label: string
    actions?: DebugAction[]
}
