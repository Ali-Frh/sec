-- This script is based on telegram-cli sample lua script by @vysheng, 
-- written to demonstrate how to use tdlib.lua for your telegram-cli bot.

-- Load tdcli library.
--tdcli = dofile('tdcli.lua')
--local redis = require 'redis'
--redis = (loadfile "redis.lua")()
--JSON = require('dkjson')
--db = require('redis')
--redis = db.connect('127.0.0.1', 6379)
--serpent = require('serpent')
--redis:select(2)}
tdcli = dofile('tdcli.lua')
--redis = dofile('redis.lua')
JSON = require('dkjson')
serpent = require('serpent')
--redis = (loadfile "./libs/redis.lua")()
redis = require('redis')
mame = Redis.connect('127.0.0.1', 6379)



-- Print message format. Use serpent for prettier result.
function vardump(value, depth, key)
  local linePrefix = ''
  local spaces = ''

  if key ~= nil then
    linePrefix = key .. ' = '
  end

  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do 
      spaces = spaces .. '  '
    end
  end

  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces .. linePrefix .. '(table) ')
    else
      print(spaces .. '(metatable) ')
        value = mTable
    end
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey)
    end
  elseif type(value)  == 'function' or 
    type(value) == 'thread' or 
    type(value) == 'userdata' or 
    value == nil then
      print(spaces .. tostring(value))
  elseif type(value)  == 'string' then
    print(spaces .. linePrefix .. '"' .. tostring(value) .. '",')
  else
    print(spaces .. linePrefix .. tostring(value) .. ',')
  end
end

