-- \\ Utils //--
local Help = require(script:WaitForChild("help"))
local Mount = require(script:WaitForChild("mountElement"))
local element = require(script:WaitForChild("createElement"))
local component = require(script:WaitForChild("Component"))

local EventFolder = script:WaitForChild("Event")
local change = require(EventFolder.Change)
local event = require(EventFolder.Event)

local Uact: Help.Element = {
    createElement = element,
    mount = Mount.mount,
    unmount = Mount.unmount,
    update = Mount.update,
    GetElements = Mount.GetElements,
    Component = component,
    Change = change,
    Event = event
}

return Uact