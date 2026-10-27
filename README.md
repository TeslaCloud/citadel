# Citadel

Citadel is the lobby schema of a Flux server network that runs behind srcdsproxy. Players land
here when they first join the network and whenever another server of the network crashes or
kicks them. They see the TeslaCloud logo for a moment and then walk around the map as ghosts:
they see each other and can chat, and they move on to the other servers by walking into a
transfer area or with `/server <name>`. Staff guide new players with 3D texts, pictures and
static entities, and draw the transfer areas.

## Installation

Clone this repository next to `flux` in `garrysmod/gamemodes`, into a folder named `citadel`,
and start the server with `+gamemode citadel`. Everything else (the database, the Workshop
content and so on) is covered in [the Flux repository](https://github.com/TeslaCloud/flux-ce).

The srcdsproxy addon and its module must be installed on this server. Set the proxy's
`default_backend` and `fallback_backend` to the name of this server.

## What players can do

- See each other and talk in the chat.
- Nothing else: players do not collide, take no damage, cannot use each other, cannot pick up
  weapons or items from the map and cannot spawn anything.
- Sprays are blocked.
- Voice chat needs the `voice` permission, which by default only the `admin` role has.
- Walking into a Server Transfer Area moves the player to its server after its delay.
- `/servers` lists the servers of the network in the console, `/server <name>` moves to one.
  These two only work while the server allows players to move themselves
  (`srcdsproxy_allow_player_transfer`); the transfer areas work regardless.

## Staff

- `assistant`: places 3D texts and pictures, makes entities static, spawns props, and moves
  and freezes the entities they have spawned themselves.
- `gamemaster`: everything an assistant can do, plus areas, including Server Transfer Areas,
  and moves and freezes any entity.
- `admin`: everything.

To keep a prop on the map, saved with it and spawned again when it loads, look at it and run
`/static add` (`/static remove` undoes it), or use the Static Add/Remove tool.

To draw a transfer area, pick the Server Transfer Area mode of the Area Tool, enter the name of
the server and the delay in seconds, add points with left click and create the area with right
click. Reload removes the transfer area you are looking at.

To give yourself the `admin` role, run `flc role set <name> admin` in the server console.

## Configuration

`ghost_alpha` sets how solid players are drawn, from 32 (barely visible) to 255 (fully solid),
160 by default. Change it on the Config editor page of the Admin tab of the Tab menu, which
needs the `manage_configuration` permission. By default only the `admin` role has it.
