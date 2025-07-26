local M = {}

---@generic T
---@param tbl table<T>
---@param item T
function M.contains(tbl, item)
    for _, i in ipairs(tbl) do
        if i == item then
            return true
        end
    end

    return false
end

---@generic T
---@param tbl T[]
---@param callback fun(item: T): boolean
---@return boolean
function M.some(tbl, callback)
    for _, item in ipairs(tbl) do
        if callback(item) then
            return true
        end
    end

    return false
end

---@generic T
---@param tbl T[]
---@param callback fun(item: T, index: integer): boolean
---@return T[]
function M.filter(tbl, callback)
    local res = {}

    for index, item in ipairs(tbl) do
        if callback(item, index) then
            table.insert(res, item)
        end
    end

    return res
end

---@generic T
---@param tbl T[]
---@return integer
function M.count(tbl)
    local count = 0

    for _, _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

return M
