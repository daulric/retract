local markers = script.Parent.Parent:WaitForChild("markers")
local ElementType = require(markers.ElementType)

function createFragment(elements)
    return {
        Type = ElementType.Types.Fragment,
        elements = elements,
    }
end

return createFragment