
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
    width = 48,

    type = "Pipe"
})

function Pipe:think(delta)
    self.x = math.floor(self.x - 144*delta)

    if self.x <= -self.width then
        self:delete()
    end
end

function Pipe:draw()
    local halfGap = self.gap / 2

    local pipeBottom = GetImage("assets/pipebottom.png")
    local pipeTop = GetImage("assets/pipetop.png")

    -- desenha o cano do topo
    for y = self.y - halfGap - 32, -32, -16 do
        love.graphics.draw(pipeBottom, self.x, y)
    end
    love.graphics.draw(pipeTop, self.x, self.y - halfGap - 16)

    -- desenha o cano de baixo
    for y = self.y + halfGap + 16, 632, 16 do
        love.graphics.draw(pipeBottom, self.x, y)
    end
    love.graphics.draw(pipeTop, self.x, self.y + halfGap)
end

---@class PipeSpawner: Object
---@field time number
---@field curState state?
PipeSpawner = object.create({
    time = 9999
})

function PipeSpawner:think(delta)
    if self.time > 2 then
        local state = GameState:getState() ---@cast state state
        if state.addObject then
            local pipe = Pipe:clone() ---@cast pipe Pipe

            pipe.x = 800
            pipe.y = math.random(100, 500)

            state:addObject(pipe)
        end

        print("spawn pipe!")
        self.time = 0
    end

    self.time = self.time + delta
end