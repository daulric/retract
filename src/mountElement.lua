local Mounted = {}
local Elements = {}

function Extended(extendClass)
    if extendClass.init then
        local success, err = pcall(function()
            extendClass:init()
        end)

        if not success then
            warn(err)
        end
    end

    if extendClass.render then
        local GetElement

        local success, err = pcall(function()
            GetElement = extendClass:render()
        end)

        if not success then
            warn(err)
        end

        return extendClass, GetElement
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

function Mounted.mount(tree, parent: Instance)

    if tree.Object then
        if parent then
            if ifTree(parent) then
                tree.Object.Parent = parent.Object
            else
                tree.Object.Parent = parent
            end
        end

        table.insert(Elements, tree)
        return tree
    end

    if tree.isExtended then
		local stuff, element = Extended(tree)
		
        if parent then
            if ifTree(parent) then
                element.Object.Parent = parent.Object
                table.insert(parent.Component, tree)
            else
                element.Object.Parent = parent
            end
        end
        
        return tree
    end
end

function unmount(elements, tree)

    pcall(function()
        for index, trees in pairs(elements) do
            if trees == tree then
                Elements[index].Object:Destroy()
                Elements[index] = nil
                break
            else
                -- this loops the tree until the table is equal to the table
                unmount(elements[index], tree)
                break
            end
        end
    end)

end

function Mounted.unmount(tree)
    unmount(Elements, tree)
end

function Mounted.update(tree, newTree)
    local parent

    if tree.Object.Parent ~= nil then
        parent = tree.Object.Parent
        tree.Object:Destroy()
    end

    tree = newTree

    if parent ~= nil then
        Mounted.mount(newTree, parent)
    end
    
    return newTree
end

function Mounted.GetElements()
    return table.freeze(table.clone(Elements))
end

return Mounted