local  e = select(2, ...)

--StaticPopup.lua
--StaticPopupItemFrameMixin:DisplayInfo(link, name, color, texture, count, tooltip)
for _, frame in pairs({'StaticPopup1ItemFrameText', 'StaticPopup2ItemFrameText', 'StaticPopup3ItemFrameText', 'StaticPopup4ItemFrameText'}) do
    hooksecurefunc(_G[frame], 'SetText', function(self, name)
        local itemName= e.strText[name]
        if not itemName then
            local link= self:GetParent().link
            if link then
                local itemID= C_Item.GetItemInfoInstant(link)
                itemName= WoWTools_ChineseMixin:GetItemName(itemID)
            end
        end
        if itemName then
            itemName= itemName:match('|c........(.-)|r') or itemName
            if name ~= itemName  then
                self:SetText(itemName)
            end
        end
    end)
end









hooksecurefunc('StaticPopup_Show', function(which, text_arg1, text_arg2, data)
    local info = StaticPopupDialogs[which];
    if not info then
        return
    end

    local dialog = nil	
	dialog = StaticPopup_FindVisible(which, data);

	if ( not dialog ) then
		local index = 1;
		if ( info.preferredIndex ) then
			index = info.preferredIndex;
		end
		for i = index, STATICPOPUP_NUMDIALOGS do
			local frame = StaticPopup_GetDialog(i);
			if ( frame and not frame:IsShown() ) then
				dialog = frame;
				break;
			end
		end

		if ( not dialog and info.preferredIndex ) then
			for i = 1, info.preferredIndex do
				local frame = _G["StaticPopup"..i];
				if ( not frame:IsShown() ) then
					dialog = frame;
					break;
				end
			end
		end
	end

	if not dialog or not dialog:IsShown() then
		return
	end

	local text = _G[dialog:GetName().."Text"];

    if ( (which == "DEATH") or
	     (which == "CAMP") or
		 (which == "QUIT") or
		 (which == "DUEL_OUTOFBOUNDS") or
		 (which == "RECOVER_CORPSE") or
		 (which == "RESURRECT") or
		 (which == "RESURRECT_NO_SICKNESS") or
		 (which == "INSTANCE_BOOT") or
		 (which == "GARRISON_BOOT") or
		 (which == "INSTANCE_LOCK") or
		 (which == "CONFIRM_SUMMON") or
		 (which == "CONFIRM_SUMMON_SCENARIO") or
		 (which == "CONFIRM_SUMMON_STARTING_AREA") or
		 (which == "BFMGR_INVITED_TO_ENTER") or
		 (which == "AREA_SPIRIT_HEAL") or
		 (which == "CONFIRM_REMOVE_COMMUNITY_MEMBER") or
		 (which == "CONFIRM_DESTROY_COMMUNITY_STREAM") or
		 (which == "CONFIRM_RUNEFORGE_LEGENDARY_CRAFT") or
		 (which == "ANIMA_DIVERSION_CONFIRM_CHANNEL")) then
        local a, b= WoWTools_ChineseMixin:SetText(text_arg1), WoWTools_ChineseMixin:SetText(text_arg2)
        if a then
            text.text_arg1 = a
        end
        if b then
            text.text_arg2 = b
        end

	elseif (which == "PREMADE_GROUP_LEADER_CHANGE_DELIST_WARNING") then
        local a, b= WoWTools_ChineseMixin:SetText(text_arg1), WoWTools_ChineseMixin:SetText(text_arg2)
        if a then
		    dialog.SubText.text_arg1 = a
        end
        if b then
		    dialog.SubText.text_arg2 = b
        end

	elseif ( which == "BILLING_NAG" ) then
		text:SetFormattedText(WoWTools_ChineseMixin:Setup(info.text), WoWTools_ChineseMixin:Setup(text_arg1), '|4分钟:分钟;');

	elseif ( which == "SPELL_CONFIRMATION_PROMPT" or which == "SPELL_CONFIRMATION_WARNING" or which == "SPELL_CONFIRMATION_PROMPT_ALERT" or which == "SPELL_CONFIRMATION_WARNING_ALERT" ) then
        local a= WoWTools_ChineseMixin:SetText(text_arg1)
        if a then
            text:SetText(a)
            info.text = a
        end

	elseif ( which == "CONFIRM_AZERITE_EMPOWERED_RESPEC_EXPENSIVE" ) then
		local goldDisplay = GetMoneyString(data.respecCost, true);
		text:SetFormattedText(WoWTools_ChineseMixin:Setup(info.text), goldDisplay, WoWTools_ChineseMixin:Setup(text_arg1), '重铸');

	elseif  ( which == "BUYOUT_AUCTION_EXPENSIVE" ) then
		local goldDisplay = GetMoneyString(text_arg1, true);
		text:SetFormattedText(WoWTools_ChineseMixin:Setup(info.text), goldDisplay, '一口价');

	else
        local a, b= WoWTools_ChineseMixin:SetText(text_arg1), WoWTools_ChineseMixin:SetText(text_arg2)
        local s= WoWTools_ChineseMixin:SetText(info.text)
        if a or b or s then
		    text:SetFormattedText(s or info.text, a or text_arg1, b or text_arg2)
        end
        if a then
		    text.text_arg1 = a
        end
        if b then
		    text.text_arg2 = b
        end
	end





	



	if info.subText then
        local subText= e.strText[info.subText]
        if subText then
            dialog.SubText:SetText(subText)
        end
	end

	local buttons = {_G[dialog:GetName().."Button1"], _G[dialog:GetName().."Button2"], _G[dialog:GetName().."Button3"], _G[dialog:GetName().."Button4"]};
	for index, button in ipairs_reverse(buttons) do
        if info["button"..index] then
            local buttonText= e.strText[info["button"..index]]
            if buttonText then
                button:SetText(buttonText)
            end
        end
	end

	if info.extraButton then
        local extraText= e.strText[info.extraButton]
        if extraText then
            local extraButton = dialog.extraButton;
            extraButton:SetText(extraText);
            local width = 128
            local padding = 40;
            local textWidth = extraButton:GetTextWidth() + padding;
            width = math.max(width, textWidth);
            extraButton:SetWidth(width);
        end
	end

	StaticPopup_Resize(dialog, which)
end)













--Blizzard_Dialogs.lua
WoWTools_ChineseMixin:HookDialog('GAME_SETTINGS_TIMED_CONFIRMATION', 'OnUpdate', function(self, elapsed)
    local duration = self.duration - elapsed
    local time = math.max(duration + 1, 1)
    self.text:SetFormattedText('接受新选项？\n\n|cnGREEN_FONT_COLOR:%d|r 秒后|cnGREEN_FONT_COLOR:恢复。|r', time)
    StaticPopup_Resize(self, "GAME_SETTINGS_TIMED_CONFIRMATION")
end)


