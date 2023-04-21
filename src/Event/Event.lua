local Event = {}

setmetatable(Event, {
    __index = function(_self, event)
        return event
    end
})

return Event