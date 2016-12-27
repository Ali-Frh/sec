JSON = require('dkjson')
db = require('redis')
redis = db.connect('127.0.0.1', 6379)
tdcli = dofile('tdcli.lua')
serpent = require('serpent')
redis:select(2)
gp = -1098875707
sudo_users = {
[999999999] = '205906514',
}
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
function is_sudo(msg)
  local var = false
  for k,v in pairs(sudo_users)do 
    if k == msg.sender_user_id_  then
      var = true
    end
	end
	
  return var
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
			if msg.content_.text_ == "PING" and is_sudo(msg) then
				tdcli.sendMessage(msg.chat_id_, 0, 1, '<b>PONG</b>', 1, 'html')
			elseif msg.content_.text_ == "PING" then
				tdcli.sendMessage(msg.chat_id_, 0, 1, '<b>You,re Zuccini :D</b>', 1, 'html')
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
