local data = {}
local markers = script.Parent:WaitForChild("markers")
local Type = require(markers.Type)

data.Change = {}
data.Event = {}
data.Attribute = {}

-- this is for property and attribute change signals

setmetatable(data.Change, {
    __index = function(_self, index)
        local listener = {
            name = index,
            Type = Type.Change
        }

        setmetatable(listener, {
            __tostring = function(self)
                return ("ReTractChange(%s)"):format(self.name)
            end
        })

        data.Change[index] = listener
        print(listener)
        return listener
    end
})

setmetatable(data.Event, {
    __index = function(_, index)
        local listener = {
            name = index,
            Type = Type.Event
        }

        setmetatable(listener, {
            __tostring = function(self)
                return ("ReTractEvent(%s)"):format(self.name)
            end
        })

        data.Event[index] = listener
        return listener
    end
})

setmetatable(data.Attribute, {
    __index = function(_, index)
        local listener = {
            name = index,
            Type = Type.Attribute
        }

        setmetatable(listener, {
            __tostring = function(self)
                return ("ReTractAttribute(%s)"):format(self.name)
            end
        })

        return listener
    end
})

return data