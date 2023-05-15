local Uact = require(game.ReplicatedStorage.Uact)

local Comp = Uact.Component:extend()

return function (props)
    props.num = 1
    return Uact.createElement("TextButton", {
        Name = "2",
        Size = UDim2.fromOffset(200, 100),
        TextScaled = true,
        Text = "Hello",
        Font = Enum.Font.Code,
        [Uact.Event.MouseButton1Click] = function(element)
            element.Text = "Hello ".. props.name
            print(element.Text)
            props.num += 1
            props.name = "random"..props.num
        end,
        [Uact.Change.Text] = function(element)
            print("text changed:", element.Text)
            element:SetAttribute("Hi", element.Text)
        end,
    })
end