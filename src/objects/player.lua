
local object = require("libs.object")

---@class Player: Object
---@field x number
---@field y number
---@field yVel number
---@field width number
---@field height number
---@field type "Player"
PlayerObject = object.create({
    x = 16,
    y = 300 - 16,
    yVel = 0,
    width = 32,
    height = 32,

    type = "Player"
})

local gravity = 20
local jump_vel = 7

local keysTime = {}
function PlayerObject:keyClicked(key)
    local isDown = love.keyboard.isDown(key)

    keysTime[key] = isDown and keysTime[key] and keysTime[key]+1 or 0
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

    if self.y + self.height >= 600 then
        GameState:changeState("title")
        return
    end

    self.y = self.y + self.yVel
end

function PlayerObject:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

---@param pipe Pipe
function PlayerObject:handleCollision(pipe)
    if self.x + self.width < pipe.x or self.x > pipe.x + pipe.width then return end

    local halfGap = pipe.gap/2
    if self.y > pipe.y - halfGap and self.y + self.height < pipe.y + halfGap then return end

    GameState:changeState("title")
end