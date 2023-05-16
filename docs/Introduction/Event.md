You can create event signal with ReTractUI. 

```lua
ReTractUI.createElement("TextButton", {
    [ReTractUI.Event.MouseButton1Click] = function(element)
        print(element.Name)
    end,
})
```

!!! note

    In this code, it will print the gui name everytime the button is clicked
