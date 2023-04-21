function SetProperty(element, propertyName, property)
    if propertyName:lower():find("changed") then
        local Property = string.split(propertyName, " ")
        local PropertyValue = Property[2]

        if element[PropertyValue] then

            element:GetPropertyChangedSignal(PropertyValue):Connect(function(...)
                property(element, ...)
            end)
            
        elseif element:GetAttribute(PropertyValue) then
            element:GetAttributeChangedSignal(PropertyValue):Connect(function(...)
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

function createElement(class, properties, components)
    components = components or {}
    properties = properties or {}

    local success, element = pcall(function()
        local instance = Instance.new(class)
        return instance
    end)

    if not success then
        warn("not a valid instance!", class)
        return
    end
    
    if properties then
        local success, err = pcall(function()
            if properties.Attributes then
                for index, attribute in pairs(properties.Attributes) do
                    element:SetAttribute(index, attribute)
                end
            end

            for propertyName, property in pairs(properties) do
                if propertyName ~= "Attributes" then
                    SetProperty(element, propertyName, property)  
                end
            end
       end)

       if not success then
            warn(err)
       end
    end
    

    if components then
        local success, err = pcall(function()
            for _, component in pairs(components) do
                if component then
                    local Created = createElement(component.Class, component.Properties, component.Component)
                    Created.Object.Parent = element
                end
            end
        end)

        if not success then
            warn(err)
        end
    end

    return {
        Object = element,
        Class = class,
        Component = components,
        Properties = properties,
    }
end

return createElement