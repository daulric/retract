local markers = script.Parent:WaitForChild("markers")
local ComponentLifecyclePhase = require(markers:WaitForChild("Lifecycle"))
local Symbol = require(markers:WaitForChild("Symbol"))
local ElementType = require(markers:WaitForChild("ElementType"))

local None = Symbol.assign("None")

local function assign(target, ...)
	for index = 1, select("#", ...) do
		local source = select(index, ...)

		if source ~= nil then
			for key, value in pairs(source) do
				if value == None then
					target[key] = nil
				else
					target[key] = value
				end
			end
		end

	end

	return target
end

local MAX_PENDING_UPDATES = 100

local InternalData = Symbol.assign("InternalData")

local componentMissingRenderMessage = [[
The component %q is missing the `render` method.
`render` must be defined when creating a Roact component!]]

local tooManyUpdatesMessage = [[
The component %q has reached the setState update recursion limit.
When using `setState` in `didUpdate`, make sure that it won't repeat infinitely!]]

local componentClassMetatable = {}

function componentClassMetatable:__tostring()
	return self.__componentName
end

local Component = {}
setmetatable(Component, componentClassMetatable)

Component.Type = ElementType.Types.StatefulComponent
Component.__index = Component
Component.__componentName = "Component"

--[[
	A method called by consumers of Roact to create a new component class.
	Components can not be extended beyond this point, with the exception of
	PureComponent.
]]
function Component:extend(name)

	local class = {}

	for key, value in pairs(self) do
		if key ~= "extend" then
			class[key] = value
		end
	end

	class.Type = ElementType.Types.StatefulComponent
	class.__index = class
	class.__componentName = name

	setmetatable(class, componentClassMetatable)

	return class
end

function Component:__getDerivedState(incomingProps, incomingState)

	local internalData = self[InternalData]
	local componentClass = internalData.componentClass

	if componentClass.getDerivedStateFromProps ~= nil then
		local derivedState = componentClass.getDerivedStateFromProps(incomingProps, incomingState)

		if derivedState ~= nil then
			return derivedState
		end
	end

	return nil
end

function Component:setState(mapState)

	local internalData = self[InternalData]
	local lifecyclePhase = internalData.lifecyclePhase

	if
		lifecyclePhase == ComponentLifecyclePhase.ShouldUpdate
		or lifecyclePhase == ComponentLifecyclePhase.WillUpdate
		or lifecyclePhase == ComponentLifecyclePhase.Render
	then
		local messageTemplate = "error when calling state in %s"

		local message = messageTemplate:format(tostring(internalData.componentClass))
		error(message, 2)
	elseif lifecyclePhase == ComponentLifecyclePhase.WillUnmount then
		return
	end

	local pendingState = internalData.pendingState

	local partialState
	if typeof(mapState) == "function" then
		partialState = mapState(pendingState or self.state, self.props)

		-- Abort the state update if the given state updater function returns nil
		if partialState == nil then
			return
		end
	elseif typeof(mapState) == "table" then
		partialState = mapState
	else
		error("Invalid argument to setState, expected function or table", 2)
	end

	local newState
	if pendingState ~= nil then
		newState = assign(pendingState, partialState)
	else
		newState = assign({}, self.state, partialState)
	end

	if lifecyclePhase == ComponentLifecyclePhase.Init then
		local derivedState = self:__getDerivedState(self.props, newState)
		self.state = assign(newState, derivedState)
	elseif
		lifecyclePhase == ComponentLifecyclePhase.DidMount
		or lifecyclePhase == ComponentLifecyclePhase.DidUpdate
		or lifecyclePhase == ComponentLifecyclePhase.ReconcileChildren
	then
		
		local derivedState = self:__getDerivedState(self.props, newState)
		internalData.pendingState = assign(newState, derivedState)
	elseif lifecyclePhase == ComponentLifecyclePhase.Idle then
		self:__update(nil, newState)
	else
		local messageTemplate = "Error : %s"

		local message = messageTemplate:format(tostring(internalData.componentClass))

		error(message, 2)
	end
end

function Component:getElementTraceback()
	return self[InternalData].virtualNode.currentElement.source
end

function Component:render()
	local internalData = self[InternalData]

	local message = componentMissingRenderMessage:format(tostring(internalData.componentClass))

	error(message, 0)
end

function Component:__getContext(key)

	local virtualNode = self[InternalData].virtualNode
	local context = virtualNode.context

	return context[key]
end

function Component:__addContext(key, value)

	local virtualNode = self[InternalData].virtualNode

	if virtualNode.originalContext == nil then
		virtualNode.originalContext = virtualNode.context
	end

	local existing = virtualNode.context
	virtualNode.context = assign({}, existing, { [key] = value })
end

function Component:__validateProps(props)

	local validator = self[InternalData].componentClass.validateProps

	if validator == nil then
		return
	end

	if typeof(validator) ~= "function" then
		error(
			("validateProps must be a function, but it is a %s.\nCheck the definition of the component %q."):format(
				typeof(validator),
				self.__componentName
			)
		)
	end

	local success, failureReason = validator(props)

	if not success then
		failureReason = failureReason or "<Validator function did not supply a message>"
		error(
			("Property validation failed in %s: %s\n\n%s"):format(
				self.__componentName,
				tostring(failureReason),
				self:getElementTraceback() or "<enable element tracebacks>"
			),
			0
		)
	end
end

function Component:__mount(reconciler, virtualNode)

	local currentElement = virtualNode.currentElement
	local hostParent = virtualNode.hostParent

	local internalData = {
		reconciler = reconciler,
		virtualNode = virtualNode,
		componentClass = self,
		lifecyclePhase = ComponentLifecyclePhase.Init,
		pendingState = nil,
	}

	local instance = {
		Type = ElementType.Types.StatefulComponentInstance,
		[InternalData] = internalData,
	}

	setmetatable(instance, self)

	virtualNode.instance = instance

	local props = currentElement.props

	if self.defaultProps ~= nil then
		props = assign({}, self.defaultProps, props)
	end

	instance:__validateProps(props)

	instance.props = props

	local newContext = assign({}, virtualNode.legacyContext)
	instance._context = newContext

	instance.state = assign({}, instance:__getDerivedState(instance.props, {}))

	if instance.init ~= nil then
		instance:init(instance.props)
		assign(instance.state, instance:__getDerivedState(instance.props, instance.state))
	end

	-- It's possible for init() to redefine _context!
	virtualNode.legacyContext = instance._context

	internalData.lifecyclePhase = ComponentLifecyclePhase.Render
	local renderResult = instance:render()

	internalData.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren
	reconciler.updateChildren(virtualNode, hostParent, renderResult)

	if instance.didMount ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.DidMount
		instance:didMount()
	end

	if internalData.pendingState ~= nil then
		-- __update will handle pendingState, so we don't pass any new element or state
		instance:__update(nil, nil)
	end

	internalData.lifecyclePhase = ComponentLifecyclePhase.Idle
end

--[[
	Internal method used by the reconciler to clean up any resources held by
	this component instance.
]]
function Component:__unmount()

	local internalData = self[InternalData]
	local virtualNode = internalData.virtualNode
	local reconciler = internalData.reconciler

	if self.willUnmount ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.WillUnmount
		self:willUnmount()
	end

	for _, childNode in pairs(virtualNode.children) do
		reconciler.unmountNode(childNode)
	end
end

function Component:__update(updatedElement, updatedState)

	local internalData = self[InternalData]
	local componentClass = internalData.componentClass

	local newProps = self.props
	if updatedElement ~= nil then
		newProps = updatedElement.props

		if componentClass.defaultProps ~= nil then
			newProps = assign({}, componentClass.defaultProps, newProps)
		end

		self:__validateProps(newProps)
	end

	local updateCount = 0
	repeat
		local finalState
		local pendingState = nil

		if internalData.pendingState ~= nil then
			pendingState = internalData.pendingState
			internalData.pendingState = nil
		end

		if updatedState ~= nil or newProps ~= self.props then
			if pendingState == nil then
				finalState = updatedState or self.state
			else
				finalState = assign(pendingState, updatedState)
			end

			local derivedState = self:__getDerivedState(newProps, finalState)

			if derivedState ~= nil then
				finalState = assign({}, finalState, derivedState)
			end

			updatedState = nil
		else
			finalState = pendingState
		end

		if not self:__resolveUpdate(newProps, finalState) then
			return false
		end

		updateCount = updateCount + 1

		if updateCount > MAX_PENDING_UPDATES then
			error(tooManyUpdatesMessage:format(tostring(internalData.componentClass)), 3)
		end
	until internalData.pendingState == nil

	return true
end

function Component:__resolveUpdate(incomingProps, incomingState)

	local internalData = self[InternalData]
	local virtualNode = internalData.virtualNode
	local reconciler = internalData.reconciler

	local oldProps = self.props
	local oldState = self.state

	if incomingProps == nil then
		incomingProps = oldProps
	end
	if incomingState == nil then
		incomingState = oldState
	end

	if self.shouldUpdate ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.ShouldUpdate
		local continueWithUpdate = self:shouldUpdate(incomingProps, incomingState)

		if not continueWithUpdate then
			internalData.lifecyclePhase = ComponentLifecyclePhase.Idle
			return false
		end
	end

	if self.willUpdate ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.WillUpdate
		self:willUpdate(incomingProps, incomingState)
	end

	internalData.lifecyclePhase = ComponentLifecyclePhase.Render

	self.props = incomingProps
	self.state = incomingState

	local renderResult = virtualNode.instance:render()

	internalData.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren
	reconciler.updateChildren(virtualNode, virtualNode.hostParent, renderResult)

	if self.didUpdate ~= nil then
		internalData.lifecyclePhase = ComponentLifecyclePhase.DidUpdate
		self:didUpdate(oldProps, oldState)
	end

	internalData.lifecyclePhase = ComponentLifecyclePhase.Idle
	return true
end

return Component