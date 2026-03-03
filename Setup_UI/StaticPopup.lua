




--StaticPopup_StandardConfirmationTextHandler(editBox, DELETE_ITEM_CONFIRM_STRING);
function WoWTools_ChineseMixin.Events:Blizzard_StaticPopup()
    if not canaccesstable(StaticPopupDialogs) then
        return
    end


    for i=1, 4 do--STATICPOPUP_NUMDIALOGS
        local dia= _G['StaticPopup'..i]
        if dia then
            self:HookLabel(dia.Text)--_G['StaticPopup'..i..'Text'] dia:GetTextFontString()
            self:HookLabel(dia.SubText)
            self:HookButton(dia:GetButton1())--_G['StaticPopup'..i..'Button1']
            self:HookButton(dia:GetButton2())
            self:HookButton(dia:GetButton3())

            hooksecurefunc(dia.ItemFrame.Text, 'SetText', function(frame, name)
                local itemName= self:CN(name)
                if not itemName then
                    local link= frame:GetParent().link
                    local itemID= link and C_Item.GetItemInfoInstant(link)
                    itemName= itemID and self:GetItemName(itemID)
                end
                if itemName then
                    itemName= itemName:match('|c........(.-)|r') or itemName
                    if name ~= itemName  then
                        frame:SetText(itemName)
                    end
                end
            end)
        end
    end





















self:HookDialog('EVOKER_NEW_PLAYER_CONFIRMATION', 'OnUpdate', function(dialog, elapsed)
    dialog.duration = dialog.duration - elapsed;
    local time = math.max(dialog.duration + 1, 1);
    dialog:SetFormattedText('接受新选项？\n\n%d秒后恢复',time)
    dialog:Resize("GAME_SETTINGS_TIMED_CONFIRMATION");
end)






--Blizzard_Dialogs.lua
self:HookDialog('GAME_SETTINGS_TIMED_CONFIRMATION', 'OnUpdate', function(dialog, elapsed)
    dialog.duration = dialog.duration - elapsed;
    local time = math.max(dialog.duration + 1, 1);
    dialog:SetFormattedText('接受新选项？\n\n%d秒后恢复',time)
    dialog:Resize("GAME_SETTINGS_TIMED_CONFIRMATION");
end)


--StaticPopup.lua
self:HookDialog("GENERIC_CONFIRMATION", 'OnShow', function(dialog, data)
	local cn= self:SetText(data.text)
    if cn then
        dialog:SetFormattedText(cn, data.text_arg1, data.text_arg2)
    end
end)



self:HookDialog("GENERIC_INPUT_BOX", 'OnShow', function(dialog, data)
    local cn= self:SetText(data.text)
    if cn then
        dialog:SetFormattedText(cn, data.text_arg1, data.text_arg2)
    end
end)










self:HookDialog("CONFIRM_LEAVE_BATTLEFIELD", 'OnShow', function(dialog, data)
    local ratedDeserterPenalty = C_PvP.GetPVPActiveRatedMatchDeserterPenalty();
    if canaccesstable(ratedDeserterPenalty) and ratedDeserterPenalty then
        dialog:SetFormattedText('现在离开比赛会使你失去至少|cnORANGE_FONT_COLOR:%1$d|r点评级分数，而且你会受到%3$s的影响，持续%2$s。|n|n如果你现在离开，你将无法获得你完成的回合的荣誉或征服点数。|n|n你确定要离开比赛吗？',
            math.abs(ratedDeserterPenalty.personalRatingChange),
            SecondsToTime(ratedDeserterPenalty.queuePenaltyDuration),
            C_Spell.GetSpellLink(ratedDeserterPenalty.queuePenaltySpellID)
        )
    end
end)











local function GetBindWarning(itemLocation)
	local item = Item:CreateFromItemLocation(itemLocation);
	if not item then
		return;
	end

	local _itemID, _itemType, _itemSubType, _itemEquipLoc, _icon, itemClassID, itemSubclassID = C_Item.GetItemInfoInstant(item:GetItemID());
	local isArmor = (itemClassID == Enum.ItemClass.Armor) and (itemSubclassID ~= Enum.ItemArmorSubclass.Shield);
	if isArmor and not IsItemPreferredArmorType(item:GetItemLocation()) then
		return '|cnRED_FONT_COLOR:这不是你偏好的护甲类型。|r';
	end
