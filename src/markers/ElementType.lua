local ElementType = {}
local Symbol = require(script.Parent.Symbol)

local ElementKindType = {
    Host = Symbol.assign("ReTract.Element.Host"),
    Functional = Symbol.assign("ReTract.Element.Function"),
    StatefulComponent = Symbol.assign("ReTract.Element.StatefulComponent")
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
        return ElementKindType.StatefulComponent
    end

end

return ElementType