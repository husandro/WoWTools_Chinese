local id, e= ...

--Blizzard_PerksProgramElements.lua
local function Init()
    --PerksProgramFrame.ProductsFrame.PerksProgramFilter.FilterDropDownButton.ButtonText:SetText('过滤器')

    e.dia("PERKS_PROGRAM_CONFIRM_PURCHASE", {text= '用%s%s 交易下列物品？', button1 = '购买', button2 = '取消'})
    e.dia("PERKS_PROGRAM_CONFIRM_REFUND", {text= '退还下列物品，获得退款%s%s？', button1 = '退款', button2 = '取消'})
    e.dia("PERKS_PROGRAM_SERVER_ERROR", {text= '商栈与服务器交换数据时出现困难，请稍后再试。', button1 = '确定'})
    e.dia("PERKS_PROGRAM_ITEM_PROCESSING_ERROR", {text= '正在处理一件物品。请稍后再试。。', button1 = '确定'})
    e.dia("PERKS_PROGRAM_CONFIRM_OVERRIDE_FROZEN_ITEM", {text= '你确定想替换当前的冻结物品吗？现在的冻结物品有可能已经下架了。', button1 = '确认', button2 = '取消'})
    e.dia("PERKS_PROGRAM_SLOW_PURCHASE", {text= '处理您的本次购买所花费的时间比正常情况更长。购买过程会在后台继续进行。', button1= '回到商栈'})
    C_Timer.After(0.3, function()
        PerksProgramFrame.FooterFrame.LeaveButton:SetFormattedText('%s 离开', CreateAtlasMarkup("perks-backarrow", 8, 13, 0, 0))
    end)

    --PerksProgramFrame.ProductsFrame.ProductsScrollBoxContainer.ScrollBox.ScrollTarget.180daf63690.ContentsContainer.Label
end




--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_PerksProgram') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_PerksProgram' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()

    end
end)
