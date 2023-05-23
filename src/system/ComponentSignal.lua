local Signals = {}
local Signal = require(script.Parent:WaitForChild("Signal"))
local freeze = require(script.Parent.Parent:WaitForChild("freeze"))

Signals.willUnmount = Signal.new()
Signals.willUpdate = Signal.new()
Signals.didUpdate = Signal.new()
Signals.didUnmount = Signal.new()
Signals.didMount = Signal.new()

freeze(Signals)
return Signals