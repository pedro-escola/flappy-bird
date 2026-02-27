
local objects = {}

local emptyFunc = function() end
---@class Object
local obj_class = {}

function obj_class:clone()
    return setmetatable({}, {__index = self})
end

---@param obj table?
---@return Object
function objects.create(obj)
    return setmetatable((obj or {}), {__index = obj_class})
end

return objects