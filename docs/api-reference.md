# Api Reference

## Methods

### Retract.createElement
```lua
Retract.createElement(class: any, [props, [children]]) -> element

type element = {
    [element validation]
    class: any,
    props: {[any]: any},
    children: {[any]: any}
}
```
This creates a tree to be mounted

### Retract.createFragment
```lua
Retract.createFragment(index: trees) -> Fragment

type Fragment = {
    [fragment validation]: any,
    elements: {[any]: any},
}
```
This creates a fragment that contains elements / trees inside the index.

### Retract.mount
```lua
Retract.mount(element: tree, path: Instance) -> tree
```
This mounts the element to the path.

### Retract.unmount
```lua
Retract.unmount(element: tree) -> void
```
This unmount and destroy instances from the tree in the path

### Retract.update
```lua
Retract.update(currentTree: tree, newTree: tree) -> tree
```
This updates the currrent tree.

## Component Types
### Retract.Component
This return creates a component with `:extend(name)` to create a component element

```lua
local component = Retract.Component:extend(name)
```

### Retract.Gateway
This ports the element to another path in the game instead of the nested parent tree. This is important incase the nested tree is very deep.

```lua
ReTract.Gateway -> Gateway
```

**Example**
```lua
Retract.createElement(Retract.Gateway, {
    path = game.Workspace
}, {
    Retract.createElement("ScreenGui", {Name = "Retract Gateway"}, {
        Retract.createElement("Frame", {
            Name = "ReTract Gaeway Frame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(7, 90, 255)
        })
    })
})
```

This creates a gateway that ports instance to the path and the mounted path when `.mount` is called

## Constants
### Retract.Children

```lua
Retract.Children -> Children
```

This returns the children in the element when `createElement` is used.

**Example with Functional Elements**
```lua
function buildFrameWithChildren(props)
    return Retract.createElement("Frame", {
        Name = "Hello",
        Size = UDim2.new(1, 0, 1, 0)
    }, props[Retract.Children])
end
```

**Example with Component Element**
```lua
local Component = Retract.Component:extend("Example")

function Component:render()
    return Retract.createElement("Frame", {
        Name = "Hello",
        Size = UDim2.new(1, 0, 1, 0)
    }, self.props[Retract.Children])
end

return Component
```

### Retract.Event
```lua
Retract.Event[Event_Name] -> function
```
This handles event in the Instance

**Usage**

```lua
[Retract.Event.MouseButton1Click] = function(element)
    print("button clicked!")
end
```

### ReTract.Change
```lua
Retract.Change[Property Name] -> function
```
This wait for the property change signal in the Instance.

**Usage**
```lua
[Retract.Change.Text] = function(element)
    print(element.Text)
end
```

### Retract.Attribute
```lua
Retract.Attribute[Attribute_Name] -> any
```
This creates an attribute in the instance

**Usage**
```lua
[Retract.Attribute.Hello] = "ReTract Attribute"
```

### Retract.AttributeChange
```lua
Retract.AttributeChange[Attribute_Name] -> function
```

This listens for when the attribute changes.

**Usage**
```lua
[Retract.AttributeChange.Hello] = function(element)
    print(element:GetAttribute("Hello"))
end
```

## Component Api and Lifecycle

### setState
```lua
self:setState(any) -> void
```

This sets the state in the component

### state
```lua
self.state -> state
```

This returns the state that was setted by `setState`.

### init
This initialize the component.

`:init`

**Usage**
```lua
function component:init()
    self:setState({
        name = "John Pork"
    })
end
```

### render

This returns the element in the component

`:render`

**Usage**
```lua
function component:render()
    return Retract.createElement("Frame", {
        Name = self.state.name
    })
end
```
### didMount
This listens for when the component is mounted.

`:didMount`

**Usage**

```lua
function component:didMount()
    print("component is mounted!")
end
```

### willUpdate

This listens for when the component is going to be updated

`:willUpdate`

**Usage**

```lua
function component:willUpdate()
    print("This component is going to be updated!")
end
```

### didUpdate
This listens for when the component is updated

`:didUpdate`

**Usage**
```lua
function component:didUpdate()
    print("component was updated!")
end
```

### willUnmount

This listens for when component is going to be be unmounted.

`:willUnmount`

**Usage**
```lua
function component:willUnmount()
    print("component is going to be unmounted")
end
```

### didUnmount

This listens for when component is unmounted

`:didUnmount`

**Usage**

```lua
function component:didUnmount()
    print("this component is unmounted")
end
```