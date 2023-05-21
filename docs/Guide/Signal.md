Managing Events, Attributes, Property and Attribute Change Signals

This is how its done.

!!! tip "Reference"

    When you use something like `ReTract.Change.Text`, it will return `Changed:Text` as a string

```lua
ReTract.createElement("TextButton", {
    [ReTract.Change.Text] = function(element)
        print(`text changed in {element.Name}: New Text: {element.Text}`)
    end,
    [ReTract.Attribute.Hello] = "Hello" --> this is an attribute,
    [ReTract.AttributeChange.Hello] = function(element)
        --> this will listen for element attribute changes; in this case its `Hello`
    end,
    [ReTract.Event.MouseButton1Click] = function(element)
        --> in this case the element is a button; it will listen for when button is clicked
    end,
})
```

That how you make property change signals.