local help = {}

type Elements = {
    Object: Instance,
    Class: string,
    Component: {[any]: any},
    Properties: {[any]: any}
}

type Event = {
    Connect: (self: any, handle: (...any) -> ()) -> (),
    Destroy: (self: any) -> (),
    Fire: (self: any, ...any) -> ()
}

type Table = {[any]: any}

type propertyvalue = (element: any, ...any) -> () | any
type Properties = {[string]: propertyvalue}

type Component = {
    setState: (self: any, value: any) -> (),
    state: {[any]: any},
    props: {[any]: any},
}

type ComponentFunc = {
    init: (self: Component) -> Elements,
    render: (self: Component) -> Elements,
}

export type Element = {
    createElement: (class: string, properties: Properties?, components: Table?) -> Elements,
    createFragment: (tree: Table) -> {[any]: any},
    mount: (tree: Elements, parent: Instance?) -> Elements,
    unmount: (tree: Elements) -> Elements,
    unmountChildren: (tree: Elements) -> (),

    GetElements: () -> (),
    Component: {
        extend: (self: any) -> ComponentFunc
    },
    
    Change: {[any]: any},
    Event: {[any]: any},

    createEvent: () -> Event
}

return help