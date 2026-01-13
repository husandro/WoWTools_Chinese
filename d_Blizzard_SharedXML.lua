
hooksecurefunc(SliderControlFrameMixin, 'SetupSlider', function(frame, _, _, _, _, label)
    WoWTools_ChineseMixin:SetLabel(frame.Label, label)
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
    WoWTools_ChineseMixin:SetLabel(frame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
    WoWTools_ChineseMixin:SetButton(frame.BorderBox.OkayButton)
    WoWTools_ChineseMixin:SetButton(frame.BorderBox.CancelButton)
    WoWTools_ChineseMixin:HookLabel(frame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription)
end)


--新，字 NEW_CAPS
hooksecurefunc(NewFeatureLabelMixin, 'OnLoad', function(frame)
    WoWTools_ChineseMixin:SetLabel(frame.Label)
    WoWTools_ChineseMixin:SetLabel(frame.BGLabel)
    WoWTools_ChineseMixin:SetLabel(frame.label)
end)

--旅行，地下堡，声望，奖励，等级奖励
hooksecurefunc(RenownLevelMixin, 'SetRewardName', function(frame)
    WoWTools_ChineseMixin:SetLabel(frame.RewardName)
end)