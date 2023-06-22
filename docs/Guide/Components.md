Managing and handling Retract Components.

```lua
local component = Retract.Component:extend("Component")

function component:init()
    self:setState({
        number = 10,
        coins = 1
    })
end

function component:willUnmount()
    self.props.num = 0
    self.props.coins = 0
end

function component:didUnmount()
    print("component is unmounted")
end

function component:didUpdate()
    print("component is updated")
end

function component:willUpdate()
    self.props.num += 100
    self.props.coins += 10
end

function component:render()
    return Retract.createElement("TextButton", {
        [Retract.Change.Text] = function(element)
            self.props.coins += self.state.number
            print(`text changed in {element.Name}: New Text: {element.Text}`)
        end,
        [Retract.Attribute.Hello] = "Hello" --> this is an attribute,
        [Retract.AttributeChange.Hello] = function(element)
            self.props.num += self.state.number
            print(`attribute canged in {element.Name}: New Attribute: {element:GetAttribute("Hello")}`)
        end,
        [Retract.Event.MouseButton1Click] = function(element)
            element.Text = "ReTract:"..self.props.num
            element:SetAttribute("Hello", "ReTract Coins: "..self.props.coins)
        end,
    }, self.props[Retract.Children])
end

return component

--// In the Local Script
local component = require(path.to.module)

local element = Retract.createElement(component, {
    coins = 100,
    num = 10,
}, {
    Retract.createElement("Part", {
        Name = "Hello"
    })
})

local handle = Retract.mount(element, game.Players.LocalPlayer.PlayerGui)

while task.wait(10) do
    handle = Retract.update(handle, Retract.createElement(component, {
        coins = 90,
        num = 10,
    }, {
        Retract.createElement("Part", {
            Name = "Hello: Part"
        })
    }))
end
```

This is an example on how Retract Componet are created and used.