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
for v,user in redis:hget('mod'..msg.chat_id_,msg.sender_user_id_) do
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
			local lowrank_msg = 'شما دسترسی کافی برای این کار را ندارید'
    -- If the message is text message
		if msg.content_.ID == "MessageText" then
			if input:match('^مقام من$') and not is_sudo(msg) and not is_mod(msg) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_شما یک کاربر ساده هستید_', 1, 'md')
			elseif input:match('^مقام من$') and is_sudo(msg) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_تو بابای منی :/_', 1, 'md')
			elseif input:match('^مقام من$') and is_mod(msg) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_شما مدیر گروه هستید_', 'md')
			--elseif input:match('^مقام من$') and is_owner(msg) then
			--	tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_شما رهبر گروه هستید_', 'md')
			end
			if input:match('^راهنما$') then
				text = [[Soon :/]]
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
			end
			if input:match('^ساخت گروه$') then
				local name = input:gsub('ساخت گروه', '')
				tdcli.createNewGroupChat({[0] = msg.sender_user_id_}, name)
				text = 'گروه '..name..'با موفقیت ساخته شد'
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 'md')
			end
			if input:match('[Cc][Rr]eategp$') and is_sudo(msg) then
				local name = input:gsub('creategp', '')
				tdcli.createNewGroupChat({[0] = msg.sender_user_id_}, name)
				text = 'گروه '..name..'با موفقیت ساخته شد'
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 'md')
			else
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, lowrank_msg, 'md')
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
