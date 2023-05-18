You can make change signal with ReTractUI


This is how its done.
## Api
```lua
ReTractUI.Change[object property] --> this will retun the property name for the object.
```
!!! tip "Reference"

    When you use something like `ReTractUI.Change.Text`, it will return `Changed:Text` as a string


## Example
```lua
ReTractUI.createElement("TextLabel", {
    [ReTractUI.Change.Text] = function(element, text)
        print(`text changed in {element.Name}: New Text: {element.Text}`)
    end
})
```

That how you make property change signals.