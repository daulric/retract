local Signal = {}
Signal.__index = Signal

function Signal.new()

    local contruct = {
        _bindable = Instance.new("BindableEvent"),
        _argCount = nil,
        _args = nil
    }

    setmetatable(contruct, Signal)
    return contruct

end

function Signal:Fire(...)
    if self._bindable then
        self._args = {...}
        self._argCount = select("#", ...)
        self._bindable:Fire()
    end
end

function Signal:Connect(handler)
    if self._bindable then
        return self._bindable.Event:Connect(function()
            handler(unpack(self._args, 1, self._argCount))
        end)
    end
end

function Signal:Destroy()
    if self._bindable then
        self._bindable:Destroy()
        self._bindable = nil
    end

    self._args = nil
    self._argCount = nil
    setmetatable(self, nil)
end

return Signal