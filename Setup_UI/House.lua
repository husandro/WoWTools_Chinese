function WoWTools_ChineseMixin.Events:Blizzard_HousingModelPreview()
    self:SetLabel(HousingModelPreviewFrame.ModelPreview.TextContainer.CollectionBonus)
    hooksecurefunc(HousingModelPreviewMixin, 'OnLoad', function(frame)
        frame:SetupTextTooltip(frame.TextContainer.CollectionBonus,
            function(tooltip)
                GameTooltip_AddHighlightLine(tooltip, format('首次收集奖励：|cnHIGHLIGHT_FONT_COLOR:+%d点住宅经验值|r', frame.catalogEntryInfo.firstAcquisitionBonus));
            end);

        frame:SetupTextTooltip(frame.TextContainer.NumOwned,
            function(tooltip)
                GameTooltip_AddHighlightLine(tooltip, format('已放置：%d，储存空间：%d', frame.catalogEntryInfo.numPlaced, frame.catalogEntryInfo.numStored));
            end);
    end)
end

function WoWTools_ChineseMixin.Events:Blizzard_HousingBulletinBoard()
    self:SetLabel(HousingBulletinBoardFrame.RosterTabButton.Label)
    C_Timer.After(0.3, function()
        self:SetLabel(HousingBulletinBoardFrame.ResidentsTab.ColumnDisplay)
    end)
    self:SetFrames(HousingBulletinBoardFrame)
end

function WoWTools_ChineseMixin.Events:Blizzard_HousingCharter()
    self:SetFrame(HousingCharterFrame)
    self:SetButton(HousingCharterFrame.RequestButton)
    self:SetButton(HousingCharterFrame.SettingsButton)
    self:SetButton(HousingCharterFrame.CloseButton)
end
--住宅区登记表 11.2.7
function WoWTools_ChineseMixin.Events:Blizzard_HousingCreateNeighborhood()
    self:HookButton(HousingCreateNeighborhoodCharterFrame.ConfirmButton)
    self:SetLabel(HousingCreateNeighborhoodCharterFrame.CancelButton)
    self:HookLabel(HousingCreateNeighborhoodCharterFrame.LocationText)
    self:HookLabel(HousingCreateNeighborhoodCharterFrame.NeighborhoodInfoText)
    self:SetFrame(HousingCreateNeighborhoodCharterFrame)
end
--住宅信息板
function WoWTools_ChineseMixin.Events:Blizzard_HousingCornerstone()
    self:HookLabel(HousingCornerstoneVisitorFrame.NeighborhoodText)
    self:SetFrame(HousingCornerstoneVisitorFrame)
end
--住宅搜索器
function WoWTools_ChineseMixin.Events:Blizzard_HousingHouseFinder()
    self:SetLabel(HouseFinderFrameTitleText)
    self:SetLabel(HouseFinderFrame.NeighborhoodListFrame.NeighborhoodsLabel)

    self:SetFrame(HouseFinderFrame.PlotInfoFrame)
    self:SetLabel(HouseFinderFrame.PlotInfoFrame.BackButton.ButtonLabel)
    self:SetButton(HouseFinderFrame.PlotInfoFrame.VisitHouseButton)
end

function WoWTools_ChineseMixin.Events:Blizzard_HousingHouseSettings()
    self:SetLabel(HousingHouseSettingsFrame.Title)
    self:SetButton(HousingHouseSettingsFrame.AbandonHouseButton)

    self:SetLabel(HousingHouseSettingsFrame.HouseOwnerLabel)
    self:SetLabel(HousingHouseSettingsFrame.PlotAccess.Label)
    self:SetLabel(HousingHouseSettingsFrame.HouseAccess.Label)
    for _, option in pairs(HousingHouseSettingsFrame.PlotAccess.accessOptions or {}) do
        self:SetLabel(option.OptionLabel)
    end
        for _, option in pairs(HousingHouseSettingsFrame.HouseAccess.accessOptions or {}) do
        self:SetLabel(option.OptionLabel)
    end
    self:SetButton(HousingHouseSettingsFrame.IgnoreListButton)
    HousingHouseSettingsFrame.SaveButton:SetText('保存')

    self:SetFrame(AbandonHouseConfirmationDialog)
    self:SetButton(AbandonHouseConfirmationDialog.ConfirmButton)
    self:SetButton(AbandonHouseConfirmationDialog.CancelButton)

end

