local Symbol = {}

function Symbol.assign(name: string)
    local symbol = newproxy(true)

    getmetatable(symbol).__tostring = function()
        return ("Symbol(%s)"):format(name)
    end

    return symbol
end


return Symbol