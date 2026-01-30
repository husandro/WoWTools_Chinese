function WoWTools_ChineseMixin.Events:Blizzard_EditMode()


    EditModeManagerFrame.Title:SetText('HUD编辑模式')
    EditModeManagerFrame.Tutorial.MainHelpPlateButtonTooltipText= '点击这里打开/关闭编辑模式的帮助系统。'
    EditModeManagerFrame.ShowGridCheckButton.Label:SetText('显示网格')
    EditModeManagerFrame.EnableSnapCheckButton.Label:SetText('贴附到界面元素上')
    EditModeManagerFrame.EnableAdvancedOptionsCheckButton.Label:SetText('高级选项')
    EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.FramesTitle.Title:SetText('框体')
    EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.CombatTitle.Title:SetText('战斗')
    EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.MiscTitle.Title:SetText('其它')

    self:SetLabel(EditModeManagerFrame.LayoutLabel)--布局：

    hooksecurefunc(EditModeManagerFrame.AccountSettings, 'SetExpandedState', function(frame, expanded, isUserInput)
        frame.Expander.Label:SetText(expanded and '收起选项 |A:editmode-up-arrow:16:11:0:3|a' or '展开选项 |A:editmode-down-arrow:16:11:0:-7|a')
    end)
    EditModeManagerFrame.AccountSettings.Expander.Label:SetText('展开选项 |A:editmode-down-arrow:16:11:0:-7|a')
    EditModeManagerFrame.RevertAllChangesButton:SetText('撤销所有变更')
    EditModeManagerFrame.SaveChangesButton:SetText('保存')

    --EditModeDialogs.lua
    EditModeUnsavedChangesDialog.CancelButton:SetText('取消')
    hooksecurefunc(EditModeUnsavedChangesDialog, 'ShowDialog', function(frame, selectedLayoutIndex)
        if selectedLayoutIndex then
            frame.Title:SetText('如果你切换布局，你会丢失所有未保存的改动。|n你想继续吗？')
            frame.SaveAndProceedButton:SetText('保存并切换')
            frame.ProceedButton:SetText('切换')
        else
            frame.Title:SetText('如果你现在退出，你会丢失所有未保存的改动。|n你想继续吗？')
            frame.SaveAndProceedButton:SetText('保存并退出')
            frame.ProceedButton:SetText('退出')
        end
    end)

    hooksecurefunc(EditModeSystemSettingsDialog, 'AttachToSystemFrame', function(frame, systemFrame)
        local name= systemFrame:GetSystemName()
        self:SetLabel(frame.Title, name)
    end)




    for _, f in pairs(EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.BasicOptionsContainer:GetLayoutChildren() or {}) do
        self:SetLabel(f.Label)
    end

    EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.FramesContainer:HookScript('OnShow', function(frame)
        for _, f in pairs(frame:GetLayoutChildren() or {}) do
            self:SetLabel(f.Label)
        end
    end)
    EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.CombatContainer:HookScript('OnShow', function(frame)
        for _, f in pairs(frame:GetLayoutChildren() or {}) do
            self:SetLabel(f.Label)
        end
    end)
    EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.MiscContainer:HookScript('OnShow', function(frame)
        for _, f in pairs(frame:GetLayoutChildren() or {}) do
            self:SetLabel(f.Label)
            if f.disabledTooltipText== HUD_EDIT_MODE_LOOT_FRAME_DISABLED_TOOLTIP then
                f.disabledTooltipText= '你必须关闭位于：界面 > 控制菜单中的“鼠标位置打开拾取窗口”选项，才能自定义拾取窗口布局。'
            end
        end
    end)




    EditModeSystemSettingsDialog.Buttons.RevertChangesButton:SetText('撤销变更')
    hooksecurefunc(EditModeSystemSettingsDialog, 'UpdateExtraButtons', function(frame)--, systemFrame)--EditModeDialogs.lua
        for _, pool in pairs({frame.pools:GetPool("EditModeSystemSettingsDialogExtraButtonTemplate")}) do
            for btn in pool:EnumerateActive() do
                self:SetButton(btn)
            end
        end
    end)


    hooksecurefunc(EditModeManagerFrame.AccountSettings, 'SetupStatusTrackingBar2', function(frame)
        frame.settingsCheckButtons.StatusTrackingBar2.Label:SetText('状态栏 2')
    end)


    --EditModeTemplates.lua
    hooksecurefunc(EditModeSettingCheckboxMixin, 'SetupSetting', function(frame, settingData)
        self:SetLabel(frame.Label, settingData.settingName)
    end)
    hooksecurefunc(EditModeSettingDropdownMixin, 'SetupSetting', function(frame, settingData)
        self:SetLabel(frame.Label, settingData.settingName)
    end)
    hooksecurefunc(EditModeSettingSliderMixin, 'SetupSetting', function(frame, settingData)
        self:SetLabel(frame.Label, settingData.settingName)
        if settingData.displayInfo.minText then
            self:SetLabel(frame.Slider.MinText, settingData.displayInfo.minText)
        end
        if settingData.displayInfo.maxText then
            self:SetLabel(frame.Slider.MaxText, settingData.displayInfo.maxText)
        end
    end)

--保存布局 EditModeLayoutDialogMixin
    hooksecurefunc(EditModeLayoutDialog, 'SetupControlsForMode', function(frame, modeData, layoutName, ...)
        local title= self:CN(modeData.title)
        if title then
            frame.Title:SetFormattedText(title, layoutName, ...)
        end
    end)
    self:HookLabel(EditModeLayoutDialog.Title)
    self:SetLabel(EditModeLayoutDialog.CharacterSpecificLayoutCheckButton.Label)
    self:HookButton(EditModeLayoutDialog.AcceptButton)
    self:HookButton(EditModeLayoutDialog.CancelButton)

    --[[hooksecurefunc(EditModeSystemSettingsDialog, 'UpdateButtons', function(_, systemFrame)--12.0有BUG
        --if systemFrame == frame.attachedToSystem then
            --if systemFrame.Selection then
              --  if HorizontalLabel

                if systemFrame.Selection.HorizontalLabel then
                    local cn= self:CN(systemFrame.Selection.HorizontalLabel:GetText())
                    if cn then
                        systemFrame.Selection.HorizontalLabel:SetText(cn)
                    end
                end
                if systemFrame.Selection.Label then
                    local cn= self:CN(systemFrame.Selection.Label:GetText())
                    if cn then
                        systemFrame.Selection.Label:SetText(cn)
                    end
                end
                if systemFrame.Selection.VerticalLabel then
                    local cn= self:CN(systemFrame.Selection.VerticalLabel:GetText())
                    if cn then
                        systemFrame.Selection.VerticalLabel:SetText(cn)
                    end
                end
                --self:SetLabel(systemFrame.Selection.HorizontalLabel)
                --self:SetLabel(systemFrame.Selection.Label)
                --self:SetLabel(systemFrame.Selection.VerticalLabel)
            --end
        --end
    end)]]

end


