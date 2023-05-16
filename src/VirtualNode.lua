local VirtualTree = {}

local ExsistingFunctions = {}
local Trees = {}

function createInstance(name, props)
    local element

    local success, err = pcall(function()
        element = Instance.new(name)
    end)

    assert(success, err)

    for index, property in pairs(props) do

        if string.find(index, "Changed") then
            local PropertyType = string.split(index, ":")[2]

            local connection = element:GetPropertyChangedSignal(PropertyType):Connect(function(...)
                property(element, ...)
            end)

            if table.find(ExsistingFunctions, property) then
                connection:Disconnect()
            else
                table.insert(ExsistingFunctions, property)
            end

        elseif typeof(element[index]) == "RBXScriptSignal" then

            local connection = element[index]:Connect(function(...)
                property(element, ...)
            end)
        
            if table.find(ExsistingFunctions, property) then
                connection:Disconnect()
            else
                table.insert(ExsistingFunctions, property)
            end

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

    end

    if type(element.class) == "function" then
        local newElement = element.class(element.props)
        preMount(newElement, tree)
    end

end

function mount(element, tree)

    if type(element) == "table" then
        preMount(element, tree)
        table.insert(Trees, element)
        print(Trees)
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

    print(Trees)
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