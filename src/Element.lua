type Stuff = {
    Object: Instance,
    Class: string,
    Component: {[any]: any},
    Properties: {[any]: any}
}

function SetProperty(element, propertyName, property)
    if propertyName:lower():find("changed") then
        local Property = string.split(propertyName, " ")
        local PropertyValue = Property[2]


        if element[PropertyValue] then

            element:GetPropertyChangedSignal(PropertyValue):Connect(function(...)
                property(element, ...)
            end)
            
        end


    elseif typeof(element[propertyName]) == "RBXScriptSignal" and type(property) == "function" then

        element[propertyName]:Connect(function(...)
           property(element, ...)
        end)

    else
        element[propertyName] = property
    end
end

function setFragment(component, element)
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
                   setFragment(component, element)
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

function createElement(class, properties, components)
    components = components or {}
    properties = properties or {}

    local Elements: Stuff = {}

    if type(class) == "string" then
        Elements = ClassElement(class, properties, components)
    elseif type(class) == "function" then
        local func = class(properties)
        Elements = ClassElement(func.Class, func.Properties, func.Component)
        table.insert(components, Elements.Component)
    end

    return Elements
end

function createFragment(component)
    local elements = {}
    elements.IsFragment = true

    local success, err = pcall(function()
        for index, components in pairs(component) do
            if components then
                local Created = createElement(components.Class, components.Properties, components.Component)
                elements[index] = Created
            end
        end
    end)

    if success then
        return elements
    end
end

return {
    createFragment = createFragment,
    createElement = createElement,
}