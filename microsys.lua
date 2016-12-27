JSON = require('dkjson')
db = require('redis')
redis = db.connect('127.0.0.1', 6379)
tdcli = dofile('tdcli.lua')
serpent = require('serpent')
redis:select(2)

function is_sudo(msg)
  local var = false
 -- — Check users id in config
for v,user in pairs(sudo_users) do
   if user == msg.sender_user_id_ then
     var = true
  end
  end
  return var
end

sudo_users = {
  215184910,--microsys
  0
}

function is_mod(msg)
  local var = false
 -- — Check users id in config
for v,user in redis:hget('mod'..msg.chat_id,msg.sender_user_id_) do
   if user == msg.sender_user_id_ then
     var = true
  end
  end
  return var
end
function dl_cb(arg, data)
  vardump(arg)
  vardump(data)
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

function vardump2(value)
  return serpent.block(value, {comment=true})
end

function tdcli_update_callback(data)
  --vardump(data)
	if (data.ID == "UpdateNewMessage") then
			local msg = data.message_
			local msg = data.message_
			local input = msg.content_.text_
			local chat_id = msg.chat_id_
			local user_id = msg.sender_user_id_
    -- If the message is text message
		if msg.content_.ID == "MessageText" then
			if input:match('[Mm][Ee]$') and is_sudo(msg) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, 'You,re Sudo :/', 1, 'md')
			elseif input:match('[Mm][Ee]$') and not is_sudo(msg) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, 'You,re My Dick :D', 1, 'md')
			end
			if input:match('[Hh][Ee][Ll][Pp]') then
				text = [[Soon :/]]
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
			end
--if msg.content_.text_ == "/f2a" and msg.reply_to_message_id_ then
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
