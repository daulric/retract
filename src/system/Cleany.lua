local Cleany = {}
Cleany.__index = Cleany

function Cleany.create()

    return setmetatable({
        _objects = {},
        _cleaning = false
    }, Cleany)

end

function Cleany:Add(object)
    assert(self._cleaning ~= true, "cleaning in process")

    table.insert(self._objects, object)

    return object
end

function Cleany:Remove(object)
    assert(self._cleaning ~= true, "cleaning in process")

    local findObject = table.find(self._objects, object)
    local obj = self._objects[findObject]

    if findObject and obj then
        if typeof(obj) == "Instance" then
            obj:Destroy()
        elseif typeof(obj) == "RBXScriptConnection" and obj.Connected then
            obj:Disconnect()
        end
        
        table.remove(self._objects, findObject)
    else
        warn("couldn't find", object, "in the cleanup")
    end

end

function Cleany:Contruct(class, ...)
    assert(self._cleaning ~= true, "cleaning in proccess; cannot continue with contruct")

    if type(class) == "table" then
        local object = class.new(...)
        return self:Add(object)
    elseif type(class) == "function" then
        local object = class(...)
        return self:Add(object)
    end

end

function Cleany:AddMultiple(...)

    assert(self._cleaning ~= true, "cleaning in process")

    local items = {...}

    for _, item in pairs(items) do
        self:Add(item)
    end

    return items
end

function Cleany:Connect(Connection: RBXScriptSignal, callback)

    assert(self._cleaning ~= true, "cleaning in process")

    local scriptConnection: RBXScriptConnection = Connection:Connect(callback)

    return self:Add(scriptConnection)
end

function GetCleanupDetails(obj)

    if typeof(obj) == "RBXScriptConnection" then
        return "Disconnect"
    end

    if typeof(obj) == "Instance" then
        return "Destroy"
    end

    if typeof(obj) == "table" then
        if type(obj.Destroy) == "function" then
            return "Destroy"
        elseif type(obj.Disconnect) == "function" then
            return "Disconnect"
        end
    end

    error("cannot get a function", 2)

end

function Clean(self)
    for _, obj in pairs(self._objects) do

        if typeof(obj) == "thread" then
            coroutine.close(obj)
        else
            local getCleanupType = GetCleanupDetails(obj)
            obj[getCleanupType](obj)
        end

    end
end

function Cleany:Clean()

    assert(self._cleaning ~= true, "already cleaning")

    if self then
        self._cleaning = true
        Clean(self)
        table.clear(self._objects)
        self._cleaning = false
        return true
    end
end

return Cleany