
if arg[#arg] == "vsc_debug" then require("lldebugger").start() end

require("states.GameState")

function love.update(delta)
    GameState:execute("think", delta)
end

function love.draw()
    GameState:execute("draw")
    --love.graphics.print("Hello World!", 400, 300)
end