-- \\ Utils // --
local nodes = script:WaitForChild("nodes")
local system = script:WaitForChild("system")
local markers = script:WaitForChild("markers")

local data = require(markers:WaitForChild("data"))

local createElement = require(nodes:WaitForChild("createElement"))
local createFragment = require(nodes:WaitForChild("createFragment"))
local ComponentAspect = require(script:WaitForChild("Component"))

local Signal = require(system:WaitForChild("Signal"))

-- Reconciler v2
local renderer = require(script:WaitForChild("Renderer"))
local Reconciler = require(script:WaitForChild("Reconciler"))(renderer)

-- \\ compile // --
local freeze = require(script:WaitForChild("freeze"))

local Retract = {
    mount = Reconciler.mountVirtualTree,
    unmount = Reconciler.unmountVirtualTree,
    update = Reconciler.updateVirtualTree,

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

freeze(Retract, "Retract")
return Retract