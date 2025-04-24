


EditModeManagerFrame.Title:SetText('HUD编辑模式')
EditModeManagerFrame.Tutorial.MainHelpPlateButtonTooltipText= '点击这里打开/关闭编辑模式的帮助系统。'
EditModeManagerFrame.ShowGridCheckButton.Label:SetText('显示网格')
EditModeManagerFrame.EnableSnapCheckButton.Label:SetText('贴附到界面元素上')
EditModeManagerFrame.EnableAdvancedOptionsCheckButton.Label:SetText('高级选项')
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.FramesTitle.Title:SetText('框体')
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.CombatTitle.Title:SetText('战斗')
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.MiscTitle.Title:SetText('其它')

WoWTools_ChineseMixin:SetLabel(EditModeManagerFrame.LayoutLabel)--布局：

hooksecurefunc(EditModeManagerFrame.AccountSettings, 'SetExpandedState', function(self, expanded, isUserInput)
    self.Expander.Label:SetText(expanded and '收起选项 |A:editmode-up-arrow:16:11:0:3|a' or '展开选项 |A:editmode-down-arrow:16:11:0:-7|a')
end)
EditModeManagerFrame.AccountSettings.Expander.Label:SetText('展开选项 |A:editmode-down-arrow:16:11:0:-7|a')
EditModeManagerFrame.RevertAllChangesButton:SetText('撤销所有变更')
EditModeManagerFrame.SaveChangesButton:SetText('保存')

--EditModeDialogs.lua
EditModeUnsavedChangesDialog.CancelButton:SetText('取消')
hooksecurefunc(EditModeUnsavedChangesDialog, 'ShowDialog', function(self, selectedLayoutIndex)
    if selectedLayoutIndex then
        self.Title:SetText('如果你切换布局，你会丢失所有未保存的改动。|n你想继续吗？')
        self.SaveAndProceedButton:SetText('保存并切换')
        self.ProceedButton:SetText('切换')
    else
        self.Title:SetText('如果你现在退出，你会丢失所有未保存的改动。|n你想继续吗？')
        self.SaveAndProceedButton:SetText('保存并退出')
        self.ProceedButton:SetText('退出')
    end
end)

hooksecurefunc(EditModeSystemSettingsDialog, 'AttachToSystemFrame', function(self, systemFrame)
    local name= systemFrame:GetSystemName()
    WoWTools_ChineseMixin:SetLabel(self.Title, name)
end)



EditModeNewLayoutDialog.Title:SetText('给新布局起名')
EditModeNewLayoutDialog.CharacterSpecificLayoutCheckButton.Label:SetText('角色专用布局')
EditModeNewLayoutDialog.AcceptButton:SetText('保存')
EditModeNewLayoutDialog.CancelButton:SetText('取消')

EditModeImportLayoutDialog.Title:SetText('导入布局')
EditModeImportLayoutDialog.EditBoxLabel:SetText('导入文本：')
EditModeImportLayoutDialog.ImportBox.EditBox.Instructions:SetText('在此粘贴布局代码')
EditModeImportLayoutDialog.NameEditBoxLabel:SetText('新布局名称：')
EditModeImportLayoutDialog.CharacterSpecificLayoutCheckButton.Label:SetText('角色专用布局')
EditModeImportLayoutDialog.AcceptButton:SetText('导入')
EditModeImportLayoutDialog.CancelButton:SetText('取消')


EditModeImportLayoutDialog.AcceptButton.disabledTooltip= '输入布局的名称'
EditModeNewLayoutDialog.AcceptButton.disabledTooltip= '输入布局的名称'

local function CheckForMaxLayouts(acceptButton, charSpecificButton)
    if EditModeManagerFrame:AreLayoutsFullyMaxed() then
        acceptButton.disabledTooltip = format('最多允许%d种角色布局和%d种账号布局', Constants.EditModeConsts.EditModeMaxLayoutsPerType, Constants.EditModeConsts.EditModeMaxLayoutsPerType)
        return true
    end
    local layoutType = charSpecificButton:IsControlChecked() and Enum.EditModeLayoutType.Character or Enum.EditModeLayoutType.Account
    local areLayoutsMaxed = EditModeManagerFrame:AreLayoutsOfTypeMaxed(layoutType)
    if areLayoutsMaxed then
        acceptButton.disabledTooltip = (layoutType == Enum.EditModeLayoutType.Character) and format('只允许有%d个角色专用的布局。勾选以保存一种账号通用的布局', Constants.EditModeConsts.EditModeMaxLayoutsPerType) or format('只允许有%d个账号通用的布局。勾选以保存一种角色专用的布局', Constants.EditModeConsts.EditModeMaxLayoutsPerType)
        return true
    end
