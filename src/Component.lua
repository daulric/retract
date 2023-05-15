local Component = {}
Component.__index = Component
Component.state = {}
Component.props = {}
table.freeze(Component.state)

function Component:setState(value: any)

	if not table.isfrozen(Component.state) and Component.state.isState ~= true then
		warn("this table was not properly set!")
		return
	end

	local NewClassState = table.clone(Component.state)

	if type(value) == "table" then
		for index, stuff in pairs(value) do
			NewClassState[tostring(index)] = stuff
		end
	elseif type(value) == "function" then
		local newState = value(NewClassState)

		if type(newState) == "table" then 
			for index, stuff in pairs(newState) do
				NewClassState[tostring(index)] = stuff
			end
		else
			table.insert(NewClassState, value)
		end
	end

	NewClassState.isState = true
	Component.state = NewClassState
	table.freeze(Component.state)
end

function Component:extend(name)
	-- this here runs the component once
	local class = {}

	if name ~= nil then
		class.name = ""..name
	end

	class.name = name

	setmetatable(class, Component)

	class.isExtended= true

	return class
end

return Component