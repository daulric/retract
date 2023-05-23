Managing and handling ReTract Components.

```lua
local component = ReTract.Component:extend("Component")

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
    return ReTract.createElement("TextButton", {
        [ReTract.Change.Text] = function(element)
            self.props.coins += self.state.number
            print(`text changed in {element.Name}: New Text: {element.Text}`)
        end,
        [ReTract.Attribute.Hello] = "Hello" --> this is an attribute,
        [ReTract.AttributeChange.Hello] = function(element)
            self.props.num += self.state.number
            print(`attribute canged in {element.Name}: New Attribute: {element:GetAttribute("Hello")}`)
        end,
        [ReTract.Event.MouseButton1Click] = function(element)
            element.Text = "ReTract:"..self.props.num
            element:SetAttribute("Hello", "ReTract Coins: "..self.props.coins)
        end,
    }, self.props[ReTract.Children])
end

return component

--// In the Local Script
local component = require(path.to.module)

local element = ReTract.createElement(component, {
    coins = 100,
    num = 10,
}, {
    ReTract.createElement("Part", {
        Name = "Hello"
    })
})

local handle = ReTract.mount(element, game.Players.LocalPlayer.PlayerGui)

while task.wait(10) do
    handle = ReTract.update(handle, ReTract.createElement(component, {
        coins = 90,
        num = 10,
    }, {
        ReTract.createElement("Part", {
            Name = "Hello: Part"
        })
    }))
end
```

This is an example on how ReTract Componet are created and used.