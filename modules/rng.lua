local tblx = require "modules.tbl"

local M = {}

function M.init()
    math.randomseed(os.time())
end

---@param rate float from 0.0 to 1.0, for 30% use 0.3
---@return boolean
function M.chance(rate)
    rate = math.max(rate, 0.0)
    rate = math.min(rate, 1.0)

    return math.random() < rate
end

---@return boolean
function M.flip_coin()
    return M.chance(0.5)
end

function M.draw(tbl)
    local index = M.draw_index(tbl)

    if not index then
        return nil
    end

    return tbl[index]
end

function M.draw_index(tbl)
    if not tbl or tblx.count(tbl) == 0 then
        return nil
    end

    return math.random(1, tblx.count(tbl))
end

function M.enum(tbl)
    local items = {}

    for _, v in pairs(tbl) do
        table.insert(items, v)
    end

    return M.draw(items)
end

return M
