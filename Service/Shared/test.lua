local Uact = require(game.ReplicatedStorage.ReTract)

local Comp = Uact.Component:extend()

function Comp:init()
    self:setState({
		bitcoin = 10,
		name = "John",
		num = 10
    })
end

function Comp:render()
    return Uact.createElement("TextButton", {
        Name = "Roblox",
        Size = UDim2.new(1, 0, 1, 0),
        TextScaled = true,
        Text = "Ulric",
        [Uact.Event.MouseButton1Click] = function(element)
            element.Text = "Hello ".. self.state.name
            print(element.Text)
            self:setState(function(state)
                state.num += 1
                state.name = "random"..state.num
                return state
            end)
        end,
        [Uact.Change.Text] = function(element)
            print("text changed:", element.Text)
            element:SetAttribute("Hi", element.Text)
        end,
    })
end

return Comp