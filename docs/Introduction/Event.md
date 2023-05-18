You can create event signal with ReTractUI. 

## Api
```lua
ReTractUI.Event[object event] --> this will retun the event name for the object
```

## Example
```lua
ReTractUI.createElement("TextButton", {
    [ReTractUI.Event.MouseButton1Click] = function(element)
        print(element.Name)
    end,
})
```

!!! note

    In this code, it will print the gui name everytime the button is clicked
