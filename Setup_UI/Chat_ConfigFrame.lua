

ChatConfigCombatSettings:HookScript('OnShow', function()
    for index, value in pairs(COMBAT_CONFIG_TABS) do--ChatConfigCombat_OnLoad()
        local tab = _G[CHAT_CONFIG_COMBAT_TAB_NAME..index]
        if tab then
            WoWTools_ChineseMixin:SetLabel(tab.Text, value.text)
            PanelTemplates_TabResize(tab, 0)
        end

    end
end)

COMBAT_CONFIG_MESSAGESOURCES_BY[1].text = function () return ( UsesGUID("SOURCE") and '自定义单位' or '我') end
COMBAT_CONFIG_MESSAGESOURCES_TO[1].text = function () return ( UsesGUID("SOURCE") and '自定义单位' or '我') end


local function set_Checkboxes(frame)
    if not FCF_GetCurrentChatFrame() or not frame:IsVisible() then
        return
    end
    local name= frame:GetName()
    WoWTools_ChineseMixin:SetLabel(_G[name.."Title"])
    WoWTools_ChineseMixin:SetLabel(_G[name.."ColorHeader"])

    local check = name.."Checkbox"
	for index in pairs(frame.checkBoxTable or {}) do
		local checkBoxName = check..index
        WoWTools_ChineseMixin:SetLabel(_G[checkBoxName.."CheckText"])
        if _G[checkBoxName] then
		    WoWTools_ChineseMixin:SetLabel(_G[checkBoxName].BlankText)
        end
	end
end
hooksecurefunc('ChatConfig_CreateCheckboxes', set_Checkboxes)
hooksecurefunc('ChatConfig_UpdateCheckboxes', set_Checkboxes)


local function set_TieredCheckboxes(frame)
    if not FCF_GetCurrentChatFrame()  then
        return
    end
    local checkBoxNameString = frame:GetName().."Checkbox"
	local checkBoxName, subCheckboxName, subCheckboxNameString
	for index, value in ipairs(frame.checkBoxTable or {}) do
		checkBoxName = checkBoxNameString..index
        WoWTools_ChineseMixin:SetLabel(_G[checkBoxName.."Text"])
        if ( value.subTypes ) then
            subCheckboxNameString = checkBoxName.."_"
            for k in ipairs(value.subTypes) do
                subCheckboxName = subCheckboxNameString..k
                WoWTools_ChineseMixin:SetLabel(_G[subCheckboxName.."Text"])
            end
        end

	end
end
hooksecurefunc('ChatConfig_CreateTieredCheckboxes', set_TieredCheckboxes)
hooksecurefunc('ChatConfig_UpdateTieredCheckboxes', set_TieredCheckboxes)

local function set_ColorSwatches(frame)
    if not frame or not frame:IsVisible() then
        return
    end
    local frameName= frame:GetName()
    WoWTools_ChineseMixin:SetLabel(_G[frameName.."Title"])
    local nameString = frameName.."Swatch"
    for index in pairs(frame.swatchTable or {}) do
        WoWTools_ChineseMixin:SetLabel(_G[nameString..index.."Text"])
    end
end
hooksecurefunc('ChatConfig_CreateColorSwatches', set_ColorSwatches)
hooksecurefunc('ChatConfig_UpdateSwatches', set_ColorSwatches)


hooksecurefunc('CombatConfig_Colorize_Update', function()
    if ( not CHATCONFIG_SELECTED_FILTER.settings ) then
		return
	end
    WoWTools_ChineseMixin:SetLabel(CombatConfigColorsExampleString1)
    WoWTools_ChineseMixin:SetLabel(CombatConfigColorsExampleString2)
end)
hooksecurefunc('CombatConfig_Formatting_Update', function()
    WoWTools_ChineseMixin:SetLabel(CombatConfigFormattingExampleString1)
	WoWTools_ChineseMixin:SetLabel(CombatConfigFormattingExampleString2)
end)

hooksecurefunc('ChatConfigCombat_InitButton', function(button)
    WoWTools_ChineseMixin:SetLabel(button.NormalText)
end)

