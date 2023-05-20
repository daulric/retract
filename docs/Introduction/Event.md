You can create event signal with ReTract. 

## Api
```lua
ReTract.Event[object event] --> this will retun the event name for the object
```

## Example
```lua
ReTract.createElement("TextButton", {
    [ReTract.Event.MouseButton1Click] = function(element)
        print(element.Name)
    end,
})
```

!!! note

    In this code, it will print the gui name everytime the button is clicked
