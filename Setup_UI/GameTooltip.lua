



local function CN_Line(line)
    local cn= line and WoWTools_ChineseMixin:SetText(line:GetText())
    if not cn then
        return
    end

    local r,g,b,a=line:GetTextColor()
    line:SetText(cn)
    if r and g and b then
        line:SetTextColor(r,g,b, a or 1)
    end
    return true
end


local function Set_Lines(tooltip)
    local name= tooltip:GetName() or 'GameTooltip'
    local find
    local num= tooltip:NumLines() or 0
    for index=1, num do
        if CN_Line(_G[name..'TextLeft'..index]) then
            find= true
        end
        if CN_Line(_G[name..'TextRight'..index]) then
            find=true
        end
    end
    if find then
        GameTooltip_CalculatePadding(tooltip)
    end
end

--WoWTools_ChineseMixin:SetLabel(tooltip['TextLeft'..index])
--WoWTools_ChineseMixin:SetLabel(tooltip['TextRight'..index])












local function add_line(tooltip, ...)
    if tooltip.AddLine then
        tooltip:AddLine(...)
    else
        BattlePetTooltipTemplate_AddTextLine(tooltip, ...)
    end
end

local function Set_Battle_Pet(tooltip, speciesID)
    local data= speciesID and WoWTools_ChineseMixin:GetPetDesc(speciesID)
    if not data then
        return
    end

    local companionID= select(4, C_PetJournal.GetPetInfoBySpeciesID(speciesID))
    local name= WoWTools_ChineseMixin:GetUnitName(nil, companionID)
    local desc=data[1]
    local source= data[2]
    local line= _G[(tooltip:GetName() or 'Gametooltip').."TextLeft1"]
    if line then
        if tooltip.textLeft then
            tooltip.textLeft:SetText(line:GetText() or '')
        end
        line:SetText(name)
    else
        add_line(tooltip, name)
    end
    if desc or source then
        add_line(tooltip, ' ')
    end
    if desc then
        add_line(tooltip, NORMAL_FONT_COLOR:WrapTextInColorCode(desc), nil, nil, nil, true)--来源提示
    end
    if source then
        add_line(tooltip, NORMAL_FONT_COLOR:WrapTextInColorCode(source), nil, nil, nil, true)--来源提示--来源
    end
end











local function Set_Quest(tooltip, questID, isShow)
    local data= WoWTools_ChineseMixin:GetQuestData(questID)
    if not data then
        return
    end
    if data.T then
        local name= tooltip:GetName() or 'Gametooltip'
        local line= (name=='ShoppingTooltip1' or name=='ShoppingTooltip2') and _G[name.."TextLeft2"] or _G[name.."TextLeft1"]
        if line then
            if tooltip.textLeft then
                tooltip.textLeft:SetText(line:GetText() or '')
            end
            line:SetText(data.T)
        else
            tooltip:AddLine('|cffff761b'..data.T)
        end
    end

    if data.O or data.S then
        tooltip:AddLine(' ')
    end
    if data.O then
        tooltip:AddLine('|cffffffff'..data.O, nil, nil, nil, true)
    end
    if data.S then
        local questLogIndex= C_QuestLog.GetLogIndexForQuestID(questID)

        for i, name in pairs(data.S) do
            local text, _, finished = GetQuestLogLeaderBoard(i, questLogIndex)
            local num, per
            if text then
                num= text:match('(%d+/%d+ )')
                per= text:match('( %(%d+%%)%)')
            end
            if num then
                name= num..name
            elseif per then
                name= name..per
            end
            local col= questLogIndex and finished and '|cff626262' or '|cff00d8ff'

            tooltip:AddLine(' - '..col..name)
        end
    end
    if isShow then
        tooltip:Show()
    end
end











