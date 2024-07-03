local id, e= ...




















local function Init_Toy()
    --ToyBox.searchBox.Instructions:SetText('搜索')
    --e.set(ToyBox.FilterDropdown.Text)
    hooksecurefunc(ToyBox.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)
end






local function Init_Heirlooms()
    --HeirloomsJournal.FilterDropdown.Text:SetText('过滤器')
    HeirloomsJournalSearchBox.Instructions:SetText('搜索')
    hooksecurefunc(HeirloomsJournal.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)

    hooksecurefunc(HeirloomsJournal, 'LayoutCurrentPage', function(self)
        for _, header in pairs(self.heirloomHeaderFrames or {}) do
            e.set(header.text)
        end
    end)

    --传家宝，名称
    hooksecurefunc(HeirloomsJournal, 'UpdateButton', function(_, btn)
        if not btn.name then
            return
        end
        local name= e.Get_Item_Search_Name(btn.itemID) or e.strText[btn.name:GetText()]
        if name then
            btn.name:SetText(name)
        end
    end)
end























local function Init()
    Init_Toy()
    Init_Heirlooms()

    CollectionsJournalTab1:SetText('坐骑')
    CollectionsJournalTab2:SetText('宠物手册')
    CollectionsJournalTab3:SetText('玩具箱')
    CollectionsJournalTab4:SetText('传家宝')
    CollectionsJournalTab5:SetText('外观')

    hooksecurefunc('CollectionsJournal_UpdateSelectedTab', function(self)--设置，标题
        e.set(self.Text)
    end)
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