function WoWTools_ChineseMixin.Events:Blizzard_ChatFrame()

    ChatConfigCombatSettings:HookScript('OnShow', function()
        for index, value in pairs(COMBAT_CONFIG_TABS) do--ChatConfigCombat_OnLoad()
            local tab = _G[CHAT_CONFIG_COMBAT_TAB_NAME..index]
            if tab then
                self:SetLabel(tab.Text, value.text)
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
        self:SetLabel(_G[name.."Title"])
        self:SetLabel(_G[name.."ColorHeader"])

        local check = name.."Checkbox"
        for index in pairs(frame.checkBoxTable or {}) do
            local checkBoxName = check..index
            self:SetLabel(_G[checkBoxName.."CheckText"])
            if _G[checkBoxName] then
                self:SetLabel(_G[checkBoxName].BlankText)
            end
        end
    end
    hooksecurefunc('ChatConfig_CreateCheckboxes', function(...) set_Checkboxes(...) end)
    hooksecurefunc('ChatConfig_UpdateCheckboxes', function(...) set_Checkboxes(...) end)


    local function set_TieredCheckboxes(frame)
        if not FCF_GetCurrentChatFrame()  then
            return
        end
        local checkBoxNameString = frame:GetName().."Checkbox"
        local checkBoxName, subCheckboxName, subCheckboxNameString
        for index, value in ipairs(frame.checkBoxTable or {}) do
            checkBoxName = checkBoxNameString..index
            self:SetLabel(_G[checkBoxName.."Text"])
            if ( value.subTypes ) then
                subCheckboxNameString = checkBoxName.."_"
                for k in ipairs(value.subTypes) do
                    subCheckboxName = subCheckboxNameString..k
                    self:SetLabel(_G[subCheckboxName.."Text"])
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
        self:SetLabel(_G[frameName.."Title"])
        local nameString = frameName.."Swatch"
        for index in pairs(frame.swatchTable or {}) do
            self:SetLabel(_G[nameString..index.."Text"])
        end
    end
    hooksecurefunc('ChatConfig_CreateColorSwatches', set_ColorSwatches)
    hooksecurefunc('ChatConfig_UpdateSwatches', set_ColorSwatches)

    --[[
    hooksecurefunc('CombatConfig_Colorize_Update', function()
        if ( not CHATCONFIG_SELECTED_FILTER.settings ) then
            return
        end
        self:SetLabel(CombatConfigColorsExampleString1)
        self:SetLabel(CombatConfigColorsExampleString2)
    end)
    hooksecurefunc('CombatConfig_Formatting_Update', function()
        --self:SetLabel(CombatConfigFormattingExampleString1)
        --self:SetLabel(CombatConfigFormattingExampleString2)
        local text, r, g, b = CombatLog_OnEvent(CHATCONFIG_SELECTED_FILTER, 0, "SPELL_DAMAGE", false, 0x0000000000000001, UnitName("player"), 0x511, 0, 0xF13000012B000820, '怪物', 0x10a28, 0, 116, '寒冰箭', Enum.Damageclass.MaskFrost, 27, Enum.Damageclass.MaskFrost, nil, nil, nil, 1, nil, nil)
        if text then
            CombatConfigFormattingExampleString1:SetText(text)
        end

        text = CombatLog_OnEvent(CHATCONFIG_SELECTED_FILTER, 0, "SPELL_DAMAGE", false, 0xF13000024D002914, '怪物', 0x10a48, 0, 0x0000000000000001, UnitName("player"), 0x511, 0, 20793, '火球术', Enum.Damageclass.MaskFire, 68, Enum.Damageclass.MaskFire, nil, nil, nil, nil, nil, nil)
        if text then
            CombatConfigFormattingExampleString2:SetText(text)
        end
    end)]]

    hooksecurefunc('ChatConfigCombat_InitButton', function(button)
        self:SetLabel(button.NormalText)
    end)

    hooksecurefunc(ChatWindowTabMixin, 'SetChatWindowIndex', function(frame, chatWindowIndex)
        local text
        if chatWindowIndex ~= VOICE_WINDOW_ID then
            local chatTab = _G["ChatFrame"..chatWindowIndex.."Tab"]
            text= self:CN(chatTab.Text:GetText())
        else
            text= '文本转语音'
        end
        if text then
            frame.Text:SetText(text)
            PanelTemplates_TabResize(frame, 0)
        end
    end)

    hooksecurefunc('FCF_MinimizeFrame', function(chatFrame)
        local cn= self:CN(chatFrame.name)
        if cn then
            chatFrame.minFrame:SetText(cn)
        end
    end)





    hooksecurefunc('TextToSpeechFrame_UpdateMessageCheckboxes', function(frame)--TextToSpeechFrame.lua
        local checkBoxNameString = frame:GetName().."CheckBox"
        for index in pairs(frame.checkBoxTable or {}) do
            local check= _G[checkBoxNameString..index]
            if check then
                self:SetLabel(check.text)
            end
        end
    end)
    TextToSpeechCharacterSpecificButtonText:SetText('角色专用设置')


    hooksecurefunc('ChatConfigCategoryFrame_Refresh', function()--ChatConfigFrame.lua
        local currentChatFrame = FCF_GetCurrentChatFrame()
        if  CURRENT_CHAT_FRAME_ID == VOICE_WINDOW_ID then
            ChatConfigFrame.Header:Setup('文字转语音选项')
        else
            ChatConfigFrame.Header:Setup(currentChatFrame ~= nil and format('%s设置', self:CN(currentChatFrame.name) or currentChatFrame.name) or "")
        end
    end)

    hooksecurefunc('FCF_SetWindowName', function(frame, name)--FloatingChatFrame.lua
        local tab = _G[frame:GetName().."Tab"]
        self:SetLabel(tab, name)
        PanelTemplates_TabResize(tab, tab.sizePadding or 0)
    end)



    for i=1, 7 do
        self:SetLabel(_G['ChatConfigCategoryFrameButton'..i])
    end

    local channelsWithTtsName =
    {
        LOOT = true,
        MONEY = true,
    }
    hooksecurefunc('TextToSpeechFrame_CreateCheckboxes', function(frame)
        for index, value in pairs(frame.checkBoxTable or {}) do
            local name=  channelsWithTtsName[value] and self:CN(_G[value.."_TTS_LABEL"]) or self:CN(_G[value])
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

    self:SetFrame(CombatConfigSettingsNameEditBox)

    ChatConfigFrameDefaultButton:SetText('聊天默认')

    self:SetButton(ChatConfigFrameRedockButton, nil, nil, nil, true)--:SetText('重置聊天窗口位置')

    ChatConfigFrameOkayButton:SetText('确定')
    CombatLogDefaultButton:SetText('战斗记录默认')
    TextToSpeechDefaultButton:SetText('文字转语音默认设置')

    ChatConfigCombatSettingsFiltersCopyFilterButton:SetText('复制')
    ChatConfigCombatSettingsFiltersAddFilterButton:SetText('添加')
    ChatConfigCombatSettingsFiltersDeleteButton:SetText('删除')
    CombatConfigSettingsSaveButton:SetText('保存')


    self:SetButton(TextToSpeechFramePanelContainer.PlaySampleButton)
    self:SetButton(TextToSpeechFramePanelContainer.PlaySampleAlternateButton)
    self:SetLabel(TextToSpeechFramePanelContainer.VoiceOptionsLabel)
    self:SetLabel(TextToSpeechFramePanelContainer.MoreVoicesURLContainer.Text)
    self:SetLabel(TextToSpeechFramePanelContainer.AdjustRateSlider.Text)
    self:SetLabel(TextToSpeechFramePanelContainer.AdjustRateSlider.Low)
    self:SetLabel(TextToSpeechFramePanelContainer.AdjustRateSlider.High)
    self:SetLabel(TextToSpeechFramePanelContainer.UseAlternateVoiceForSystemMessagesCheckButton.text)
    self:SetLabel(TextToSpeechFramePanelContainer.AdjustVolumeSlider.Text)
    self:SetLabel(ChatConfigTextToSpeechMessageSettings.SubTitle)


    TextToSpeechFramePanelContainer.PlaySoundSeparatingChatLinesCheckButton.text:SetText('每条新信息之间播放声音')
    TextToSpeechFramePanelContainer.PlayActivitySoundWhenNotFocusedCheckButton.text:SetText('某个聊天窗口有活动，而且不是当前焦点窗口时，播放一个音效')
    TextToSpeechFramePanelContainer.AddCharacterNameToSpeechCheckButton.text:SetText('在语音中添加<角色名说>')
    TextToSpeechFramePanelContainer.NarrateMyMessagesCheckButton.text:SetText('大声朗读我自己的信息')

    self:SetLabel(ChatConfigTextToSpeechMessageSettingsSubTitle)
    self:SetLabel(TextToSpeechFramePanelContainerText)--使用另一个声音来朗读系统信息




    TextToSpeechButton:HookScript('OnEnter', function()--TextToSpeech.lua
        GameTooltip_SetTitle(GameTooltip, '文字转语音选项')
        GameTooltip:Show()
    end)


    CreateChannelPopup.UseVoiceChat.Text:SetText('启用语音聊天')
    CreateChannelPopup.Header.Text:SetText('新建频道')
    CreateChannelPopup.Name.Label:SetText('频道名称')
    CreateChannelPopup.Password.Label:SetText('密码')
    CreateChannelPopup.OKButton:SetText('确定')
    CreateChannelPopup.CancelButton:SetText('取消')











    ChatFrameChannelButton:SetTooltipFunction(function()--ChannelFrameButtonMixin.lua
        return MicroButtonTooltipText('聊天频道', "TOGGLECHATTAB")
    end)

    self:SetLabel(CombatConfigColorsColorizeUnitNameCheckText)
    self:SetLabel(CombatConfigColorsColorizeSpellNamesCheckText)
    self:SetLabel(CombatConfigColorsColorizeSpellNamesSchoolColoringText)
    self:SetLabel(CombatConfigColorsColorizeDamageNumberCheckText)
    self:SetLabel(CombatConfigColorsColorizeDamageNumberSchoolColoringText)
    self:SetLabel(CombatConfigColorsColorizeDamageSchoolCheckText)
    self:SetLabel(CombatConfigColorsColorizeEntireLineCheckText)
    self:SetLabel(CombatConfigColorsColorizeEntireLineBySourceText)
    self:SetLabel(CombatConfigColorsColorizeEntireLineByTargetText)

    self:SetLabel(CombatConfigColorsHighlightingTitle)
    self:SetLabel(CombatConfigColorsHighlightingLineText)
    self:SetLabel(CombatConfigColorsHighlightingAbilityText)
    self:SetLabel(CombatConfigColorsHighlightingDamageText)
    self:SetLabel(CombatConfigColorsHighlightingSchoolText)
end









function WoWTools_ChineseMixin.Events:Blizzard_Channels()
    ChannelFrameTitleText:SetText('聊天频道')
    ChannelFrame.NewButton:SetText('添加')
    ChannelFrame.SettingsButton:SetText('设置')
    self:HookLabel(ChannelFrame.ChannelRoster.ChannelName)
end