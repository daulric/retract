You can make change signal with ReTract


This is how its done.
## Api
```lua
ReTract.Change[object property] --> this will retun the property name for the object.
```
!!! tip "Reference"

    When you use something like `ReTract.Change.Text`, it will return `Changed:Text` as a string


## Example
```lua
ReTract.createElement("TextLabel", {
    [ReTract.Change.Text] = function(element, text)
        print(`text changed in {element.Name}: New Text: {element.Text}`)
    end
})
```

That how you make property change signals.