hooksecurefunc(ChatWindowTabMixin, 'SetChatWindowIndex', function(frame, chatWindowIndex)
    local text
    if chatWindowIndex ~= VOICE_WINDOW_ID then
        local chatTab = _G["ChatFrame"..chatWindowIndex.."Tab"]
        text= WoWTools_ChineseMixin:CN(chatTab.Text:GetText())
    else
        text= '文本转语音'
    end
    if text then
        frame.Text:SetText(text)
        PanelTemplates_TabResize(frame, 0)
    end
end)





hooksecurefunc('TextToSpeechFrame_UpdateMessageCheckboxes', function(frame)--TextToSpeechFrame.lua
    local checkBoxNameString = frame:GetName().."CheckBox"
    for index in pairs(frame.checkBoxTable or {}) do
        local check= _G[checkBoxNameString..index]
        if check then
            WoWTools_ChineseMixin:SetLabel(check.text)
        end
    end
end)
TextToSpeechCharacterSpecificButtonText:SetText('角色专用设置')


hooksecurefunc('ChatConfigCategoryFrame_Refresh', function()--ChatConfigFrame.lua
    local currentChatFrame = FCF_GetCurrentChatFrame()
    if  CURRENT_CHAT_FRAME_ID == VOICE_WINDOW_ID then
        ChatConfigFrame.Header:Setup('文字转语音选项')
    else
        ChatConfigFrame.Header:Setup(currentChatFrame ~= nil and format('%s设置', WoWTools_ChineseMixin:CN(currentChatFrame.name) or currentChatFrame.name) or "")
    end
end)

hooksecurefunc('FCF_SetWindowName', function(frame, name)--FloatingChatFrame.lua
    local tab = _G[frame:GetName().."Tab"]
    WoWTools_ChineseMixin:SetLabel(tab, name)
    PanelTemplates_TabResize(tab, tab.sizePadding or 0)
end)



for i=1, 7 do
    WoWTools_ChineseMixin:SetLabel(_G['ChatConfigCategoryFrameButton'..i])
end

local channelsWithTtsName =
{
	LOOT = true,
	MONEY = true,
}
hooksecurefunc('TextToSpeechFrame_CreateCheckboxes', function(frame)
	for index, value in pairs(frame.checkBoxTable or {}) do
        local name=  channelsWithTtsName[value] and WoWTools_ChineseMixin:CN(_G[value.."_TTS_LABEL"]) or WoWTools_ChineseMixin:CN(_G[value])
        if name then
            _G[frame:GetName().."Checkbox"..index].text:SetText(name)
        end
	end
end)



CombatConfigColorsExampleTitle:SetText('范例文字：')
CombatConfigFormattingExampleTitle:SetText('范例文字：')
CombatConfigFormattingShowTimeStamp.Text:SetText('显示时间戳')
CombatConfigFormattingShowTimeStamp.tooltip = '显示战斗记录信息的时间戳。'
CombatConfigFormattingShowBraces.Text:SetText('显示括号')
CombatConfigFormattingShowBraces.tooltip = '在战斗记录信息中的超链接外显示括号。'
CombatConfigFormattingUnitNamesText:SetText('单位名称')
CombatConfigFormattingUnitNames.tooltip = '在单位名称外显示括号。'

CombatConfigFormattingSpellNamesText:SetText('法术名')
CombatConfigFormattingSpellNames.tooltip= '在法术名称外显示括号。'
CombatConfigFormattingItemNamesText:SetText('物品名')
CombatConfigFormattingItemNames.tooltip= '在物品名称外显示括号。'
CombatConfigFormattingFullTextText:SetText('使用详细模式')
CombatConfigFormattingItemNames.tooltip= '整句显示战斗记录信息。'
CombatConfigSettingsShowQuickButtonText:SetText('显示快捷按钮')
CombatConfigSettingsShowQuickButton.tooltip= '在聊天窗口中放置一个该过滤条件的快捷方式。'
CombatConfigSettingsSoloText:SetText('独身')
CombatConfigSettingsPartyText:SetText('小队')
CombatConfigSettingsRaidText:SetText('团队')

ChatConfigFrameDefaultButton:SetText('聊天默认')

WoWTools_ChineseMixin:SetButton(ChatConfigFrameRedockButton, nil, nil, nil, true)--:SetText('重置聊天窗口位置')

ChatConfigFrameOkayButton:SetText('确定')
CombatLogDefaultButton:SetText('战斗记录默认')
TextToSpeechDefaultButton:SetText('文字转语音默认设置')

