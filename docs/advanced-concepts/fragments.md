Fragments are used when creating a list of elements.

## Without Fragments
```lua
function Items(props)
    return Retract.createElement("Frame", {}, {
        Retract.createElement("UIGridLayout", {
            -- props here
        }),

        List = Retract.createElement(List)
    })
end
```

This `List` function will be implemented in the `Items` function.

Due to this reason, the grid layout will not be applied to these TextLabels because it is parented to a Frame and it doesn't have the same parent as the Grid Layout.

```lua
function List(props)
    return Retract.createElement("Frame", {}, {
        Retract.createElement("TextLabel", {
            -- props here
        }),
        Retract.createElement("TextLabel", {
            -- props here
        })
    })

end
```

This is the result when you are not using fragments.
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
    return Retract.createFragment({
        Retract.createElement("TextLabel", {
            -- props here
        }),
        Retract.createElement("TextLabel", {
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