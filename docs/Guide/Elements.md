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
        Value = props.value,
        Name = props.name
    }),
    ReTract.createElement("BoolValue", {
        Value = true,
        Name = props.name2
    })
})

-- parenting fragments to ScreenGui
ReTract.createElement(Fragments, {
    value = "hello",
    name = "Fragment",
    name2 = "Fragment2"
})
```

## **Mounting Element**
This mounts the element to the instance which is the parent and it will return the tree.

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

## **Updating Element**
This will update the original tree and take the place 

```lua
handle = ReTract.update(handle, ReTract.createElement(require(path.to.module), {
    text = "ReTract UI"    
}, {

  ReTract.createElement("TextLabel", {
    Name = "Hello",
  }),

}))
```

## **Unmouting Element**
This will dismantle and destroy the element from the hub.

```lua
ReTract.unmount(handle)
```