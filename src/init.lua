-- \\ Utils // --
local nodes = script:WaitForChild("nodes")
local system = script:WaitForChild("system")
local markers = script:WaitForChild("markers")

local data = require(markers:WaitForChild("data"))

local VirtualNode = require(script:WaitForChild("VirtualNode"))
local createElement = require(nodes:WaitForChild("createElement"))
local createFragment = require(nodes:WaitForChild("createFragment"))
local ComponentAspect = require(script:WaitForChild("Component"))

local Signal = require(system:WaitForChild("Signal"))

-- \\ compile // --
local freeze = require(script:WaitForChild("freeze"))

local ReTract = {
    mount = VirtualNode.mount,
    unmount = VirtualNode.unmount,
    update = VirtualNode.update,

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

freeze(ReTract)
return ReTract