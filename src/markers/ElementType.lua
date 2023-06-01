local ElementTypeInternal = {}

type ElementKindType = typeof(ElementTypeInternal)

local ElementType: ElementKindType = newproxy(true)

local Symbol = require(script.Parent.Symbol)

local Gateway = require(script.Parent:WaitForChild("Gateway"))

local ElementKindType = {
    Host = Symbol.assign("Retract.Element.Host"),
    Functional = Symbol.assign("Retract.Element.Function"),
    StatefulComponent = Symbol.assign("Retract.Element.StatefulComponent"),

    --// Other Stuff
    Fragment = Symbol.assign("Retract.Fragment"),
    Gateway = Symbol.assign("Retract.Gateway"),
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
        if element.Type == ElementKindType.StatefulComponent then
            return ElementKindType.StatefulComponent
        end

        if element.Type == ElementKindType.Fragment then
            return ElementKindType.Fragment
        end
    end

end

getmetatable(ElementType).__index = ElementTypeInternal

return ElementType