# ReTract Gateway

Retract Gateway is a method used for porting elements to another path of the game.

```lua
local element = ReTract.createElement(ReTract.Gateway, {
    path = game.ReplicatedStorage
}, {
    ReTract.createElement("Part", {Name = "ReTract Part"})
})

ReTract.mount(element, game.Players.LocalPlayer.PlayerGui)
```

!!! tip
    **Instead of mounting the element to the Player's PlayerGui, it will mount to the path.**
    **This is great when handling deep nested code inside of your project.**

**Usage**

```lua
local element = ReTract.createElement("ScreenGui", {
    Name = "ReTract Component"
}, {
    TextLabel = ReTract.createElement("TextLabel", {
        Name = "TextLabel",
        Size = UDim2.new(0, 200, 0, 200),
        Text = "ReTract",
    }),

    GatewayTest = ReTract.createElement(ReTract.Gateway, {
        path = game.ReplicatedStorage
    }, {
        Part = ReTract.createElement("Part", {
            Name = "retracttype"
        })
    })
})

ReTract.mount(element, game.Players.LocalPlayer.PlayerGui)
```

The TextLabel will be parented to the Screen Gui, but the Part in the gateway will be parented to the path, which is ReplicatedStorage and not the Screen Gui