local Signals = {}
local Signal = require(script.Parent:WaitForChild("Signal"))
local freeze = require(script.Parent.Parent:WaitForChild("freeze"))

Signals.unmountSignal = Signal.new()
Signals.updateSignal = Signal.new()

freeze(Signals)
return Signals