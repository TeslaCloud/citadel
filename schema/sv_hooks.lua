--- Server hooks of the schema: players are translucent ghosts who cannot hurt, use, spray or
-- pick up anything, wear their own player model, and the map is not reloaded while empty.

local function set_ghost_look(actor, alpha)
  actor:SetRenderMode(RENDERMODE_TRANSALPHA)
  actor:SetColor(Color(255, 255, 255, alpha))
end

--- Tells a player, and only them, whether the server lets players move themselves to another
-- server of the network.
-- @param actor [Player]
function SCHEMA:PlayerInitialized(actor)
  actor:set_nv('self_transfer', SrcdsProxy:available() and Proxy.player_transfer_allowed() == true, actor)
end

--- Turns a spawning player into a ghost that other players pass through. Hidden players keep
-- their look.
-- @param actor [Player]
function SCHEMA:PostPlayerSpawn(actor)
  actor:SetCustomCollisionCheck(true)
  actor:SetAvoidPlayers(false)

  if !actor:is_hidden() then
    set_ghost_look(actor, Config.get('ghost_alpha', 160))
  end
end

--- Blocks all damage to players before the gamemode shows them the damage flash.
-- @param entity [Entity the entity taking damage]
-- @param _damage_info [CTakeDamageInfo]
-- @return [Boolean true when the entity is a player, nil otherwise]
function SCHEMA:EntityTakeDamage(entity, _damage_info)
  if entity:IsPlayer() then
    return true
  end
end

--- Blocks all damage to players.
-- @param _victim [Player]
-- @param _attacker [Entity]
-- @return [Boolean false]
function SCHEMA:PlayerCanTakeDamage(_victim, _attacker)
  return false
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

--- Applies the stored 'ghost_alpha' value to every player who is not hidden once it changes.
-- @param key [String config key]
-- @param _old_value [Any]
-- @param new_value [Any value that has been stored]
function SCHEMA:ConfigChanged(key, _old_value, new_value)
  if key == 'ghost_alpha' then
    for _, target in player.Iterator() do
      if !target:is_hidden() then
        set_ghost_look(target, new_value)
      end
    end
  end
end