--StaticPopup.lua
WoWTools_ChineseMixin:HookDialog("GENERIC_CONFIRMATION", 'OnShow', function(self, data)--StaticPopup.lua
    if data.text==HUD_EDIT_MODE_DELETE_LAYOUT_DIALOG_TITLE then
        self.text:SetFormattedText('你确定要删除布局|n|cnGREEN_FONT_COLOR:%s|r吗？', data.text_arg1, data.text_arg2)

    elseif data.text==SELL_ALL_JUNK_ITEMS_POPUP then
        self.text:SetFormattedText('你即将出售所有垃圾物品，而且无法回购。\n你确定要继续吗？', data.text_arg1, data.text_arg2)

    elseif data.text==PROFESSIONS_CRAFTING_ORDER_MAIL_REPORT_WARNING then
        self.text:SetFormattedText('这名玩家有你还未认领的物品。如果你在认领前举报这名玩家，你会失去所有这些物品。', data.text_arg1, data.text_arg2)

    elseif data.text==SELL_ALL_JUNK_ITEMS_POPUP then
        self.text:SetFormattedText('你即将出售所有垃圾物品，而且无法回购。\n你确定要继续吗？', data.text_arg1, data.text_arg2)

    elseif data.text==TALENT_FRAME_CONFIRM_CLOSE then
        self.text:SetFormattedText('如果你继续，会失去所有待定的改动。', data.text_arg1, data.text_arg2)

    elseif data.text==CRAFTING_ORDER_RECRAFT_WARNING2 then
        self.text:SetFormattedText('再造可能导致你的物品的品质下降。|n|n\n\n你确定要发布此订单吗？', data.text_arg1, data.text_arg2)

    elseif data.text==PROFESSIONS_ORDER_UNUSABLE_WARNING then
        self.text:SetFormattedText('此物品目前不能使用，而且拾取后就会绑定。确定要下达此订单吗？', data.text_arg1, data.text_arg2)

    elseif data.text==CRAFTING_ORDERS_IGNORE_CONFIRMATION then
        self.text:SetFormattedText('你确定要屏蔽|cnGREEN_FONT_COLOR:%s|r吗？', data.text_arg1, data.text_arg2)

    elseif data.text==CRAFTING_ORDERS_OWN_REAGENTS_CONFIRMATION then
        self.text:SetFormattedText('你即将完成一个制造订单，里面包含一些你自己的材料。你确定吗？', data.text_arg1, data.text_arg2)

    elseif data.text==TALENT_FRAME_CONFIRM_LEAVE_DEFAULT_LOADOUT then
        self.text:SetFormattedText('你如果不先将你当前的天赋配置储存下来，就会永远失去此配置。|n|n你确定要继续吗？', data.text_arg1, data.text_arg2)

    elseif data.text==TALENT_FRAME_CONFIRM_STARTER_DEVIATION then
        self.text:SetFormattedText('选择此天赋会使你离开入门天赋配置指引。', data.text_arg1, data.text_arg2)

    end

    if not data.acceptText then
        self.button1:SetText('是')

    elseif data.acceptText==OKAY then
        self.button1:SetText('确定')

    elseif data.acceptText==SAVE then
        self.button1:SetText('保存')

    elseif data.acceptText==ACCEPT then
            self.button1:SetText('接受')

    elseif data.acceptText==CONTINUE then
        self.button1:SetText('继续')
    end

    if not data.cancelText then
        self.button2:SetText('否')

    elseif data.cancelText==CANCEL then
        self.button2:SetText('取消')
    end

end)

WoWTools_ChineseMixin:HookDialog("GENERIC_INPUT_BOX", 'OnShow', function(self, data)
    if data.text==HUD_EDIT_MODE_RENAME_LAYOUT_DIALOG_TITLE then
        self.text:SetFormattedText('为布局|cnGREEN_FONT_COLOR:%s|r输入新名称', data.text_arg1, data.text_arg2)
    end

    if not data.acceptText then
        self.button1:SetText('完成')

    elseif data.acceptText==OKAY then
        self.button1:SetText('确定')

    elseif data.acceptText==SAVE then
        self.button1:SetText('保存')

    elseif data.acceptText==ACCEPT then
            self.button1:SetText('接受')

    elseif data.acceptText==CONTINUE then
        self.button1:SetText('继续')
    end

    if not data.cancelText then
        self.button2:SetText('取消')
    end
end)



