local cards = require "main.data.cards"
local Grid = require "modules.grid"
local Rng = require "modules.rng"

local Pos = Grid.Pos

local M = {}

local function is_board_empty(board)
    for _, row in ipairs { Pos.North, Pos.Center, Pos.South } do
        for _, col in ipairs { Pos.West, Pos.Center, Pos.East } do
            if board[row][col] then
                return false
            end
        end
    end

    return true
end

---@return BoardPos[]
local function find_empty_corners(board)
    local corners = {}

    for _, row in ipairs { Pos.North, Pos.South } do
        for _, col in ipairs { Pos.West, Pos.East } do
            if not board[row][col] then
                table.insert(corners, { row = row, col = col })
            end
        end
    end

    return corners
end

---@param hand integer[]
---@param sides ("top"|"bottom"|"left"|"right")[]
local function find_max_sum_from_hand(hand, sides)
    local sums = {}

    for index, card_id in ipairs(hand) do
        local card = cards[card_id]

        sums[index] = 0

        for _, side in ipairs(sides) do
            sums[index] = sums[index] + card[side]
        end
    end

    local max_index = 1
    local max_value = 0

    for index, sum in ipairs(sums) do
        if sum > max_value then
            max_index = index
        end
    end

    return { index = max_index, sum = max_value }
end

---@param hand integer[]
---@param board table<Pos, table<Pos, OwnedCard|nil>>
---@return EnemyPlan|nil
local function defensive_move(hand, board)
    local corners = find_empty_corners(board)

    -- NOTE: this case cant happen when ai starts first
    if #corners == 0 then
        return nil
    end

    local nw = find_max_sum_from_hand(hand, { "top", "left" })
    local ne = find_max_sum_from_hand(hand, { "top", "right" })
    local sw = find_max_sum_from_hand(hand, { "bottom", "left" })
    local se = find_max_sum_from_hand(hand, { "bottom", "right" })

    -- TODO: find best option
    local corner = Rng.draw(corners)

    if not corner then
        return nil
    end

    if corner.row == Pos.North then
        if corner.col == Pos.West then
            return {
                hand_index = nw.index,
                target_pos = corner,
            }
        else
            return {
                hand_index = ne.index,
                target_pos = corner,
            }
        end
    else
        if corner.col == Pos.West then
            return {
                hand_index = sw.index,
                target_pos = corner,
            }
        else
            return {
                hand_index = se.index,
                target_pos = corner,
            }
        end
    end
end

---@param card Card
---@param board table<Pos, table<Pos, OwnedCard|nil>>
---@return BoardPos[]
local function find_capturable_board_positions(card, board)
    local positions = {}

    for _, row in ipairs { Pos.North, Pos.Center, Pos.South } do
        for _, col in ipairs { Pos.West, Pos.Center, Pos.East } do
            local curr = board[row][col]
            if curr and curr.player then
                if card.top > curr.card.bottom then
                    local p = Grid.below(row, col)
                    if p and not board[p.row][p.col] then
                        table.insert(positions, p)
                    end
                end

                if card.bottom > curr.card.top then
                    local p = Grid.above(row, col)
                    if p and not board[p.row][p.col] then
                        table.insert(positions, p)
                    end
                end

                if card.left > curr.card.right then
                    local p = Grid.left(row, col)
                    if p and not board[p.row][p.col] then
                        table.insert(positions, p)
                    end
                end

                if card.right > curr.card.left then
                    local p = Grid.right(row, col)
                    if p and not board[p.row][p.col] then
                        table.insert(positions, p)
                    end
                end
            end
        end
    end

    return positions
end

---@param hand integer[]
---@param board table<Pos, table<Pos, OwnedCard|nil>>
---@return EnemyPlan|nil
local function capturing_move(hand, board)
    local capturing_moves = {}

    for index, card_id in ipairs(hand) do
        local card = cards[card_id]

        for _, pos in ipairs(find_capturable_board_positions(card, board)) do
            table.insert(capturing_moves, {
                hand_index = index,
                target_pos = pos,
            })
        end
    end

    if #capturing_moves == 0 then
        return nil
    end

    -- TODO: find best move
    return Rng.draw(capturing_moves)
end

---@param hand integer[]
---@param board table<Pos, table<Pos, OwnedCard|nil>>
---@return EnemyPlan|nil
function M.random_move(hand, board)
    local possible_moves = {}

    for _, row in ipairs { Pos.North, Pos.Center, Pos.South } do
        for _, col in ipairs { Pos.West, Pos.Center, Pos.East } do
            if not board[row][col] then
                table.insert(possible_moves, { row = row, col = col })
            end
        end
    end

    return {
        hand_index = Rng.draw_index(hand),
        target_pos = Rng.draw(possible_moves),
    }
end

---@param hand integer[]
---@param board table<Pos, table<Pos, OwnedCard|nil>>
---@return EnemyPlan|nil
function M.calculate(hand, board)
    if is_board_empty(board) then
        return defensive_move(hand, board)
    end

    local move_capturing = capturing_move(hand, board)
    local move_defensive = defensive_move(hand, board)

    if move_capturing ~= nil then
        return move_capturing
    elseif move_defensive ~= nil then
        return move_defensive
    end

    return M.random_move(hand, board)
end

return M