end
local function CheckForDuplicateLayoutName(acceptButton, editBox)
    local editBoxText = editBox:GetText()
    local editModeLayouts = EditModeManagerFrame:GetLayouts()
    for _, layout in ipairs(editModeLayouts) do
        if layout.layoutName == editBoxText then
            acceptButton.disabledTooltip = '该名称已被使用。'
            return true
        end
    end
end
hooksecurefunc(EditModeImportLayoutDialog, 'UpdateAcceptButtonEnabledState', function(self)
    if not CheckForMaxLayouts(self.AcceptButton, self.CharacterSpecificLayoutCheckButton)
        and not CheckForDuplicateLayoutName(self.AcceptButton, self.LayoutNameEditBox)  then
        self.AcceptButton.disabledTooltip = '输入布局的名称'
    end
end)
hooksecurefunc(EditModeNewLayoutDialog, 'UpdateAcceptButtonEnabledState', function(self)
    if not CheckForMaxLayouts(self.AcceptButton, self.CharacterSpecificLayoutCheckButton)
        and not CheckForDuplicateLayoutName(self.AcceptButton, self.LayoutNameEditBox)  then
        self.AcceptButton.disabledTooltip = '输入布局的名称'
    end
end)




for _, frame in pairs(EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.BasicOptionsContainer:GetLayoutChildren() or {}) do
    WoWTools_ChineseMixin:SetLabel(frame.Label)
end

EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.FramesContainer:HookScript('OnShow', function(self)
    for _,frame in pairs(self:GetLayoutChildren() or {}) do
        WoWTools_ChineseMixin:SetLabel(frame.Label)
    end
end)
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.CombatContainer:HookScript('OnShow', function(self)
    for _,frame in pairs(self:GetLayoutChildren() or {}) do
        WoWTools_ChineseMixin:SetLabel(frame.Label)
    end
end)
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.MiscContainer:HookScript('OnShow', function(self)
    for _,frame in pairs(self:GetLayoutChildren() or {}) do
        WoWTools_ChineseMixin:SetLabel(frame.Label)
        if frame.disabledTooltipText== HUD_EDIT_MODE_LOOT_FRAME_DISABLED_TOOLTIP then
            frame.disabledTooltipText= '你必须关闭位于：界面 > 控制菜单中的“鼠标位置打开拾取窗口”选项，才能自定义拾取窗口布局。'
        end
    end
end)




EditModeSystemSettingsDialog.Buttons.RevertChangesButton:SetText('撤销变更')
hooksecurefunc(EditModeSystemSettingsDialog, 'UpdateExtraButtons', function(self, systemFrame)--EditModeDialogs.lua
    if systemFrame == self.attachedToSystem then
        systemFrame.resetToDefaultPositionButton:SetText('重设到默认位置')
    end
end)
hooksecurefunc(EditModeSystemSettingsDialog, 'UpdateButtons', function(self, systemFrame)
    if systemFrame == self.attachedToSystem then
        if systemFrame.Selection then
            WoWTools_ChineseMixin:SetLabel(systemFrame.Selection.HorizontalLabel)
            WoWTools_ChineseMixin:SetLabel(systemFrame.Selection.Label)
            WoWTools_ChineseMixin:SetLabel(systemFrame.Selection.VerticalLabel)
        end
    end
end)

hooksecurefunc(EditModeManagerFrame.AccountSettings, 'SetupStatusTrackingBar2', function(self)
    self.settingsCheckButtons.StatusTrackingBar2.Label:SetText('状态栏 2')
end)


--EditModeTemplates.lua
hooksecurefunc(EditModeSettingCheckboxMixin, 'SetupSetting', function(self, settingData)
    WoWTools_ChineseMixin:SetLabel(self.Label, settingData.settingName)
end)
hooksecurefunc(EditModeSettingDropdownMixin, 'SetupSetting', function(self, settingData)
    WoWTools_ChineseMixin:SetLabel(self.Label, settingData.settingName)
end)
hooksecurefunc(EditModeSettingSliderMixin, 'SetupSetting', function(self, settingData)
    WoWTools_ChineseMixin:SetLabel(self.Label, settingData.settingName)
    if settingData.displayInfo.minText then
        WoWTools_ChineseMixin:SetLabel(self.Slider.MinText, settingData.displayInfo.minText)
    end
    if settingData.displayInfo.maxText then
        WoWTools_ChineseMixin:SetLabel(self.Slider.MaxText, settingData.displayInfo.maxText)
    end
end)







--[[编辑模式    











]]



