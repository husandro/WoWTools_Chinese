





--TooltipDataRules.lua
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
    print(data.id)
    if not data.id or PlayerHasToy(data.id) then
        return
    end

    local source = e.Get_Toy_Source(data.id)
    if source then
        tooltip:AddLine('|cffffffff'..source..'|r', nil, nil, nil, true)
        tooltip:Show()
    end
end)








local function Init()
end





--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_Collections') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_Collections' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()
    end
end)
