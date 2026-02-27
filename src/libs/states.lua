
local states = {}

local blankFunc = function() end

---@class state
local base_state = {
    enter = blankFunc, ---@type fun(self: state, prevState: state)?
    exit = blankFunc, ---@type fun(self: state, curState: state)?
    think = blankFunc, ---@type fun(self: state, delta: number)?
    draw = blankFunc ---@type fun(self: state)?
}

local state_meta = { ---@type metatable
    __index = base_state
}

---@class state_handler
local base_handler = {
    enums = {},
    states = {}, ---@type table<number, state>
    curState = 1 ---@type integer
}

---Creates a new state.
---@param name string
---@param funcs state?
---@return state?
function base_handler:create(name, funcs)
    if not name then return end

    name = name:upper()

    if self.enums[name] then
        error("That state already exists!", 2)
        return
    end

    local enum = 1
    for _ in pairs(self.enums) do
        enum = enum + 1
    end
    self.enums[name] = enum

    local newState = setmetatable(funcs or {}, state_meta)
    self.states[enum] = newState

    return newState
end

---Executes the current state's `func_name` function, if it exists.
---@param func_name any
---@return unknown
function base_handler:execute(func_name, ...)
    local curState = self.states[self.curState] or base_state

    if curState[func_name] then
        return curState[func_name](curState, ...)
    end
    
    return nil
end

---comment
---@param newState string | integer
function base_handler:changeState(newState)
    local newState_type = type(newState)
    if newState_type ~= "string" and newState_type ~= "number" then return end

    local newState_num = nil ---@type integer
    if newState_type == "string"
    and self:getState(newState) then
        newState_num = self.enums[newState:upper()]
    elseif newState_type == "number" then
        newState_num = newState
    end

    local newState_state = self.states[newState_num] or 0
    local oldState = self.states[self.curState] or 0

    self:execute("exit", newState_state)
    self.curState = newState_num
    self:execute("enter", oldState)
end

---Gets a state from its name.
---@param name string
---@return state?
function base_handler:getState(name)
    if not name then return end

    name = name:upper()
    if self.enums[name] then
        return self.states[self.enums[name]]
    end
end

local metatable = { ---@type metatable
    __index = base_handler
}

---Creates a new state handler.
---@return state_handler
function states.create()
    return setmetatable({}, metatable)
end

return states