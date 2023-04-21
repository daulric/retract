local Change = {}

-- this is for property and attribute change signals

setmetatable(Change, {
    __index = function(_self, index)
        return "Changed "..index
    end
})

return Change