end
self:HookDialog('EQUIP_BIND', function(dialog, data)
    local warning = GetBindWarning(data.itemLocation);
    if warning then
        dialog:SetText('装备之后，该物品将与你绑定。' .. "|n|n" .. warning);
    end
end)

self:HookDialog('EQUIP_BIND_REFUNDABLE', 'OnShow', function(dialog, data)
    local warning = GetBindWarning(data.itemLocation);
    if warning then
        dialog:SetText('进行此项操作会使该物品无法退还' .. "|n|n" .. warning);
    end
end)

self:HookDialog('EQUIP_BIND_TRADEABLE', 'OnShow', function(dialog, data)
    local warning = GetBindWarning(data.itemLocation);
    if warning then
        dialog:SetText('执行此项操作会使该物品不可交易。' .. "|n|n" .. warning);
    end
end)



self:HookDialog("XP_LOSS", 'OnShow', function(dialog, data)
    if data then
		dialog:SetFormattedText('记住，如果你找到你的尸体，那么你可以在没有任何惩罚的情况下复活。你决定现在以承受所有物品（包括已装备的和物品栏中的）损失50%%的耐久度并承受%s的复活虚弱时间的代价来复活吗？', data)
    end
end)
self:HookDialog("CONFIRM_GLYPH_PLACEMENT", 'OnShow', function(dialog, data)
	dialog:SetFormattedText('你确定要使用%s铭文吗？这将取代%s。', data.name, data.currentName)
end)
self:HookDialog("CONFIRM_GLYPH_REMOVAL", 'OnShow', function(dialog, data)
    dialog:SetFormattedText('你确定要移除%s吗？', data.name)
end)
self:HookDialog("CONFIRM_LEAVE_COMMUNITY", 'OnShow', function(dialog, clubInfo)
	if clubInfo.clubType == Enum.ClubType.Character then
		dialog.SubText:SetFormattedText('你确定要退出%s吗？', clubInfo.name);
	else
		dialog.SubText:SetFormattedText('你确定要退出%s吗？', clubInfo.name);
	end
end)
self:HookDialog("REMOVE_GUILDMEMBER", 'OnShow', function(dialog, data)
    if data then
        dialog:SetFormattedText('你确定想要从公会中移除%s吗？', data.name);
    end
end)
self:HookDialog("CONFIRM_UPGRADE_ITEM", 'OnShow', function(dialog, data)
    if data.isItemBound then
        dialog:SetFormattedText('你确定要花费%s升级下列物品吗', data.costString)
    else
        dialog:SetFormattedText('你确定要花费%s升级下列物品吗？升级会将该物品变成灵魂绑定物品。', data.costString)
    end
end)

self:HookDialog("DELETE_GOOD_ITEM", 'OnShow', function(dialog)
    local itemLocation = C_Cursor.GetCursorItem();
    if itemLocation and C_Item.DoesItemExist(itemLocation) and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation) then
        local msg = C_SpellBook.ContainsAnyDisenchantSpell() and '你想摧毁%s吗？\n\n你可以分解或拆解此物品，来获得|Hcurrency:1718|h %s|h泰坦残血精华。\n\n请在输入框中输入\"'..DELETE_ITEM_CONFIRM_STRING..'\"以确认。'
                or '你真的要摧毁%s吗？\n\n你可以拆解此物品，来获得|Hcurrency:1718|h %s|h泰坦残血精华。\n\n请在输入框中输入\"'..DELETE_ITEM_CONFIRM_STRING..'\"以确认。';
        local itemName = dialog:GetTextFontString().text_arg1;
        local azeriteIconMarkup = CreateTextureMarkup("Interface\\Icons\\INV_AzeriteDebuff",64,64,16,16,0,1,0,1,0,-2)
        dialog:SetFormattedText(msg, itemName, azeriteIconMarkup)
    else
        dialog:SetText('你真的要摧毁%s吗？\n\n请在输入框中输入\"'..DELETE_ITEM_CONFIRM_STRING..'\"以确认。')
    end
