There are two types of Elements class:

## **Element**
### Api For Element
```lua
type props = {[any]: any}
type children = {[any]: any}

ReTractUI.createElement(class: any, properties: props, components: children) -> element
```

### Example When Using Element
```lua
ReTractUI.createElement("ScreenGui", {
    Name = "ReTractUI",
}, {
    Frame = ReTractUI.createElement("Frame", {
        Name = "ReTract Frame",
        Size = Udim2.new(0.5, 0, 0.5, 0)
    })
})
```

### Functional Elements
Elements can be functional as well.
```lua
function build(props)
    return ReTractUI.createElement("ScreenGui", {
        Name = "ReTractUI"
    }, {
        Frame = ReTractUI.createElement("Frame", {
            Name = props.name,
            Size = Udim2.new(0.5, 0, 0.5, 0)
        })
    })
end

ReTract.createElement(build, {
    name = "ReTract"
})
```

### Component Element
```lua
local myComp = ReTractUI.Component:extend(name: string)

function myComp:init()
    self:setState({
        name = "John"
    })
end

function myComp:render()
    return ReTractUI.createElement("TextLabel", {
        Name = self.state.name -- john
        Text = self.state.text
    })
end

return myComp

-- In the Local Script

ReTractUI.createElement(require(path.to.module), {
    text = "john doe is the best" -- > this will add to the state.
})

```

## **Fragments**
Instead of Using Create Element to have children, you can use fragments to create multiple children.

### Api

```lua
type Fragment = {[any]: elements}

local chidrens = ReTractUI.createFragment(index: Fragment) -> Fragments
```

### Example

```lua
local Fragment = ReTractUI.createFragment({
    ReTractUI.createElement("StringValue", {
        Value = "Fragment working",
        Name = "ReTract String"
    }),
    ReTractUI.createElement("BoolValue", {
        Value = true,
        Name = "ReTract Boolean"
    })
})

-- parenting fragments to ScreenGui
ReTractUI.createElement("ScreenGui", {
    Name = "ReTractUI",
}, {
    Frame = ReTractUI.createElement("Frame", {
        Name = "ReTract Frame",
        Size = Udim2.new(0.5, 0, 0.5, 0)
    }),
    Fragment, -- Fragment in the components area
})
```