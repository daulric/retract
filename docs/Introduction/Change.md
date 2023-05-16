You can make change signal with ReTractUI

This is how its done.

```lua
ReTractUI.createElement("TextLabel", {
    [ReTractUI.Change.Text] = function(element, text)
        print(`text changed in {element.Name}: New Text: {element.Text}`)
    end
})
```

That how you make property change signals.