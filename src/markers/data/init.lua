local data = {}
local markers = script.Parent
local Type = require(markers.Type)
local setTable = require(script.setTable)

data.Change = {}
data.Event = {}
data.Attribute = {}
data.AttributeChange = {}

-- this is for property and attribute change signals

setTable(data.Change, "ReTract.Change", Type.Change, true)
setTable(data.Event, "ReTract.Event", Type.Event, true)
setTable(data.Attribute, "ReTract.Attribute", Type.Attribute)
setTable(data.AttributeChange, "ReTract.Attribute.Change", Type.AttributeChange, true)

return data