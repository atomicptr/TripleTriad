local SmartAI = require "main.ai.smart"

local M = {}

---@param hand integer[]
---@param board table<Pos, table<Pos, OwnedCard|nil>>
---@return EnemyPlan|nil
function M.calculate(hand, board)
    return SmartAI.random_move(hand, board)
end

return M
