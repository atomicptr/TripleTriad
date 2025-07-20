local SmartAI = require "main.ai.smart"

local M = {}

---@param hand integer[]
---@param board GameField
---@param rules Ruleset[]
---@return EnemyPlan|nil
function M.calculate(hand, board, rules)
    return SmartAI.random_move(hand, board)
end

return M
