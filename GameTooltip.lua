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


--  ( ) . % + - * ? [ ^ $
local ITEM_UPGRADE_TOOLTIP_FORMAT_STRING= ITEM_UPGRADE_TOOLTIP_FORMAT_STRING:gsub(': (.+)', '(.+)')--升级：%s %d/%d
local ENCHANTED_TOOLTIP_LINE = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)')--附魔：%s
local COVENANT_RENOWN_TOAST_REWARD_COMBINER= COVENANT_RENOWN_TOAST_REWARD_COMBINER:gsub('%%s', '(.+)')--%s 和 %s
local EQUIPMENT_SETS= EQUIPMENT_SETS:match('(.-)'..HEADER_COLON)--"Set di equipaggiamenti: |cFFFFFFFF%s|r"
if EQUIPMENT_SETS then
    EQUIPMENT_SETS= EQUIPMENT_SETS..'(.+)'
end

local function get_gameTooltip_text(self)
    local text= self and self:IsShown() and self:GetText()
    if text and text~='' and not text:find('|') then
        local text2= e.strText[text]
        if not text2 then
            local up= text:match(ITEM_UPGRADE_TOOLTIP_FORMAT_STRING)---"升级：%s %d/%d
            local set2= EQUIPMENT_SETS and text:match(EQUIPMENT_SETS)--"装备配置方案：|cFFFFFFFF%s|r"
            local ench= text:match(ENCHANTED_TOOLTIP_LINE)
            local gem1, gem2= text:match(COVENANT_RENOWN_TOAST_REWARD_COMBINER)
            local str1, str2= text:match('(.-): (.+)')
            local str3= text:match('%d+ (.+)')
            local str4= text:match('|c........(.-)|r')
            local str5= text:match('(.+) %(%d/%d%)')--套装名称 (4/5)

            if up then
                local t= up:match(': (.-) %d')
                if t and e.strText[t] then
                    text2= '升级'..up:gsub(t, e.strText[t])
                else
                    text2= '升级'..up
                end

            elseif set2 then
                text2= '装备配置方案'..set2

            elseif ench then--附魔：%s
                local col, str6=  ench:match('(|.-:)(.-)|r')
                local t= ench:match('(.+) |A') or ench:match(' (.+)')
                if t then
                    local num= t:match('%d+ (.+)')
                    if num then
                        t= e.strText[num] or e.strText[num:match(".+ (.+)")]
                        if t then
                            ench= ench:gsub(num, t)
                        end
                    elseif e.strText[t] then
                        ench= ench:gsub(t, e.strText[t])
                    end
                    text2= '附魔：'..e.cn(ench)
                elseif col and str6 then
                    text2='附魔：'..col..e.cn(str6)..'|r'
                else
                    text2='附魔：'..e.cn(ench)
                end
            elseif gem1 and gem2 then
                local find
                local t1= gem1:match('%d+ (.+)')
                if t1 then
                    local s1= e.strText[t1:match(".+ (.+)")] or e.strText[t1]
                    if s1 and gem1 then
                        gem1= gem1:gsub(t1, s1)
                        find=true
                    end
                end
                local t2= gem2:match('%d+ (.+) |A') or gem2:match('%d+ (.+)')--无法找到
                if t2 then
                    local s1= e.strText[t2] or e.strText[t2:match(".+ (.+)")]
                    if s1 then
                        gem2= gem2:gsub(t2, s1)
                        find=true
                    end
                end
                if find then
                    text2= gem1..' 和 '..gem2
                end

            elseif e.strText[str1] then
                if str2 then
                    str2= e.strText[str2] or str2
                    local t= str2:match(' (.-) %d')
                    if t and e.strText[t] then
                        str2= str2:gsub(t, e.strText[t])
                    end
                end
                text2= e.strText[str1]..': '..(str2 or '')

            elseif str3 then
                if e.strText[str3] then--+75 Maestria
                    text2= text:gsub(str3, e.strText[str3])
                else

                    local t= e.strText[str3:match(".+ (.+) |A")] or e.strText[str3:match(".+ (.+)")]--+75 Indice di Maestria(大写m)
                    if t then
                        text2= text:gsub(str3, t)
                    end
                end
            elseif str4 then
                if e.strText[str4] then
                    text2= text:gsub(str4, e.strText[str4])
                end
            elseif str5 then
                if e.strText[str5] then
                    text2= text:gsub(str5, e.strText[str5])
                end
            end
        end
        if text2 then
            self:SetText(text2)
            self:SetTextColor(self:GetTextColor())
        end
    end
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
        if frame.elapsed>TOOLTIP_UPDATE_TIME then
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

--[[SharedTooltipTemplate
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
--BattlePetTooltipTemplat    
]]



set_GameTooltip_func(GameTooltip)
set_GameTooltip_func(ItemRefTooltip)
set_GameTooltip_func(EmbeddedItemTooltip)

set_pettips_func(BattlePetTooltip)
set_pettips_func(FloatingBattlePetTooltip)





























local function add_data(tooltip, info, isSpell)
    if not info then
        return
    end
    local add
    for index, text in pairs(info) do
        if text~=' ' then
            if index==1 then
                tooltip.TextLeft1:SetText(text)
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
        tooltip:Show()
    end
end

local function set_item(tooltip, data)
    add_data(tooltip, e.Get_Item_Data(data.id), false)
end

local function set_spell(tooltip, data)
    add_data(tooltip, e.Get_Spell_Data(data.id), true)
end


--排除，插件 WoWeuCN_Tooltips

if GetItemData then
    set_item= function() end
end
if GetSpellData then
    set_spell= function() end
end



--TooltipDataRules.lua
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

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
    set_spell(tooltip, data)
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
        GameTooltip_AddColoredLine(self, ("%s:"):format('卖价'), HIGHLIGHT_FONT_COLOR)
        local indent = string.rep(" ",4)
        SetTooltipMoney(self, cost, nil, string.format("%s%s:", indent, '最小'))
        SetTooltipMoney(self, maxcost, nil, string.format("%s%s:", indent, '最大'))
    end
end





















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
