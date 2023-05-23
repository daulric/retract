Fragments are used when creating a list of elements.

## Without Fragments
```lua
function Items(props)
    return ReTract.createElement("Frame", {}, {
        ReTract.createElement("UIGridLayout", {
            -- props here
        }),

        List = ReTract.createElement(List)
    })
end
```

This `List` function will be implemented in the `Items` function.

Due to this reason, the grid layout will not be applied to these TextLabels because it is parented to a Frame and it doesn't have the same parent as the Grid Layout.

```lua
function List(props)
    return ReTract.createElement("Frame", {}, {
        Retract.createElement("TextLabel", {
            -- props here
        }),
        ReTract.createElement("TextLabel", {
            -- props here
        })
    })

end
```

This is what we will get if we didn't use Fragments
```
Frame:
    UIGridLayout
    Frame:
        TextLabel
        TextLabel
```

## With Fragments

```lua
function List(props)
    return ReTract.createFragment({
        Retract.createElement("TextLabel", {
            -- props here
        }),
        ReTract.createElement("TextLabel", {
            -- props here
        })
    })
end
```
When using Fragments, it will be parented as the same parent as the UIGridLayout. This will return the following:

```
Frame:
    UIGridLayout
    TextLabel
    TextLabel
```