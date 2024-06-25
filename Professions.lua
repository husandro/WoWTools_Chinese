local id, e = ...




local function Init()
end











--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(_, _, arg1)
    if arg1==id then
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)