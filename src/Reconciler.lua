local reconciler = {}

local markers = script.Parent:WaitForChild("markers")
local Type = require(markers.Type)
local ElementType = require(markers.ElementType)
local Children = require(markers.Children)
local SingleEventManager = require(script.Parent:WaitForChild("SingleEventManager"))

local lifecycle = require(script.Parent.markers.Lifecycle)

function applyProps(element)
    local instance = element.instance

    for index, property in pairs(element.props) do
        -- This is for getting the children in the Component
        if index == Children then
            continue
        end
    
        if index.Event then
            SingleEventManager:connect(instance, index, property)
        elseif index.Type == Type.Attribute then
            instance:SetAttribute(index.name, property)
        else
            instance[index] = property
        end
    end

end

function updateProps(element, newProps)

    if element.Type == ElementType.Types.StatefulComponent then
        element.class:__update(newProps)
    else
        for i, v in pairs(newProps) do

            if i ~= Children then
                element.props[i] = v
            end

        end

        preMount(element, element.Parent)
    end
end

function ManageFragment(element, hostParent)

    local elements

    if element.class then
        elements = element.class.elements
    else
        elements = element.elements
    end

    updateChildren(elements, hostParent)
end

function HandleGateway(element)
    local hostParent = element.props.path
    local children = element.props[Children]

    assert(hostParent ~= nil, "There is no host parent")

    updateChildren(children, hostParent)
end

function updateChildren(children, hostParent)
    for _, element in ElementType.iterateElements(children) do
        local instance = preMount(element, hostParent)
        element.instance = instance
    end
end

function preMount(element, hostParent)

    if element.Type == ElementType.Types.Functional then
        local newElement = element.class(element.props)
        assert(newElement ~= nil, `there is nothing in this function; {debug.traceback()}`)
        element.rootNode = newElement
        preMount(newElement, hostParent)
    end

    if element.Type == ElementType.Types.StatefulComponent then
        local component = element.class
        component:__mount(element, hostParent)
    end

    if element.Type == ElementType.Types.Fragment then
        ManageFragment(element, hostParent)
    end

    if element.Type == ElementType.Types.Gateway then
        HandleGateway(element)
    end

    if element.Type == ElementType.Types.Host then
        local completeInstance = Instance.new(element.class)

        element.instance = completeInstance

        applyProps(element)

        updateChildren(element.props[Children], completeInstance)

        if typeof(hostParent) == "Instance" then
            completeInstance.Parent = hostParent
        end

        element.Parent = hostParent

        return completeInstance
    end
end

function mount(element, tree)

    if type(element) == "table" then
        preMount(element, tree)
        element.Parent = tree
        return element
    end

end

function unmount(element)

    local path = element.Parent

    if element.Type == ElementType.Types.StatefulComponent then
        element.class:__unmount()
    elseif element.Type == ElementType.Types.Functional then
        unmount(element.rootNode)
    elseif element.Type == ElementType.Types.Gateway then
        for _, nodes in pairs(element.props[Children]) do
            unmount(nodes)
        end
    elseif element.Type == ElementType.Types.Fragment then
        local components

        if element.class then
            components = element.class.elements
        elseif element.elements then
            components = element.elements
        end

        for i, v in pairs(components) do
            unmount(v)
        end

    elseif element.Type == ElementType.Types.Host then
        if element.instance and typeof(element.instance) == "Instance" then

            if element.instance.Parent ~= nil then
                element.instance:Destroy()
                element.instance = nil
            end

        end
    
        for _, nodes in pairs(element.props[Children]) do
            unmount(nodes)
        end

    end

    return path
end

function unmountwhileUpdating(element)
	if element.Type == ElementType.Types.StatefulComponent then
        element.class:__unmountwithChanging()
    elseif element.Type == ElementType.Types.Functional then
        unmountwhileUpdating(element.rootNode)
    elseif element.Type == ElementType.Types.Gateway then
        for _, nodes in ElementType.iterateElements(element.props[Children]) do
            unmountwhileUpdating(nodes)
        end
    elseif element.Type == ElementType.Types.Fragment then
        for _, nodes in ElementType.iterateElements(element.elements) do
            unmountwhileUpdating(nodes)
        end
    elseif element.Type == ElementType.Types.Host then
        if element.instance and typeof(element.instance) == "Instance" then

            for _, nodes in ElementType.iterateElements(element.props[Children]) do
                unmountwhileUpdating(nodes)
            end

            if element.instance.Parent ~= nil then
                element.instance:Destroy()
            end

        end
    end
end

function preUpdate(currentTree, props)
    unmountwhileUpdating(currentTree)
    updateProps(currentTree, props)

    for i, v in pairs(currentTree.props[Children]) do
        preUpdate(v, {})
    end

end

function update(currentTree, newTree)
    preUpdate(currentTree, newTree.props)
    return currentTree
end

reconciler.mount = mount
reconciler.update = update
reconciler.unmount = unmount
reconciler.unmountSecond = unmountwhileUpdating
reconciler.premount = preMount
reconciler.updateProps = updateProps
reconciler.preupdate = preUpdate
reconciler.updateChildren = updateChildren

return reconciler