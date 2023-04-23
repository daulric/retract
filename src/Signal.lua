local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({
        _bindable = Instance.new("BindableEvent"),
        _args = nil,
        _argCount = nil
    }, Signal)
end

function Signal:Connect(handle)
    if self._bindable then
        return self._bindable.Event:Connect(function(...)
            handle(unpack(self._args, 1, self._argCount))
        end)
    end
end

function Signal:Fire(...)
    if self._bindable then
        self._args = {...}
        self._argCount = select("#", ...)
        self._bindable:Fire()
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