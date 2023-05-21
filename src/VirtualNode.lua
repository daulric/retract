local VirtualNode = {}

local Trees = {}

local system = script.Parent:WaitForChild("system")
local markers = script.Parent:WaitForChild("markers")
local Type = require(markers.Type)
local ElementType = require(markers.ElementType)
local Children = require(markers.Children)

local ComponentSignal = require(system.ComponentSignal)

function createInstance(name, props)
    local element

    local success, err = pcall(function()
        element = Instance.new(name)
    end)

    assert(success, err)

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

    return element
end

function ManageFragment(fragment, tree)
    for index, node in pairs(fragment.components) do
        print("building fragment")
        preMount(node, tree)
    end
end

function ComponentAspectSignal(newElement, element)

    task.spawn(function()
        if newElement.willUnmount then
            ComponentSignal.unmountSignal:Connect(function(tree)
                if tree == element then
                    task.spawn(newElement.willUnmount, newElement)
                end
            end)
        end
    end)

    task.spawn(function()
        if newElement.willUpdate then
            ComponentSignal.updateSignal:Connect(function(tree)
                if tree == element then
                    task.spawn(newElement.willUpdate, newElement)
                end
            end)
        end
    end)
end

function preMount(element, tree)

    if element.Type == ElementType.Types.Host then
        local completeInstance = createInstance(element.class, element.props)
        element.instance = completeInstance

        for _, child in pairs(element.children) do
            preMount(child, completeInstance)
        end

        if typeof(tree) == "Instance" then
            completeInstance.Parent = tree
        end

        return completeInstance
    end

    if element.Type == ElementType.Types.Functional then
        local newElement = element.class(element.props)
        assert(newElement ~= nil, `there is nothing in this function; {debug.traceback()}`)
        element.instance = preMount(newElement, tree)
    end

    if element.Type == ElementType.Types.StatefulComponent then
        local newElement = element.class

        if newElement.isComponent then
            newElement.props = element.props
            ComponentAspectSignal(newElement, element)

            if newElement.init then
                local success, err = pcall(newElement.init, newElement)
                assert(success, err)
            end
    
            if newElement.render then
                local elements = newElement:render()
                assert(elements ~= nil, `there is nothing to render; {debug.traceback()}`)
                element.instance = preMount(elements, tree)
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

end

function mount(element, tree)

    if type(element) == "table" then
        preMount(element, tree)
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

function unmount(tree)
    local findTree, parentTree = deepSearch(Trees, tree)

    local path

    if findTree then

        if findTree.instance then
            path = findTree.instance.Parent
            findTree.instance:Destroy()
            findTree.instance = nil
        end

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

function finishedUnmount(element)
    -- // stuff will be added here
    ComponentSignal.unmountSignal:Fire(element)
    task.wait()
    return unmount(element)
end

function finishedUpdate(currentTree, element)
    --// Stuff will be added here
    ComponentSignal.updateSignal:Fire(currentTree)
    task.wait()
    return update(currentTree, element)
end

VirtualNode.mount = mount
VirtualNode.update = finishedUpdate
VirtualNode.unmount = finishedUnmount

return VirtualNode