local Players = game:GetService("Players")
local Uact = require(game.ReplicatedStorage:WaitForChild("Uact"))

local Element = Uact:createElement("ScreenGui", {
    Name = "Ulric",
    IgnoreGuiInset = true
}, {
    ["k_21"] = Uact:createElement("Frame", {
        Name = "Idk",
        Size = UDim2.new(1, 0, 1, 0)
    }, {
        daulric = Uact:createElement("TextButton", {
            Name = "daulric",
            Text = "daulric",
            BackgroundColor3 = Color3.fromRGB(137, 21, 21),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 0, 1, 0),
            TextScaled = true,
            MouseButton1Click  = function(element)
                element.Text = "daulric is the best"
                task.wait(1)
                element.Text = "daulric"
            end,
            
            Changed = function(element, property, state)
                if property == "Text" then
                    print(element, "changed", state)
                end
            end
        })
    })
})

Element.Object.Parent = Players.LocalPlayer.PlayerGui