
if arg[#arg] == "vsc_debug" then require("lldebugger").start() end

local images = {}
---@param path string
function GetImage(path)
    if images[path] == nil then
        images[path] = love.graphics.newImage(path)
    end

    return images[path]
end

function love.load()
    love.graphics.setBackgroundColor(75 / 255, 220 / 255, 1)
end

require("states.GameState")

function love.update(delta)
    GameState:execute("think", delta)
end

function love.draw()
    GameState:execute("draw")
    --love.graphics.print("Hello World!", 400, 300)
end