function WoWTools_ChineseMixin.Events:Blizzard_HouseEditor()
    self:SetLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.PlaceInstruction.InstructionText)

    self:SetLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.RotateLeftInstruction.InstructionText)
    self:HookLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.RotateLeftInstruction.Control.Text)

    self:SetLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.RotateRightInstruction.InstructionText)
    self:HookLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.RotateRightInstruction.Control.Text)

    self:SetLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.RemoveInstruction.InstructionText)
    self:HookLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.RemoveInstruction.Control.Text)

    self:SetLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.ToggleGridInstruction.InstructionText)
    self:HookLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.ToggleGridInstruction.Control.Text)

    self:SetLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.CancelInstruction.InstructionText)
    self:HookLabel(HouseEditorFrame.BasicDecorModeFrame.Instructions.CancelInstruction.Control.Text)

    self:SetTabButton(HouseEditorFrame.StoragePanel)

    self:SetLabel(HouseEditorFrame.StoragePanel.OptionsContainer.CategoryText)
    self:SetLabel(HouseEditorFrame.StoragePanel.SearchBox.Instructions)

    self:SetFrames(HouseEditorFrame.ExteriorCustomizationModeFrame.CoreOptionsPanel)

    for _, btn in pairs({HouseEditorFrame.ModeBar:GetRegions()}) do
        local cn= self:CN(btn.modeName)
        if cn then
            btn.modeName= cn
        end
        --[[cn= self:CN(btn.keybindName)
        if cn then
            btn.keybindName= cn
        end]]
        cn= self:CN(btn.enabledTooltip)
        if cn then
            btn.enabledTooltip= cn
        end

        cn= self:CN(btn.enabledTooltipKeybind)
        if cn then
            btn.enabledTooltipKeybind= cn
        end
    end
end


--住宅信息板
function WoWTools_ChineseMixin.Events:Blizzard_HousingDashboard()
--Blizzard_HousingData.lua
    self:SetLabel(HousingDashboardFrame.HouseInfoContent.DashboardNoHousesFrame.TitleText)
    WoWTools_ChineseMixin:SetCN(HOUSING_EXPERT_DECOR_GLOBAL_SPACE_ACTIVATE, '切换到私密住宅编辑')
    WoWTools_ChineseMixin:SetCN(HOUSING_EXPERT_DECOR_GLOBAL_SPACE_DEACTIVATE, '切换到公共住宅编辑')

    HousingDashboardFrame.houseInfoTab.titleText = HOUSING_DASHBOARD_HOUSEINFO_FRAMETITLE
    self:HookLabel(HousingDashboardFrameTitleText)

    self:SetLabel(HousingDashboardFrame.CatalogContent.Categories.BackButton.Text)
    self:SetFrame(HousingDashboardFrame.HouseInfoContent.DashboardNoHousesFrame)
    self:SetButton(HousingDashboardFrame.HouseInfoContent.DashboardNoHousesFrame.NoHouseButton)

--11.2.7中显示图标，会出错
    WoWTools_DataMixin:Hook(HousingDashboardFrame.CatalogContent, 'UpdateCategoryText', function(frame)
        local categoryString = frame.Categories:GetFocusedCategoryString()
        if categoryString then
            local t= self:SetText(categoryString)
            if t then
                frame.OptionsContainer.CategoryText:SetText(t)
            end
        end
    end)

--HousingModelPreviewMixin
    hooksecurefunc(HousingDashboardFrame.CatalogContent.PreviewFrame, 'PreviewCatalogEntryInfo', function(frame, info)
        if info and info.entryID then
            local cn= self:CN(info.name) or self:GetHouseDecoName(info.entryID.recordID)
            if cn then
                frame.NameContainer.Name:SetText(cn)
            end
        end
    end)

    self:SetLabel(HousingDashboardFrame.CatalogContent.PreviewFrame.TextContainer.CollectionBonus)
    self:SetLabel(HousingDashboardFrame.CatalogContent.PreviewFrame.PreviewUnavailableText)

    self:SetLabel(HousingDashboardFrame.HouseInfoContent.ContentFrame.HouseUpgradeFrame.WatchFavorButton.Label)
end



function WoWTools_ChineseMixin.Events:Blizzard_HousingTemplates()

    --self:AddDialogs("CONFIRM_DESTROY_DECOR", {button1 = '接受', button2 = '拒绝'})
    

    for value, name in pairs(HousingResultToErrorText or {}) do
        local cn= self:CN(name)
        if cn then
            HousingResultToErrorText[value]= cn
        end
    end

    for value, name in pairs(NeighborhoodTypeStrings or {}) do
        local cn= self:CN(name)
        if cn then
            NeighborhoodTypeStrings[value]= cn
        end
    end

    for value, name in pairs(HousingAccessTypeStrings or {}) do
        local cn= self:CN(name)
        if cn then
            HousingAccessTypeStrings[value]= cn
        end
    end


    for value, name in pairs(HouseOwnerErrorTypeStrings or {}) do
        local cn= self:CN(name)
        if cn then
            HouseOwnerErrorTypeStrings[value]= cn
        end
    end
    for value, name in pairs(HousingLayoutGenericRestrictionStrings or {}) do
        local cn= self:CN(name)
        if cn then
            HousingLayoutGenericRestrictionStrings[value]= cn
        end
    end
    for value, name in pairs(HousingLayoutRotateRestrictionStrings or {}) do
        local cn= self:CN(name)
        if cn then
            HousingLayoutRotateRestrictionStrings[value]= cn
        end
    end
    for value, name in pairs(HousingLayoutRemoveRestrictionString or {}) do
        local cn= self:CN(name)
        if cn then
            HousingLayoutRemoveRestrictionString[value]= cn
        end
    end
    for value, name in pairs(HousingLayoutMoveRestrictionStrings or {}) do
        local cn= self:CN(name)
        if cn then
            HousingLayoutMoveRestrictionStrings[value]= cn
        end
    end

    --hooksecurefunc(HousingModelPreviewMixin, 'PreviewCatalogEntryInfo', function(frame, catalogEntryInfo)--可用


end
