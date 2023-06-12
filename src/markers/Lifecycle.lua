local Symbol = require(script.Parent:WaitForChild("Symbol"))

return {
    Updating = Symbol.assign("Updating"),
    Mounting = Symbol.assign("Mounting"),
    Unmounting = Symbol.assign("Unmounting"),
    Pending = Symbol.assign("Pending")
}