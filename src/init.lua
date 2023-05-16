-- \\ Utils // --
local data = require(script:WaitForChild("data"))
local signal = require(script:WaitForChild("Signal"))

local nodes = script:WaitForChild("nodes")

local VirtualNode = require(script:WaitForChild("VirtualNode"))
local createElement = require(nodes:WaitForChild("createElement"))
local createFragment = require(nodes:WaitForChild("createFragment"))

-- \\ compile // --
local freeze = require(script:WaitForChild("freeze"))

local Uact ={
    mount = VirtualNode.mount,
    unmount = VirtualNode.unmount,
    update = VirtualNode.update,

    createElement = createElement,
    createFragment = createFragment,

    Change = data.Change,
    Event = data.Event,
}

freeze(Uact)
return Uact