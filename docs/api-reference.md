# Api Reference

## Methods

### ReTract.createElement
```lua
ReTract.createElement(class: any, [props, [children]]) -> element

type element = {
    [element validation]
    class: any,
    props: {[any]: any},
    children: {[any]: any}
}
```
This creates a tree to be mounted

### ReTract.createFragment
```lua
ReTract.createFragment(index: trees) -> Fragment

type Fragment = {
    [fragment validation],
    elements: {[any]: any},
}
```
This creates a fragment that contains elements / trees inside the index.

### ReTract.mount
```lua
ReTract.mount(element: tree, path: Instance) -> tree
```
This mounts the element to the path.

### ReTract.unmount
```lua
ReTract.unmount(element: tree) -> void
```
This unmount and destroy instances from the tree in the path

### ReTract.update
```lua
ReTract.update(currentTree: tree, newTree: tree) -> tree
```
This updates the currrent tree.

## Component Types
### ReTract.Component
This return creates a component with `:extend(name)` to create a component element

```lua
local component = ReTract.Component:extend(name)
```

### ReTract.Gateway
This ports the element to another path in the game instead of the nested parent tree. This is important incase the nested tree is very deep.

```lua
ReTract.Gateway -> Gateway
```

**Example**
```lua
ReTract.createElement(ReTract.Gateway, {
    path = game.Workspace
}, {
    ReTract.createElement("ScreenGui", {Name = "ReTract Gateway"}, {
        ReTract.createElement("Frame", {
            Name = "ReTract Gaeway Frame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(7, 90, 255)
        })
    })
})
```

This creates a gateway that ports instance to the path and the mounted path when `.mount` is called

!!! warning

    This feature is still in development. This may not be fully functional at this time but it will be at some point.


## Constants
### ReTract.Children

```lua
ReTract.Children -> Children
```

This returns the children in the element when `createElement` is used.

**Example with Functional Elements**
```lua
function buildFrameWithChildren(props)
    return ReTract.createElement("Frame", {
        Name = "Hello",
        Size = UDim2.new(1, 0, 1, 0)
    }, props[ReTract.Children])
end
```

**Example with Component Element**
```lua
local Component = ReTract.Component:extend("Example")

function Component:render()
    return ReTract.createElement("Frame", {
        Name = "Hello",
        Size = UDim2.new(1, 0, 1, 0)
    }, self.props[ReTract.Children])
end

return Component
```

### ReTract.Event
```lua
ReTract.Event[Event_Name] -> function
```
This handles event in the Instance

**Usage**

```lua
[ReTract.Event.MouseButton1Click] = function(element)
    print("button clicked!")
end
```

### ReTract.Change
```lua
ReTract.Change[Property Name] -> function
```
This wait for the property change signal in the Instance.

**Usage**
```lua
[ReTract.Change.Text] = function(element)
    print(element.Text)
end
```

### ReTract.Attribute
```lua
ReTract.Attribute[Attribute_Name] -> any
```
This creates an attribute in the instance

**Usage**
```lua
[ReTract.Attribute.Hello] = "ReTract Attribute"
```

### ReTract.AttributeChange
```lua
ReTract.AttributeChange[Attribute_Name] -> function
```

This listens for when the attribute changes.

**Usage**
```lua
[ReTract.AttributeChange.Hello] = function(element)
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
    return ReTract.createElement("Frame", {
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