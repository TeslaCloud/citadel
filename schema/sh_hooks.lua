--- Shared hooks of the schema: players pass through each other.

--- Keeps players from colliding with each other.
-- @param ent1 [Entity first entity]
-- @param ent2 [Entity second entity]
-- @return [Boolean false when both entities are players, nil otherwise]
function SCHEMA:ShouldCollide(ent1, ent2)
  if ent1:IsPlayer() and ent2:IsPlayer() then
    return false
  end
end