WoWTools_ChineseMixin:AddDialogs('BANK_CONFIRM_CLEANUP', {text='你确定要自动整理你的物品吗？|n该操作会影响所有的战团标签。', button1='接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs('CONFIRM_BUY_BANK_TAB', {text='你是否想要购买一个战团银行标签？', button1='是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs('BANK_MONEY_WITHDRAW', {text='提取数量：', button1='接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs('BANK_MONEY_DEPOSIT', {text='存放数量：', button1='接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("LFG_LIST_INVITING_CONVERT_TO_RAID", {text = '邀请这名玩家或队伍会将你的小队转化为团队。', button1 = '邀请', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs('RELEASE_PET', {text ='你确定要|cnRED_FONT_COLOR:永久释放|r你的宠物吗？你将永远无法再召唤此宠物。', button1='|cnRED_FONT_COLOR:确定|r', button2='|cnGREEN_FONT_COLOR:取消|r',})
WoWTools_ChineseMixin:AddDialogs('CONFIRM_RESET_TO_DEFAULT_KEYBINDINGS', {text = '确定将所有快捷键设置为默认值吗？', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs('GAME_SETTINGS_TIMED_CONFIRMATION', {button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs('GAME_SETTINGS_CONFIRM_DISCARD', {text= '你尚有还未应用的设置。\n你确定要退出吗？', button1 = '退出', button2 = '应用并退出', button3 = '取消'})
WoWTools_ChineseMixin:AddDialogs('GAME_SETTINGS_APPLY_DEFAULTS', {text= '你想要将所有用户界面和插件设置重置为默认状态，还是只重置这个界面或插件的设置？', button1 = '所有设置', button2 = '这些设置', button3 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_OVERWRITE_EQUIPMENT_SET", {text = '你已经有一个名为|cnGREEN_FONT_COLOR:%s|r的装备方案了。是否要覆盖已有方案', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_SAVE_EQUIPMENT_SET", {text = '你想要保存装备方案\"|cnGREEN_FONT_COLOR:%s|r\"吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_DELETE_EQUIPMENT_SET", {text = '你确认要删除装备方案 |cnGREEN_FONT_COLOR:%s|r 吗？', button1 = '是', button2 = '否'})

WoWTools_ChineseMixin:AddDialogs("CONFIRM_GLYPH_PLACEMENT",{button1 = '是', button2 = '否'})

WoWTools_ChineseMixin:HookDialog("CONFIRM_GLYPH_PLACEMENT", 'OnShow', function(self)
    self.text:SetFormattedText('你确定要使用|cnGREEN_FONT_COLOR:%s|r铭文吗？这将取代|cnGREEN_FONT_COLOR:%s|r。', self.data.name, self.data.currentName)
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_GLYPH_REMOVAL",{button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_GLYPH_REMOVAL", 'OnShow', function(self)
    self.text:SetFormattedText('你确定要移除|cnGREEN_FONT_COLOR:%s|r吗？', self.data.name)
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_RESET_TEXTTOSPEECH_SETTINGS", {text = '确定将所有文字转语音设定重置为默认值吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REDOCK_CHAT", {text = '这么做会将你的聊天窗口重新并入综合标签页。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_PURCHASE_TOKEN_ITEM", {text = '你确定要将%s兑换为下列物品吗？ %s', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_PURCHASE_NONREFUNDABLE_ITEM", {text = '你确定要将%s兑换为下列物品吗？本次购买将无法退还。%s', button1 = '是', button2 = '否'})

WoWTools_ChineseMixin:AddDialogs("CONFIRM_UPGRADE_ITEM", {button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_UPGRADE_ITEM", 'OnShow', function(self, data)
    if data.isItemBound then
        self.text:SetFormattedText('你确定要花费|cnGREEN_FONT_COLOR:%s|r升级下列物品吗？', data.costString)
    else
        self.text:SetFormattedText('你确定要花费|cnGREEN_FONT_COLOR:%s|r升级下列物品吗？升级会将该物品变成灵魂绑定物品。', data.costString)
    end
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_REFUND_TOKEN_ITEM", {text = '你确定要退还下面这件物品%s，获得%s的退款吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REFUND_MAX_HONOR", {text = '你的荣誉已接近上限。卖掉这件物品会让你损失%d点荣誉。确认要继续吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REFUND_MAX_ARENA_POINTS", {text = '你的竞技场点数已接近上限。出售这件物品会让你损失|cnGREEN_FONT_COLOR:%d|r点竞技场点数。确认要继续吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REFUND_MAX_HONOR_AND_ARENA", {text = '你的荣誉已接近上限。卖掉此物品会使你损失%1$d点荣誉和%2$d的竞技场点数。要继续吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_HIGH_COST_ITEM", {text = '你确定要花费如下金额的货币购买%s吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_COMPLETE_EXPENSIVE_QUEST", {text = '完成这个任务需要缴纳如下数额的金币。你确定要完成这个任务吗？', button1 = '完成任务', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_ACCEPT_PVP_QUEST", {text = '接受这个任务之后，你将被标记为PvP状态，直到你放弃或完成此任务。你确定要接受任务吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("USE_GUILDBANK_REPAIR", {text = '你想要使用公会资金修理吗？', button1 = '使用个人资金', button2 = '确定'})
WoWTools_ChineseMixin:AddDialogs("GUILDBANK_WITHDRAW", {text = '接提取数量：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("GUILDBANK_DEPOSIT", {text = '存放数量：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_BUY_GUILDBANK_TAB", {text = '你是否想要购买一个公会银行标签？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_BUY_REAGENTBANK_TAB", {text = '确定购买材料银行栏位吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("TOO_MANY_LUA_ERRORS", {text = '你的插件有大量错误，可能会导致游戏速度降低。你可以在界面选项中打开Lua错误显示。', button1 = '禁用插件', button2 = '忽略'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_ACCEPT_SOCKETS", {text = '镶嵌之后，一颗或多颗宝石将被摧毁。你确定要镶嵌新的宝石吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_RESET_INSTANCES", {text = '你确定想要重置你的所有副本吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_RESET_CHALLENGE_MODE", {text = '你确定要重置地下城吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_GUILD_DISBAND", {text = '你真的要解散公会吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_BUY_BANK_SLOT", {text = '你愿意付钱购买银行空位吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("MACRO_ACTION_FORBIDDEN", {text = '一段宏代码已被禁止，因为其功能只对暴雪UI开放。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("ADDON_ACTION_FORBIDDEN", {text = '|cnRED_FONT_COLOR:%s|r已被禁用，因为该功能只对暴雪的UI开放。\n你可以禁用这个插件并重新装载UI。', button1 = '禁用', button2 = '忽略'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_LOOT_DISTRIBUTION", {text = '你想要将%s分配给%s，确定吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_BATTLEFIELD_ENTRY", {text = '你现在可以进入战斗：\n\n|cff20ff20%s|r\n', button1 = '进入', button2 = '离开队列'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_CONFIRM_WORLD_PVP_QUEUED", {text = '你已在%s队列中。请等候。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_CONFIRM_WORLD_PVP_QUEUED_WARMUP", {text = '你正在下一场%s战斗的等待队列中。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_DENY_WORLD_PVP_QUEUED", {text = '你现在无法进入%s战场的等待队列。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_INVITED_TO_QUEUE", {text = '你想要加入%s的战斗吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_INVITED_TO_QUEUE_WARMUP", {text = '%s的战斗即将打响！你要加入等待队列吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_INVITED_TO_ENTER", {text = '%s的战斗又一次在召唤你！|n现在进入？|n剩余时间：%d %s', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_EJECT_PENDING", {text = '你已在%s队列中但还没有收到战斗的召唤。稍后你将被传出战场。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_EJECT_PENDING_REMOTE", {text = '你已在%s队列中但还没有收到战斗的召唤。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_PLAYER_EXITED_BATTLE", {text = '你已经从%s的战斗中退出。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_PLAYER_LOW_LEVEL", {text = '你的级别太低，无法进入%s。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_PLAYER_NOT_WHILE_IN_RAID", {text = '你不能在团队中进入%s。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BFMGR_PLAYER_DESERTER", {text = '在你的逃亡者负面效果消失之前，你无法进入%s。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_GUILD_LEAVE", {text = '确定要退出%s？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_GUILD_PROMOTE", {text = '确定要将%s提升为会长？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("RENAME_GUILD", {text = '输入新的公会名：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("HELP_TICKET_QUEUE_DISABLED", {text = 'GM帮助请求暂时不可用。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CLIENT_RESTART_ALERT", {text = '你的有些设置需要你重新启动游戏才能够生效。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CLIENT_LOGOUT_ALERT", {text = '你的某些设置将在你登出游戏并重新登录之后生效。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("COD_ALERT", {text = '你没有足够的钱来支付付款取信邮件。', button1 = '关闭'})
WoWTools_ChineseMixin:AddDialogs("COD_CONFIRMATION", {text = '收下这件物品将花费：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("COD_CONFIRMATION_AUTO_LOOT", {text = '收下这件物品将花费：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("DELETE_MAIL", {text = '删除这封邮件会摧毁%s', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("DELETE_MONEY", {text = '删除这封邮件会摧毁：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REPORT_BATTLEPET_NAME", {text = '你确定要举报%s 使用不当战斗宠物名吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REPORT_PET_NAME", {text = '你确定要举报%s 使用不当战斗宠物名吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REPORT_SPAM_MAIL", {text = '你确定要举报%s为骚扰者吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("JOIN_CHANNEL", {text = '输入频道名称', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CHANNEL_INVITE", {text = '你想要将谁邀请至%s？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CHANNEL_PASSWORD", {text = '为%s输入一个密码。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("NAME_CHAT", {text = '输入对话窗口名称', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("RESET_CHAT", {text = '"将你的聊天窗口重置为默认设置。\n你会失去所有自定义设置。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("PETRENAMECONFIRM", {text = '你确定要将宠物命名为\'%s\'吗？', button1 = '是', button2 = '否'})

WoWTools_ChineseMixin:AddDialogs("SKINNED", {text = '徽记被取走 - 你只能在墓地复活', button1 = '接受'})
WoWTools_ChineseMixin:AddDialogs("SKINNED_REPOP", {text = '徽记被取走 - 你只能在墓地复活', button1 = '释放灵魂', button2 = '拒绝'})
WoWTools_ChineseMixin:AddDialogs("TRADE", {text = '和%s交易吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("PARTY_INVITE", {button1 = '接受', button2 = '拒绝'})
WoWTools_ChineseMixin:AddDialogs("GROUP_INVITE_CONFIRMATION", {button1 = '接受', button2 = '拒绝'})
WoWTools_ChineseMixin:AddDialogs("CHAT_CHANNEL_INVITE", {text = '%2$s邀请你加入\'%1$s\'频道。', button1 = '接受', button2 = '拒绝'})
WoWTools_ChineseMixin:AddDialogs("BN_BLOCK_FAILED_TOO_MANY_RID", {text = '你能够屏蔽的实名和战网昵称好友已达上限。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("BN_BLOCK_FAILED_TOO_MANY_CID", {text = '你通过暴雪游戏服务屏蔽的角色数量已达上限。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CHAT_CHANNEL_PASSWORD", {text = '请输入\'%1$s\'的密码。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CAMP", {text = '%d%s后返回角色选择画面', button1 = '取消'})
WoWTools_ChineseMixin:AddDialogs("QUIT", {text = '%d%s后退出游戏', button1 = '立刻退出', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("LOOT_BIND", {text = '拾取%s后，该物品将与你绑定', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("EQUIP_BIND", {text = '装备之后，该物品将与你绑定。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("EQUIP_BIND_REFUNDABLE", {text = '进行此项操作会使该物品无法退还', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("EQUIP_BIND_TRADEABLE", {text = '执行此项操作会使该物品不可交易。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("USE_BIND", {text = '使用该物品后会将它和你绑定', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIM_BEFORE_USE", {text = '你确定要使用这个物品吗？', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("USE_NO_REFUND_CONFIRM", {text = '进行此项操作会使该物品无法退还', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_AZERITE_EMPOWERED_BIND", {text = '选择一种力量后，此物品会与你绑定。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_AZERITE_EMPOWERED_SELECT_POWER", {text = '你确定要选择这项艾泽里特之力吗？', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_AZERITE_EMPOWERED_RESPEC", {text = '重铸的花费会随使用的次数而提升。\n\n你确定要花费如下金额来重铸%s吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_AZERITE_EMPOWERED_RESPEC_EXPENSIVE", {text = '重铸的花费会随使用的次数而提升。|n|n你确定要花费%s来重铸%s吗？|n|n请输入 %s 以确认。', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("DELETE_ITEM", {text = '你确定要摧毁%s？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("DELETE_QUEST_ITEM", {text = '确定要销毁%s吗？\n\n|cffff2020销毁该物品的同时也将放弃所有相关任务。|r', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("DELETE_GOOD_ITEM", {text = '你真的要摧毁%s吗？\n\n请在输入框中输入\"'..DELETE_ITEM_CONFIRM_STRING..'\"以确认。', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("DELETE_GOOD_QUEST_ITEM", {text = '确定要摧毁%s吗？\n|cffff2020摧毁该物品也将同时放弃相关任务。|r\n\n请在输入框中输入\"'..DELETE_ITEM_CONFIRM_STRING..'\"以确认。', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("QUEST_ACCEPT", {text = '%s即将开始%s\n你也想这样吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("QUEST_ACCEPT_LOG_FULL", {text = '%s正在开始%s任务\n你的任务纪录已满。如果能够在任务纪录中\n空出位置，你也可以参与此任务。', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("ABANDON_PET", {text = '你是否决定永远地遗弃你的宠物？你将再也不能召唤它了。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("ABANDON_QUEST", {text = '放弃\"%s\"？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("ABANDON_QUEST_WITH_ITEMS", {text = '确定要放弃\"%s\"并摧毁%s吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("ADD_FRIEND", {text = '输入好友的角色名：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("SET_FRIENDNOTE", {text = '为%s设置备注：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("SET_BNFRIENDNOTE", {text = '为%s设置备注：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("SET_COMMUNITY_MEMBER_NOTE", {text = '为%s设置备注：', button1 = '接受', button2 = '取消'})

WoWTools_ChineseMixin:AddDialogs("CONFIRM_REMOVE_COMMUNITY_MEMBER", {text = '你确定要将%s从群组中移除吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_REMOVE_COMMUNITY_MEMBER", 'OnShow', function(self, data)
    if data.clubType == Enum.ClubType.Character then
        self.text:SetFormattedText('你确定要将%s从社区中移除吗？', data.name)
    else
        self.text:SetFormattedText('你确定要将%s从群组中移除吗？', data.name)
    end
end)


WoWTools_ChineseMixin:AddDialogs("CONFIRM_DESTROY_COMMUNITY_STREAM", {text = '你确定要删除频道%s吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_DESTROY_COMMUNITY_STREAM", 'OnShow', function(self, data)
    local streamInfo = C_Club.GetStreamInfo(data.clubId, data.streamId)
    if streamInfo then
        self.text:SetFormattedText('你确定要删除频道%s吗', streamInfo.name)
    end
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_LEAVE_AND_DESTROY_COMMUNITY", {text = '确定要退出并删除群组吗？', subText = '退出后群组会被删除。你确定要删除群组吗？此操作无法撤销。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_LEAVE_AND_DESTROY_COMMUNITY", 'OnShow', function(self, clubInfo)
    if clubInfo.clubType == Enum.ClubType.Character then
        self.text:SetText('确定要退出并删除社区吗？')
        self.SubText:SetText('退出后社区会被删除。你确定要删除社区吗？此操作无法撤销。')
    else
        self.text:SetText('确定要退出并删除群组吗？')
        self.SubText:SetText('退出后群组会被删除。你确定要删除群组吗？此操作无法撤销。')
    end
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_LEAVE_COMMUNITY", {text = '退出群组？', subText = '你确定要退出%s吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_LEAVE_COMMUNITY", 'OnShow', function(self, clubInfo)
    if clubInfo.clubType == Enum.ClubType.Character then
        self.text:SetText('退出社区？')
        self.SubText:SetFormattedText('你确定要退出%s吗？', clubInfo.name)
    else
        self.text:SetText('退出群组？')
        self.SubText:SetFormattedText('你确定要退出%s吗？', clubInfo.name)
    end
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_DESTROY_COMMUNITY", {button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_DESTROY_COMMUNITY", 'OnShow', function(self, clubInfo)
    if clubInfo.clubType == Enum.ClubType.BattleNet then
        self.text:SetFormattedText('你确定要删除群组\"%s\"吗？此操作无法撤销。|n|n请在输入框中输入\"'..COMMUNITIES_DELETE_CONFIRM_STRING ..'\"以确认。', clubInfo.name)
    else
        self.text:SetFormattedText('你确定要删除社区\"%s\"吗？此操作无法撤销。|n|n请在输入框中输入\"'..COMMUNITIES_DELETE_CONFIRM_STRING ..'\"以确认。', clubInfo.name)
    end
end)

WoWTools_ChineseMixin:AddDialogs("ADD_IGNORE", {text = '输入想要屏蔽的玩家名字\n或者\n在聊天窗口中按住Shift并点击该玩家的名字：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("ADD_GUILDMEMBER", {text = '添加公会成员：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONVERT_TO_RAID", {text = '你的队伍已经满了。你想要将队伍转换成团队吗？\n\n注意：在团队中，你的大部分任务都无法完成！', button1 = '转换', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID", {text = '你的队伍已经满了。你想要将队伍转换成团队吗？\n\n注意：在团队中，你的大部分任务都无法完成！', button1 = '转换', button2 = '取消'})

WoWTools_ChineseMixin:AddDialogs("REMOVE_GUILDMEMBER", {text = format('确定想要从公会中移除%s吗？', "XXX"), button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:HookDialog("REMOVE_GUILDMEMBER", 'OnShow', function(self, data)
    if data then
        self.text:SetFormattedText('你确定想要从公会中移除%s吗？', data.name)
    end
end)

WoWTools_ChineseMixin:AddDialogs("SET_GUILDPLAYERNOTE", {text = '设置玩家信息', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("SET_GUILDOFFICERNOTE", {text = '设置公会官员信息', button1 = '接受', button2 = '取消'})

WoWTools_ChineseMixin:AddDialogs("SET_GUILD_COMMUNITIY_NOTE", {text = '设置玩家信息', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("SET_GUILD_COMMUNITIY_NOTE", 'OnShow', function(self, data)
    if data then
        self.text:SetText(data.isPublic and '设置玩家信息' or '设置公会官员信息')
    end
end)

WoWTools_ChineseMixin:AddDialogs("RENAME_PET", {text = '输入你想要给宠物起的名字：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("DUEL_REQUESTED", {text = '%s向你发出决斗要求。', button1 = '接受', button2 = '拒绝'})
WoWTools_ChineseMixin:AddDialogs("DUEL_OUTOFBOUNDS", {text = '正在离开决斗区域,你将在%d%s内失败。'})
WoWTools_ChineseMixin:AddDialogs("PET_BATTLE_PVP_DUEL_REQUESTED", {text = '%s向你发出宠物对战要求。', button1 = '接受', button2 = '拒绝'})
WoWTools_ChineseMixin:AddDialogs("UNLEARN_SKILL", {text = '你确定要忘却%s并遗忘所有已经学会的配方？如果你选择回到此专业，你的专精知识将依然存在。|n|n在框内输入 \"'..UNLEARN_SKILL_CONFIRMATION ..'\" 以确认。', button1 = '忘却这个技能', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("XP_LOSS", {text = '如果你找到你的尸体，那么你可以在没有任何惩罚的情况下复活。现在由我来复活你，那么你的所有物品（包括已装备的和物品栏中的）将损失50%%的耐久度，你也要承受%s的|cff71d5ff|Hspell:15007|h[复活虚弱]|h|r时间。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("XP_LOSS_NO_SICKNESS_NO_DURABILITY", {text = '你可以找到你的尸体并在尸体位置复活。10级以下的玩家可以在此复活并不受任何惩罚。"', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("RECOVER_CORPSE", {delayText = '%d%s后复活', text= '现在复活吗？', button1 = '接受'})
WoWTools_ChineseMixin:AddDialogs("RECOVER_CORPSE_INSTANCE", {text= '你必须进入副本才能捡回你的尸体。'})
WoWTools_ChineseMixin:AddDialogs("AREA_SPIRIT_HEAL", {text = '%d%s后复活', button1 = '选择位置', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("BIND_ENCHANT", {text = '对这件物品进行附魔将使其与你绑定。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("BIND_SOCKET", {text = '该操作将使此物品与你绑定。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("REFUNDABLE_SOCKET", {text = '进行此项操作会使该物品无法退还', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("ACTION_WILL_BIND_ITEM", {text = '该操作将使此物品与你绑定。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("REPLACE_ENCHANT", {text = '你要将\"%s\"替换为\"%s\"吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("REPLACE_TRADESKILL_ENCHANT", {text = '你要将\"%s\"替换为\"%s\"吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("TRADE_REPLACE_ENCHANT", {text = '你要将\"%s\"替换为\"%s\"吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("TRADE_POTENTIAL_BIND_ENCHANT", {text = '将此物品附魔会使其与你绑定。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("TRADE_POTENTIAL_REMOVE_TRANSMOG", {text = '交易%s后，将把它从你的外观收藏中移除。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL", {text = '出售后%s将变为不可交易物品，即使你将其回购也无法恢复。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("END_BOUND_TRADEABLE", {text = '执行此项操作会使该物品不可交易。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("INSTANCE_BOOT", {text = '你现在不在这个副本的队伍里。你将在%d%s内被传送到最近的墓地中。'})
WoWTools_ChineseMixin:AddDialogs("GARRISON_BOOT", {text = '该要塞不属于你或者你的队长。你将在%d %s后被传送出要塞。'})
WoWTools_ChineseMixin:AddDialogs("INSTANCE_LOCK", {text = '你进入了一个已经保存进度的副本！你将在%2$s内被保存到%1$s的副本进度中！', button1 = '接受', button2 = '离开副本'})
--WoWTools_ChineseMixin:AddDialogs("CONFIRM_TALENT_WIPE", {text = '你确定要遗忘所有的天赋吗', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_BINDER", {text = '你想要将%s设为你的新家吗？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_SUMMON", {text = '%s想将你召唤到%s去。这个法术将在%d%s后取消。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_SUMMON_SCENARIO", {text = '%s已在%s开启一个场景战役。你是否愿意加入他们？\n\n此邀请将在%d%s后失效。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_SUMMON_STARTING_AREA", {text = '%s想召唤你前往%s。\n\n你将无法返回此初始区域。\n\n该法术将在%d %s后取消。', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("BILLING_NAG", {text = '您的帐户中还有%d%s的剩余游戏时间', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("IGR_BILLING_NAG", {text = '你的IGR游戏时间即将用尽，你很快会被断开连接。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_LOOT_ROLL", {text = '拾取%s后，该物品将与你绑定。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("GOSSIP_CONFIRM", {button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("GOSSIP_ENTER_CODE", {text = '请输入电子兑换券号码：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CREATE_COMBAT_FILTER", {text = '输入过滤名称：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("COPY_COMBAT_FILTER", {text = '输入过滤名称：', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_COMBAT_FILTER_DELETE", {text = '你确认要删除这个过滤条件？', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_COMBAT_FILTER_DEFAULTS", {text = '你确定要将过滤条件设定为初始状态吗？', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("WOW_MOUSE_NOT_FOUND", {text = '无法找到魔兽世界专用鼠标。请连接鼠标后在用户界面中再次启动该选项。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_BUY_STABLE_SLOT", {text = '你确定要支付以下数量的金币来购买一个新的兽栏栏位吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("TALENTS_INVOLUNTARILY_RESET", {text = '因为天赋树有了一些改动，你的某些天赋已被重置。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("TALENTS_INVOLUNTARILY_RESET_PET", {text = '你的宠物天赋已被重置。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("SPEC_INVOLUNTARILY_CHANGED", {text = '由于该专精暂时无法使用，你的角色专精已发生改变。', button1 = '确定'})

WoWTools_ChineseMixin:AddDialogs("VOTE_BOOT_PLAYER", {button1 = '是', button2 = '否'})

WoWTools_ChineseMixin:AddDialogs("VOTE_BOOT_REASON_REQUIRED", {text = '请写明将%s投票移出的理由：', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("LAG_SUCCESS", {text = '你的延迟报告已经成功提交。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("LFG_OFFER_CONTINUE", {text = '一名玩家离开了你的队伍。是否寻找另一名玩家以完成%s？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_MAIL_ITEM_UNREFUNDABLE", {text = '进行此项操作会使该物品无法退还', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("AUCTION_HOUSE_DISABLED", {text = '拍卖行目前暂时关闭。|n请稍后再试。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_BLOCK_INVITES", {text = '你确定要屏蔽任何来自%s的邀请？', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("BATTLENET_UNAVAILABLE", {text = '暴雪游戏服务暂时不可用。\n\n你的实名和战网昵称好友无法显示，你也无法发送或收到实名或战网昵称好友邀请。也许需要重启游戏以重新启用暴雪游戏服务功能。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("WEB_PROXY_FAILED", {text = '在配置浏览器时发生错误。请重启魔兽世界并再试一次。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("WEB_ERROR", {text = '错误：%d|n浏览器无法完成你的请求。请重试。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_REMOVE_FRIEND", {button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_REMOVE_FRIEND", 'OnShow', function(self)
    local text= self.text:GetText() or ''
    local name= text:match(WoWTools_ChineseMixin:Magic(BATTLETAG_REMOVE_FRIEND_CONFIRMATION))
    local name2= text:match(WoWTools_ChineseMixin:Magic(REMOVE_FRIEND_CONFIRMATION))
    if name then
        self.text:SetFormattedText('你确定要将  |cnRED_FONT_COLOR:%s|r 移出|cff82c5ff战网昵称|r好友名单吗？', name)
    elseif name2 then
        self.text:SetFormattedText('你确定要将 |cnRED_FONT_COLOR:%s|r 移出|cnGREEN_FONT_COLOR:实名|r好友名单？', name2)
    end
end)
WoWTools_ChineseMixin:AddDialogs("PICKUP_MONEY", {text = '提取总额', button1 = '接受', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_GUILD_CHARTER_PURCHASE", {text = '你会失去在上一个公会中的一级公会声望\n你是否要继续？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("GUILD_DEMOTE_CONFIRM", {button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("GUILD_PROMOTE_CONFIRM", {button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_RANK_AUTHENTICATOR_REMOVE", {button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("VOID_DEPOSIT_CONFIRM", {text = '储存这件物品将移除该物品上的一切改动并使其无法退还，且无法交易。\n你是否要继续？', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("GUILD_IMPEACH", {text = '你所在公会的领袖已被标记为非活动状态。你现在可以争取公会领导权。是否要移除公会领袖？', button1 = '弹劾', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("SPELL_CONFIRMATION_PROMPT", {button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("SPELL_CONFIRMATION_WARNING", {button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_LAUNCH_URL", {text = '点击“确定”后将在你的网络浏览器中打开一个窗口。', button1 = '确定', button2 = '取消'})

WoWTools_ChineseMixin:AddDialogs("CONFIRM_LEAVE_INSTANCE_PARTY", {button1 = '是', button2 = '取消'})
StaticPopupDialogs["CONFIRM_LEAVE_INSTANCE_PARTY"].OnShow= function(self)
    local text= self.text:GetText()
    if text== CONFIRM_LEAVE_BATTLEFIELD then
        self.text:SetText('确定要离开战场吗？')
    elseif text== CONFIRM_LEAVE_INSTANCE_PARTY then
        self.text:SetText('确定要离开副本队伍吗？\n\n一旦离开队伍，你将无法返回该副本。')
    end
end

WoWTools_ChineseMixin:AddDialogs("CONFIRM_LEAVE_BATTLEFIELD", {text = '确定要离开战场吗？', button1 = '是', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_LEAVE_BATTLEFIELD", 'OnShow', function(self)
    local ratedDeserterPenalty = C_PvP.GetPVPActiveRatedMatchDeserterPenalty()
    if ( ratedDeserterPenalty ) then
        local ratingChange = math.abs(ratedDeserterPenalty.personalRatingChange)
        local queuePenaltySpellLink, queuePenaltyDuration = C_Spell.GetSpellLink(ratedDeserterPenalty.queuePenaltySpellID), SecondsToTime(ratedDeserterPenalty.queuePenaltyDuration)
        self.text:SetFormattedText('现在离开比赛会使你失去至少|cnORANGE_FONT_COLOR:%1$d|r点评级分数，而且你会受到%3$s的影响，持续%2$s。|n|n如果你现在离开，你将无法获得你完成的回合的荣誉或征服点数。|n|n你确定要离开比赛吗？', ratingChange, queuePenaltyDuration, queuePenaltySpellLink)
    elseif ( IsActiveBattlefieldArena() and not C_PvP.IsInBrawl() ) then
        self.text:SetText('确定要离开竞技场吗？')
    else
        self.text:SetText('确定要离开战场吗？')
    end
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_SURRENDER_ARENA", {text= '放弃？', button1 = '是', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("CONFIRM_SURRENDER_ARENA", 'OnShow', function(self)
    self.text:SetText('放弃？')
end)


WoWTools_ChineseMixin:AddDialogs("SAVED_VARIABLES_TOO_LARGE", {text = '你的计算机内存不足，无法加载下列插件设置。请关闭部分插件。\n\n|cffffd200%s|r', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("PRODUCT_ASSIGN_TO_TARGET_FAILED", {text = '获取物品错误。请重试一次。', button1 = '确定'})
WoWTools_ChineseMixin:HookDialog("BATTLEFIELD_BORDER_WARNING", 'OnUpdate', function(self)
    self.text:SetFormattedText('你已经脱离了%s的战斗。\n\n为你保留的位置将在%s后失效。', self.data.name, SecondsToTime(self.timeleft, false, true))
end)
WoWTools_ChineseMixin:AddDialogs("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS", {text = '针对此项活动，你的队伍人数已满，将被移出列表。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("LFG_LIST_ENTRY_EXPIRED_TIMEOUT", {text = '你的队伍由于长期处于非活跃状态，已被移出列表。如果你还需要寻找申请者，请重新加入列表。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("NAME_TRANSMOG_OUTFIT", {text = '输入外观方案名称：', button1 = '保存', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_OVERWRITE_TRANSMOG_OUTFIT", {text = '你已经有一个名为%s的外观方案了。是否要覆盖已有方案？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_DELETE_TRANSMOG_OUTFIT", {text = '确定要删除外观方案%s吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("TRANSMOG_OUTFIT_CHECKING_APPEARANCES", {text = '检查外观……', button1 = '取消'})
WoWTools_ChineseMixin:AddDialogs("TRANSMOG_OUTFIT_ALL_INVALID_APPEARANCES", {text = '由于你的角色无法幻化此套装下的任何外观，因此你无法保存此外观方案。', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("TRANSMOG_OUTFIT_SOME_INVALID_APPEARANCES", {text = '此外观方案无法保存，因为你的角色有一件或多件物品无法幻化。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("TRANSMOG_APPLY_WARNING", {button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("TRANSMOG_FAVORITE_WARNING", {text = '将此外观设置为偏好外观将使你背包中的这个物品无法退款且无法交易。\n确定要继续吗？', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CONFIRM_UNLOCK_TRIAL_CHARACTER", {text = '确定要升级这个角色吗？完成此步骤之后，你将无法更改自己的选择。', button1 = '确定', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("DANGEROUS_SCRIPTS_WARNING", {text = '你正试图运行自定义脚本。运行自定义脚本可能危害到你的角色，导致物品或金币损失。|n|n确定要运行吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("EXPERIMENTAL_CVAR_WARNING", {text = '您已开启了一项或多项实验性镜头功能。这可能对部分玩家造成视觉上的不适。', button1 = '接受', button2 = '禁用"'})
WoWTools_ChineseMixin:AddDialogs("PREMADE_GROUP_SEARCH_DELIST_WARNING", {text = '你的预创建队伍界面上已有一组队伍列表。是否要清除列表，开始新的搜索？', button1 = '是', button2 = '否'})

WoWTools_ChineseMixin:AddDialogs("PREMADE_GROUP_LEADER_CHANGE_DELIST_WARNING", {text = '你已经被提升为队伍领袖|TInterface\\GroupFrame\\UI-Group-LeaderIcon:0:0:0:-1|t |n|n|cffffd200你想以此队名重新列出队伍吗？|r|n%s|n', subText = '|n%s后自动从列表移除', button1 = '列出我的队伍', button2 = '我想编辑队名', button3 = '不列出我的队伍'})
WoWTools_ChineseMixin:HookDialog("PREMADE_GROUP_LEADER_CHANGE_DELIST_WARNING", 'OnShow', function(self, data)
    self.text:SetFormattedText('你已经被提升为队伍领袖|TInterface\\GroupFrame\\UI-Group-LeaderIcon:0:0:0:-1|t |n|n|cffffd200你想以此队名重新列出队伍吗？|r|n%s|n', data.listingTitle)
end)

WoWTools_ChineseMixin:AddDialogs("PREMADE_GROUP_INSECURE_SEARCH", {text= '你的队伍已被移出列表，要搜索|n%s吗？', button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:AddDialogs("BACKPACK_INCREASE_SIZE", {text = '为您的《魔兽世界》账号添加安全令和短信安全保护功能，即可获得4格额外的背包空间。|n|n战网安全令完全免费，而且使用方便，可以有效地保护您的账号。短信安全保护功能可以在账号有重要改动时为您通知提醒。|n|n点击“启用”以打开账号安全设置页面。', button1 = '启用', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("GROUP_FINDER_AUTHENTICATOR_POPUP", {text = '为你的账号添加安全令和短信安全保护功能后就能使用队伍查找器的全部功能。|n|n战网安全令完全免费，而且使用方便，可以有效地保护您的账号，短信安全保护功能可以在账号有重要改动时为您通知提醒。|n|n点击“启用”即可打开安全令设置网站。', button1 = '启用', button2 = '取消'})
WoWTools_ChineseMixin:AddDialogs("CLIENT_INVENTORY_FULL_OVERFLOW", {text= '你的背包满了。给背包腾出空间才能获得遗漏的物品。', button1 = '确定'})

WoWTools_ChineseMixin:AddDialogs("LEAVING_TUTORIAL_AREA", {button2 = '结束教程"'})
WoWTools_ChineseMixin:HookDialog("LEAVING_TUTORIAL_AREA", 'OnShow', function(self)
    if UnitFactionGroup("player") == "Horde" then
        self.button1:SetText('返回')
        self.text:SetText('你距离奥格瑞玛太远了。|n |n如果你继续走的话，就会脱离教程。|n |n你想返回奥格瑞玛吗？|n |n |n')
    else
        self.button1:SetText('返回')
        self.text:SetText('你距离暴风城太远了。|n |n如果你继续走的话，就会脱离教程。|n |n你想返回暴风城吗？|n |n |n')
    end
end)

WoWTools_ChineseMixin:AddDialogs("CLUB_FINDER_ENABLED_DISABLED", {text = '公会和社区查找器已可用或不可用。', button1 = '确定'})

WoWTools_ChineseMixin:AddDialogs("INVITE_COMMUNITY_MEMBER", {text = '邀请成员', subText = '输入战网昵称。',button1 = '发送', button2 = '取消'})
WoWTools_ChineseMixin:HookDialog("INVITE_COMMUNITY_MEMBER", 'OnShow', function(self, data)
    local clubInfo = C_Club.GetClubInfo(data.clubId) or {}
    if clubInfo.clubType == Enum.ClubType.BattleNet then
        self.SubText:SetText('输入一位战网好友名称')
        self.editBox.Instructions:SetText('实名好友或战网昵称')
    else
        self.SubText:SetText('输入角色名-服务器名。')
    end
    self.button1:SetScript("OnEnter", function(self2)
        if(not self2:IsEnabled()) then
            GameTooltip:SetOwner(self2, "ANCHOR_BOTTOMRIGHT")
            GameTooltip_AddColoredLine(GameTooltip, '已经达到最大人数。移除一名玩家后才能进行邀请。', RED_FONT_COLOR, true)
            GameTooltip:Show()
        end
    end)
    if (self.extraButton) then
        self.extraButton:SetScript("OnEnter", function(self2)
            if(not self2:IsEnabled()) then
                GameTooltip:SetOwner(self2, "ANCHOR_BOTTOMRIGHT")
                GameTooltip_AddColoredLine(GameTooltip, '已经达到最大人数。移除一名玩家后才能进行邀请。', RED_FONT_COLOR, true)
                GameTooltip:Show()
            end
        end)
    end
end)

WoWTools_ChineseMixin:AddDialogs("CONFIRM_RAF_REMOVE_RECRUIT", {text = '你确定要从你的招募战友中移除|n|cffffd200%s|r|n吗？|n|n请在输入框中输入“'..REMOVE_RECRUIT_CONFIRM_STRING..'”以确定。', button1 = '是', button2 = '否'})

WoWTools_ChineseMixin:AddDialogs("REGIONAL_CHAT_DISABLED", {
    text = '聊天已关闭',
    subText = '某些区域规定对此账号有影响。聊天功能已经默认关闭。你现在可以重新开启这些功能。或者你之后决定开启的话，可以在聊天设置面板里进行操作。\n\n如果你决定开启这些功能，请注意我们的社区互动规则，如果你遇到了任何的不当言论、行为，只要这些言论和行为对游戏体验造成了破坏或者干扰，您就可以使用我们在游戏内的举报选项进行举报。我们会评估聊天记录并采取对应的措施。',
    button1 = '打开聊天',
    button2 = '聊天保持关闭'
})
WoWTools_ChineseMixin:AddDialogs("CHAT_CONFIG_DISABLE_CHAT", {text = '你确定要完全关闭聊天吗？你将无法发送和接收任何信息。', button1 = '关闭聊天', button2 = '取消'})

WoWTools_ChineseMixin:AddDialogs("RETURNING_PLAYER_PROMPT", {button1 = '是', button2 = '否'})
WoWTools_ChineseMixin:HookDialog("RETURNING_PLAYER_PROMPT", 'OnShow', function(self)
    local factionMajorCities = {
        ["Alliance"] = '暴风城',
        ["Horde"] = '奥格瑞玛',
    }
    local playerFactionGroup = UnitFactionGroup("player")
    local factionCity = playerFactionGroup and factionMajorCities[playerFactionGroup] or nil
    if factionCity then
        self.text:SetFormattedText('我们有好一阵子没见到你了！|n|n在%s可以开始全新的冒险之旅！|n|n你希望传送到那里吗？', factionCity)
    end
end)

WoWTools_ChineseMixin:AddDialogs("CRAFTING_HOUSE_DISABLED", {text = '工匠商盟目前不接受制造订单。|n请稍后再来看看！', button1 = '确定'})
WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_DISABLED", {text = '商栈目前关闭。|n请稍后再试。', button1 = '确定'})


--HelpFrame.lua
WoWTools_ChineseMixin:AddDialogs("EXTERNAL_LINK", {text = '你正被重新定向到：\n|cffffd200%s|r\n点击“确定”，以在你的网页浏览器中打开此链接。', button1 = '确定', button2= '取消', button3 = '复制链接'})

--LFGFrame.lua
WoWTools_ChineseMixin:AddDialogs("LFG_QUEUE_EXPAND_DESCRIPTION", {text = '你正被重新定向到：\n|cffffd200%s|r\n点击“确定”，以在你的网页浏览器中打开此链接。', button1 = '是', button2= '否'})

--Blizzard_PetBattleUI.lua
WoWTools_ChineseMixin:AddDialogs("PET_BATTLE_FORFEIT", {text = '确定要放弃比赛吗？你的对手将被判定获胜，你的宠物也将损失百分之%d的生命值。', button1 = '确定', button2 = '取消',})
WoWTools_ChineseMixin:AddDialogs("PET_BATTLE_FORFEIT_NO_PENALTY", {text = '确定要放弃比赛吗？你的对手将被判定获胜。', button1 = '确定', button2 = '取消',})

--TextToSpeechFrame.lua
WoWTools_ChineseMixin:AddDialogs("TTS_CONFIRM_SAVE_SETTINGS", {text= '你想让这个角色使用已经在这台电脑上保存的文字转语音设置吗？如果你从另一台电脑上登入，此设置会保存并覆盖之前你拥有的任何设定。', button1= '是', button2= '取消'})

--Keybindings.lua
WoWTools_ChineseMixin:AddDialogs("CONFIRM_DELETING_CHARACTER_SPECIFIC_BINDINGS", {text = '确定要切换到通用键位设定吗？所有本角色专用的键位设定都将被永久删除。', button1 = '确定', button2 = '取消'})
