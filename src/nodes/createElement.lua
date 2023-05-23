local markers = script.Parent.Parent:WaitForChild("markers")

local ElementType = require(markers.ElementType)
local Children = require(markers.Children)

function createElement(class, props, children)
    children = children or {}
    props = props or {}

    if children ~= nil then
        if props[Children] ~= nil then
            warn("there is already children in the props")
            return
        end

        props[Children] = children
    end

    local index = {
        Type = ElementType.typeof(class),
        class = class,
        props = props,
        children = children
    }

    return index
end

return createElement