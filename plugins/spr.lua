local function get_message_kicks_callback(extra, success, result)

    if result.to.peer_type == 'channel' then
      local chat = 'channel#id'..result.to.peer_id
    if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
      send_large_msg(chat, "I won't kick myself")
	  return
    end
    if is_momod2(result.from.peer_id, result.to.id) then -- Ignore mods,owner,admin
	  send_large_msg(chat, "you can't kick mods,owner and admins")
      return
    end
      channel_kick_user(chat, "user#id"..result.from.peer_id, ok_cb, false)
	  send_large_msg(chat, "User "..result.from.peer_id.." Kick")
    end
end
local function get_message_bans_callback(extra, success, result)

    if result.to.peer_type == 'channel' then
    local chat = 'channel#id'..result.to.peer_id
    if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
      send_large_msg(chat, "I won't ban myself")
	  return
    end
    if is_momod2(result.from.peer_id, result.to.id) then -- Ignore mods,owner,admin
	  send_large_msg(chat, "you can't ban mods,owner and admins")
      return
    end
      ban_user(result.from.peer_id, result.to.peer_id)
	  send_large_msg(chat, "User "..result.from.peer_id.." Banned")
    end
  end
local function get_message_unbans_callback(extra, success, result)


    if result.to.peer_type == 'channel' then
      local chat = 'channel#id'..result.to.peer_id
    send_large_msg(chat, "User "..result.from.peer_id.." Unbanned")
    -- Save on redis
    local hash =  'banned:'..result.to.peer_id
    redis:srem(hash, result.from.peer_id)
    end
  end
local function get_message_banalls_callback(extra, success, result)


    if result.to.peer_type == 'channel' then
      local chat = 'channel#id'..result.to.peer_id
    if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
      send_large_msg(chat, "I won't banall myself")
	  return
    end
    if is_momod2(result.from.peer_id, result.to.id) then -- Ignore mods,owner,admin
	  send_large_msg(chat, "you can't banall mods,owner and admins")
      return
    end
    local cha = 'channel#id'..result.to.peer_id
    banall_user(result.from.peer_id)
    channel_kick_user(chat, "user#id"..result.from.peer_id, ok_cb, false)
    send_large_msg(cha, "User "..result.from.peer_id.." hammered")
    end
  end
local function get_message_unbanalls_callback(extra, success, result)

    if result.to.peer_type == 'channel' then
      local chat = 'channel#id'..result.to.peer_id
    send_large_msg(chat, "User "..result.from.peer_id.." Unbanall")
    -- Save on redis
    local hash =  'gbanned'
    redis:srem(hash, result.from.peer_id)
    end
  end
local function get_message_silent_callback(extra, success, result)

    if result.to.peer_type == 'channel' then
    local chat = 'channel#id'..result.to.peer_id
    if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
      send_large_msg(chat, "I won't silent myself")
	  return
    end
    if is_momod2(result.from.peer_id, result.to.id) then -- Ignore mods,owner,admin
	  send_large_msg(chat, "you can't silent mods,owner and admins")
      return
    end
      silent_user(result.from.peer_id, result.to.peer_id)
	  send_large_msg(chat, "User "..result.from.peer_id.." Silent")
    end
  end
local function get_message_unsilent_callback(extra, success, result)


    if result.to.peer_type == 'channel' then
      local chat = 'channel#id'..result.to.peer_id
    send_large_msg(chat, "User "..result.from.peer_id.." Unsilent")
    -- Save on redis
    local hash =  'silented:'..result.to.peer_id
    redis:srem(hash, result.from.peer_id)
    end
  end
local function get_message_delete_callback(extra, success, result)


    if result.to.peer_type == 'channel' then
    local user_id = result.msg.peer_id
	delete_msg(msg.id, msg.reply_id, msg)
    end
  end
local function run(msg, matches)
  if is_momod(msg) then
    if matches[1] == "k" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_kicks_callback, get_receiver(msg))
    end
    if matches[1] == "b" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_bans_callback, get_receiver(msg))
    end
    if matches[1] == "ub" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_unbans_callback, get_receiver(msg))
    end
    if matches[1] == "🖕🏿" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_banalls_callback, get_receiver(msg))
    end
    if matches[1] == "ugb" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_unbanalls_callback, get_receiver(msg))
    end
    if matches[1] == "🔇" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_silent_callback, get_receiver(msg))
    end
    if matches[1] == "🔈" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_unsilent_callback, get_receiver(msg))
    end
    if matches[1] == "delete" and msg.reply_id then
      msgr = get_message(msg.reply_id,get_message_delete_callback, get_receiver(msg))
    end
  end
end

return {
  description = "Kick by Reply",
  usage = {
    "!kic"
  },
  patterns = {
    "^(k)$",
	"^(b)$",
	"^(ub)$",
	"^(🖕🏿)$",
	"^(ugb)$",
    "^(🔇)$",
	"^(🔈)$",
	"^(delete)$"
  },
  run = run,

  pre_process = pre_process
}
