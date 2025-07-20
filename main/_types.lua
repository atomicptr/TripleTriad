---@meta

---@class CardSlot
---@field card Card|nil
---@field owner "player"|"enemy"|nil
---@field row Pos
---@field col Pos
---@field element Element|nil

---@class BoardPos
---@field row Pos
---@field col Pos

---@class EnemyPlan
---@field hand_index integer
---@field target_pos BoardPos

---@class ElementPlacement
---@field pos BoardPos
---@field element Element|nil
---

---@alias GameField table<Pos, table<Pos, CardSlot>>
