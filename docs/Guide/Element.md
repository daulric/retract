There are three types of Elements:

* Host
* Functional
* Stateful

## **Element**

### Host Element
```lua
local handle = ReTract.createElement("ScreenGui", {
    Name = "ReTract",
}, {
    Frame = ReTract.createElement("Frame", {
        Name = "ReTract Frame",
        Size = Udim2.new(0.5, 0, 0.5, 0)
    })
})
```

### Functional Elements
Elements can be functional as well.
```lua
function build(props)
    return ReTract.createElement("ScreenGui", {
        Name = "ReTract"
    }, {
        Frame = ReTract.createElement("Frame", {
            Name = props.name,
            Size = Udim2.new(0.5, 0, 0.5, 0)
        })
    }, props[ReTract.Children])
end
```

### Stateful Element
```lua
local myComp = ReTract.Component:extend(name: string)

function myComp:init()
    self:setState({
        name = "John"
    })
end

function myComp:render()
    return ReTract.createElement("TextLabel", {
        Name = self.state.name -- john
        Text = self.state.text
    }, self.props[ReTract.Children])
end

return myComp
```
## **Fragments**
Instead of Using Create Element to have children, you can use fragments to create multiple children.

```lua
local Fragments = ReTract.createFragment({
    ReTract.createElement("StringValue", {
        Value = "Fragment working",
        Name = "ReTract String"
    }),
    ReTract.createElement("BoolValue", {
        Value = true,
        Name = "ReTract Boolean"
    })
})

-- parenting fragments to ScreenGui
ReTract.createElement("ScreenGui", {
    Name = "ReTract",
}, {
    Frame = ReTract.createElement("Frame", {
        Name = "ReTract Frame",
        Size = Udim2.new(0.5, 0, 0.5, 0)
    }),
    Fragments, -- Fragment in the components area
})
```

## **Mounting Element**
```lua
local handle = ReTract.createElement(require(path.to.module), {
    text = "john doe is the best" -- > this will add to the state.
}, {
    ReTract.createElement("TextLabel", {
        Name = "Hello"
    })
})

ReTract.mount(handle, game.Players.LocalPlayer)
```