---@enum Ruleset
local Ruleset = {
    -- Open: Enables the player to see which cards the opponent is using.
    Open = 0,

    -- Same: When a card is placed touching two or more other cards
    -- (one or both of them have to be the opposite color), and
    -- the touching sides of each card is the same (8 touching 8 for example),
    -- then the other two cards are flipped. Combo rule applies.
    Same = 1,

    -- SameWall: An extension of the Same rule. The edges of the
    -- board are counted as A ranks for the purposes of the Same rule.
    -- Combo rule applies. If the Same rule is not present in a region
    -- that has Same Wall, Same Wall will not appear in the list of rules
    -- when starting a game because it can have no effect without Same but
    -- it will be carried with the player to other regions, and can therefore
    -- still be spread.
    SameWall = 2,

    -- SuddenDeath: If the game ends in a draw, a sudden death occurs in
    -- which a new game is started but the cards are distributed on the
    -- side of the color they were on at the end of the game.
    SuddenDeath = 3,

    -- Random: Five cards are randomly chosen from the player's deck
    -- instead of the player being able to choose five cards themselves.
    Random = 4,

    -- Plus: Similar to the Same rule. When one card is placed touching
    -- two others and the ranks touching the cards plus the opposing rank
    -- equal the same sum, then both cards are captured. Combo rule applies.
    Plus = 5,

    -- Combo: Of the cards captured by the Same, Same Wall or Plus rule,
    -- if they are adjacent to another card whose rank is lower, it is
    -- captured as well. This is not a separate rule; any time Same or Plus
    -- is in effect, Combo is in effect as well.
    Combo = 6,

    -- Elemental: In the elemental rule, one or more of the spaces are
    -- randomly marked with an element. Some cards have elements in the
    -- upper-right corner. Ruby Dragon, for example, is fire-elemental,
    -- and Quezacotl is thunder-elemental. When an elemental card is
    -- placed on a corresponding element, each rank goes up a point.
    -- When any card is placed on a non-matching element, each rank
    -- goes down a point. This does not affect the Same, Plus and Same
    -- Wall rules, where the cards' original ranks apply.
    Elemental = 7,
}

return Ruleset
