
local states = require("libs.states")

require("objects.player")

GameState = states.create()

GameState:create("title", {
    ---@param self state
    ---@param delta number
    think = function (self, delta)
        GameState:changeState("game")
    end
})

GameState:create("game", {
    ---@param self state
    ---@param delta number
    think = function(self, delta)
        PlayerObject:think(delta)
    end,

    draw = function(self)
        PlayerObject:draw()
    end
})