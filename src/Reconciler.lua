local markers = script.Parent:WaitForChild("markers")
local ElementType = require(markers:WaitForChild("ElementType"))
local Symbol = require(markers:WaitForChild("Symbol"))
local Children = require(markers:WaitForChild("Children"))

local InternalData = Symbol.assign("Internal Data")

function createReconciler(renderer)
    local reconciler

    local mountNode
    local unmountNode
    local updateNode

    local function replaceVirtualNode(virtualNode: VirtualNode, newElement)
		local hostParent = virtualNode.hostParent
		local hostKey = virtualNode.hostKey
		local parent = virtualNode.parent
        local depth = virtualNode.depth

		if not virtualNode.wasUnmounted then
			unmountNode(virtualNode)
		end

		local newNode = mountNode(newElement, hostParent)

		if newNode ~= nil then
			newNode.depth = depth
			newNode.parent = parent
		end

		return newNode
	end

    local function updateChildren(virtualNode: VirtualNode, hostParent, newChildElements)
        virtualNode.updateChildrenCount = virtualNode.updateChildrenCount + 1

		local currentUpdateChildrenCount = virtualNode.updateChildrenCount

		local removeKeys = {}

		for childKey, childNode in pairs(virtualNode.children) do
			local newElement = ElementType.getElementByID(newChildElements, childKey)

			local newNode = updateNode(childNode, newElement)

			if virtualNode.updateChildrenCount ~= currentUpdateChildrenCount then
				if newNode and newNode ~= virtualNode.children[childKey] then
					unmountNode(newNode)
				end

				return
			end

			if newNode ~= nil then
				virtualNode.children[childKey] = newNode
			else
				removeKeys[childKey] = true
			end
		end

		for childKey in pairs(removeKeys) do
			virtualNode.children[childKey] = nil
		end

		for childKey, newElement in ElementType.iterateElements(newChildElements) do

			if virtualNode.children[childKey] == nil then
				local childNode = mountNode(
					newElement,
					hostParent,
                    virtualNode.context,
                    virtualNode.legacyContext
				)

				if virtualNode.updateChildrenCount ~= currentUpdateChildrenCount then
					if childNode then
						unmountNode(childNode)
					end

					return
				end

				if childNode ~= nil then
					childNode.depth = virtualNode.depth + 1
					childNode.parent = virtualNode
					virtualNode.children[childKey] = childNode
				end

			end
		end
    end

    local function createVirtualNode(element, hostParent, context, legacyContext)
        return {
            currentElement = element,
            Type = ElementType.Types.Element,
            hostParent = hostParent,
            depth = 0,
            wasUnmounted = false,
            parent = nil,
            object = nil,
            updateChildrenCount = 0,
            children = {},
            context = context or {},
            legacyContext = legacyContext,
            parentLegacyContext = legacyContext,
            originalContext = nil
        }
    end

    type VirtualNode = typeof(createVirtualNode())

    local function mountFunctionalNode(virtualNode: VirtualNode)
        local currentElement = virtualNode.currentElement
        local stuff = currentElement.class(currentElement.props)
        updateChildren(virtualNode, virtualNode.hostParent, stuff)
    end

    local function mountFragmentNode(virtualNode: VirtualNode)
        local currentElement = virtualNode.currentElement
        local children = currentElement.elements

        updateChildren(virtualNode, virtualNode.hostParent, children)
    end

    local function mountGatewayNode(virtualNode: VirtualNode)
        local currentElement = virtualNode.currentElement
        local path = currentElement.props.path
        local children = currentElement.props[Children]

        assert(renderer.isHostObject(path), `{path} is not a valid object`)

        updateChildren(virtualNode, path, children)
    end

    function mountNode(element, hostParent, context, legacyContext)
        local virtualNode = createVirtualNode(element, hostParent, context, legacyContext)
        local currentElement = virtualNode.currentElement

        local Type = element.Type

        if Type == ElementType.Types.Host then
            renderer.mountHostNode(virtualNode, reconciler)
        elseif Type == ElementType.Types.Functional then
            mountFunctionalNode(virtualNode)
        elseif Type == ElementType.Types.Fragment then
            mountFragmentNode(virtualNode)
        elseif Type == ElementType.Types.Gateway then
            mountGatewayNode(virtualNode)
        elseif Type == ElementType.Types.StatefulComponent then
            currentElement.class:__mount(reconciler, virtualNode)
        end

        return virtualNode
    end

    local function unmoutVirtualNodeChildren(virtualNode: VirtualNode)
        for i, v in pairs(virtualNode.children) do
            unmountNode(v)
        end
    end

    function unmountNode(virtualNode: VirtualNode)
        local element = virtualNode.currentElement
        local Type = ElementType.of(element)

        if Type == ElementType.Types.Host then
            renderer.unmountHostNode(virtualNode, reconciler)
        elseif Type == ElementType.Types.Functional then
            unmoutVirtualNodeChildren(virtualNode)
        elseif Type == ElementType.Types.Fragment then
            unmoutVirtualNodeChildren(virtualNode)
        elseif Type == ElementType.Types.Gateway then
            unmoutVirtualNodeChildren(virtualNode)
        elseif Type == ElementType.Types.StatefulComponent then
            virtualNode.instance:__unmount()
        else
            error(`Unknown Element Virtual Tree ID: {element}`)
        end

    end

    local function updateFunctionalNode(virtualNode: VirtualNode, newElement)
        local children = newElement.class(newElement.props)
        updateChildren(virtualNode, virtualNode.hostParent, children)
        return virtualNode
    end

    local function updateGatewayNode(virtualNode: VirtualNode, newElement)
        local oldElement = virtualNode.currentElement
        local oldPath = oldElement.props.path

        local hostPath = newElement.props.path

        if oldPath ~= hostPath then
            return replaceVirtualNode(virtualNode, newElement)
        end

        local children = newElement.props[Children]

        updateChildren(virtualNode, hostPath, children)

        return virtualNode
    end

    local function updateFragmentNode(virtualNode: VirtualNode, newElement)
        updateChildren(virtualNode, virtualNode.hostParent, newElement.elements)
        return virtualNode
    end

    function updateNode(virtualNode: VirtualNode, newElement, newState)
        if virtualNode.currentElement == newElement and newState == nil then
			return virtualNode
		end

		if typeof(newElement) == "boolean" or newElement == nil then
			unmountNode(virtualNode)
			return nil
		end

		if virtualNode.currentElement.component ~= newElement.component then
			return replaceVirtualNode(virtualNode, newElement)
		end

        local Type = ElementType.of(newElement)
        local shouldContinueUpdate = true

        if Type == ElementType.Types.Host then
            virtualNode = renderer.updateHostNode(virtualNode, reconciler, newElement)
        elseif Type == ElementType.Types.Functional then
            virtualNode = updateFunctionalNode(virtualNode, newElement)
        elseif Type == ElementType.Types.Fragment then
            virtualNode = updateFragmentNode(virtualNode, newElement)
        elseif Type == ElementType.Types.Gateway then
            virtualNode = updateGatewayNode(virtualNode, newElement)
        elseif Type == ElementType.Types.StatefulComponent then
            shouldContinueUpdate = virtualNode.instance:__update(newElement, newState)
        else
            error("Unknown Element Type!")
        end

        if not shouldContinueUpdate then
			return virtualNode
		end

        virtualNode.currentElement = newElement
        return virtualNode
    end

    local function mountVirtualTree(element, hostParent)
        local tree = {
            Type = ElementType.Types.VirtualTree,
            [InternalData] = {
                rootNode = nil,
                mounted = true,
            }
        }

        tree[InternalData].rootNode = mountNode(element, hostParent)
        return tree
    end

    local function updateVirtualTree(tree, newElement)
        local InternalData = tree[InternalData]
        InternalData.rootNode = updateNode(InternalData.rootNode, newElement)
        return tree
    end

    local function unmountVirtualTree(virtualTree)
        if virtualTree[InternalData].rootNode then
            local rootNode = virtualTree[InternalData].rootNode
            unmountNode(rootNode)
        end
    end

    reconciler = {
        updateChildren = updateChildren,
        replaceVirtualNode = replaceVirtualNode,
        mountNode = mountNode,
        unmountNode = unmountNode,
        updateNode = updateNode,
        mountVirtualTree = mountVirtualTree,
        updateVirtualTree = updateVirtualTree,
        unmountVirtualTree = unmountVirtualTree,
    }

    return reconciler

end

return createReconciler