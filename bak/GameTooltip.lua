local e= select(2, ...)
--[[
TooltipDataRules.lua 
LuaEnum.lua
Enum.TooltipDataLineType = {
		None = 0,
		Blank = 1,
		UnitName = 2,
		GemSocket = 3,
		AzeriteEssenceSlot = 4,
		AzeriteEssencePower = 5,
		LearnableSpell = 6,
		UnitThreat = 7,
		QuestObjective = 8,
		AzeriteItemPowerDescription = 9,
		RuneforgeLegendaryPowerDescription = 10,
		SellPrice = 11,
		ProfessionCraftingQuality = 12,
		SpellName = 13,
		CurrencyTotal = 14,
		ItemEnchantmentPermanent = 15,
		UnitOwner = 16,
		QuestTitle = 17,
		QuestPlayer = 18,
		NestedBlock = 19,
		ItemBinding = 20,
		RestrictedRaceClass = 21,
		RestrictedFaction = 22,
		RestrictedSkill = 23,
		RestrictedPvPMedal = 24,
		RestrictedReputation = 25,
		RestrictedSpellKnown = 26,
		RestrictedLevel = 27,
		EquipSlot = 28,
		ItemName = 29,
		Separator = 30,
		ToyName = 31,
		ToyText = 32,
		ToyEffect = 33,
		ToyDuration = 34,
		RestrictedArena = 35,
		RestrictedBg = 36,
		ToyFlavorText = 37,
		ToyDescription = 38,
		ToySource = 39,
	},
BlizzardInterfaceCode/Interface/AddOns/Blizzard_SharedXMLGame/Tooltip/TooltipDataRules.lua
]]


local COVENANT_RENOWN_TOAST_REWARD_COMBINER= COVENANT_RENOWN_TOAST_REWARD_COMBINER:gsub('%%s', '(.+)')--%s 和 %s

--单位，名称
TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.UnitName, function(tooltip, lineData)
    local unitToken = lineData.unitToken;
	if not unitToken or UnitIsPlayer(unitToken) then
        return 
    end
    local cnName= e.strText[lineData.leftText] 
    if not cnName then
        local guid = UnitGUID(unitToken)
        local npc= guid and select(6, strsplit("-", guid))--位面,NPCID
        if npc then
            cnName= e.Get_NPC_Name(tonumber(npc))
        end
    end
    if cnName then
        lineData.leftText= cnName
    end
end)






TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, function(tooltip, lineData)
    if not lineData.leftText then
        return
    end
    local text= e.strText[lineData.leftText]    
    if text then
        lineData.leftText= text
        return
    end
       
    local gem1, gem2= lineData.leftText:match(COVENANT_RENOWN_TOAST_REWARD_COMBINER)
    if gem1 and gem2 then
        
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
            lineData.leftText= gem1..' 和 '..gem2
        end
    end
end)




TooltipDataRules.GemSocketEnchantment(tooltip, lineData)