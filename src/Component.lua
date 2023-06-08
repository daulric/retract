local Component = {}
Component.__index = Component

local ElementType = require(script.Parent:WaitForChild("markers").ElementType)
local markers = script.Parent:WaitForChild("markers")

local Children = require(markers.Children)

local Reconciler = require(script.Parent:WaitForChild("Reconciler"))
local system = script.Parent:WaitForChild("system")
local Signal = require(system:WaitForChild("Signal"))
local createElement = require(script.Parent:WaitForChild("nodes").createElement)

function Component:setState(value: any)

	assert(table.isfrozen(self.state) or self.state.isState == true, `This is an invalid state. Please configure your state; Table ID: {tostring(self.state)}`)

	local NewClassState = table.clone(self.state)

	if type(value) == "table" then
		for index, stuff in pairs(value) do
			NewClassState[tostring(index)] = stuff
		end
	elseif type(value) == "function" then
		local newState = value(NewClassState)

		if type(newState) == "table" then 
			for index, stuff in pairs(newState) do
				NewClassState[tostring(index)] = stuff
			end
		else
			table.insert(NewClassState, value)
		end
	end

	self.state = NewClassState
	table.freeze(self.state)
end

function Component:render()
	error(`This is no render; This is just a dummy render just to warn that there is nothing to render {self._name}`)
end

function createSignal(class, Type)
	class.Signals[Type] = Signal.new()
end

function Component:extend(name)
	-- this here runs the component once
	local class = {}
	class.Signals = {}

	assert(name ~= nil, "you need a name for this component"..debug.traceback(2))

	class._name = name or tostring(self)
	class.state = {isState = true}
	class.mounted = false
	table.freeze(class.state)

	createSignal(class, "didMount")
	createSignal(class, "willUpdate")
	createSignal(class, "didUpdate")
	createSignal(class, "willUnmount")
	createSignal(class, "didUnmount")
	class.Type = ElementType.Types.StatefulComponent

	setmetatable(class, Component)
	return class
end

function ComponentAspectSignal(component)

	local Signals = component.Signals

    if component.willUnmount then
        Signals.willUnmount:Connect(function()
            component:willUnmount()
        end)
    end

    if component.willUpdate then
        Signals.willUpdate:Connect(function(props)
            component:willUpdate(props)
        end)
    end
    
    if component.didUnmount then
        Signals.didUnmount:Connect(function()
            component:didUnmount()
        end)
    end

    if component.didUpdate then
        Signals.didUpdate:Connect(function(props)
            component:didUpdate(props)
        end)
    end

    if component.didMount then
        Signals.didMount:Connect(function(tree)
            component:didMount()
        end)
    end

end

function SendSignal(class, Type, ...)
	class.Signals[Type]:Fire(...)
end

function Component:__render(hostParent)
	local newElement = self:render()
	self.rootNode = newElement
	self.Parent = hostParent
	Reconciler.premount(newElement, hostParent)
end

function Component:__mount(element, hostParent)
	self.props = element.props

	task.spawn(ComponentAspectSignal, self)

	if self.init then
	    local success, err = pcall(self.init, self)
	    assert(success, err)
	end

	if self.render then

	    self:__render(hostParent)

		if self.mounted == false then
			SendSignal(self, "didMount")
			self.mounted = true
		end

	end

	return element
end

function Component:__unmountwithChanging()
	Reconciler.unmountSecond(self.rootNode)
end

function Component:__unmount()

	if self.mounted == true then
		SendSignal(self, "willUnmount")
		Reconciler.unmountSecond(self.rootNode)
		SendSignal(self, "didUnmount")
	end

	self.mounted = false
end

function Component:__update(newProps)
	local oldProps = self.props
	SendSignal(self, "willUpdate", newProps)
	local path = self.Parent

	Reconciler.unmountSecond(self.rootNode)

	if newProps.props then
		for i, v in pairs(newProps) do
			self.props[i] = v
		end
	end

	self:__render(path)

	for i, v in pairs(self.props[Children]) do
		Reconciler.preupdate(v, {})
	end

	SendSignal(self, "didUpdate", oldProps)
	return self
end

return Component