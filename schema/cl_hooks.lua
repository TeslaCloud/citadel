--- Client hooks of the schema: the intro, the loading screen, the HUD, the spawn menu and the
-- lobby hints.

--- Opens the intro panel once the local player has been initialized.
function SCHEMA:PlayerInitialized()
  if !IsValid(Flux.intro_panel) then
    Flux.intro_panel = vgui.Create('fl_intro')

    if IsValid(Flux.intro_panel) then
      Flux.intro_panel:MakePopup()
    end
  end
end

--- Shows the lobby hint that applies to the local player as the intro fades out.
function SCHEMA:IntroPanelRemoved()
  if PLAYER:get_nv('self_transfer') == true then
    Hints:display('citadel_servers')
  else
    Hints:display('citadel_lobby')
  end
end

--- Keeps the loading screen visible until the intro panel has been created.
-- @return [Boolean true while there is no intro panel, otherwise nil]
function SCHEMA:ShouldDrawLoadingScreen()
  if !Flux.intro_panel then
    return true
  end
end

--- Hides the HUD while the intro panel is open.
-- @return [Boolean false while the intro panel is valid, otherwise nil]
function SCHEMA:ShouldHUDPaint()
  if IsValid(Flux.intro_panel) then
    return false
  end
end

--- Keeps the spawn menu closed for players who can neither spawn props nor use the tool gun.
-- @return [Boolean false without the 'spawn_props' and 'toolgun' permissions, otherwise nil]
function SCHEMA:SpawnMenuOpen()
  if !PLAYER:can('spawn_props') and !PLAYER:can('toolgun') then
    return false
  end
end

--- Registers the hints about moving to the other servers of the network: the one about the
-- server commands is only picked while the local player may move themselves.
function SCHEMA:RegisterHints()
  Hints:add('citadel_lobby', 'hint.citadel_lobby', nil, false, function()
    return IsValid(PLAYER) and !PLAYER:get_nv('self_transfer')
  end)

  Hints:add('citadel_servers', 'hint.citadel_servers', nil, false, function()
    return IsValid(PLAYER) and PLAYER:get_nv('self_transfer') == true
  end)
end
