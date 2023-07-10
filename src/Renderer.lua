local renderer = {}
local markers = script.Parent:WaitForChild("markers")
local Type = require(markers:WaitForChild("Type"))
local ElementType = require(markers:WaitForChild("ElementType"))

local Children = require(markers.Children)
local SingleEventManager = require(script.Parent:WaitForChild("SingleEventManager"))

local getDefaultInstanceProperty = require(script.Parent:WaitForChild("getDefaultProperty"))

local function identity(...)
    return ...
end

local function setDefaultProperty(object, key, newValue)
    if newValue == nil then
		local hostClass = object.ClassName
		local _, defaultValue = getDefaultInstanceProperty(hostClass, key)
		newValue = defaultValue
	end

	object[key] = newValue

	return
end

local function applyProp(virtualNode, key, newValue, oldValue)
    if newValue == oldValue then
        return
    end

    if key == Children then
        return
    end

    local KeyType = key.Type

    if KeyType == Type.Event or KeyType == Type.Change or KeyType == Type.AttributeChange then
        if virtualNode.eventManager == nil then
			virtualNode.eventManager = SingleEventManager.new(virtualNode.object)
		end

		local eventName = key.name

		if KeyType == Type.Change then
			virtualNode.eventManager:connectPropertyChange(eventName, newValue)
        elseif KeyType == Type.AttributeChange then
            virtualNode.eventManager:connectAttributeChange(eventName, newValue)
		else
			virtualNode.eventManager:connectEvent(eventName, newValue)
		end

    else
        setDefaultProperty(virtualNode.object, key, newValue)
    end

end

local function applyProps(virtualNode, props)
    for key, value in pairs(props) do
        applyProp(virtualNode, key, value, nil)
    end
end

function updateProps(virtualNode, oldProps, newProps)

    -- Clean up props that were removed
	for propKey, oldValue in pairs(oldProps) do
		local newValue = newProps[propKey]

		if newValue == nil then
			applyProp(virtualNode, propKey, nil, oldValue)
		end
	end

    for propKey, newValue in pairs(newProps) do
		local oldValue = oldProps[propKey]
		applyProp(virtualNode, propKey, newValue, oldValue)
	end

end

function renderer.isHostObject(target)
	return typeof(target) == "Instance"
end

function renderer.mountHostNode(virtualNode, reconciler)
    local element = virtualNode.currentElement
    local hostParent = virtualNode.hostParent

    local instance = Instance.new(element.class)
    virtualNode.object = instance
    instance.Name = tostring(virtualNode.hostKey)

    local success, errorMessage = xpcall(function()
        applyProps(virtualNode, element.props)
    end, identity)

    if not success then

        local source = element.source

		if source == nil then
			source = "<enable element tracebacks>"
		end

        error(errorMessage)

    end

    local children = element.props[Children]

    if children ~= nil then
        reconciler.updateChildren(virtualNode, virtualNode.object, children)
    end

    instance.Parent = hostParent
    virtualNode.object = instance

    if virtualNode.eventManager ~= nil then
        virtualNode.eventManager:resume()
    end

end

function renderer.unmountHostNode(virtualNode, reconciler)

    for i, node in pairs(virtualNode.children) do
        reconciler.unmountNode(node)
    end

    virtualNode.object:Destroy()
end

function renderer.updateHostNode(virtualNode, reconciler, newElement)
    local oldProps = virtualNode.currentElement.props
    local newProps = newElement.props

    if virtualNode.eventManager then
        virtualNode.eventManager:suspend()
    end

    local success, err = xpcall(function()
        updateProps(virtualNode, oldProps, newProps)
    end, identity)

    if not success then
        local source = newElement.source

        if source == nil then
            source = "<element tracebacks>"
        end

        error(`{source}:{err}`)
    end

    local children = newElement.props[Children]

    if children ~= nil or oldProps[Children] ~= nil then
        reconciler.updateChildren(virtualNode, virtualNode.hostParent, children)
    end

    if virtualNode.eventManager then
        virtualNode.eventManager:resume()
    end

    return virtualNode
end

return renderer