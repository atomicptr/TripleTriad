local M = {}

function M.init()
    math.randomseed(os.time())
end

---@return boolean
function M.flip_coin()
    local count = 0

    for _ = 1, 100 do
        if math.random() >= 0.5 then
            count = count + 1
        end

        if count >= 50 then
            return true
        end
    end

    return false
end

function M.draw(tbl)
    local index = M.draw_index(tbl)

    if not index then
        return nil
    end

    return tbl[index]
end

function M.draw_index(tbl)
    if not tbl or #tbl == 0 then
        return nil
    end

    return math.random(1, #tbl)
end

return M
