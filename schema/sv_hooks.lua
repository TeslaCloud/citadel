--- Server hooks of the schema: players are translucent ghosts who cannot hurt, use, spray or
-- pick up anything, wear their own player model, and the map is not reloaded while empty.

--- Makes a player translucent. A hidden player is given the look for when they are shown
-- again, which the Observer plugin keeps in their visible_color field while they are hidden.
local function set_ghost_look(actor, alpha)
  local color = Color(255, 255, 255, alpha)

  actor:SetRenderMode(RENDERMODE_TRANSALPHA)

  if actor:is_hidden() then
    actor.visible_color = color
  else
    actor:SetColor(color)
  end
end

local function self_transfer_allowed()
  return SrcdsProxy:available() and Proxy.player_transfer_allowed() == true
end

--- Tells a player, and only them, whether the server lets players move themselves to another
-- server of the network.
-- @param actor [Player]
function SCHEMA:PlayerInitialized(actor)
  actor:set_nv('self_transfer', self_transfer_allowed(), actor)
end

--- Checks once a second whether the server has started or stopped letting players move
-- themselves to another server of the network, and tells every player when it has.
function SCHEMA:OneSecond()
  local allowed = self_transfer_allowed()

  if allowed == self.self_transfer then return end

  self.self_transfer = allowed

  for _, target in player.Iterator() do
    target:set_nv('self_transfer', allowed, target)
  end
end

--- Turns a spawning player into a ghost that other players pass through.
-- @param actor [Player]
function SCHEMA:PostPlayerSpawn(actor)
  actor:SetCustomCollisionCheck(true)
  actor:SetAvoidPlayers(false)

  set_ghost_look(actor, Config.get('citadel_ghost_alpha', 160))
end

--- Blocks all damage to players, so that the gamemode does not show them the damage flash
-- either.
-- @param entity [Entity the entity taking damage]
-- @param _damage_info [CTakeDamageInfo]
-- @return [Boolean true when the entity is a player, nil otherwise]
function SCHEMA:EntityTakeDamage(entity, _damage_info)
  if entity:IsPlayer() then
    return true
  end
end

--- Keeps players from using other players.
-- @param _activator [Player]
-- @param target [Entity the entity being used]
-- @return [Boolean false when the target is a player, nil otherwise]
function SCHEMA:PlayerUse(_activator, target)
  if IsValid(target) and target:IsPlayer() then
    return false
  end
end

--- Keeps players from spraying decals.
-- @param _actor [Player]
-- @return [Boolean true]
function SCHEMA:PlayerSpray(_actor)
  return true
end

--- Keeps players without the 'spawn_sweps' permission from picking up weapons that lie in the
-- world. Weapons that they are given are created in the same tick and pass.
-- @param actor [Player]
-- @param weapon [Weapon]
-- @return [Boolean false for a weapon in the world and a player without the permission]
function SCHEMA:PlayerCanPickupWeapon(actor, weapon)
  if weapon:GetCreationTime() < CurTime() and !actor:can('spawn_sweps') then
    return false
  end
end

--- Keeps players from picking up items such as health kits and ammo.
-- @param _actor [Player]
-- @param _item [Entity]
-- @return [Boolean false]
function SCHEMA:PlayerCanPickupItem(_actor, _item)
  return false
end

--- Lets the base gamemode apply the player model each player has picked.
-- @param _actor [Player]
-- @return [Boolean false]
function SCHEMA:GetPlayerModel(_actor)
  return false
end

--- Keeps the server from reloading the map while it is empty.
-- @return [Boolean false]
function SCHEMA:ShouldServerAutoRestart()
  return false
end

--- Applies the stored 'citadel_ghost_alpha' value to every player once it changes.
-- @param key [String config key]
-- @param _old_value [Any]
-- @param new_value [Any value that has been stored]
function SCHEMA:ConfigChanged(key, _old_value, new_value)
  if key == 'citadel_ghost_alpha' then
    for _, target in player.Iterator() do
      set_ghost_look(target, new_value)
    end
  end
end
