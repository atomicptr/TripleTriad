local M = {}

---@param pos vector3
---@return vector3
function M.world_to_screen(pos)
    local screen_width, screen_height = window.get_size()
    local zoom = window.get_display_scale()

    local screen_x = (pos.x * zoom) + (screen_width * 0.5)
    local screen_y = (pos.y * zoom) + (screen_height * 0.5)

    return vmath.vector3(screen_x, screen_y, 0)
end

return M
