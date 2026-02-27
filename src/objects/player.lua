
local object = require("libs.object")

---@class Player: Object
---@field x number
---@field y number
---@field yVel number
PlayerObject = object.create({
    x = 16,
    y = 16,
    yVel = 0
})

local gravity = 20
local jump_vel = 7

local keysTime = {}
function PlayerObject:keyClicked(key)
    local isDown = love.keyboard.isDown(key)

    keysTime[key] = isDown and keysTime[key]+1 or 0
    return (keysTime[key] == 1)
end

---@param delta number
function PlayerObject:think(delta)
    self.yVel = self.yVel + (gravity * delta)

    if self:keyClicked("space") then
        self.yVel = -jump_vel
    end

    if self.y < 0 then
        self.y = 0
        self.yVel = 0
    end

    self.y = self.y + self.yVel
end

function PlayerObject:draw()
    love.graphics.rectangle("fill", self.x, self.y, 32, 32)
end