local reconciler = {}

local markers = script.Parent:WaitForChild("markers")
local Type = require(markers.Type)
local ElementType = require(markers.ElementType)
local Children = require(markers.Children)
local SingleEventManager = require(script.Parent:WaitForChild("SingleEventManager"))

function applyProp(element, index, value)
    local instance = element.instance

    if index == Children then
        return
    end

    if index.Event then
        local connection = SingleEventManager:connect(instance, index, value)
        table.insert(element.connections, connection)
    elseif index.Type == Type.Attribute then
        instance:SetAttribute(index.name, value)
    else
        instance[index] = value
    end

end

function applyProps(element)
    for index, value in pairs(element.props) do
        applyProp(element, index, value)
    end
end

function updateProps(element, newProps)

    if element.Type == ElementType.Types.StatefulComponent then
        element.class:__update(newProps)
    elseif element.Type == ElementType.Types.Fragment then
        --[[ this here is a noop because fragments does not have props.
            this is placed here to override the statement / code below
        ]]
    else

        unmountwhileUpdating(element)

        for i, v in pairs(newProps) do

            if i ~= Children then
                element.props[i] = v
            end

        end

        preMount(element, element.Parent)
    end
end

function updateChildren(children, hostParent)
    for _, element in ElementType.iterateElements(children) do
        preMount(element, hostParent)
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
        if component.mounted == false then
            component:__mount(element, hostParent)
        else
            component:__render(hostParent)
        end
    end

    if element.Type == ElementType.Types.Fragment then

        local components

        if element.class then
            components = element.class.elements
        else
            components = element.elements
        end

        updateChildren(components, hostParent)
    end

    if element.Type == ElementType.Types.Gateway then
        local hostParent = element.props.path
        local children = element.props[Children]

        assert(hostParent ~= nil, "There is no host parent")

        updateChildren(children, hostParent)
    end

    if element.Type == ElementType.Types.Host then
        local completeInstance = Instance.new(element.class)

        element.instance = completeInstance
        element.connections = {}

        applyProps(element)
    
        updateChildren(element.children, completeInstance)
    
        if typeof(hostParent) == "Instance" then
            completeInstance.Parent = hostParent
        end
    
        element.Parent = hostParent
    end

end

function mount(element, hostParent)

    if typeof(element) == "table" then
        preMount(element, hostParent)
        return element
    end

end

function deleteConnections(element)
    if element.connections then
        for i, v in pairs(element.connections) do
            if v.Connected then
                v:Disconnect()
            end
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
        for _, nodes in pairs(element.children) do
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

            deleteConnections(element)
            if element.instance.Parent ~= nil then
                element.instance:Destroy()
                element.instance = nil
            end

        end
    
        for _, nodes in pairs(element.children) do
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
        for _, nodes in ElementType.iterateElements(element.children) do
            unmountwhileUpdating(nodes)
        end
    elseif element.Type == ElementType.Types.Fragment then
        for _, nodes in ElementType.iterateElements(element.elements) do
            unmountwhileUpdating(nodes)
        end
    elseif element.Type == ElementType.Types.Host then
        if element.instance and typeof(element.instance) == "Instance" then

            for _, nodes in ElementType.iterateElements(element.children) do
                unmountwhileUpdating(nodes)
            end

            deleteConnections(element)
            element.instance:Destroy()

        end
    end
end

function preUpdate(currentTree, props)
    updateProps(currentTree, props)

    if currentTree.children then
        for i, v in ElementType.iterateElements(currentTree.children) do
            preUpdate(v, {})
        end
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