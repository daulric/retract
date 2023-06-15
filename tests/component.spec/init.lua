return function ()
    local ReTract = require(game.ReplicatedStorage.ReTract)
    local component = require(script:WaitForChild("testComponent"))
    local player = game.Players.LocalPlayer

    local handle = ReTract.createElement(component, {
        name = "hello"
    })

    local handler

    it("should mount an extended component", function()
        handler = component:__mount(handle, player.PlayerGui)
        expect(handler).to.be.ok()
    end)

    it("should update the component", function()
        expect(component:__update(ReTract.createElement(component, {
            name = "idk"
        }))).to.be.ok()
    end)

    it("unmount component", function()
        expect(component:__unmount()).to.never.be.ok()
    end)

end