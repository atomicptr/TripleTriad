local tbl = require "modules.tbl"
local Ruleset = require "main.data.rulesets"
local M = {}

---@class FieldSet
---@field top integer
---@field bottom integer
---@field left integer
---@field right integer

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

return M
