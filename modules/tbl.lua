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

return M
