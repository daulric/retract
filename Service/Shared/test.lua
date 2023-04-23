local Uact = require(game.ReplicatedStorage.Uact)

local Comp = Uact.Component:extend()

function Comp:render()
    return Uact.createElement("TextButton", {
        Name = "Ulric",
        [Uact.Event.MouseButton1Click] = function(element)
            print(element.Name)
        end,
        Size = UDim2.fromOffset(200, 100)
    })
end

return Comp