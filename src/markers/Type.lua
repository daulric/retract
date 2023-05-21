local Symbol = require(script.Parent:WaitForChild("Symbol"))

return {
    -- // Event, Property, and Attribute Signals for Events
    Event = Symbol.assign("ReTract.Event"),
    Change = Symbol.assign("ReTract.Change"),
    Attribute = Symbol.assign("ReTract.Attribute"),
    AttributeChange = Symbol.assign("ReTract.Attribute.Change"),
}