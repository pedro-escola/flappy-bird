
local states = require("libs.states")

require("objects.player")
require("objects.pipe")

---@class GameState: state_handler
GameState = states.create()

GameState.score = 0

GameState:create("title", {
    ---@param self state
    ---@param delta number
    think = function (self, delta)
        GameState:changeState("game")
    end
})

---@class GameState_gameState: state
---@field score number
---@field objects table<integer, Object?>
---@field addObject fun(self: GameState_gameState, object: Object)

GameState:create("game", {
    score = 0,

    ---@param self GameState_gameState
    enter = function(self)
        self.objects = {}

        self.score = 0
        self:addObject(PlayerObject:clone())
        self:addObject(PipeSpawner:clone())
    end,

    ---@param self GameState_gameState
    ---@param delta number
    think = function(self, delta)
        local player = nil
        for _, obj in ipairs(self.objects) do
            if obj.think then
                obj:think(delta)
            end

            if obj.type == "Player" then
                player = obj
            elseif (player ~= nil)
            and obj.type == "Pipe" then
                player:handleCollision(obj)
            end
        end
    end,

    draw = function(self)
        for _, obj in ipairs(self.objects) do
            if obj.draw then
                obj:draw()
            end
        end

        love.graphics.print(tostring(self.score), 400, 0)
    end,

    ---@param self GameState_gameState
    addObject = function(self, obj)
        function obj.delete()
            for key, val in ipairs(self.objects) do
                if val == obj then
                    table.remove(self.objects, key)
                    break
                end
            end
        end

        table.insert(self.objects, obj)
    end
})