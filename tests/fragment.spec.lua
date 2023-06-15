return function ()
    local retract = require(game.ReplicatedStorage.ReTract)
    local fragment
    local handle

    it('should create a fragment', function()
        fragment = retract.createFragment({
            Hello = retract.createElement("TextLabel", {
                Name = "Hello"
            }),
            Bye = retract.createElement("TextLabel", {
                Name = "bye"
            })
        })

        expect(fragment.elements).to.be.ok()
        expect(fragment).to.be.ok()
    end)

    it("should mount the fragment", function()
        handle = retract.mount(fragment, game.Workspace)
        expect(handle).to.be.ok()
    end)

    it("should update fragment", function()
        handle = retract.update(handle, fragment)
        expect(handle).to.be.ok()
    end)

    it("should unmount fragment", function()
        expect(retract.unmount(handle)).to.never.to.be.ok()
    end)

end