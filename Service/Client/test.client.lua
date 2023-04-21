local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Uact = require(game.ReplicatedStorage:WaitForChild("Uact"))

local Element = Uact.createElement("ScreenGui", {
    Name = "Ulric",
	IgnoreGuiInset = true
})

local function changeColor (color: Color3)
    return Uact.createElement("TextButton", {
        Name = "daulric",
        Text = "daulric",
        BackgroundColor3 = color,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 1, 0),
        TextScaled = true,
        [Uact.Event.MouseButton1Click]  = function(element)
            element.Text = "daulric is the best"
            ReplicatedStorage.TestBool.Value = not ReplicatedStorage.TestBool.Value
            task.wait(1)
            element.Text = "daulric"
        end,
        
        [Uact.Change.Text] = function(element)
            print(element, element.Text)
        end,

        [Uact.Change.Parent] = function(element)
            if element.Parent == nil then
                element.Parent = game.Workspace
            end
        end,

        Attributes = {
            Hello = "Idk"
        }
    })
end

Uact.mount(Element, Players.LocalPlayer.PlayerGui)
task.wait(1)
local handler = Uact.mount(changeColor(Color3.fromRGB(213, 15, 15)), Element)


ReplicatedStorage.TestBool:GetPropertyChangedSignal("Value"):Connect(function()
    local r = math.random(1, 255)
    local g = math.random(1, 255)
    local b = math.random(1, 255)
    handler = Uact.update(handler, changeColor(Color3.fromRGB(r, g, b)))
end)