local function Set_Spell(tooltip, spellID)
    if spellID then
        local name, desc= WoWTools_ChineseMixin:GetSpellName(spellID)
        if name then
            local line= _G[(tooltip:GetName() or 'Gametooltip').."TextLeft1"]
            if line then
                if tooltip.textLeft then
                    tooltip.textLeft:SetText(line:GetText() or '')
                end
                line:SetText(name)
            else
                tooltip:AddLine(name)
            end
        end
        if desc then
            tooltip:AddLine(' ')
            tooltip:AddLine(NORMAL_FONT_COLOR:WrapTextInColorCode(desc), nil,nil,nil, true)
        end
    end
end










local function Set_Item(tooltip, info)
    local title, desc= WoWTools_ChineseMixin:GetItemName(info.id)
    if title then
        local name= tooltip:GetName() or 'Gametooltip'
        local line= (name=='ShoppingTooltip1' or name=='ShoppingTooltip2') and _G[name.."TextLeft2"] or _G[name.."TextLeft1"]
        if line then
            line:SetText(title)
        else
            tooltip:AddLine(title)
        end
    end

    if desc then
        tooltip:AddLine(' ')
        tooltip:AddLine(NORMAL_FONT_COLOR:WrapTextInColorCode(desc), nil,nil,nil, true)
    end
end











local function Set_Unit(tooltip, unit)
    unit= unit or select(2, TooltipUtil.GetDisplayedUnit(tooltip))
    local name, desc= WoWTools_ChineseMixin:GetUnitName(unit, nil)
    if name then
        local line= _G[(tooltip:GetName() or 'Gametooltip').."TextLeft1"]
        if line then
            if tooltip.textLeft then
                tooltip.textLeft:SetText(line:GetText() or '')
            end
            line:SetText(name)
        else
            tooltip:AddLine(name)
        end
    end
    if desc then
        tooltip:AddLine(' ')
        tooltip:AddLine(desc)
    end
end











local function Set_Mount(tooltip, mountID)
    if WoWTools_TooltipMixin or not mountID then
        return
    end
    local source= mountID and select(3, C_MountJournal.GetMountInfoExtraByID(mountID))
    source= WoWTools_ChineseMixin:CN(source)
    if source then
        tooltip:AddLine(' ')
        tooltip:AddLine(NORMAL_FONT_COLOR:WrapTextInColorCode(source), nil,nil,nil,true)
    end
end











