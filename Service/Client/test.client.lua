local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Uact = require(game.ReplicatedStorage:WaitForChild("ReTract"))
local testComponent = require(game.ReplicatedStorage.test)

local value = Instance.new("StringValue")
value.Value = "hello"

local fragments = Uact.createFragment({
    Uact.createElement("UICorner"),
    Uact.createElement("RemoteFunction")
})

function getTime(props)
    return Uact.createElement("TextButton", {
        Name = "Button Click",
        Text = props.Time,
        [Uact.Event.MouseButton1Click] = function(element)
            print(`Name of element: {element.Name}`)
            props.Time = os.time()
            element.Text = props.Time
            value.Value = props.Time
        end,
        [Uact.Change.Text] = function(element)
            element.BackgroundColor3 = Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255))
        end,
        Size = UDim2.new(1, 0, 1, 0),
        TextScaled = true
        --Position = UDim2.new(0.5, 0, 0.5, 0)
    }, {

        Uact.createElement("RemoteEvent", {
            Name = "Event",
        }),
        
        fragments,
    })
end

function handleGateway(props)
	return Uact.createElement(Uact.Gateway, {
		path = game.Workspace
	}, {
		Uact.createElement("Part", {
			Name = props.Name
		})
	})
end

local test = Uact.createElement("ScreenGui", {
    Name = "Ulric"
}, {
    idk = Uact.createElement("Frame", {
        Name = "Test Frame"
    }),
    hello = Uact.createElement(getTime, {
        Time = os.clock()
    }),
    testcomp = Uact.createElement(testComponent, {
        num = 10,
        name = "John"
    })
})

local handle = Uact.mount(test, Players.LocalPlayer.PlayerGui)

print("Curent handle:", handle)

value:GetPropertyChangedSignal("Value"):Connect(function()
   handle = Uact.update(handle, test)
end)