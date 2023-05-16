function createElement(class, properties, components)
    components = components or {}
    properties = properties or {}

    local index = {
        class = class,
        props = properties,
        components = components
    }

    return index
end

return createElement