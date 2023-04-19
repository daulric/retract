-- \\ Utils //--
local ElementFolder = script:WaitForChild("Element")
local Help = require(script:WaitForChild("help"))

local Uact: Help.Element = {
    createElement = function(self, class, properties, component)
        return require(ElementFolder:WaitForChild("createElement"))(class, properties, component)
    end,
}

return Uact