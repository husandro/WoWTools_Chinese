local e= select(2, ...)

--[[
local function set_model_tooltip(self)
    if self then
        local tooltip= self.tooltip and e.strText[self.tooltip]
        if tooltip then
            self.tooltip = tooltip
        end
        local tooltipText= self.tooltipText and e.strText[self.tooltipText]
        if tooltipText then
            self.tooltipText = tooltipText
        end
        local simpleTooltipLine= self.simpleTooltipLine and e.strText[self.simpleTooltipLine]
        if simpleTooltipLine then
            self.simpleTooltipLine= simpleTooltipLine
        end
    end
end
local function model(self)
    local frame= self and self.ControlFrame
    if frame then
        set_model_tooltip(frame.zoomInButton)
        set_model_tooltip(frame.zoomOutButton)
        set_model_tooltip(frame.rotateLeftButton)
        set_model_tooltip(frame.rotateRightButton)
        set_model_tooltip(frame.resetButton)

        set_model_tooltip(frame.ResetCameraButton)
        set_model_tooltip(frame.ZoomOutButton)
        set_model_tooltip(frame.ZoomInButton)
        set_model_tooltip(frame.RotateLeftButton)
        set_model_tooltip(frame.RotateRightButton)
    end
end

model(CharacterModelScene)
if WardrobeTransmogFrame then
    model(WardrobeTransmogFrame.ModelScene)
end
model(PetStableModelScene)]]



local function get_gameTooltip_text(self)
    e.set(self) 
    self:SetTextColor(self:GetTextColor())
end

local function set_gameTooltip_text(frame)
    if frame and frame.GetName then
        local name= frame:GetName()-- or 'GameTooltip'
        if name then
            for i=1, frame:NumLines() or 0 do
                get_gameTooltip_text(_G[name.."TextLeft"..i])
                get_gameTooltip_text(_G[name.."TextRight"..i])
            end
        end
    end
end


local function set_GameTooltip_func(self)
    self:HookScript('OnShow', set_gameTooltip_text)
    self:HookScript('OnUpdate', function(frame, elapsed)
        frame.elapsed= (frame.elapsed or TOOLTIP_UPDATE_TIME) +elapsed
        if frame.elapsed>TOOLTIP_UPDATE_TIME and frame:IsVisible() then
            set_gameTooltip_text(frame)
        end
    end)
end

local function set_pettips_func(self)--FloatingPetBattleTooltip.xml
    if not self then
        return
    end
    local function set_pet_func(frame)
        e.set(frame.BattlePet)
        e.set(frame.PetType)
        local level = frame.Level:GetText():match('(%d+)')
        if level then
            frame.Level:SetFormattedText('等级 %s', level)
        end
    end
    self:HookScript('OnShow', set_pet_func)
end

--[[
SharedTooltipTemplate
local tabs={ GameTooltipTemplate
    'ItemRefTooltip',
    'RunforgeFrameTooltipTemplate',
    'NamePlateTooltip',
    'PerksProgramTooltip',
    'ItemSocketingDescription',
    'UIWidgetBaseItemEmbeddedTooltipTemplate',
    'EncounterJournalTooltipItem1Tooltip',
    'GarrisonMissionMechanicTooltip',
}
BattlePetTooltipTemplat    
]]



set_GameTooltip_func(GameTooltip)
set_GameTooltip_func(ItemRefTooltip)
set_GameTooltip_func(EmbeddedItemTooltip)

set_pettips_func(BattlePetTooltip)
set_pettips_func(FloatingBattlePetTooltip)





























--[[local function add_data(tooltip, data, info, isSpell)
    if not tooltip:IsVisible() or not info then
        return
    end

    if #data.lines== #info  then
        local tipName= tooltip:GetName() or ''
        for index, text in pairs(info) do
            local line= tooltip['TextLeft'..index] or _G[tipName.."TextLeft"..index]
            if line then
                line:SetText(isSpell and e.ReplaceText(text) or text)
                --line:SetTextColor(line:GetTextColor())
            end
        end
    else
        local add
        for index, text in pairs(info) do
            if text~=' ' then
                if index==1 then
                    tooltip.TextLeft1:SetText(isSpell and e.ReplaceText(text) or text)
                else
                    if not add then
                        tooltip:AddLine(' ')
                        add=true
                    end
                    tooltip:AddLine(isSpell and e.ReplaceText(text) or text, nil,nil,nil, true)
                end
            end
        end
        if add then
            --tooltip:Show()
        end
    end
end]]







