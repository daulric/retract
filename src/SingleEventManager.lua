local Manager = {}
local Type = require(script.Parent:WaitForChild("markers").Type)

function Manager:connect(element: Instance, key, value)
    if key.Type == Type.Event then
        return element[key.name]:Connect(function(...)
            value(element, ...)
        end)

    elseif key.Type == Type.Change then
        return element:GetPropertyChangedSignal(key.name):Connect(function(...)
            value(element, ...)
        end)

    elseif key.Type == Type.AttributeChange then
        return element:GetAttributeChangedSignal(key.name):Connect(function(...)
            value(element, ...)
        end)
    end
end

return Manager
