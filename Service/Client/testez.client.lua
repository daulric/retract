local testEz = require(game.ReplicatedStorage.testez)

local testReporter = testEz.Reporters.TextReporter

testEz.TestBootstrap:run({game.ReplicatedStorage.tests}, testReporter)