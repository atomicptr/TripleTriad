local Grid = require "modules.grid"

local Pos = Grid.Pos

local M = {}

---@param hand integer[]
---@param board table<Pos, table<Pos, OwnedCard|nil>>
---@return EnemyPlan|nil
function M.calculate(hand, board)
    for _, row in ipairs { Pos.North, Pos.Center, Pos.South } do
        for _, col in ipairs { Pos.West, Pos.Center, Pos.East } do
            if not board[row][col] then
                -- found an empty spot, just place the first card, lmao

                return {
                    hand_index = 1,
                    target_pos = { row = row, col = col },
                }
            end
        end
    end

    return nil
end

return M
