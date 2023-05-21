local markers = script.Parent.Parent:WaitForChild("markers")
local ElementType = require(markers.ElementType)

function createFragment(index)
    return {
        Type = ElementType.Types.Fragment,
        components = index,
        isFragment = true
    }
end

return createFragment