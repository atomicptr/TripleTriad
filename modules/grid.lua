local M = {}

---@enum Pos
local Pos = {
    North = 1,
    South = 2,
    East = 3,
    West = 4,
    Center = 5,
}

M.Pos = Pos

M.Rows = { Pos.North, Pos.Center, Pos.South }
M.Cols = { Pos.West, Pos.Center, Pos.East }

---@param callback fun(row: Pos, col: Pos)
function M.for_each(callback)
    for _, row in ipairs(M.Rows) do
        for _, col in ipairs(M.Cols) do
            callback(row, col)
        end
    end
end

---@generic T
---@generic U
---@param callback fun(acc: T, row: integer, col: integer): U
---@param initial U|nil
---@return U|nil
function M.fold(callback, initial)
    local value = initial

    M.for_each(function(row, col)
        value = callback(value, row, col)
    end)

    return value
end

---@generic T
---@param callback fun(row: Pos, col: Pos): T
---@return table<Pos, table<Pos, T>>
function M.create(callback)
    local grid = {}

    for _, row in ipairs(M.Rows) do
        grid[row] = {}

        for _, col in ipairs(M.Cols) do
            grid[row][col] = callback(row, col)
        end
    end

    return grid
end

---@param row Pos
---@param col Pos
---@return { row: Pos, col: Pos }|nil
function M.above(row, col)
    if row == Pos.North then
        return nil
    elseif row == Pos.Center then
        return { row = Pos.North, col = col }
    else
        return { row = Pos.Center, col = col }
    end
end

---@param row Pos
---@param col Pos
---@return { row: Pos, col: Pos }|nil
function M.below(row, col)
    if row == Pos.North then
        return { row = Pos.Center, col = col }
    elseif row == Pos.Center then
        return { row = Pos.South, col = col }
    else
        return nil
    end
end

---@param row Pos
---@param col Pos
---@return { row: Pos, col: Pos }|nil
function M.left(row, col)
    if col == Pos.West then
        return nil
    elseif col == Pos.Center then
        return { row = row, col = Pos.West }
    else
        return { row = row, col = Pos.Center }
    end
end

---@param row Pos
---@param col Pos
---@return { row: Pos, col: Pos }|nil
function M.right(row, col)
    if col == Pos.West then
        return { row = row, col = Pos.Center }
    elseif col == Pos.Center then
        return { row = row, col = Pos.East }
    else
        return nil
    end
end

---@param row Pos
---@param col Pos
---@return { row: Pos, col: Pos, direction: string }[]
function M.orthogonal(row, col)
    local orthogonals = {}

    local dirs = {}

    local dir = M.above(row, col)
    if dir then
        table.insert(dirs, { row = dir.row, col = dir.col, direction = "up" })
    end

    dir = M.below(row, col)
    if dir then
        table.insert(dirs, { row = dir.row, col = dir.col, direction = "down" })
    end

    dir = M.left(row, col)
    if dir then
        table.insert(dirs, { row = dir.row, col = dir.col, direction = "left" })
    end

    dir = M.right(row, col)
    if dir then
        table.insert(dirs, { row = dir.row, col = dir.col, direction = "right" })
    end

    for _, side in ipairs(dirs) do
        if side then
            table.insert(orthogonals, side)
        end
    end

    return orthogonals
end

return M
