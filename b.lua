-- Look for lua libraries on these PATH
package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  .. ';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

-- Load the libraries
tdcli = dofile('tdcli.lua')
--redis = dofile('redis.lua')
JSON = require('dkjson')
serpent = require('serpent')
--redis = (loadfile "./libs/redis.lua")()
redis = require('redis')
mame = Redis.connect('127.0.0.1', 6379)
-- Print message
local function vardump(value)
  print(serpent.block(value, {comment=false}))
end
function is_sudo(msg)
 local var = false
--  — Check users id in config
  for v,user in pairs(sudo_users) do
  if user == msg.sender_user_id_ then
     var = true
 end
  end
  return var
end
sudo_users = {
  205906514,
  0
}
-- Print callback
function dl_cb(arg, data)
  print('=====================================================================')
  vardump(arg)
  vardump(data)
  print('=====================================================================')
end

function tdcli_update_callback(data)
  vardump(data)

  if (data.ID == "UpdateNewMessage") then
    local msg = data.message_
    local input = msg.content_.text_
    local chat_id = msg.chat_id_
    local user_id = msg.sender_user_id_

    vardump(msg)

    if msg.content_.ID == "MessageText" then
      -- put a function here
      if input:match('^mute sticker') and user_id = mame:get('mod'..msg.chat_id_) then
		text = '*Sticker Posting Has Been Disallowed*'
		mame:set('msticker'..msg.chat_id_,true)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
      elseif input:match('^mute sticker') and not user_id = mame:get('mod'..msg.chat_id_) then
		text = '*You,re Not Mod Or Higher*'
		mame:set('msticker'..msg.chat_id_,true)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('$unmute sticker') and user_id = mame:get('mod'..msg.chat_id_) then
		text = '*Sticker Posting Has Been Allowed*'
		mame:del('msticker'..msg.chat_id_)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('$unmute sticker') and not user_id = mame:get('mod'..msg.chat_id_) then
		text = '*You,re Not Mod Or Higher*'
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('^+mod$') and is_sudo(msg) then
		local id = input:gsub('+mod', '')
		text = id..'*Has Been Promoted !*'
		mame:set('mods'..msg.chat_id_,id)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('^+mod$') and is_sudo(msg) then
		text = '*You,re Not Mod Or Higher*'
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
      end
    end
  elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
    tdcli_function ({
      ID="GetChats",
      offset_order_="9223372036854775807",
      offset_chat_id_=0,
      limit_=20
    }, dl_cb, nil)
  end
end
