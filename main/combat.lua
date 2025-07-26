local tbl = require "modules.tbl"
local Ruleset = require "main.data.rulesets"
local Grid = require "modules.grid"

local M = {}

---@class FieldSet
---@field top integer
---@field bottom integer
---@field left integer
---@field right integer

---@param board GameField
---@param row Pos
---@param col Pos
---@return OrthoCard[]
function M.get_orthogonal_cards(board, row, col)
    local ortho_cards = {}

    for _, pos in ipairs(Grid.orthogonal(row, col)) do
        local card = board[pos.row][pos.col]

        if card then
            table.insert(ortho_cards, {
                slot = card,
                direction = pos.direction,
            })
        end
    end

    return ortho_cards
end

---@param card Card
---@param field_element Element|nil
---@param rules Ruleset[]
---@return FieldSet
function M.card_values(card, field_element, rules)
    local is_element = tbl.contains(rules, Ruleset.Elemental)

    if not is_element or not field_element then
        return {
            top = card.top,
            bottom = card.bottom,
            left = card.left,
            right = card.right,
        }
    end

    local mod = -1

    if card.element == field_element then
        mod = 1
    end

    return {
        top = card.top + mod,
        bottom = card.bottom + mod,
        left = card.left + mod,
        right = card.right + mod,
    }
end

---@param card Card
---@param card_pos BoardPos
---@param board GameField
---@param rules Ruleset[]
---@return CardSlot[]
function M.process_combat(card, card_pos, board, rules)
    local res = {}

    local is_element = tbl.contains(rules, Ruleset.Elemental)
    local field_element = nil
    local owner = board[card_pos.row][card_pos.col].owner

    if is_element then
        field_element = board[card_pos.row][card_pos.col].element
    end

    local card_vals = M.card_values(card, field_element, rules)

    local targets = M.get_orthogonal_cards(board, card_pos.row, card_pos.col)

    for _, target in ipairs(targets) do
        if target.slot.card and owner ~= target.slot.owner then
            local target_card = target.slot.card
            assert(target_card)

            local target_vals = M.card_values(target_card, target.slot.element, rules)

            if target.direction == "up" and card_vals.top > target_vals.bottom then
                table.insert(res, target.slot)
            elseif target.direction == "down" and card_vals.bottom > target_vals.top then
                table.insert(res, target.slot)
            elseif target.direction == "left" and card_vals.left > target_vals.right then
                table.insert(res, target.slot)
            elseif target.direction == "right" and card_vals.right > target_vals.left then
                table.insert(res, target.slot)
            end
        end
    end

    return res
end

---@param card Card
---@param card_pos BoardPos
---@param board GameField
---@param rules Ruleset[]
---@return CardSlot[]
function M.process_same(card, card_pos, board, rules)
    assert(tbl.contains(rules, Ruleset.Same))

    local targets = M.get_orthogonal_cards(board, card_pos.row, card_pos.col)

    local valid_targets = tbl.filter(targets, function(item)
        return item.slot.card ~= nil
    end)

    -- rule only applies if we even have two or more targets to begin with
    if tbl.count(valid_targets) < 2 then
        return {}
    end

    local res = {}

    local is_element = tbl.contains(rules, Ruleset.Elemental)
    local field_element = nil
    local owner = board[card_pos.row][card_pos.col].owner

    local card_vals = M.card_values(card, field_element, rules)

    if is_element then
        field_element = board[card_pos.row][card_pos.col].element
    end

    -- TODO: add support for same wall

    for _, target in ipairs(valid_targets) do
        local target_card = target.slot.card
        assert(target_card)

        local target_vals = M.card_values(target_card, target.slot.element, rules)

        if target.direction == "up" and card_vals.top == target_vals.bottom then
            table.insert(res, target.slot)
        elseif target.direction == "down" and card_vals.bottom == target_vals.top then
            table.insert(res, target.slot)
        elseif target.direction == "left" and card_vals.left == target_vals.right then
            table.insert(res, target.slot)
        elseif target.direction == "right" and card_vals.right == target_vals.left then
            table.insert(res, target.slot)
        end
    end

    if tbl.count(res) < 2 then
        return {}
    end

    return tbl.filter(res, function(item)
        return item.owner ~= owner
    end)
end

---@param card Card
---@param card_pos BoardPos
---@param board GameField
---@param rules Ruleset[]
---@return CardSlot[]
function M.process_plus(card, card_pos, board, rules)
    assert(tbl.contains(rules, Ruleset.Plus))

    local targets = M.get_orthogonal_cards(board, card_pos.row, card_pos.col)

    local valid_targets = tbl.filter(targets, function(item)
        return item.slot.card ~= nil
    end)

    -- rule only applies if we even have two or more targets to begin with
    if tbl.count(valid_targets) < 2 then
        return {}
    end

    local is_element = tbl.contains(rules, Ruleset.Elemental)
    local field_element = nil
    local owner = board[card_pos.row][card_pos.col].owner

    local card_vals = M.card_values(card, field_element, rules)

    if is_element then
        field_element = board[card_pos.row][card_pos.col].element
    end

    local dir_values = {}

    for _, target in ipairs(valid_targets) do
        local target_card = target.slot.card
        assert(target_card)

        local target_vals = M.card_values(target_card, target.slot.element, rules)

        -- calculate all directions
        if target.direction == "up" then
            local value = card_vals.top + target_vals.bottom

            if not dir_values[value] then
                dir_values[value] = {}
            end

            table.insert(dir_values[value], target.slot)
        elseif target.direction == "down" then
            local value = card_vals.bottom + target_vals.top

            if not dir_values[value] then
                dir_values[value] = {}
            end

            table.insert(dir_values[value], target.slot)
        elseif target.direction == "left" then
            local value = card_vals.left + target_vals.right

            if not dir_values[value] then
                dir_values[value] = {}
            end

            table.insert(dir_values[value], target.slot)
        elseif target.direction == "right" then
            local value = card_vals.right + target_vals.left

            if not dir_values[value] then
                dir_values[value] = {}
            end

            table.insert(dir_values[value], target.slot)
        end
    end

    local res = {}

    for _, dir_targets in pairs(dir_values) do
        if tbl.count(dir_targets) >= 2 then
            for _, target in ipairs(dir_targets) do
                table.insert(res, target)
            end
        end
    end

    if tbl.count(res) < 2 then
        return {}
    end

    return tbl.filter(res, function(item)
        return item.owner ~= owner
    end)
end

---@param owner "player"|"enemy"
---@param flipped_cards CardSlot[]
---@param board GameField
---@param rules Ruleset[]
---@return CardSlot[]
function M.process_combo(owner, flipped_cards, board, rules)
    assert(tbl.contains(rules, Ruleset.Combo))

    local res = {}

    for _, fc in ipairs(flipped_cards) do
        fc.owner = owner
        local combo_flipped = M.process_combat(fc.card, { row = fc.row, col = fc.col }, board, rules)

        for _, combo_flip in ipairs(combo_flipped) do
            table.insert(res, combo_flip)
        end
    end

    return res
end

return M
