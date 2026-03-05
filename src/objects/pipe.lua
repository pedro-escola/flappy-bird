
local object = require("libs.object")

--local pipeGap = 168
local pipeGap = 128

---@class Pipe: Object
---@field x number
---@field y number
---@field gap number
---@field width number
---@field delete fun()
---@field type "Pipe"
Pipe = object.create({
    x = 0,
    y = 0,
    gap = pipeGap,
    width = 32,

    type = "Pipe"
})

function Pipe:think(delta)
    self.x = self.x - 128*delta

    if self.x <= -32 then
        self:delete()
    end
end

function Pipe:draw()
    local halfGap = self.gap / 2
    love.graphics.rectangle("fill", self.x, 0, 32, self.y - halfGap)
    love.graphics.rectangle("fill", self.x, self.y + halfGap, 32, 1024)
end

---@class PipeSpawner: Object
---@field time number
---@field curState state?
PipeSpawner = object.create({
    time = 9999
})

function PipeSpawner:think(delta)
    if self.time > 2 then
        local state = GameState:getState()
        if state.addObject then
            local pipe = Pipe:clone()

            pipe.x = 800
            pipe.y = math.random(100, 500)

            state:addObject(pipe)
        end

        print("spawn pipe!")
        self.time = 0
    end

    self.time = self.time + delta
end