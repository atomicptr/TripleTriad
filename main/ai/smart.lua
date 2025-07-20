local cards = require "main.data.cards"
local Grid = require "modules.grid"
local Rng = require "modules.rng"
local combat = require "main.combat"

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

    Grid.for_each(function(row, col)
        if row == Pos.Center or col == Pos.Center then
            return
        end

        if not board[row][col].card then
            table.insert(corners, { row = row, col = col })
        end
    end)

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
---@param board GameField
---@param rules Ruleset[]
---@return EnemyPlan|nil
local function defensive_move(hand, board, rules)
    local corners = find_empty_corners(board)

    -- NOTE: this case cant happen when ai starts first
    if #corners == 0 then
        return nil
    end

    local nw = find_max_sum_from_hand(hand, { "top", "left" })
    local ne = find_max_sum_from_hand(hand, { "top", "right" })
    local sw = find_max_sum_from_hand(hand, { "bottom", "left" })
    local se = find_max_sum_from_hand(hand, { "bottom", "right" })

    -- TODO: take element into account
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
---@param board GameField
---@param rules Ruleset[]
---@return { pos: BoardPos, target_pos: BoardPos }[]
local function find_capturable_board_positions(card, board, rules)
    local positions = {}

    Grid.for_each(function(row, col)
        local target_pos = { row = row, col = col }

        local curr = board[row][col]

        if not curr.card then
            return
        end

        local curr_vals = combat.card_values(curr.card, curr.element, rules)

        -- dont attack your own cards
        if curr.owner == "enemy" then
            return
        end

        local below_pos = Grid.below(row, col)
        if below_pos then
            local below_field = board[below_pos.row][below_pos.col]
            if below_field and not below_field.card then
                local card_vals = combat.card_values(card, below_field.element, rules)

                if card_vals.top > curr_vals.bottom then
                    table.insert(positions, { pos = below_pos, target_pos = target_pos })
                end
            end
        end

        local above_pos = Grid.above(row, col)
        if above_pos then
            local above_field = board[above_pos.row][above_pos.col]
            if above_field and not above_field.card then
                local card_vals = combat.card_values(card, above_field.element, rules)

                if card_vals.bottom > curr_vals.top then
                    table.insert(positions, { pos = above_pos, target_pos = target_pos })
                end
            end
        end

        local left_pos = Grid.left(row, col)
        if left_pos then
            local left_field = board[left_pos.row][left_pos.col]
            if left_field and not left_field.card then
                local card_vals = combat.card_values(card, left_field.element, rules)

                if card_vals.right > curr_vals.left then
                    table.insert(positions, { pos = left_pos, target_pos = target_pos })
                end
            end
        end

        local right_pos = Grid.right(row, col)
        if right_pos then
            local right_field = board[right_pos.row][right_pos.col]
            if right_field and not right_field.card then
                local card_vals = combat.card_values(card, right_field.element, rules)

                if card_vals.left > curr_vals.right then
                    table.insert(positions, { pos = right_pos, target_pos = target_pos })
                end
            end
        end
    end)

    return positions
end

---@param card Card
---@param field_element Element|nil
---@param rules Ruleset[]
---@return integer
local function calculate_card_value(card, field_element, rules)
    local val = combat.card_values(card, field_element, rules)
    return val.top + val.bottom + val.left + val.right
end

---@param hand integer[]
---@param board GameField
---@param rules Ruleset[]
---@return EnemyPlan|nil
local function capturing_move(hand, board, rules)
    local capturing_moves = {}

    for index, card_id in ipairs(hand) do
        local card = cards[card_id]

        for _, cappos in ipairs(find_capturable_board_positions(card, board, rules)) do
            local pos = cappos.pos
            local target_pos = cappos.target_pos

            local value = calculate_card_value(card, board[pos.row][pos.col].element, rules)
            local target_value = calculate_card_value(card, board[target_pos.row][target_pos.col].element, rules)

            local found = false

            for prev_index, prev_tbl in ipairs(capturing_moves) do
                if prev_tbl.row == pos.row and prev_tbl.col == pos.col and prev_tbl.plan.hand_index == index then
                    capturing_moves[prev_index].value = capturing_moves[prev_index].value + value
                    capturing_moves[prev_index].target_value = capturing_moves[prev_index].target_value + target_value

                    found = true
                    break
                end
            end

            if not found then
                table.insert(capturing_moves, {
                    row = pos.row,
                    col = pos.col,

                    value = value,
                    target_value = target_value,

                    plan = {
                        hand_index = index,
                        target_pos = pos,
                    },
                })
            end
        end
    end

    if #capturing_moves == 0 then
        return nil
    end

    -- find highest target value while minimizing our card value
    local curr_index = nil
    local curr_value = 0
    local curr_target_value = 0

    for pos_index, move in ipairs(capturing_moves) do
        if move.target_value > curr_target_value then
            curr_index = pos_index
            curr_value = move.value
            curr_target_value = move.target_value
        elseif move.target_value == curr_target_value then
            if move.value < curr_value then
                curr_index = pos_index
                curr_value = move.value
                curr_target_value = move.target_value
            end
        end
    end

    if not curr_index then
        return nil
    end

    return capturing_moves[curr_index].plan
end

---@param hand integer[]
---@param board GameField
---@param rules Ruleset[]
---@return EnemyPlan|nil
local function random_move(hand, board, rules)
    local possible_moves = {}

    -- TODO: dont play on negative element if possible
    Grid.for_each(function(row, col)
        if not board[row][col].card then
            table.insert(possible_moves, { row = row, col = col })
        end
    end)

    return {
        hand_index = Rng.draw_index(hand),
        target_pos = Rng.draw(possible_moves),
    }
end

---@param hand integer[]
---@param board GameField
---@param rules Ruleset[]
---@return EnemyPlan|nil
function M.calculate(hand, board, rules)
    if is_board_empty(board) then
        return defensive_move(hand, board, rules)
    end

    local move_capturing = capturing_move(hand, board, rules)
    local move_defensive = defensive_move(hand, board, rules)

    if move_capturing ~= nil then
        return move_capturing
    elseif move_defensive ~= nil then
        return move_defensive
    end

    return random_move(hand, board, rules)
end

return M