end)
self:AddDialogs("DELETE_GOOD_ITEM", {text= '你真的要摧毁%s吗？\n\n请在输入框中输入\"'..DELETE_ITEM_CONFIRM_STRING..'\"以确认。'})
self:AddDialogs("DELETE_GOOD_QUEST_ITEM", {text= '确定要摧毁%s吗？\n|cffff2020摧毁该物品也将同时放弃相关任务。|r\n\n请在输入框中输入\"'..DELETE_ITEM_CONFIRM_STRING..'\"以确认。'})

self:HookDialog("CONFIRM_REMOVE_COMMUNITY_MEMBER", 'OnShow', function(dialog, clubInfo)
	if clubInfo.clubType == Enum.ClubType.Character then
		dialog:SetFormattedText('你确定要将%s从社区中移除吗？', clubInfo.name)
	else
		dialog:SetFormattedText('你确定要将%s从群组中移除吗？', clubInfo.name)
	end
end)
self:HookDialog("CONFIRM_DESTROY_COMMUNITY_STREAM",  function(dialog, data)
    local streamInfo = C_Club.GetStreamInfo(data.clubId, data.streamId);
    if streamInfo then
        dialog:SetFormattedText('你确定要删除频道%s吗？', streamInfo.name)
    end
end)

self:HookDialog("CONFIRM_DESTROY_COMMUNITY", 'OnShow', function(dialog, clubInfo)
    if clubInfo.clubType == Enum.ClubType.BattleNet then
        dialog:SetText('你确定要删除群组\"%s\"吗？此操作无法撤销。|n|n请在输入框中输入\"'..COMMUNITIES_DELETE_CONFIRM_STRING..'\"以确认。', clubInfo.name)
    else
        dialog:SetText('你确定要删除社区\"%s\"吗？此操作无法撤销。|n|n请在输入框中输入\"'..COMMUNITIES_DELETE_CONFIRM_STRING..'\"以确认。', clubInfo.name)
    end
end)
self:HookDialog("PREMADE_GROUP_LEADER_CHANGE_DELIST_WARNING", 'OnShow',  function(dialog, data)
    dialog:SetText('你已经被提升为队伍领袖|TInterface\\GroupFrame\\UI-Group-LeaderIcon:0:0:0:-1|t |n|n|cffffd200你想以此队名重新列出队伍吗？|r|n%s|n', data.listingTitle)
end)
self:HookDialog("BATTLEFIELD_BORDER_WARNING", 'OnUpdate',  function(dialog, elapsed, data)
    dialog:SetFormattedText('你已经脱离了%s的战斗。\n\n为你保留的位置将在%s后失效。', data.name, SecondsToTime(dialog.timeleft, false, true))
    dialog:Resize("BATTLEFIELD_BORDER_WARNING");
end)




self:AddDialogs("UNLEARN_SKILL", {text= '你确定要忘却%s并遗忘所有已经学会的配方？如果你选择回到此专业，你的专精知识将依然存在。|n|n在框内输入 \"'..UNLEARN_SKILL_CONFIRMATION..'\" 以确认。'})
self:AddDialogs("CONFIRM_RAF_REMOVE_RECRUIT", {text= '你确定要从你的招募战友中移除|n|cffffd200%s|r|n吗？|n|n请在输入框中输入“'..REMOVE_RECRUIT_CONFIRM_STRING..'”以确定。'})









--[[C_Timer.After(4, function()
    for dia, data in pairs(StaticPopupDialogs) do
        for name, en in pairs(data) do
            if type(en)=='string' and not self:IsCN(en) then
                local cn= self:CN(en)
                if cn then
                    StaticPopupDialogs[dia][name]= cn
                end
            end
        end
    end
end)]]

end














