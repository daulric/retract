local ElementType = {}
local Symbol = require(script.Parent.Symbol)

local Gateway = require(script.Parent:WaitForChild("Gateway"))

local ElementKindType = {
    Host = Symbol.assign("ReTract.Element.Host"),
    Functional = Symbol.assign("ReTract.Element.Function"),
    StatefulComponent = Symbol.assign("ReTract.Element.StatefulComponent"),

    --// Other Stuff
    Fragment = Symbol.assign("ReTract.Fragment"),
    Gateway = Symbol.assign("ReTract.Geteway")
}

ElementType.Types = ElementKindType

function ElementType.typeof(element)

    if typeof(element) == "string" then
        return ElementKindType.Host
    end

    if typeof(element) == "function" then
        return ElementKindType.Functional
    end

    if typeof(element) == "table" then
        if element.isComponent then
            return ElementKindType.StatefulComponent
        end

        if element.isFragment then
            return ElementKindType.Fragment
        end
    end

    if element == Gateway then
        return ElementKindType.Gateway
    end

end

return ElementType