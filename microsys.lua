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
			if input:match('^مقام من$') and not is_sudo(msg) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_شما یک کاربر ساده هستید_', 1, 'md')
			elseif input:match('^مقام من$') and is_sudo(msg) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_تو بابای منی :/_', 1, 'md')
			--elseif input:match('^مقام من$') and is_mod(msg) then
				--tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_شما مدیر گروه هستید_', 'md')
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
			if input:match('creategp$') and is_sudo(msg) then
					local name = input:gsub('creategp', '')
					tdcli.createNewGroupChat({[0] = msg.sender_user_id_}, name)
					text = 'گروه '..name..'با موفقیت ساخته شد'
					text2 = 'A Group Created By'..user_id..'\nname of gp is'..name
					tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 'md')
					tdcli.sendText(205906514, 0, 0, 1, nil, text2, 'md')
			elseif not is_sudo(msg) then
					tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, lowrank_msg, 'md')
			end
			if chat_id == redis:get('groups',chat_id) then
				return true
			elseif not chat_id == redis:get('groups',chat_id) and not input:match('^افزودن$') and not input:match('^حذف گروه$') then
				return false
			end
			--if input:match('^افزودن$') and is_sudo(msg) then
--settings--##########################################################################
--####################################################################################
--lock #tag
		if input:match('^lock tag$') and is_sudo(msg) then
			mame:set('ltag:'..msg.chat_id_, true)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock tag Has Been Activated :D_', 1, 'md')
		elseif input:match('^unlock tag$') and is_sudo(msg) then
			mame:del('ltag:'..msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock tag Has Been Deactivated :D_', 1, 'md')
		--elseif input:match('unlock username$') and not mame:get('luser:'..msg.chat_id_) then
		--	tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Already Deactivated :D_', 1, 'md')
		elseif input:match('#') and mame:get('ltag:'..msg.chat_id_) and not is_sudo(msg) then
			--tdcli.deleteMessages(msg.chat_id_, data.message_.text_)
			tdcli.deleteMessages(chat_id, {[0] = msg.id_})
			--lang system
		if input:match('^setlang$') then
				local lang = input:gsub('setlang', '')
			if lang == 'fa' and not mame:get('lang'..chat_id,true) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '*زبان شما به فارسی تغییر نمود*', 1, 'md')
				mame:set('lang'..msg.chat_id_,true)
			elseif lang == 'en' and mame:get('lang'..chat_id,true) then
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '*Group Language Seted To : [EN]*', 1, 'md')
				mame:set('lang'..msg.chat_id_,false)
			end
				
-----------------------------------------------------------------------
--lock username
	--	elseif input:match('lock username$') and mame:get('luser:'..msg.chat_id_) then
		--	tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Already Activated :D_', 1, 'md')
		if input:match('^lock username$') and is_sudo(msg) then
			mame:set('luser:'..msg.chat_id_, true)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Has Been Activated :D_', 1, 'md')
		elseif input:match('^unlock username$') and is_sudo(msg) then
			mame:del('luser:'..msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Has Been Deactivated :D_', 1, 'md')
		--elseif input:match('unlock username$') and not mame:get('luser:'..msg.chat_id_) then
		--	tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Already Deactivated :D_', 1, 'md')
		elseif input:match('@') and mame:get('luser:'..msg.chat_id_) then
			--tdcli.deleteMessages(msg.chat_id_, data.message_.text_)
			tdcli.deleteMessages(chat_id, {[0] = msg.id_})
		end

			if not redis:get('lang'..chat_id,true) then
				local lfwd = 'lfwd:'..chat_id
				if redis:get(lfwd) then
					lfwd = "Locked !"
				else 
					lfwd = "Unlocked !"
				end
				local luser = 'luser'..chat_id
				if redis:get(luser) then
					luser = "Locked !"
				else 
					luser = "Unlocked !"
				end
				local luser = 'ltag'..chat_id
				if redis:get(ltag) then
					ltag = "Locked !"
				else 
					ltag = "Unlocked !"
				end
			end
			if redis:get('lang'..chat_id,true) then
				local lfwd = 'lfwd:'..chat_id
				if redis:get(lfwd) then
					lfwd = "غیر مجاز"
				else 
					lfwd = "مجاز"
				end
				local luser = 'luser'..chat_id
				if redis:get(luser) then
					luser = "غیر مجاز"
				else 
					luser = "مجاز"
				end
				local luser = 'ltag'..chat_id
				if redis:get(ltag) then
					ltag = "غیر مجاز"
				else 
					ltag = "مجاز"
				end
			end
			if redis:get('lang'..chat_id,true) then
				lang = 'فارسی'
			elseif not redis:get('lang'..chat_id,true) then
				lang = 'English'
			end
		
		if input:match('^group settings$') then
			--if redis:get('lfwd:'..msg.chat_id_) then
			--	local lock_fwd = 'yes'
			--elseif not redis:get('lfwd:'..msg.chat_id_) then
			--	local lock_fwd = 'no'
			--elseif lock_fwd == nil then
			--	local lock_fwd = 'undefined'
			--end
					--🔹 -- Abi
					--🔸 -- Narenji
			if redis:get('lang'..chat_id,true) then
				text = '_⚙تنظیمات گروه'..chat_id..'_\n*🔸زبان گروه :*_'..lang..'_\n➖➖➖➖➖➖➖➖\n\n*🔹وضعیت فروارد کردن :*_'..lfwd..'_\n *🔸وضعیت ارسال یوزرنیم :*_'..luser..'_\n*🔹وضعیت ارسال هشتگ :*_ '..ltag
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
			elseif not redis:get('lang'..chat_id,true) then
				text = '_⚙ Settings Of '..msg.chat_id_..'_\n*🔸Gp Language :*_'..lang..'_\n➖➖➖➖➖➖➖➖\n\n*🔹 Forwarding Stat :*_'..lfwd..'_\n *🔸 Username Sending Stat :*_'..luser..'_\n*🔹 HashTag Sending Stat :*_ '..ltag
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
			end
		end
--if msg.content_.text_ == "/f2a" and msg.reply_to_message_id_ then
	elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
    tdcli_function ({
      ID="GetChats",
      offset_order_="9223372036854775807",
      offset_chat_id_=0,
      limit_=20
    }, dl_cb, nil)
	end
end
end
