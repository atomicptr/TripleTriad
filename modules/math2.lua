local M = {}

---@param point vector3
---@param rect_pos vector3
---@param rect_size float
---@return boolean
function M.point_in_rect(point, rect_pos, rect_size)
    local half_size = rect_size / 2
    return point.x >= rect_pos.x - half_size
        and point.x <= rect_pos.x + half_size
        and point.y >= rect_pos.y - half_size
        and point.y <= rect_pos.y + half_size
end

return M
