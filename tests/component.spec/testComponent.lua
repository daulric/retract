local ReTract = require(game.ReplicatedStorage.ReTract)

local component = ReTract.Component:extend("TestComponent")

function component:render()
    return ReTract.createElement("Part", {
        Name = self.props.name
    })
end

return component