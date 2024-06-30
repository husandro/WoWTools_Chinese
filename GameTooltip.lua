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
local ITEM_UPGRADE_TOOLTIP_FORMAT_STRING= ITEM_UPGRADE_TOOLTIP_FORMAT_STRING:gsub(': (.+)', '(.+)')
local ENCHANTED_TOOLTIP_LINE = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)')--附魔：%s
local COVENANT_RENOWN_TOAST_REWARD_COMBINER= COVENANT_RENOWN_TOAST_REWARD_COMBINER:gsub('%%s', '(.+)')--%s 和 %s
local EQUIPMENT_SETS= EQUIPMENT_SETS:match('(.-):')--"Set di equipaggiamenti: |cFFFFFFFF%s|r"


local function get_gameTooltip_text(self)
    local text= self and self:IsShown() and self:GetText()
    if text and text~='' and not text:find('|') then
        local text2= e.strText[text]
        if not text2 then
            local up= text:match(ITEM_UPGRADE_TOOLTIP_FORMAT_STRING)---"升级：%s %d/%d
            local set2= EQUIPMENT_SETS and text:match(EQUIPMENT_SETS..'(.+)')--"装备配置方案：|cFFFFFFFF%s|r"
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
                local col, str5=  ench:match('(|.-:)(.-)|r')
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
                elseif col and str5 then
                    text2='附魔：'..col..e.cn(str5)..'|r'
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




set_GameTooltip_func(GameTooltip)
set_GameTooltip_func(ItemRefTooltip)
set_GameTooltip_func(EmbeddedItemTooltip)
--set_GameTooltip_func(NamePlateTooltip)


set_pettips_func(BattlePetTooltip)
set_pettips_func(FloatingBattlePetTooltip)

--hooksecurefunc(GameTooltip, 'SetText', function(self, text)



--TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Object,  function(tooltip, data)end)--TooltipUtil.lua


--[[TooltipDataRules.lua
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

TooltipDataProcessor.AddTooltipPostCall(TooltipDataProcessor.AllTypes,  function(tooltip, data)--TooltipUtil.lua
    if tooltip==ShoppingTooltip1 or ShoppingTooltip2==tooltip then
        return
    end
    if not tooltip.textLeft then
        func.Set_Init_Item(tooltip)
        tooltip:HookScript("OnHide", function(frame)--隐藏
            func.Set_Init_Item(frame, true)
            if frame.WoWHeadButton then
                frame.WoWHeadButton:rest()
            end
        end)
    end



    


    --25宏, 11动作条, 4可交互物品, 14装备管理, 0物品 19玩具, 9宠物
    if data.type==2 then--单位
        if tooltip== GameTooltip then
            func.Set_Unit(tooltip)
        end

    elseif data.id and data.type then
        if data.type==0 then
            local itemLink, itemID= select(2, TooltipUtil.GetDisplayedItem(tooltip))--物品
            itemLink= itemLink or itemID or data.id
            func.Set_Item(tooltip, itemLink, itemID)
        elseif data.type==19 then
            func.Set_Item(tooltip, nil, data.id)--物品

        elseif data.type==1 then
            func.Set_Spell(tooltip, data.id)--法术

        elseif data.type==5 then
            func.Set_Currency(tooltip, data.id)--货币

        elseif data.type==7 then--Aura
            func.set_All_Aura(tooltip, data)

        elseif data.type==8 then--艾泽拉斯之心
            func.set_Azerite(tooltip, data.id)

        elseif data.type==10 then
            func.Set_Mount(tooltip, data.id)--坐骑

        elseif data.type==12 then--成就
            func.Set_Achievement(tooltip, data.id)

        elseif data.type==22 then--法术弹出框
            func.Set_Flyout(tooltip, data.id)

        elseif data.type==23 then
            func.Set_Quest(tooltip, data.id)--任务

        elseif data.type==25 then--宏 11版本
          
        end
    end
end)]]







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
