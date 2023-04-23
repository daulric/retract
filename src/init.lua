-- \\ Utils // --
local Help = require(script:WaitForChild("help"))
local Mount = require(script:WaitForChild("mountElement"))
local element = require(script:WaitForChild("Element"))
local component = require(script:WaitForChild("Component"))
local data = require(script:WaitForChild("data"))
local signal = require(script:WaitForChild("Signal"))

-- \\ compile // --
local freeze = require(script:WaitForChild("freeze"))

local Uact: Help.Element? = freeze({
    createElement = element.createElement,
    createFragment = element.createFragment,

    mount = Mount.mount,
    unmount = Mount.unmount,
    unmountChildren = Mount.unmountChildren,
    update = Mount.update,

    GetElements = Mount.GetElements,
    Component = component,

    Change = data.Change,
    Event = data.Event,

    createEvent = signal.new
})

return Uact