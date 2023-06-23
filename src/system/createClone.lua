return function (index: {[any]: any})
    local newIndex = {}

    for i, v in pairs(index) do
        newIndex[i] = v
    end

    index.__newindex = function(self, i, v)
        if self[i] ~= v then
            newIndex[i] = v
        end
    end

    return newIndex
end