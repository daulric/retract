local Mounted = {}

type Stuff = {
    Object: Instance,
    Class: string,
    Component: {[any]: any},
    Properties: {[any]: any}
}

local Elements = {}

local connections = {}

-- // Initializing the tree \\ --

function SetProperty(element, propertyName, property)
    if propertyName:lower():find("changed") then
        local Property = string.split(propertyName, " ")
        local PropertyValue = Property[2]


        if element[PropertyValue] then

            local connection = element:GetPropertyChangedSignal(PropertyValue):Connect(function(...)
                property(element, ...)
            end)

            if table.find(connections, property) then
                connection:Disconnect()
            else
                table.insert(connections, property)
            end
            
        end


    elseif typeof(element[propertyName]) == "RBXScriptSignal" and type(property) == "function" then

        local connection = element[propertyName]:Connect(function(...)
           property(element, ...)
        end)

        if table.find(connections, property) then
            connection:Disconnect()
        else
            table.insert(connections, property)
        end

    else
        element[propertyName] = property
    end
end

function mountFragment(component, element)
    for index, value in pairs(component) do
        if index ~= "IsFragment" then
            local Created = ClassElement(value.Class, value.Properties, value.Component)
            Created.Object.Parent = element
        end
    end
end

function ClassElement(class, properties, components)
    properties = properties or {}
    components = components or {}

    local success, element = pcall(function()
        return Instance.new(class)
    end)

    if not success then
        warn("not a valid instance!", class)
        return
    end
    
    if properties then
        local success, err = pcall(function()
           for propertyName, property in pairs(properties) do
                SetProperty(element, propertyName, property)
            end
        end)

    end

    if components then
        for index, component in pairs(components) do
            if component then
                if component.IsFragment then
                   mountFragment(component, element)
                else
                    local Created = ClassElement(component.Class, component.Properties, component.Component)
                    Created.Object.Parent = element
                end
            end
        end
    end

    local final: Stuff = {
        Object = element,
        Class = class,
        Properties = properties,
        Component = components
    }

    return final
end

function ExtendedElement(class, properties)
    local success, data = pcall(function()
        if class.isExtended then
            return class
        end
    end)

    if not success then
        warn("this is not a component", class)
        return
    end

    for index, property in pairs(properties) do
        data.props[index] = property
    end

    local initSuccess, err = pcall(function()
        if data.init then
            task.spawn(function()
                data.init()
            end)
        end
    end)

    if not initSuccess then
        warn(err)
    end

    local renderSuccess, element = pcall(function()
        if data.render then
            return data:render()
        end
    end)

    if renderSuccess then
        return element
    end

end

function ifTree(class)

    local success, err = pcall(function()
        if class.Object then
            return true
        end
    end)

    return success
end

function createElement(class, properties, components)
    components = components or {}
    properties = properties or {}

    local Stuff: Stuff = {}

    if type(class) == "string" then
        Stuff = ClassElement(class, properties, components)
    elseif type(class) == "function" then
        local func = class(properties)
        Stuff = ClassElement(func.Class, func.Properties, func.Component)
        table.insert(Stuff.Component, components)
    elseif type(class) == "table" then
        local stuff = ExtendedElement(class, properties)
        Stuff = ClassElement(stuff.Class, stuff.Properties, stuff.Component)
        table.insert(Stuff.Component, components)
    end

    return Stuff
end

-- // Mounting Tree \\ --

function normalMount(tree, parent)
    if parent then
		if ifTree(parent) then			
            tree.Object.Parent = parent.Object
            table.insert(parent.Component, tree)
        else
            tree.Object.Parent = parent
            table.insert(Elements, tree)
        end
    end
end

function setFragment(tree, parent)
    for index, value in pairs(tree) do
        if index ~= "IsFragment" then
            if parent then
                if ifTree(parent) then
                    value.Object.Parent = parent.Object
                    table.insert(parent.Component, value)
                else
                    value.Object.Parent = parent
                end
            end
        end
    end
end

function isExtendTree(tree, element, parent, stuff)
    if parent then
        if ifTree(parent) then
            element.Object.Parent = parent.Object
            stuff.props = parent.props
            table.insert(parent.Component, tree)
        else
            element.Object.Parent = parent
        end
    end
end

function Mounted.mount(tree, parent)
    local class = createElement(tree.Class, tree.Properties, tree.Component)

    if type(class) == "table" then
        if class.Object then
            normalMount(class, parent)
            table.insert(Elements, class)
            return class
        end

        if class.IsFragment then
            setFragment(class, parent)
            return class
        end
    end

    if type(class) == "function" then
        local func

        if ifTree(parent) then
            func = tree(tree.Properties)
        else
            func = tree()
        end

        normalMount(func, parent)
    end

end

function unmount(tree, elements)
    local component

    pcall(function()

        for index, trees in pairs(elements) do
            if trees == tree then

                if tree.isExtended then
                    component = trees:render()
                elseif type(trees) == "function" then
                    component = tree()
                else
                    component = trees
                end

                component.Object:Destroy()

                elements[index] = nil
                break
                
            else
                unmount(tree, trees.Component)
            end
        end
    end)

end

function Mounted.unmount(tree)
    unmount(tree, Elements)
end

function Mounted.unmountChildren(tree)
    print(tree)
    if tree.Component then
        for index, trees in pairs(tree.Component) do
            if trees.Object then
                if trees.Object.Parent then
                    if trees.Object:GetChildren() >= 1 then
                        trees.Object:ClearAllChildren()
                    end

                    trees.Object:Destroy()
                end
            end

            tree.Component[index] = nil
        end
    end
end

function Mounted.GetElements()
    return table.freeze(table.clone(Elements))
end

return Mounted