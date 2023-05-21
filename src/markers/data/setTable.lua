return function (Table, message, PropertyType)
    setmetatable(Table, {
        __index = function(_self, index)
            local listener = {
                name = index,
                Type = PropertyType
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