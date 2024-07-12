local id, e= ...








local function Init()
    WardrobeCollectionFrameSearchBox.Instructions:SetText('搜索')
    --[[hooksecurefunc(WardrobeCollectionFrame, 'SetContainer', function(self, parent)
        if parent == CollectionsJournal then
            --self.FilterButton:SetText('过滤器')
        elseif parent == WardrobeFrame then
            self.FilterButton:SetText('来源')
        end
    end)]]
    --WardrobeCollectionFrame.FilterButton.Text:SetText('过滤器')
    WardrobeCollectionFrameTab1:SetText('物品')
        hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
            self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
        end)
    WardrobeCollectionFrameTab2:SetText('套装')
        hooksecurefunc(WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
            self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
        end)

    WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox.Label:SetText('两侧肩膀使用不同的幻化外观')



    --试衣间
    WardrobeFrameTitleText:SetText('幻化')
    --WardrobeOutfitDropDown.SaveButton:SetText('保存')
    --WardrobeTransmogFrame.ApplyButton:SetText('应用')
    WardrobeOutfitEditFrame.Title:SetText('输入外观方案名称：')
    WardrobeOutfitEditFrame.AcceptButton:SetText('接受')
    WardrobeOutfitEditFrame.CancelButton:SetText('取消')
    WardrobeOutfitEditFrame.DeleteButton:SetText('删除外观方案')
    WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:HookScript('OnEnter', function()
        GameTooltip:SetText('取消所有的待定改动')
    end)


    hooksecurefunc(WardrobeSetsScrollFrameButtonMixin, 'Init', function(btn, data)
        e.set(btn.Name)
    end)

    e.hookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Name)
    e.hookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Label)
end













--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_Collections') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_Collections' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)