-- Print callback
function dl_cb(arg, data)
  vardump(arg)
  vardump(data)
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
      -- And content of the text is...
     -- if msg.content_.text_ == "ping" then
        -- Reply with regular text
       -- tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'pong', 1)
	   if msg.content_.text_ == "/id" then
        -- Reply with regular text
		tdcli.sendText(msg.chat_id_, 0, 1, msg.chat_id_, 1, 'html')
		elseif input:match('^setname') then
        local text = input:gsub('setname', '')
        --tdcli.changeAccountTtl(text)
		tdcli.changeChatTitle(msg.chat_id_, text)
		elseif input:match('^creategp') then
        local text = input:gsub('creategp', '')
		tdcli.createNewGroupChat({[0] = msg.sender_user_id_}, text)
		tdcli.sendText(msg.chat_id_, 0, 1, '<i> Group Was Created Successfuly </i>', 1, 'html')
	elseif input:match('^fuckgp') then
		local text = input:gsub('fuckgp', '')
		tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Are You Sure ? :/_\n if yes type *are befuck*\n else type *na nafuck*', 1, 'md')
		elseif input:match('are befuck') then
		tdcli.closeChat(data.message_.chat_id_)
		elseif input:match('na nafuck') then
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Fucking Progress Has Been Canceled :D_', 1, 'md')
		elseif input:match('^id$') then
			local gpid = '_Chat??:'..msg.chat_id_..'_'
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, gpid, 1, 'md')
		elseif input:match('^tosuper') then
			local gpid = msg.chat_id_
			tdcli.migrateGroupChatToChannelChat(gpid)
		elseif input:match('^getlink') then
			--tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_If I,m Creator I,ve Send Gplink On Next Msg_', 1, 'md')
			tdcli.exportChatInviteLink(msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, msg.invite_link_, 1, 'md')
			--tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, 'lonk :'..ChatInviteLink, 1, 'md')
		elseif input:match('^typing on$') then
			hash = 'typing:'..msg.chat_id_
			mame:set(hash,true)
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Typing Mode For This Gp Has Been Activted_', 1, 'md')
		elseif input:match('^typing off$') then
			hash = 'typing:'..msg.chat_id_
			mame:del(hash)
		elseif input:match('^typingall on$') then
			hash = 'typingall'
			mame:set(hash,'true')
		elseif input:match('^typingall off$') then
			hash = 'typingall'
			mame:del(hash)
		elseif input:match('(.*)') and mame:get('typingall') == 'true' then
			tdcli.sendChatAction(msg.chat_id_, 'Typing')
		elseif input:match('lock fwd$') and not mame:get('lfwd:'..msg.chat_id_) then
			mame:set('lfwd:'..msg.chat_id_, true)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Fwd Has Been Activated :D_', 1, 'md')
		elseif input:match('unlock fwd$') and mame:get('lfwd:'..msg.chat_id_) then
			mame:del('lfwd:'..msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Fwd Has Been Deactivated :D_', 1, 'md')
		elseif mame:get('lfwd:'..chat_id) and msg.forward_info_ then
			tdcli.deleteMessages(chat_id, {[0] = msg.id_})
		end
		if input:match('^block') then
			local id = input:gsub('block', '')
			tdcli.blockUser(id)
		elseif input:match('^unblock') then
			local id = input:gsub('unblock', '')
			tdcli.unblockUser(id)
		elseif input:match('^sessions$') then
			tdcli.getActiveSessions()
		end
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
		if input:match('^lock username$') then
			mame:set('luser:'..msg.chat_id_, true)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Has Been Activated :D_', 1, 'md')
		elseif input:match('^unlock username$') then
			mame:del('luser:'..msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Has Been Deactivated :D_', 1, 'md')
		--elseif input:match('unlock username$') and not mame:get('luser:'..msg.chat_id_) then
		--	tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Already Deactivated :D_', 1, 'md')
		elseif input:match('@') and mame:get('luser:'..msg.chat_id_) then
			--tdcli.deleteMessages(msg.chat_id_, data.message_.text_)
			tdcli.deleteMessages(chat_id, {[0] = msg.id_})
		end
		--elseif input:match('reset lock_username$') then
		--	mame:set('luser:'..msg.chat_id_)
		--	tdcli.sendText(msg.chat_id_, 0, 1, '<i>Lock Username Has Been Reseted :D</i>', 1, 'html')
		
		--if redis:get('lock_fwd:'..chat_id) and msg.forward_info_ then
       -- tdcli.deleteMessages(chat_id, {[0] = msg.id_})
 --     end
--lock #tag
		if input:match('^lock tag$') then
			mame:set('ltag:'..msg.chat_id_, true)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock tag Has Been Activated :D_', 1, 'md')
		elseif input:match('^unlock tag$') then
			mame:del('ltag:'..msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock tag Has Been Deactivated :D_', 1, 'md')
		--elseif input:match('unlock username$') and not mame:get('luser:'..msg.chat_id_) then
		--	tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Already Deactivated :D_', 1, 'md')
		elseif input:match('#') and mame:get('ltag:'..msg.chat_id_) then
			--tdcli.deleteMessages(msg.chat_id_, data.message_.text_)
			tdcli.deleteMessages(chat_id, {[0] = msg.id_})
		end
--------------------##############################
--settings
		local lfwd = 'lfwd:'..chat_id
     if mame:get(lfwd) then
   lfwd = "Locked !"
   else 
   lfwd = "Unlocked !"
  end
				local luser = 'luser'..chat_id
     if mame:get(luser) then
   luser = "Locked !"
   else 
   luser = "Unlocked !"
  end
				local luser = 'ltag'..chat_id
			if mame:get(ltag) then
   ltag = "Locked !"
   else 
   ltag = "Unlocked !"
  end
			if mame:get('lang'..chat_id,true) then
   lang = "فارسی"
   elseif not mame:get('lang'..chat_id,true) then 
   lang = "English"
  end
		

		if input:match('^group settings$') then
			--if mame:get('lfwd:'..msg.chat_id_) then
			--	local lock_fwd = 'yes'
			--elseif not mame:get('lfwd:'..msg.chat_id_) then
			--	local lock_fwd = 'no'
			--elseif lock_fwd == nil then
			--	local lock_fwd = 'undefined'
			--end
					--🔹 -- Abi
					--🔸 -- Narenji
text = '_⚙ Settings Of '..msg.chat_id_..'_\n*🔸Gp Language :*_'..lang..'_\n➖➖➖➖➖➖➖➖\n\n*🔹 Forwarding Stat :*_'..lfwd..'_\n *🔸 Username Sending Stat :*_'..luser..'_\n*🔹 HashTag Sending Stat :*_ '..ltag
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	
	-------------------------------------------------Junk Codes :/--------------------------------------------------------------------------
		--tdcli.createNewChannelChat(text, 1, 'A Gp Created With MicroSys Bot\n#Developer : @ShopBuy')
		--elseif input:match('^/addme') then
        --local text = input:gsub('addme', '')
		--tdcli.addChatMember(text, msg.sender_user_id_, 20)
      -- And if content of the text is...
      --elseif msg.content_.text_ == "PING" then
        -- Reply with formatted text
      --  tdcli.sendMessage(msg.chat_id_, 0, 1, '<b>PONG</b>', 1, 'html')
				end
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
