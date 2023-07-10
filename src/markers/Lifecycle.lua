local Symbol = require(script.Parent:WaitForChild("Symbol"))

return {
    DidMount = Symbol.assign("DidMount"),
    WillUpdate = Symbol.assign("willUpdate"),
    DidUpdate = Symbol.assign("didUpdate"),
    WillUnmount = Symbol.assign("willUnmount"),
    ReconcileChildren = Symbol.assign("ReconcileChildren"),
    Render = Symbol.assign("Render"),
    Init = Symbol.assign("Init"),
    Idle = Symbol.assign("Idle"),
    ShouldUpdate = Symbol.assign("Should Update"),

    Updating = Symbol.assign("Updating"),
    Mounting = Symbol.assign("Mounting"),
    Unmounting = Symbol.assign("Unmounting"),
    Pending = Symbol.assign("Pending"),
}