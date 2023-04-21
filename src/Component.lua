local Component = {}

function Register(class: {[any]: any}, name)
	class.name = name

	class.state = {}
	class.state.isState = true
	table.freeze(class.state)

	function class:setState(value: any)
		if not table.isfrozen(class.state) and class.state.isState ~= true then
			warn("this table was not properly set!")
			return
		end

		local NewClassState = table.clone(class.state)

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
		class.state = NewClassState
		table.freeze(class.state)
	end

	if name ~= nil then
		class.name = ""..name
	end
	
end

function Component:extend(name)
	-- this here runs the component once
	local class = {}
	Register(class, name)
	class.isExtended = true

	return class
end

return Component