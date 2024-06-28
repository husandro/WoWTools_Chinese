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
        --[[local selected = CollectionsJournal_GetTab(self)
        if selected==1 then
            self:SetTitle('坐骑')
        elseif selected==2 then
            self:SetTitle('宠物手册')
        elseif selected==3 then
            self:SetTitle('玩具箱')
        elseif selected==4 then
            self:SetTitle('传家宝')
        elseif selected==5 then
            self:SetTitle('外观')
        end]]
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