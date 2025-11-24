function WoWTools_ChineseMixin.Events:Blizzard_SharedXML()
    hooksecurefunc(SliderControlFrameMixin, 'SetupSlider', function(frame, _, _, _, _, label)
        self:SetLabel(frame.Label, label)
    end)

    hooksecurefunc('SearchBoxTemplate_OnLoad', function(frame)--SharedUIPanelTemplates.lua
        frame.Instructions:SetText('搜索')
    end)
    if _G['Main_HelpPlate_Button_ShowTooltip'] then--11.1.5 无
        hooksecurefunc('Main_HelpPlate_Button_ShowTooltip', function(frame)
            HelpPlateTooltip.Text:SetText(frame.MainHelpPlateButtonTooltipText or '点击这里打开/关闭本窗口的帮助系统。')
        end)
    end

    hooksecurefunc(SearchBoxListMixin, 'UpdateSearchPreview', function(frame, finished, dbLoaded, numResults)
        if finished and not frame.searchButtons[numResults] then
            frame.showAllResults.text:SetFormattedText('显示全部%d个结果', numResults)
        end
    end)
    hooksecurefunc(IconSelectorPopupFrameTemplateMixin, 'OnLoad', function(frame)
        self:SetLabel(frame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
        self:SetButton(frame.BorderBox.OkayButton)
        self:SetButton(frame.BorderBox.CancelButton)
        self:HookLabel(frame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription)
        --self:HookLabel(frame.BorderBox.IconTypeDropdown.Text)
    end)
    --[[hooksecurefunc(IconSelectorPopupFrameTemplateMixin, 'SetSelectedIconText', function(frame)
        if ( frame:GetSelectedIndex() ) then
            frame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription:SetText('点击在列表中浏览')
        else
            frame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription:SetText('此图标不在列表中')
        end
    end)]]

--新，字 NEW_CAPS
    hooksecurefunc(NewFeatureLabelMixin, 'OnLoad', function(frame)
        self:SetLabel(frame.Label)
    end)
end