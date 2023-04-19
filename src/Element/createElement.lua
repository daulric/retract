function createElement(class, properties, components)
    local success, element = pcall(function()
        local instance = Instance.new(class)
        return instance
    end)

    if not success then
        warn("not a valid instance!")
        return
    end
    
    if properties then
       local success, err = pcall(function()
            for propertyName, property in pairs(properties) do
                if typeof(element[propertyName]) == "RBXScriptSignal" and type(property) == "function" then

                    if propertyName:lower() == "changed" then

                        element[propertyName]:Connect(function(value)
                            local State = element[value]
                            property(element, value, State)
                        end)

                    else

                        element[propertyName]:Connect(function(...)
                            property(element, ...)
                        end)

                    end

                else
                    element[propertyName] = property
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