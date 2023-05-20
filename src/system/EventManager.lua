local EventManager = {}

function EventManager:PropertyChange(element, key, func)

    local success, signal = pcall(function()

        if element[key.name] then
            return element:GetPropertyChangedSignal(key.name)
        end

    end)

    assert(success, `This is not a valid member of {element.Name}; we got {key.name}`)

    signal:Connect(function(...)
        func(element, ...)
    end)

end

function EventManager:SignalEvent(element, key, func)

    element[key.name]:Connect(function(...)
        func(element, ...)
    end)

end

return EventManager