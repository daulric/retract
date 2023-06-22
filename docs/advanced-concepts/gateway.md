# Retract Gateway

Retract Gateway is a method used for porting elements to another path of the game.

```lua
local element = Retract.createElement(Retract.Gateway, {
    path = game.ReplicatedStorage
}, {
    Retract.createElement("Part", {Name = "Retract Part"})
})

Retract.mount(element, game.Players.LocalPlayer.PlayerGui)
```

!!! tip
    **Instead of mounting the element to the Player's PlayerGui, it will mount to the path.**
    **This is great when handling deep nested code inside of your project.**

**Usage**

```lua
local element = Retract.createElement("ScreenGui", {
    Name = "Retract Component"
}, {
    TextLabel = Retract.createElement("TextLabel", {
        Name = "TextLabel",
        Size = UDim2.new(0, 200, 0, 200),
        Text = "Retract",
    }),

    GatewayTest = Retract.createElement(Retract.Gateway, {
        path = game.ReplicatedStorage
    }, {
        Part = Retract.createElement("Part", {
            Name = "retracttype"
        })
    })
})

Retract.mount(element, game.Players.LocalPlayer.PlayerGui)
```

The TextLabel will be parented to the Screen Gui, but the Part in the gateway will be parented to the path, which is ReplicatedStorage and not the Screen Gui