ChatConfigCombatSettingsFiltersCopyFilterButton:SetText('复制')
ChatConfigCombatSettingsFiltersAddFilterButton:SetText('添加')
ChatConfigCombatSettingsFiltersDeleteButton:SetText('删除')
CombatConfigSettingsSaveButton:SetText('保存')

if TextToSpeechFramePlaySampleAlternateButton then--11.2 没有了
    TextToSpeechFramePlaySampleAlternateButton:SetText('播放样本')
    TextToSpeechFramePlaySampleButton:SetText('播放样本')
    TextToSpeechFrameTtsVoiceDropdownLabel:SetText('语音设置"')
    TextToSpeechFrameTtsVoiceDropdownMoreVoicesLabel:SetText('更多信息请查阅|cff00aaff|HurlIndex:56|h支持页面|h|r')
    TextToSpeechFrameAdjustRateSliderLabel:SetText('调节讲话速度')
    TextToSpeechFrameAdjustVolumeSliderLabel:SetText('音量')
    TextToSpeechFrameAdjustRateSliderLow:SetText('慢')
    TextToSpeechFrameAdjustRateSliderHigh:SetText('快')

else
    WoWTools_ChineseMixin:SetButton(TextToSpeechFramePanelContainer.PlaySampleButton)
    WoWTools_ChineseMixin:SetButton(TextToSpeechFramePanelContainer.PlaySampleAlternateButton)
    WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainer.VoiceOptionsLabel)
    WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainer.MoreVoicesURLContainer.Text)
    WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainer.AdjustRateSlider.Text)
    WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainer.AdjustRateSlider.Low)
    WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainer.AdjustRateSlider.High)
    WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainer.UseAlternateVoiceForSystemMessagesCheckButton.text)
    WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainer.AdjustVolumeSlider.Text)
end

TextToSpeechFramePanelContainer.PlaySoundSeparatingChatLinesCheckButton.text:SetText('每条新信息之间播放声音')
TextToSpeechFramePanelContainer.PlayActivitySoundWhenNotFocusedCheckButton.text:SetText('某个聊天窗口有活动，而且不是当前焦点窗口时，播放一个音效')
TextToSpeechFramePanelContainer.AddCharacterNameToSpeechCheckButton.text:SetText('在语音中添加<角色名说>')
TextToSpeechFramePanelContainer.NarrateMyMessagesCheckButton.text:SetText('大声朗读我自己的信息')

WoWTools_ChineseMixin:SetLabel(ChatConfigTextToSpeechMessageSettingsSubTitle)
WoWTools_ChineseMixin:SetLabel(TextToSpeechFramePanelContainerText)--使用另一个声音来朗读系统信息
ChatConfigTextToSpeechMessageSettingsSubTitle:SetText('对特定信息开启文字转语音')

TextToSpeechButton:HookScript('OnEnter', function()--TextToSpeech.lua
    GameTooltip_SetTitle(GameTooltip, '文字转语音选项')
    GameTooltip:Show()
end)

ChannelFrameTitleText:SetText('聊天频道')
ChannelFrame.NewButton:SetText('添加')
ChannelFrame.SettingsButton:SetText('设置')
CreateChannelPopup.UseVoiceChat.Text:SetText('启用语音聊天')
CreateChannelPopup.Header.Text:SetText('新建频道')
CreateChannelPopup.Name.Label:SetText('频道名称')
CreateChannelPopup.Password.Label:SetText('密码')
CreateChannelPopup.OKButton:SetText('确定')
CreateChannelPopup.CancelButton:SetText('取消')











ChatFrameChannelButton:SetTooltipFunction(function()--ChannelFrameButtonMixin.lua
    return MicroButtonTooltipText('聊天频道', "TOGGLECHATTAB")
end)

WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeUnitNameCheckText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeSpellNamesCheckText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeSpellNamesSchoolColoringText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeDamageNumberCheckText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeDamageNumberSchoolColoringText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeDamageSchoolCheckText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeEntireLineCheckText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeEntireLineBySourceText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsColorizeEntireLineByTargetText)

WoWTools_ChineseMixin:SetLabel(CombatConfigColorsHighlightingTitle)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsHighlightingLineText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsHighlightingAbilityText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsHighlightingDamageText)
WoWTools_ChineseMixin:SetLabel(CombatConfigColorsHighlightingSchoolText)