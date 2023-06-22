There are three types of Elements:

* Host
* Functional
* Stateful

## **Element**

### Host Element
```lua
local handle = Retract.createElement("ScreenGui", {
    Name = "Retract",
}, {
    Frame = Retract.createElement("Frame", {
        Name = "Retract Frame",
        Size = Udim2.new(0.5, 0, 0.5, 0)
    })
})
```

### Functional Elements
Elements can be functional as well.
```lua
function build(props)
    return Retract.createElement("ScreenGui", {
        Name = "Retract"
    }, {
        Frame = Retract.createElement("Frame", {
            Name = props.name,
            Size = Udim2.new(0.5, 0, 0.5, 0)
        })
    }, props[Retract.Children])
end
```

### Stateful Element
```lua
local myComp = Retract.Component:extend(name: string)

function myComp:init()
    self:setState({
        name = "John"
    })
end

function myComp:render()
    return Retract.createElement("TextLabel", {
        Name = self.state.name -- john
        Text = self.state.text
    }, self.props[Retract.Children])
end

return myComp
```
## **Fragments**
Instead of Using Create Element to have children, you can use fragments to create multiple children.

```lua
function Fragments(props)
    return Retract.createFragment({
        Retract.createElement("StringValue", {
            Value = props.value,
            Name = props.name
        }),
        Retract.createElement("BoolValue", {
            Value = true,
            Name = props.name2
        })
    })
end

-- creating an element for the fragments.
Retract.createElement(Fragments, {
    value = "hello",
    name = "Fragment",
    name2 = "Fragment2"
})
```

!!! note Note Brief

    Because we are using `props`, we used a function to handle the props, otherwise you can create an element with fragments.

## **Mounting Element**
This mounts the element to the instance which is the parent and it will return the tree.

```lua
local handle = Retract.createElement(require(path.to.module), {
    text = "john doe is the best" -- > this will add to the state.
}, {
    Retract.createElement("TextLabel", {
        Name = "Hello"
    })
})

Retract.mount(handle, game.Players.LocalPlayer)
```

## **Updating Element**
This will update the original tree and take the place 

```lua
handle = Retract.update(handle, Retract.createElement(require(path.to.module), {
    text = "Retract UI"    
}, {

  Retract.createElement("TextLabel", {
    Name = "Hello",
  }),

}))
```

## **Unmouting Element**
This will dismantle and destroy the element from the hub.

```lua
Retract.unmount(handle)
```