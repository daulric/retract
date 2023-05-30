return function ()
    local ReTract = require(game.ReplicatedStorage:WaitForChild("ReTract"))
    local element
    local handle
    local oldHandle
    local player = game.Players.LocalPlayer
        
    it("create an element", function()
        element = ReTract.createElement("Part", {Name = "Hello"})
        expect(element).to.be.ok()
    end)

    it("should mount the element", function()
        handle = ReTract.mount(element, player.PlayerGui)
        task.wait()
        expect(handle).to.be.ok()
    end)

    it("should update element", function()
        oldHandle = handle
        handle = ReTract.update(handle, ReTract.createElement("Part", {Name = "IDK"}))
        expect(handle).to.never.equal(oldHandle)
        expect(handle).to.be.ok()
    end)

    it("should unmount element", function()
        expect(ReTract.unmount(handle)).to.never.be.ok()
    end)

    it("custom retract properties", function()
        expect(ReTract.Gateway).to.be.ok()
        expect(ReTract.Attribute).to.be.ok()
        expect(ReTract.AttributeChange).to.be.ok()
        expect(ReTract.Change).to.be.ok()
        expect(ReTract.Children).to.be.ok()
        expect(ReTract.Event).to.be.ok()
    end)

end