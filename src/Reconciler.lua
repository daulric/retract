local reconciler = {}

local system = script.Parent:WaitForChild("system")
local markers = script.Parent:WaitForChild("markers")
local Type = require(markers.Type)
local ElementType = require(markers.ElementType)
local Children = require(markers.Children)
local SingleEventManager = require(script.Parent:WaitForChild("SingleEventManager"))

local ComponentSignal = require(system.ComponentSignal)

function applyProps(element, instance)
    local connections = {}

    for index, property in pairs(element.props) do
        -- This is for getting the children in the Component
        if index == Children then
            continue
        end
    
        if index.Event then
            local connection = SingleEventManager:connect(instance, index, property)
            table.insert(connections, connection)
        elseif index.Type == Type.Attribute then
            instance:SetAttribute(index.name, property)
        else
            instance[index] = property
        end
    end

    element.connections = connections
end

function DeleteConnection(element)
    if element.Type == ElementType.Types.Host then
        for _, connection in pairs(element.connections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            end
        end
    end
end

function updateGatewayProps(element, newProps)
    element.props.path = newProps.props.path

    for i, v in pairs(element.props[Children]) do
        updateDummyProps(v)
    end

end

function updateFunctionalProps(element, newProps)

    for i, v in pairs(newProps.props) do
        if i ~= Children then
            element.props[i] = v
        end
    end

    local newElement = element.class(element.props)
    element.rootNode = newElement

    for i, v in pairs(element.props[Children]) do
        updateDummyProps(v)
    end

end

function updateHostProps(element, newProps)
    DeleteConnection(element)

    for i, v in pairs(newProps.props) do
        if i ~=  Children then
            element.props[i] = v
        end
    end

    for i, v in pairs(element.props[Children]) do
        updateDummyProps(v)
    end

    applyProps(element, element.instance)
end

function updateFragments(element, newProps)
    if element.components then
        element.components = newProps.components
    end
end

function updateDummyProps(element)
    updateProps(element, {})
end

function updateProps(element, newProps)
    if element.Type == ElementType.Types.Host then
        updateHostProps(element, newProps)
    elseif element.Type == ElementType.Types.Functional then
        updateFunctionalProps(element, newProps)
    elseif element.Type == ElementType.Types.Gateway then
        updateGatewayProps(element, newProps)
    elseif element.Type == ElementType.Types.StatefulComponent then
        element.class:__update(newProps)
    elseif element.Type == ElementType.Types.Fragment then
        if element.class then
            updateFragments(element.class, newProps)
        else
            updateFragments(element, newProps)
        end
    end

end

function ManageFragment(fragment, tree)
    for index, node in pairs(fragment.components) do
        preMount(node, tree)
    end
end

function HandleGateway(element)
    local hostParent = element.props.path
    local children = element.props[Children]

    if typeof(hostParent) == "Instance" then

        for _, node in pairs(children) do
            local instance = preMount(node, hostParent)
            node.instance = instance
        end

    end
end

function preMount(element, tree)

    if element.Type == ElementType.Types.Functional then
        local newElement = element.class(element.props)
        assert(newElement ~= nil, `there is nothing in this function; {debug.traceback()}`)
        element.rootNode = newElement
        preMount(newElement, tree)
    end

    if element.Type == ElementType.Types.StatefulComponent then
        local component = element.class
        component:__mount(element, tree)
    end

    if element.Type == ElementType.Types.Fragment then

        if element.class then
            local newFragment = element.class
            ManageFragment(newFragment, tree)
        else
            ManageFragment(element, tree)
        end

    end

    if element.Type == ElementType.Types.Gateway then
        HandleGateway(element)
    end

    if element.Type == ElementType.Types.Host then
        local completeInstance = Instance.new(element.class)
        element.instance = completeInstance

        applyProps(element, completeInstance)

        for _, child in pairs(element.props[Children]) do
            preMount(child, completeInstance)
        end

        if typeof(tree) == "Instance" then
            completeInstance.Parent = tree
        end

        element.Parent = tree
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

function unmountFragment(element)
    if element.components then
        for _, nodes in pairs(element.components) do
            unmount(nodes)
        end
    elseif element.class.components then
        for _, nodes in pairs(element.class.components) do
            unmount(nodes)
        end
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
        unmountFragment(element)
    elseif element.Type == ElementType.Types.Host then
        if element.instance and typeof(element.instance) == "Instance" then

            DeleteConnection(element)

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
		unmountwhileUpdating(element.class.rootNode)
    elseif element.Type == ElementType.Types.Functional then
        unmountwhileUpdating(element.rootNode)
    elseif element.Type == ElementType.Types.Gateway then
        for _, nodes in pairs(element.props[Children]) do
            unmountwhileUpdating(nodes)
        end
    elseif element.Type == ElementType.Types.Fragment then
        for _, nodes in pairs(element.components) do
            unmountwhileUpdating(nodes)
        end
    elseif element.Type == ElementType.Types.Host then
        if element.instance and typeof(element.instance) == "Instance" then

            DeleteConnection(element)

            if element.instance.Parent ~= nil then
                element.instance:Destroy()
            end

        end

        for _, nodes in pairs(element.props[Children]) do
            unmountwhileUpdating(nodes)
        end

    end
end

function update(currentTree, newTree)
    unmountwhileUpdating(currentTree)
    updateProps(currentTree, newTree)
    preMount(currentTree, currentTree.Parent)
    return currentTree
end

reconciler.mount = mount
reconciler.update = update
reconciler.unmount = unmount
reconciler.unmountSecond = unmountwhileUpdating
reconciler.premount = preMount
reconciler.updateProps = updateProps

return reconciler