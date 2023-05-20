local Component = {}
Component.__index = Component

function Component:setState(value: any)

	assert(table.isfrozen(self.state) or self.state.isState == true, `This is an invalid state. Please configure your state; Table ID: {tostring(self.state)}`)

	local NewClassState = table.clone(self.state)

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
	self.state = NewClassState
	table.freeze(self.state)
end

function Component:extend(name)
	-- this here runs the component once
	local class = {}

	if name ~= nil then
		class.name = ""..name
	end

	class.name = name
	class.state = {isState = true}
	table.freeze(class.state)
	class.isComponent = true

	setmetatable(class, Component)
	return class
end

return Component