local data = {}

data.Change = {}
data.Event = {}

-- this is for property and attribute change signals

setmetatable(data.Change, {
    __index = function(_self, index)
        return "Changed "..index
    end
})

setmetatable(data.Event, {
    __index = function(_self, index)
        return index
    end
})

return data