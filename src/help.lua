local help = {}

type Elements = {
    Object: Instance,
}

type Table = {[any]: any}

export type Element = {
    createElement: (self: any, class: string, properties: Table?, components: Table?) -> Elements,
    --Change: {[string]: any}
}

return help