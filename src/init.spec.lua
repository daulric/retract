local Players = game:GetService("Players")

return function ()
    local Uact = require(script.Parent)
    local NewIndex

    it("should create element", function()
        local Element = Uact:createElement("ScreenGui", {
            Name = "Ulric",
            IgnoreGuiInset = true
        }, {
            ["k_21"] = Uact:createElement("Frame", {
                Name = "Idk",
                Size = UDim2.new(1, 0, 1, 0)
            }, {
                daulric = Uact:createElement("TextButton", {
                    Name = "daulric",
                    Text = "daulric",
                    BackgroundColor3 = Color3.fromRGB(137, 21, 21),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 1, 0),
                    TextScaled = true,
                    MouseButton1Click  = function(element)
                        print(element.Name)
                    end
                })
            })
        })

        expect(Element).to.be.a("table")
        Players.PlayerAdded:Connect(function(player)
            Element.Object.Parent = player.PlayerGui
        end)
    end)

end