local function set_item(tooltip, data)
    local info= e.Get_Item_Data(data.id)
    if not info then
        return
    end

    if #data.lines== #info  then
        local tipName= tooltip:GetName() or ''
        for index, text in pairs(info) do
            local line= tooltip['TextLeft'..index] or _G[tipName.."TextLeft"..index]
            if line then
                line:SetText(text)
            end
        end
    else
        for index, text in pairs(info) do
            if text~='' then
                if index==1 and tooltip.TextLeft1 then
                    tooltip.TextLeft1:SetText(text)
                else
                    tooltip:AddLine(text, nil,nil,nil, true)
                end
            end
        end
    end
end


local function set_spell(tooltip, data)
    local name = e.Get_Spell_Name(data.id)
    if name then
        tooltip.TextLeft1:SetText(name)
        local desc= e.Get_Spell_Desc(data.id)
        if desc then
            tooltip:AddLine(' ')
            tooltip:AddLine(desc, nil,nil,nil, true)
        end
    end
end


--排除，插件 WoWeuCN_Tooltips
if not GetItemData then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
        set_item(tooltip, data)

        if C_Heirloom.IsItemHeirloom(data.id) then
            local source= e.Get_Heirloom_Source(data.id)
            if source and not C_Heirloom.PlayerHasHeirloom(data.id) then
                tooltip:AddLine(source, nil,nil,nil, true)
                --tooltip:Show()
            end
        end
    end)
end


TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Toy, function(tooltip, data)
    set_item(tooltip, data)
    if not PlayerHasToy(data.id) then
        local source= e.Get_Toy_Source(data.id)
        if source then
            tooltip:AddLine(source, nil,nil,nil, true)
            --tooltip:Show()
        end
    end
end)


if not GetSpellData then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
        set_spell(tooltip, data)
    end)
end
















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
        GameTooltip_AddColoredLine(self, ("%s:"):format('卖价'), HIGHLIGHT_FONT_COLOR)
        local indent = string.rep(" ",4)
        SetTooltipMoney(self, cost, nil, string.format("%s%s:", indent, '最小'))
        SetTooltipMoney(self, maxcost, nil, string.format("%s%s:", indent, '最大'))
    end
end










--Blizzard_FrameXML/SharedPetBattleTemplates.lua
--战斗宠物，技能 SharedPetBattleTemplates.lua
hooksecurefunc('SharedPetBattleAbilityTooltip_SetAbility', function(self, abilityInfo, additionalText)
    local abilityID = abilityInfo:GetAbilityID()
    local info = abilityID and e.Get_Pet_Ablity_Info(abilityID)
    if info then
        --local _, name, icon, _, unparsedDescription, _, petType = C_PetBattles.GetAbilityInfoByID(abilityID)
        local description = info[2] and SharedPetAbilityTooltip_ParseText(abilityInfo, info[2])
        if description then
            self.Description:SetText(description)
        end        
        if info[1] then
            self.Name:SetText(info[1])
        end
    end
end)















--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(_, _, arg1)
    if arg1=='Blizzard_PerksProgram' then--Blizzard_PerksProgramElements.lua
        set_GameTooltip_func(PerksProgramTooltip)

    elseif arg1=='Blizzard_ItemSocketingUI' then--镶嵌宝石，界面
        ItemSocketingSocketButton:SetText('应用')
        set_GameTooltip_func(ItemSocketingDescription)

    end
end)













--[[不要删除了，还要用
TooltipDataRules.lua
Blizzard_SharedXMLGame/Tooltip/TooltipDataHandler.lua
TooltipDataRules.lua 
    Enum.TooltipDataType = {
		Item = 0,
		Spell = 1,
		Unit = 2,
		Corpse = 3,
		Object = 4,
		Currency = 5,
		BattlePet = 6,
		UnitAura = 7,
		AzeriteEssence = 8,
		CompanionPet = 9,
		Mount = 10,
		PetAction = 11,
		Achievement = 12,
		EnhancedConduit = 13,
		EquipmentSet = 14,
		InstanceLock = 15,
		PvPBrawl = 16,
		RecipeRankInfo = 17,
		Totem = 18,
		Toy = 19,
		CorruptionCleanser = 20,
		MinimapMouseover = 21,
		Flyout = 22,
		Quest = 23,
		QuestPartyProgress = 24,
		Macro = 25,
		Debug = 26,
	},
]]
