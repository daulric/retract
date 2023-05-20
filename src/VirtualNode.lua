local VirtualTree = {}

local Trees = {}

local system = script.Parent:WaitForChild("system")
local markers = script.Parent:WaitForChild("markers")
local Type = require(markers.Type)
local EventManager = require(system.EventManager)

function createInstance(name, props)
    local element

    local success, err = pcall(function()
        element = Instance.new(name)
    end)

    assert(success, err)

    for index, property in pairs(props) do

        if index.Type == Type.Change then
            EventManager:PropertyChange(element, index, property)
        elseif index.Type == Type.Attribute then
            element:SetAttribute(index.name, property)
        elseif index.Type == Type.Event then
            EventManager:SignalEvent(element, index, property)
        else
            element[index] = property
        end

    end

    return element
end

function preMount(element, tree)

    if type(element.class) == "string" then
        local completeInstance = createInstance(element.class, element.props)
        element.instance = completeInstance

        for _, value in pairs(element.components) do

            if value.isFragment then
                for index, node in pairs(value) do
                    if index ~= "isFragment" then
                        preMount(node, completeInstance)
                    end
                end
            else
                preMount(value, completeInstance)
            end

        end

        if typeof(tree) == "Instance" then
            completeInstance.Parent = tree
        end

        return completeInstance
    end

    if type(element.class) == "function" then
        local newElement = element.class(element.props)
        element.components = {}
        element.instance = preMount(newElement, tree)
    end

    if type(element.class) == "table" then
        local newElement = element.class
        element.components = {}

        if newElement.isComponent then

            newElement:setState(element.props)

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

    return path
end

function update(currentTree, newTree)
    local path = unmount(currentTree)
    return mount(newTree, path)
end

VirtualTree.mount = mount
VirtualTree.update = update
VirtualTree.unmount = unmount

return VirtualTree