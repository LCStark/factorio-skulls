function insert_skull(owner, maker, time)
  local time_string = get_neat_time(time)
  local skull = create_skull(owner, maker, time_string)
  local inserted = game.player.insert(skull)
  if (inserted == 0) then
    game.player.surface.spill_item_stack({ position = game.player.position, stack = skull })
  end  
end

function get_neat_time(time)
  local seconds = math.floor(time / 60)
  local time_days = math.floor(seconds / 60 / 60 / 24)
  local time_hours = math.floor(seconds / 60 / 60) - time_days * 24
  local time_minutes = math.floor(seconds / 60) - time_hours * 60 - time_days * 60 * 24
  local time_seconds = seconds - time_minutes * 60 - time_hours * 60 * 60 - time_days * 60 * 60 * 24
  
  return string.format("%dd:%02dh:%02dm:%02ds", time_days, time_hours, time_minutes, time_seconds)
end


-- Debug
commands.add_command("insert_skull", nil, function(command)
  insert_skull(game.player.name, game.player.name, game.tick)
end)

commands.add_command("neat_time", nil, function(command)
  game.print(get_neat_time(command.parameter))
end)
-- End Debug

function create_skull(skull_owner, skull_maker, time)
  local stack = { name = "skull-item", count = 1 }
  stack.custom_description = {"", {"description.skull-owner", skull_owner}, "\n", {"description.skull-maker", skull_maker}, "\n", {"description.skull-time", time}}
  return stack
end

script.on_event(defines.events.on_pre_player_died, function(event)
  local player = game.get_player(event.player_index)
  local cause_name = ""
  if event.cause then
    cause_name = event.cause.name  
    if (cause_name == "character") then
      cause_name = event.cause.player.name
    else
      cause_name = { "entity-name." .. cause_name }
    end
  else
    cause_name = {"skulls-messages.unknown-cause"}
  end 
  
  local time_string = get_neat_time(event.tick)
  local skull = create_skull(player.name, cause_name, time_string)
  
  local inserted = player.insert(skull)
  if (inserted == 0) then
    player.surface.spill_item_stack({ position = player.position, stack = skull })
  end
end)