TooltipDataProcessor.AddTooltipPostCall(TooltipDataProcessor.AllTypes, function(tooltip, data)
    Set_Lines(tooltip)

    if data.type==Enum.TooltipDataType.Item then--0
        if not GetItemData then--排除，插件 WoWeuCN_Tooltips
            Set_Item(tooltip, data)
            if data.id and C_Heirloom.IsItemHeirloom(data.id) then
                local source= WoWTools_ChineseMixin:GetHeirloomSource(data.id)
                if source and not C_Heirloom.PlayerHasHeirloom(data.id) then
                    tooltip:AddLine(source, nil,nil,nil, true)
                end
            end
        end
        if not WoWTools_TooltipMixin then
            local speciesID = select(13, C_PetJournal.GetPetInfoByItemID(data.id))
            Set_Battle_Pet(tooltip, speciesID)
        end

    elseif data.type==Enum.TooltipDataType.Spell then--1
        if not GetSpellData then
            Set_Spell(tooltip, data.id)
        end


    elseif data.type==Enum.TooltipDataType.Unit then--2
        Set_Unit(tooltip)

    --elseif data.type==Enum.TooltipDataType.Corpse then--3
    --elseif data.type==Enum.TooltipDataType.Object then--4
    --elseif data.type==Enum.TooltipDataType.Currency then--5
    --elseif data.type==Enum.TooltipDataType.BattlePet then--6


    elseif data.type==Enum.TooltipDataType.UnitAura then--7
        Set_Spell(tooltip, data.id)
  --elseif data.type==Enum.TooltipDataType.AzeriteEssence then--8
    --elseif data.type==Enum.TooltipDataType.CompanionPet then--9
    elseif data.type==Enum.TooltipDataType.Mount then--10
        Set_Mount(tooltip, data.id)

    elseif data.type==Enum.TooltipDataType.PetAction then--11
        local action= tooltip:GetOwner()
        local spellID = select(7, GetPetActionInfo(action and action:GetID() or 0))
        Set_Spell(tooltip, spellID)
    --elseif data.type==Enum.TooltipDataType.Achievement then--12
    --elseif data.type==Enum.TooltipDataType.EnhancedConduit then--13
    --elseif data.type==Enum.TooltipDataType.EquipmentSet then--14
    --elseif data.type==Enum.TooltipDataType.InstanceLock then--15
    --elseif data.type==Enum.TooltipDataType.PvPBrawl then--16
    --elseif data.type==Enum.TooltipDataType.RecipeRankInfo then--17
    --elseif data.type==Enum.TooltipDataType.Totem then--18
    elseif data.type== Enum.TooltipDataType.Toy then--19
        Set_Item(tooltip, data)
        if not PlayerHasToy(data.id) then
            local source= WoWTools_ChineseMixin:GetToySource(data.id)
            if source then
                tooltip:AddLine(source, nil,nil,nil, true)
            end
        end
    --elseif data.type==Enum.TooltipDataType.CorruptionCleanser then--20
    --elseif data.type==Enum.TooltipDataType.MinimapMouseover then--21
    --elseif data.type==Enum.TooltipDataType.Flyout then--22
    elseif data.type==Enum.TooltipDataType.Quest then--23
        Set_Quest(tooltip, data.id)
    --elseif data.type==Enum.TooltipDataType.QuestPartyProgress then--24

    elseif data.type== Enum.TooltipDataType.Macro then--25
        local frame= tooltip:GetOwner()--宏 11版本
        if frame and frame.action then
            local type, macroID, subType= GetActionInfo(frame.action)
            if type=='macro' and macroID and subType=='spell' then
                Set_Spell(tooltip, macroID)
            end
        end

    --elseif data.type==Enum.TooltipDataType.Debug then--27
    end
end)

hooksecurefunc("QuestMapLogTitleButton_OnEnter", function(self)
    Set_Quest(GameTooltip, self.questID, true)
end)
hooksecurefunc('GameTooltip_AddQuest', function(self, questIDArg)
    local questID = self.questID or questIDArg
    Set_Quest(GameTooltip, questID, true)
end)



















--GameTooltip.lua

TOOLTIP_QUEST_REWARDS_STYLE_DEFAULT.headerText = '奖励'
TOOLTIP_QUEST_REWARDS_STYLE_WORLD_QUEST.headerText = '奖励'
TOOLTIP_QUEST_REWARDS_STYLE_CONTRIBUTION.headerText = '为该建筑捐献物资会奖励你：'
TOOLTIP_QUEST_REWARDS_STYLE_PVP_BOUNTY.headerText = '悬赏奖励'
TOOLTIP_QUEST_REWARDS_STYLE_ISLANDS_QUEUE.headerText = '获胜奖励：'
TOOLTIP_QUEST_REWARDS_STYLE_EMISSARY_REWARD.headerText = '奖励'
TOOLTIP_QUEST_REWARDS_PRIORITIZE_CURRENCY_OVER_ITEM.headerText = '奖励'

--替换，原生
function GameTooltip_OnTooltipAddMoney(self, cost, maxcost)
    if( not maxcost or maxcost < 1 ) then --We just have 1 price to display
        SetTooltipMoney(self, cost, nil, string.format("%s:", '卖价'))
    else
        GameTooltip_AddColoredLine(self, format("%s:", '卖价'), HIGHLIGHT_FONT_COLOR)
        local indent = string.rep(" ", 4)
        SetTooltipMoney(self, cost, nil, string.format("%s%s:", indent, '最小'))
        SetTooltipMoney(self, maxcost, nil, string.format("%s%s:", indent, '最大'))
    end
end








