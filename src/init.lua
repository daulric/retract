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

local ReTractUI = {
    mount = VirtualNode.mount,
    unmount = VirtualNode.unmount,
    update = VirtualNode.update,

    createElement = createElement,
    createFragment = createFragment,

    Change = data.Change,
    Event = data.Event,
    Attribute = data.Attribute,

    Component = ComponentAspect,

    createSignal = Signal.new,
}

freeze(ReTractUI)
return ReTractUI