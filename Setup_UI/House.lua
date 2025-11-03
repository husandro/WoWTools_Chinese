
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

function WoWTools_MoveMixin.Events:Blizzard_HousingCornerstone()
    self:SetFrame(HousingCornerstoneVisitorFrame)

    self:SetFrame(HousingCornerstonePurchaseFrame)
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
end