--Blizzard_FrameXML/SharedPetBattleTemplates.lua
--战斗宠物，技能 SharedPetBattleTemplates.lua
hooksecurefunc('SharedPetBattleAbilityTooltip_SetAbility', function(self, abilityInfo, additionalText)
    local abilityID = abilityInfo:GetAbilityID()
    if not abilityID then
        return
    end


	local _, _, _, maxCooldown, _, numTurns = C_PetBattles.GetAbilityInfoByID(abilityID);


    local cnDesc, cnName= WoWTools_ChineseMixin:GetPetAblityDesc(abilityID, abilityInfo)

    if cnName then
        self.Name:SetText(cnName)
    end

	if ( numTurns and numTurns > 1 ) then
		self.Duration:SetFormattedText('%d轮技能', numTurns)
	end


    if ( maxCooldown > 0 ) then
		self.MaxCooldown:SetFormattedText('%d轮冷却', maxCooldown)
	end

    local currentCooldown = abilityInfo:GetCooldown();
	if ( currentCooldown > 0 ) then
		self.CurrentCooldown:SetFormattedText('剩余冷却时间：%d轮', currentCooldown)
	end

    additionalText= additionalText and WoWTools_ChineseMixin:SetText(additionalText)
    if additionalText then
        self.AdditionalText:SetText(additionalText);
    end

    if cnDesc then
        self.Description:SetText(cnDesc)
    end

    WoWTools_ChineseMixin:SetLabel(self.StrongAgainstType1Label)
    WoWTools_ChineseMixin:SetLabel(self.WeakAgainstType1Label)
end)









if not WoWTools_TooltipMixin then
    hooksecurefunc("BattlePetToolTip_Show", function(speciesID)--BattlePetTooltip.lua 
        Set_Battle_Pet(BattlePetTooltip, speciesID)
    end)

    hooksecurefunc('FloatingBattlePet_Show', function(speciesID)--FloatingPetBattleTooltip.lua
        Set_Battle_Pet(FloatingBattlePetTooltip, speciesID)
    end)
    hooksecurefunc(GameTooltip, "SetCompanionPet", function(tooltip, petGUID)--设置宠物信息
        local speciesID= petGUID and C_PetJournal.GetPetInfoByPetID(petGUID)
        Set_Battle_Pet(tooltip, speciesID)--宠物
    end)
end











--FloatingPetBattleTooltip.xml
local function set_pet_func(frame)
    WoWTools_ChineseMixin:SetLabel(frame.BattlePet)
    WoWTools_ChineseMixin:SetLabel(frame.PetType)
    local level = frame.Level:GetText():match('(%d+)')
    if level then
        frame.Level:SetFormattedText('等级 %s', level)
    end
end
BattlePetTooltip:HookScript('OnShow', set_pet_func)
FloatingBattlePetTooltip:HookScript('OnShow', set_pet_func)








local function Set_OnShow(tooltip)
    tooltip:HookScript('OnShow', Set_Lines)
end

Set_OnShow(SettingsTooltip)
Set_OnShow(GameTooltip)
Set_OnShow(ItemRefTooltip)
Set_OnShow(EmbeddedItemTooltip)

EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_PerksProgram' or arg1=='Blizzard_ItemSocketingUI' then

        if arg1=='Blizzard_PerksProgram' then
            Set_OnShow(PerksProgramTooltip)

        elseif arg1=='Blizzard_ItemSocketingUI' then
            Set_OnShow(ItemSocketingDescription)
        end

        if C_AddOns.IsAddOnLoaded('Blizzard_PerksProgram') and  C_AddOns.IsAddOnLoaded('Blizzard_ItemSocketingUI') then
            EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
        end
    end
end)






--[[
TooltipDataRules.lua
Blizzard_SharedXMLGame/Tooltip/TooltipDataHandler.lua
TooltipDataRules.lua 
]]
hooksecurefunc('BattlePetTooltipTemplate_SetBattlePet', function(tooltipFrame, data)
    local t= WoWTools_ChineseMixin:CN(_G["BATTLE_PET_NAME_"..data.petType])
    if t then
	    tooltipFrame.PetType:SetText(t)
    end
    tooltipFrame.Level:SetFormattedText('等级%d', data.level)
end)