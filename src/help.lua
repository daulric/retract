local help = {}

type Elements = {
    Object: Instance,
    Class: string,
    Component: {[any]: any},
    Properties: {[any]: any}
}

type Table = {[any]: any}

type propertyvalue = (element: any, ...any) -> () | any

type AttributeProperty = boolean | BrickColor | Color3 | ColorSequence | NumberRange | NumberSequence | Rect
type Properties = {
    [any]: propertyvalue,
    Attributes: {[any]: AttributeProperty}
}

type Component = {
    setState: (self: any, value: any) -> (),
    state: {[any]: any}
}

type ComponentFunc = {
    render: (self: Component) -> Elements
}

export type Element = {
    createElement: (class: string, properties: Properties, components: Table?) -> (),
    mount: (tree: Elements, parent: Instance?) -> (),
    unmount: (tree: Elements) -> {[number]: Elements},
    update: (tree: Elements, newTree: Elements) -> {[number]: Elements},

    GetElements: () -> (),
    Component: {
        extend: () -> ComponentFunc
    },
    Change: {[any]: any},
    Event: {[any]: any}
}

return help