local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Uact = require(game.ReplicatedStorage:WaitForChild("Uact"))

local testComp = require(game.ReplicatedStorage.test)

local Element = Uact.createElement("ScreenGui", {
    Name = "Test",
	IgnoreGuiInset = true
})

local Hello = Uact.createFragment({
    
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
    }, {
        Uact.createFragment({
            Uact.createElement(testComp, {
                name = "uric"
            }),

            Hello = Uact.createElement("TextButton", {
                Name = "Ulric",
                Size = UDim2.fromOffset(200,100),
                [Uact.Event.MouseButton1Click] = function(element)
                    element.Text = "Ulric is the Best!"
                end,
                [Uact.Change.Text] = function(element)
                    print("text changed:", element.Text)
                end
            }),
        
            Idk = Uact.createElement("TextButton", {
                Name = "IDK"
            })

        })
    })
end

local function Ftest()
    return Uact.createElement("TextButton", {
        Name = "Hello",
        Size = UDim2.fromScale(1, 1),
        TextScaled = true,
        Text = "Hello",
        Font = Enum.Font.Code,
        [Uact.Event.MouseButton1Click] = function(element)
            element.Text = "Ulric is the Best!"
            task.wait()
            element.Text = "Hello"
        end,
        [Uact.Change.Text] = function(element)
            print("text changed:", element.Text)
            element:SetAttribute("Hi", element.Text)
        end,
    })
end

Uact.mount(Element, Players.LocalPlayer.PlayerGui)
handler = Uact.mount(changeColor(Color3.fromRGB(1, 1, 225)), Element)

print(Uact.GetElements())

ReplicatedStorage.TestBool:GetPropertyChangedSignal("Value"):Connect(function()
    local r = math.random(1, 255)
    local g = math.random(1, 255)
    local b = math.random(1, 255)
    task.wait(5)
    --print(table.find(Element.Component, handler))
	Uact.unmount(Element)
    print("unmounted!")
    task.wait(1)
    Uact.mount(Element, Players.LocalPlayer.PlayerGui)
end)