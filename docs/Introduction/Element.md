There are two types of Elements class:

## **Element**
### Api For Element
```lua
type props = {[any]: any}
type children = {[any]: any}

ReTract.createElement(class: any, properties: props, components: children) -> element
```

### Example When Using Element
```lua
ReTract.createElement("ScreenGui", {
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
    })
end

ReTract.createElement(build, {
    name = "ReTract"
})
```

### Component Element
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
    })
end

return myComp

-- In the Local Script

ReTract.createElement(require(path.to.module), {
    text = "john doe is the best" -- > this will add to the state.
})

```

## **Fragments**
Instead of Using Create Element to have children, you can use fragments to create multiple children.

### Api

```lua
type Fragment = {[any]: elements}

local chidrens = ReTract.createFragment(index: Fragment) -> Fragments
```

### Example

```lua
local Fragment = ReTract.createFragment({
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
    Fragment, -- Fragment in the components area
})
```