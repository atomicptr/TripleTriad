local Grid = require "modules.grid"
local Ruleset = require "main.data.rulesets"
local cards = require "main.data.cards"

local Pos = Grid.Pos

---@class Scenario
---@field start_turn "player"|"enemy"
---@field player_hand integer[]
---@field enemy_hand integer[]
---@field rules Ruleset[]
---@field field GameField

---@param steps { pos: BoardPos, element: Element|nil, card: integer, owner: "player"|"enemy" }
---@return GameField
local function make_grid(steps)
    ---@type GameField
    local grid = Grid.create(function(row, col)
        ---@type CardSlot
        return {
            card = nil,
            row = row,
            col = col,
            element = nil,
        }
    end)

    for _, step in ipairs(steps) do
        local pos = step.pos

        grid[pos.row][pos.col].element = step.element
        grid[pos.row][pos.col].card = cards[step.card]
        grid[pos.row][pos.col].owner = step.owner
    end

    return grid
end

---@type table<string, Scenario>
local scenarios = {
    TestSameCombo = {
        start_turn = "player",
        player_hand = { 40, 40, 40 },
        enemy_hand = { 1, 1 },
        rules = {
            Ruleset.Open,
            Ruleset.Same,
            Ruleset.Combo,
        },
        field = make_grid {
            { pos = { row = Pos.Center, col = Pos.West }, card = 40, owner = "player" },
            { pos = { row = Pos.Center, col = Pos.East }, card = 40, owner = "enemy" },
            { pos = { row = Pos.South, col = Pos.Center }, card = 54, owner = "enemy" },
            { pos = { row = Pos.South, col = Pos.West }, card = 71, owner = "enemy" },
            { pos = { row = Pos.South, col = Pos.East }, card = 13, owner = "enemy" },
        },
    },

    TestPlusCombo = {
        start_turn = "player",
        player_hand = { 110, 110, 110 },
        enemy_hand = { 1, 1, 1 },
        rules = {
            Ruleset.Open,
            Ruleset.Plus,
            Ruleset.Combo,
        },
        field = make_grid {
            { pos = { row = Pos.North, col = Pos.Center }, card = 17, owner = "enemy" },
            { pos = { row = Pos.South, col = Pos.Center }, card = 82, owner = "enemy" },
            { pos = { row = Pos.Center, col = Pos.West }, card = 23, owner = "enemy" },
        },
    },
}

return scenarios
