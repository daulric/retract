return function (Table, message, PropertyType, isEvent)
    setmetatable(Table, {
        __index = function(_self, index)
            local listener = {
                name = index,
                Type = PropertyType,
                Event = isEvent
            }
    
            setmetatable(listener, {
                __tostring = function(self)
                    return (`{message}(%s)`):format(self.name)
                end
            })
            return listener
        end
    })
end