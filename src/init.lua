-- \\ Utils // --
local nodes = script:WaitForChild("nodes")
local system = script:WaitForChild("system")
local markers = script:WaitForChild("markers")

local data = require(markers:WaitForChild("data"))

local Reconciler = require(script:WaitForChild("Reconciler"))
local createElement = require(nodes:WaitForChild("createElement"))
local createFragment = require(nodes:WaitForChild("createFragment"))
local ComponentAspect = require(script:WaitForChild("Component"))

local Signal = require(system:WaitForChild("Signal"))

-- \\ compile // --
local freeze = require(script:WaitForChild("freeze"))

local Retract = {
    mount = Reconciler.mount,
    unmount = Reconciler.unmount,
    update = Reconciler.update,

    createElement = createElement,
    createFragment = createFragment,

    --// Event, Property, and Attribute Signals
    Change = data.Change,
    Event = data.Event,
    AttributeChange = data.AttributeChange,
    
    --// Attributes and Children
    Attribute = data.Attribute,
    Children = require(markers.Children),
    Gateway = require(markers.Gateway),

    Component = ComponentAspect,

    createSignal = Signal.new,
}

freeze(Retract)
return Retract