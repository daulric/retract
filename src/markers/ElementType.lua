local ElementTypeInternal = {}
local ElementType = newproxy(true)

local Symbol = require(script.Parent.Symbol)

local Gateway = require(script.Parent:WaitForChild("Gateway"))

local ElementKindType = {
    Host = Symbol.assign("ReTract.Element.Host"),
    Functional = Symbol.assign("ReTract.Element.Function"),
    StatefulComponent = Symbol.assign("ReTract.Element.StatefulComponent"),

    --// Other Stuff
    Fragment = Symbol.assign("ReTract.Fragment"),
    Gateway = Symbol.assign("ReTract.Gateway")
}

ElementTypeInternal.Types = ElementKindType

local Types = {
    ["string"] = ElementKindType.Host,
    ["function"] = ElementKindType.Functional,
    [Gateway] = ElementKindType.Gateway
}

function ElementTypeInternal.typeof(element)

    if Types[typeof(element)] then
        return Types[typeof(element)]
    end

    if element == Gateway then
        return Types[Gateway]
    end

    if typeof(element) == "table" then
        if element.isComponent then
            return ElementKindType.StatefulComponent
        end

        if element.isFragment then
            return ElementKindType.Fragment
        end
    end

end

getmetatable(ElementType).__index = ElementTypeInternal

return ElementType