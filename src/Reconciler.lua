local reconciler = {}

local Trees = {}

local system = script.Parent:WaitForChild("system")
local markers = script.Parent:WaitForChild("markers")
local Type = require(markers.Type)
local ElementType = require(markers.ElementType)
local Children = require(markers.Children)

local ComponentSignal = require(system.ComponentSignal)

function applyProps(element, props)
    for index, property in pairs(props) do

        -- This is for getting the children in the Component
        if index == Children then
            continue
        end

        if index.Type == Type.Change then
            element:GetPropertyChangedSignal(index.name):Connect(function(...)
                property(element, ...)
            end)
        elseif index.Type == Type.AttributeChange then
            element:GetAttributeChangedSignal(index.name):Connect(function(...)
                property(element, ...)
            end)
        elseif index.Type == Type.Event then
            element[index.name]:Connect(function(...)
                property(element, ...)
            end)
        elseif index.Type == Type.Attribute then
            element:SetAttribute(index.name, property)
        else
            element[index] = property
        end

    end
end

function ManageFragment(fragment, tree)
    for index, node in pairs(fragment.components) do
        preMount(node, tree)
    end
end

function ComponentAspectSignal(component, element)

    if component.willUnmount then
        ComponentSignal.willUnmount:Connect(function(tree)
            if tree == element then
                component:willUnmount()
            end
        end)
    end

    if component.willUpdate then
        ComponentSignal.willUpdate:Connect(function(tree)
            if tree == element then
                component:willUpdate()
            end
        end)
    end
    
    if component.didUnmount then
        ComponentSignal.didUnmount:Connect(function(tree)
            if tree == element then
                component:didUnmount()
            end
        end)
    end

    if component.didUpdate then
        ComponentSignal.didUpdate:Connect(function(tree)
            if tree == element then
                component:didUpdate()
            end
        end)
    end

    if component.didMount then
        ComponentSignal.didMount:Connect(function(tree)
            if tree == element then
                component:didMount()
            end
        end)
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

function ManageFunctionalAndStateful(element, newElement, tree)

    element.StatefulandFunctalStufff = newElement

    if newElement.Type == ElementType.Types.Gateway then
        element.gatewayInstances = newElement.children
    end

    if newElement.Type == ElementType.Types.Fragment then
        element.components = newElement.components
    end

    local instance = preMount(newElement, tree)
    element.instance = instance

end

function preMount(element, tree)

    if element.Type == ElementType.Types.Functional then
        local newElement = element.class(element.props)
        assert(newElement ~= nil, `there is nothing in this function; {debug.traceback()}`)
        ManageFunctionalAndStateful(element, newElement, tree)
    end

    if element.Type == ElementType.Types.StatefulComponent then
        local component = element.class

        if component.isComponent then
            component.props = element.props
            task.spawn(ComponentAspectSignal, component, element)

            if component.init then
                local success, err = pcall(component.init, component)
                assert(success, err)
            end

            if component.render then
                local newElement = component:render()
                assert(newElement ~= nil, `there is nothing to render; {debug.traceback()}`)

                ManageFunctionalAndStateful(element, newElement, tree)
            end

        end

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

        applyProps(completeInstance, element.props)

        for _, child in pairs(element.children) do
            preMount(child, completeInstance)
        end

        if typeof(tree) == "Instance" then
            completeInstance.Parent = tree
        end

        return completeInstance
    end
end

function mount(element, tree)

    if type(element) == "table" then
        preMount(element, tree)
        element.Parent = tree
        task.wait()
        table.insert(Trees, element)
        return element
    end

end

function deepSearch(trees, tree)

    for index, value in pairs(trees) do
        if type(value) == "table" then
            if value == tree then
                return value, trees
            else
                return deepSearch(value, tree)
            end
        end
    end
end

function DeleteInstances(findTree)
    for index, value in pairs(findTree) do
        if index == "Parent" then continue end

        if typeof(value) == "Instance" then
            pcall(function()
                if value.Parent ~= nil then
                    value:Destroy()
                end
            end)
        elseif typeof(value) == "table" then
            DeleteInstances(value)
        end
    end
end

function unmount(tree)
    local findTree, parentTree = deepSearch(Trees, tree)

    local path

    if findTree then
        path = findTree.Parent
        DeleteInstances(findTree)

        local removed = table.find(parentTree, findTree)

        if removed then
            table.remove(parentTree, removed)
        end

    end

    return path, parentTree
end

function update(currentTree, newTree)
    local path = unmount(currentTree)
    return mount(newTree, path)
end

--// This is the Finished functions for virtual node
function finishedMount(element, path)
    local mounted = mount(element, path)
    ComponentSignal.didMount:Fire(element)
    return mounted
end

function finishedUnmount(element)
    -- // stuff will be added here
    ComponentSignal.willUnmount:Fire(element)
    unmount(element)
    ComponentSignal.didUnmount:Fire(element)
end

function finishedUpdate(currentTree, element)
    --// Stuff will be added here
    ComponentSignal.willUpdate:Fire(currentTree)
    local updated = update(currentTree, element)
    ComponentSignal.didUpdate:Fire(updated)
    return updated
end

reconciler.mount = finishedMount
reconciler.update = finishedUpdate
reconciler.unmount = finishedUnmount

return reconciler