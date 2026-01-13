function WoWTools_ChineseMixin.Events:Blizzard_MacroUI()
    self:SetFrame(MacroFrame)
    MacroFrameTab1:SetText('通用宏')
    MacroFrameTab2:SetText('专用宏', 0.3)
    MacroSaveButton:SetText('保存')
    MacroCancelButton:SetText('取消')
    MacroDeleteButton:SetText('删除')
    MacroNewButton:SetText('新建')
    MacroExitButton:SetText('退出')
    self:AddDialogs("CONFIRM_DELETE_SELECTED_MACRO", {text= '确定要删除这个宏吗？', button1= '是', button2= '取消'})

    self:SetLabel(MacroPopupFrame.BorderBox.EditBoxHeaderText)
    self:SetLabel(MacroPopupFrame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
    self:SetButton(MacroPopupFrame.BorderBox.CancelButton)
    self:SetButton(MacroPopupFrame.BorderBox.OkayButton)
end







--公会银行
function WoWTools_ChineseMixin.Events:Blizzard_GuildBankUI()
    GuildBankFrameTab1:SetText('公会银行')
    GuildItemSearchBox.Instructions:SetText('搜索')
    GuildBankFrame.WithdrawButton:SetText('提取')
    GuildBankFrame.DepositButton:SetText('存放')
    GuildBankMoneyLimitLabel:SetText('可用数量：')
    hooksecurefunc(GuildBankFrame, 'UpdateTabs', function(frame)--Blizzard_GuildBankUI.lua
        local name, isViewable, canDeposit, numWithdrawals, remainingWithdrawals, disableAll, titleText, withdrawalText
        local numTabs = GetNumGuildBankTabs()
        local currentTab = GetCurrentGuildBankTab()
        -- Set buyable tab
        local tabToBuyIndex
        if ( numTabs < MAX_BUY_GUILDBANK_TABS ) then
            tabToBuyIndex = numTabs + 1
        end
        -- Disable and gray out all tabs if in the moneyLog since the tab is irrelevant
        if ( frame.mode == "moneylog" ) then
            disableAll = 1
        end
        for i=1, MAX_GUILDBANK_TABS do
            local tab = frame.BankTabs[i]
            local tabButton = tab.Button
            name, _, isViewable = GetGuildBankTabInfo(i)
            if ( not name or name == "" ) then
                name = format('标签%d', i)
            end
            if ( i == tabToBuyIndex and IsGuildLeader() ) then
                tabButton.tooltip = '购买新的公会银行标签'
                if ( disableAll or frame.mode == "log" or frame.mode == "tabinfo" ) then
                else
                    if ( i == currentTab ) then
                        titleText = '购买新的公会银行标签'
                    end
                end
            elseif ( i > numTabs ) then
            else
                if ( isViewable ) then
                    if ( i == currentTab ) then
                        withdrawalText = name
                        titleText =  name
                    end
                end
            end
        end

        -- Set Title
        if ( frame.mode == "moneylog" ) then
            titleText = '金币记录'
            withdrawalText = nil
        elseif ( frame.mode == "log" ) then
            if ( titleText ) then
                titleText = format('%s 记录', titleText)
            end
        elseif ( frame.mode == "tabinfo" ) then
            withdrawalText = nil
            if ( titleText ) then
                titleText = format('%s 信息', titleText)
            end
        end
        -- Get selected tab info
        name, _, _, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo(currentTab)
        if ( titleText and (frame.mode ~= "moneylog" and titleText ~= BUY_GUILDBANK_TAB) ) then
            local access
            if ( not canDeposit and numWithdrawals == 0 ) then
                access = '|cffff2020（锁定）|r'
            elseif ( not canDeposit ) then
                access = '|cffff2020（只能提取）|r'
            elseif ( numWithdrawals == 0 ) then
                access = '|cffff2020（只能存放）|r'
            else
                access = '|cff20ff20（全部权限）|r'
            end
            titleText = titleText.."  "..access
        end
        if ( titleText ) then
            frame.TabTitle:SetText(titleText)
        end
        if ( withdrawalText ) then
            local stackString
            if ( remainingWithdrawals > 0 ) then
                stackString = format('%d 堆', remainingWithdrawals)
            elseif ( remainingWithdrawals == 0 ) then
                stackString = '无'
            else
                stackString = '无限'
            end
            frame.LimitLabel:SetText(format('%s的每日提取额度剩余：|cffffffff%s|r', withdrawalText, stackString))
        end
    end)
    GuildBankFrameTab2:SetText('记录')
    GuildBankFrameTab3:SetText('金币记录')
    GuildBankFrameTab4:SetText('信息')
    GuildBankInfoSaveButton:SetText('保存改变')

    self:SetLabel(GuildBankPopupFrame.BorderBox.EditBoxHeaderText)
    self:SetLabel(GuildBankPopupFrame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
    GuildBankPopupFrame.BorderBox.OkayButton:SetText('确定')
    GuildBankPopupFrame.BorderBox.CancelButton:SetText('取消')

    self:SetLabel(GuildBankFrame.BuyInfo.TabText)
    self:SetButton(GuildBankFrame.BuyInfo.PurchaseButton)
end









--玩家, 观察角色, 界面
function WoWTools_ChineseMixin.Events:Blizzard_InspectUI()
    InspectFrameTab1:SetText('角色')
        --pvp
        hooksecurefunc('InspectPVPFrame_Update', function()
            local _, _, _, _, lifetimeHKs, _, honorLevel = GetInspectHonorData()
            InspectPVPFrame.HKs:SetFormattedText('|cffffd200荣誉消灭：|r %d', lifetimeHKs or 0)
            if C_SpecializationInfo.CanPlayerUsePVPTalentUI() then
                InspectPVPFrame.HonorLevel:SetFormattedText('荣誉等级：%d', honorLevel)
            end
        end)
    InspectFrameTab3:SetText('公会')

    self:SetFrames(InspectPVPFrame)
    --self:SetLabel(InspectPVPFrame.RatedBG.RatingLabel)

end





function WoWTools_ChineseMixin.Events:Blizzard_ArtifactUI()
    --Blizzard_ArtifactUI.lua
    self:AddDialogs("CONFIRM_ARTIFACT_RESPEC", {text = '确定要重置你的神器专长吗？|n|n这将消耗%s点|cffe6cc80神器能量|r。', button1 = '是', button2 = '否'})
    self:AddDialogs("NOT_ENOUGH_POWER_ARTIFACT_RESPEC", {text = '你没有足够的|cffe6cc80神器能量|r来重置你的专长。|n|n需要%s点|cffe6cc80神器能量|r。', button1 = '确定'})

    --Blizzard_ArtifactPerks.lua
    self:AddDialogs("CONFIRM_RELIC_REPLACE", {text = '你确定要替换此圣物吗？已有的圣物将被摧毁。', button1 = '接受', button2 = '取消'})

    hooksecurefunc(ArtifactFrame, 'SetTab', function()
        self:SetLabel(ArtifactFrameTab1)
	    self:SetLabel(ArtifactFrameTab2)
    end)

    --Blizzard_ArtifactPerks.lua ArtifactTitleTemplateMixin
    self:SetLabel(ArtifactFrame.PerksTab.TitleContainer.ArtifactPower)
    self:SetFrame(ArtifactFrame.PerksTab.DisabledFrame, nil, nil, 2)
    hooksecurefunc(ArtifactFrame.PerksTab.TitleContainer, 'RefreshTitle', function(frame)
        local itemID, itemName= C_ArtifactUI.GetArtifactInfo()
        if not itemID then
            return
        end
        local name = self:GetItemName(itemID) or self:SetText(itemName)
        if name then
            if C_ArtifactUI.IsArtifactDisabled() then
                frame:GetParent().DisabledFrame.ArtifactName:SetText(name)
            else
                frame.ArtifactName:SetText(name);
            end
        end
    end)
end



function WoWTools_ChineseMixin.Events:Blizzard_Soulbinds()
    self:AddDialogs("SOULBIND_DIALOG_MOVE_CONDUIT", {text = '一个导灵器只能同时被放置在一个插槽内，所以之前插槽里的该导灵器已被移除。', button1 = '接受'})
    self:AddDialogs("SOULBIND_DIALOG_INSTALL_CONDUIT_UNUSABLE", {text = '此插槽目前未激活。你确定想在此添加一个导灵器吗？', button1 = '接受', button2 = '取消'})
end
function WoWTools_ChineseMixin.Events:Blizzard_AnimaDiversionUI()
    self:AddDialogs("ANIMA_DIVERSION_CONFIRM_CHANNEL", {text = '你确定想引导心能到%s吗？|n|n|cffffd200%s|r', button1 = '是', button2 = '取消'})
    self:AddDialogs("ANIMA_DIVERSION_CONFIRM_REINFORCE", {text = '你确定想强化%s吗？|n|n|cffffd200这样会永久激活此地点，而且无法撤销。|r', button1 = '是', button2 = '取消'})
    self:AddDialogs("SOULBIND_CONDUIT_NO_CHANGES_CONFIRMATION", {text = '你对你的导灵器进行了改动，但并没有应用这些改动。你确定想要离开吗？', button1 = '离开', button2 = '取消'})
end
function WoWTools_ChineseMixin.Events:Blizzard_CovenantSanctum()
    self:AddDialogs("CONFIRM_ARTIFACT_RESPEC", {button1 = '是', button2 = '否'})
    self:HookDialog("CONFIRM_ARTIFACT_RESPEC", 'OnShow', function(frame, data)
        if data then
            local costString = GetGarrisonTalentCostString(data.talent)
            local t= frame.text or frame:GetTextFontString()
            t:SetFormattedText('把|cff20ff20%s|r升到%d级会花费|n%s', data.talent.name, data.talent.tier + 1, costString)
        end
    end)
end
function WoWTools_ChineseMixin.Events:Blizzard_GarrisonTemplates()
    self:AddDialogs("CONFIRM_FOLLOWER_UPGRADE", {button1 = '是', button2 = '否'})
    self:AddDialogs("CONFIRM_FOLLOWER_ABILITY_UPGRADE", {button1 = '是', button2 = '否'})
    self:AddDialogs("CONFIRM_FOLLOWER_TEMPORARY_ABILITY", {text = '确定要赋予%s这个临时技能吗？', button1 = '是', button2 = '否'})
    self:AddDialogs("CONFIRM_FOLLOWER_EQUIPMENT", {button1 = '是', button2 = '否'})
end
function WoWTools_ChineseMixin.Events:Blizzard_ClassTrial()
    self:AddDialogs("CLASS_TRIAL_CHOOSE_BOOST_TYPE", {text = '你希望使用哪种角色直升？', button1 = '接受', button2 = '接受', button3 = '取消'})
    self:AddDialogs("CLASS_TRIAL_CHOOSE_BOOST_LOGOUT_PROMPT", {text = '要使用此角色直升服务，请登出游戏，返回角色选择界面。', button1 = '立刻返回角色选择画面', button2 = '取消'})
end





--要塞
function WoWTools_ChineseMixin.Events:Blizzard_GarrisonUI()
    self:AddDialogs("DEACTIVATE_FOLLOWER", {button1 = '是', button2 = '否'})
    self:HookDialog("DEACTIVATE_FOLLOWER", 'OnShow', function(frame)
        local quality = C_Garrison.GetFollowerQuality(frame.data)
        local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(frame.data)..FONT_COLOR_CODE_CLOSE
        local cost = GetMoneyString(C_Garrison.GetFollowerActivationCost())
        local uses = C_Garrison.GetNumFollowerDailyActivations()
        local t= frame.text or frame:GetTextFontString()
        t:SetFormattedText('确定要遣散|n%s吗？|n|n重新激活一名追随者需要花费%s。|n你每天可重新激活%d名追随者。', name, cost, uses)
    end)

    self:AddDialogs("ACTIVATE_FOLLOWER", {button1 = '是', button2 = '否'})
    self:HookDialog("ACTIVATE_FOLLOWER", 'OnShow', function(frame)
        local quality = C_Garrison.GetFollowerQuality(frame.data)
        local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(frame.data)..FONT_COLOR_CODE_CLOSE
        local cost = GetMoneyString(C_Garrison.GetFollowerActivationCost())
        local uses = C_Garrison.GetNumFollowerDailyActivations()
        local t= frame.text or frame:GetTextFontString()
        t:SetFormattedText('确定要激活|n%s吗？|n|n你今天还能激活%d名追随者，这将花费：', name, cost, uses)
    end)

    self:AddDialogs("CONFIRM_RECRUIT_FOLLOWER", {text  = '确定要招募%s吗？', button1 = '是', button2 = '否'})

    self:AddDialogs("DANGEROUS_MISSIONS", {button1 = '确定', button2 = '取消'})
    self:HookDialog("DANGEROUS_MISSIONS", 'OnShow', function(frame)
        local warningIconText = "|T" .. STATICPOPUP_TEXTURE_ALERT .. ":15:15:0:-2|t"
        local t= frame.text or frame:GetTextFontString()
        t:SetFormattedText('|n %s |cffff2020警告！|r %s |n|n你即将执行一项高危行动。如果行动失败，所有参与任务的舰船都有一定几率永久损毁。', warningIconText, warningIconText)
    end)

    self:AddDialogs("GARRISON_SHIP_RENAME", {text  = '输入你想要的名字：', button1 = '接受', button2 = '取消', button3= '默认'})

    self:AddDialogs("GARRISON_SHIP_DECOMMISSION", {button1 = '是', button2 = '否'})
    self:HookDialog("GARRISON_SHIP_DECOMMISSION", 'OnShow', function(frame)
        local quality = C_Garrison.GetFollowerQuality(frame.data.followerID)
        local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(frame.data.followerID)..FONT_COLOR_CODE_CLOSE
        local t= frame.text or frame:GetTextFontString()
        t:SetFormattedText('你确定要永久报废|n%s吗？|n|n你将无法重新获得这艘舰船。', name)
    end)

    self:AddDialogs("GARRISON_CANCEL_UPGRADE_BUILDING", {text  = '确定要取消这次建筑升级吗？升级的费用将被退还。', button1 = '是', button2 = '否'})
    self:AddDialogs("GARRISON_CANCEL_BUILD_BUILDING", {text  = '确定要取消建造这座建筑吗？建造的费用将被退还。', button1 = '是', button2 = '否'})
    self:AddDialogs("COVENANT_MISSIONS_CONFIRM_ADVENTURE", {text  = '开始冒险？', button1 = '确认', button2 = '取消'})
    self:AddDialogs("COVENANT_MISSIONS_HEAL_CONFIRMATION", {text  = '你确定要彻底治愈这名追随者吗？', button1 = '确认', button2 = '取消'})
    self:AddDialogs("COVENANT_MISSIONS_HEAL_ALL_CONFIRMATION", {text  = '你确定要付出%s，治疗所有受伤的伙伴？', button1 = '治疗全部', button2 = '取消'})
--报告
    self:SetLabel(GarrisonLandingPageTab1Text)
    self:HookLabel(GarrisonLandingPageReport.Title)
    self:HookLabel(GarrisonLandingPageReportList.EmptyMissionText)
    hooksecurefunc('GarrisonLandingPageReportList_UpdateItems', function()
        local garrTypeID = GarrisonLandingPage.garrTypeID;

        GarrisonLandingPageReport.InProgress.Text:SetFormattedText('进行中 - %d', #GarrisonLandingPageReport.List.items)

        local availableString = garrTypeID == Enum.GarrisonType.Type_9_0_Garrison and '可选 - %d' or '可选任务：%d';
        GarrisonLandingPageReport.Available.Text:SetFormattedText(availableString, #GarrisonLandingPageReport.List.AvailableItems)
    end)
--追随者
    self:SetLabel(GarrisonLandingPageTab2Text)
    self:SetLabel(GarrisonLandingPageFollowerList.LandingPageHeader)
--
    self:SetLabel(GarrisonLandingPageTab3Text)
end








function WoWTools_ChineseMixin.Events:Blizzard_RuneforgeUI()
    self:AddDialogs("CONFIRM_RUNEFORGE_LEGENDARY_CRAFT", {button1 = '是', button2 = '否'})
    self:HookDialog("CONFIRM_RUNEFORGE_LEGENDARY_CRAFT", 'OnShow', function(frame, data)
        local t= frame.text or frame:GetTextFontString()
        local cn= WoWTools_ChineseMixin:CN(data.title)
        if cn then
           t:SetText(cn)
        else
            local text= data and data.title
            if text then
                local a= string.match(text, self:Magic(RUNEFORGE_LEGENDARY_UPGRADING_CONFIRMATION))
                local b= string.match(text, self:Magic(RUNEFORGE_LEGENDARY_CRAFTING_CONFIRMATION))
                if a then
                    t:SetFormattedText('你确定要花费%s给这件传说装备升级吗？', a)
                elseif b then
                    t:SetFormattedText('你确定要花费%s打造这件传说装备吗？', b)
                end
            end
        end
    end)
end












function WoWTools_ChineseMixin.Events:Blizzard_ClickBindingUI()
    self:AddDialogs("CONFIRM_LOSE_UNSAVED_CLICK_BINDINGS", {text  = '你有未保存的点击施法按键绑定。如果你现在关闭，会丢失所有改动。', button1 = '确定', button2 = '取消'})
    self:AddDialogs("CONFIRM_RESET_CLICK_BINDINGS", {text  = '确定将所有点击施法按键绑定重置为默认值吗？\n', button1 = '确定', button2 = '取消'})

    self:SetLabel(ClickBindingFrame.MouseoverCastKeyDropdown.Label)
    ClickBindingFrameTitleText:SetText('关于点击施法按键绑定')
    ClickBindingFrame.TutorialFrame:SetTitle('关于点击施法按键绑定')

    ClickBindingFrame.SaveButton:SetText('保存')
    ClickBindingFrame.AddBindingButton:SetText('添加绑定')
    ClickBindingFrame.ResetButton:SetText('恢复默认设置')
    ClickBindingFrame.EnableMouseoverCastCheckbox.Label:SetText('鼠标悬停施法')
    ClickBindingFrame.EnableMouseoverCastCheckbox:HookScript('OnEnter', function()
        GameTooltip:SetText('启用后，鼠标悬停到一个单位框体并使用一个键盘快捷键施放法术时，会直接对该单位施法，无需将该单位设为目标。', nil, nil, nil, nil, true)

    end)
    --ClickBindingFrame.MouseoverCastKeyDropDown.Label:SetText('鼠标悬停施法按键')
    ClickBindingFrame.TutorialFrame.SummaryText:SetText('将法术和宏绑定到鼠标点击')
    ClickBindingFrame.TutorialFrame.InfoText:SetText('通过点击单位框体施放绑定的法术和宏')
    ClickBindingFrame.TutorialFrame.AlternateText:SetText('可以使用Shift键、Ctrl键或者Alt键来设定其他的点击绑定')
    ClickBindingFrame.TutorialFrame.ThrallName:SetText('萨尔')
    --[[ClickBindingFrame.SpellbookPortrait:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, MicroButtonTooltipText('法术书和专业', "TOGGLESPELLBOOK"))
        GameTooltip:Show()
    end)]]
    ClickBindingFrame.MacrosPortrait:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '宏')
        GameTooltip:Show()
    end)

    local function NameAndIconFromElementData(elementData)
        if elementData.bindingInfo then
            local bindingInfo = elementData.bindingInfo
            local type = bindingInfo.type
            local actionID = bindingInfo.actionID

            local actionName
            if type == Enum.ClickBindingType.Spell or type == Enum.ClickBindingType.PetAction then
                local overrideID = FindSpellOverrideByID(actionID)
                actionName = C_Spell.GetSpellName(overrideID)
            elseif type == Enum.ClickBindingType.Macro then
                local macroName
                macroName = GetMacroInfo(actionID)
                actionName = format('%s (宏)', macroName)
            elseif type == Enum.ClickBindingType.Interaction then
                if actionID == Enum.ClickBindingInteraction.Target then
                    actionName = '目标单位框架 (默认)'
                elseif actionID == Enum.ClickBindingInteraction.OpenContextMenu then
                    actionName = '打开上下文菜单 (默认)'
                end
            end
            return actionName
        elseif elementData.elementType == 1 then
            return '默认鼠标绑定'
        elseif elementData.elementType == 3 then
            return '自定义鼠标绑定'
        elseif elementData.elementType == 5 then
            return '空'
        end
    end
    --ClickBindingFrame.ScrollBox
    hooksecurefunc(ClickBindingFrame, 'SetUnboundText', function(frame, elementData)
        frame.UnboundText:SetFormattedText('%s 解除绑定', NameAndIconFromElementData(elementData))
    end)

    local ButtonStrings = {
        LeftButton = '左键',
        Button1 = '左键',
        RightButton = '右键',
        Button2 = '右键',
        MiddleButton = '中键',
        Button3 = '中键',
        Button4 = '按键4',
        Button5 = '按键5',
        Button6 = '按键6',
        Button7 = '按键7',
        Button8 = '按键8',
        Button9 = '按键9',
        Button10 = '按键10',
        Button11 = '按键11',
        Button12 = '按键12',
        Button13 = '按键13',
        Button14 = '按键14',
        Button15 = '按键15',
        Button16 = '按键16',
        Button17 = '按键17',
        Button18 = '按键18',
        Button19 = '按键19',
        Button20 = '按键20',
        Button21 = '按键21',
        Button22 = '按键22',
        Button23 = '按键23',
        Button24 = '按键24',
        Button25 = '按键25',
        Button26 = '按键26',
        Button27 = '按键27',
        Button28 = '按键28',
        Button29 = '按键29',
        Button30 = '按键30',
        Button31 = '按键31',
    }

    local function BindingTextFromElementData(elementData)
        if elementData.elementType == 5 then
            local bindingText = elementData.bindingInfo and '鼠标移到该位置并点击一个鼠标按键来进行绑定' or '点击一个法术或宏以开始'
            return GREEN_FONT_COLOR:WrapTextInColorCode(bindingText)
        end

        local bindingInfo = elementData.bindingInfo
        if not bindingInfo or not bindingInfo.button then
            return RED_FONT_COLOR:WrapTextInColorCode('解除绑定 - 把鼠标移到目标上并点击来设置')
        end

        local buttonString = ButtonStrings[bindingInfo.button]
        local modifierText = C_ClickBindings.GetStringFromModifiers(bindingInfo.modifiers)
        if modifierText ~= "" then
            return format('%s-%s', modifierText, buttonString)
        else
            return buttonString
        end
    end
    local function ColoredNameAndIconFromElementData(elementData)
        local name = NameAndIconFromElementData(elementData)
        local isDisabled
        if elementData.elementType == 5 then
            isDisabled = (elementData.bindingInfo == nil)
        else
            isDisabled = elementData.unbound
        end
        if isDisabled then
            name = DISABLED_FONT_COLOR:WrapTextInColorCode(name)
        end
        return name
    end
    hooksecurefunc(ClickBindingLineMixin, 'Init', function(frame, elementData)
        local name= BindingTextFromElementData(elementData)
        --self:SetLabel(frame.BindingText)--, BindingTextFromElementData(elementData))
        if name then
            frame.BindingText:SetText(name)
        end

        name= ColoredNameAndIconFromElementData(elementData)
        if name then
            frame.Name:SetText(name)
        end
        --self:SetLabel(frame.Name)--, ColoredNameAndIconFromElementData(elementData))
    end)
    hooksecurefunc(ClickBindingHeaderMixin, 'Init', function(frame, elementData)
        local name= ColoredNameAndIconFromElementData(elementData)
        if name then
            frame.Name:SetText(name)
        end
        --self:SetLabel(frame.Name)--, ColoredNameAndIconFromElementData(elementData))
    end)
end









function WoWTools_ChineseMixin.Events:Blizzard_ProfessionsTemplates()
    self:AddDialogs("PROFESSIONS_RECRAFT_REPLACE_OPTIONAL_REAGENT", {button1 = '接受', button2 = '取消'})
    self:HookDialog("PROFESSIONS_RECRAFT_REPLACE_OPTIONAL_REAGENT", 'OnShow', function(frame, data)
        (frame.text or frame:GetTextFontString()):SetFormattedText(
            '你想替换%s吗？\n它会在再造时被摧毁。',
            self:GetData(data.itemName, {itemID=data.itemID or C_Item.GetItemInfoInstant(data.itemName) }) or data.itemName or ''
        )
    end)
end






function WoWTools_ChineseMixin.Events:Blizzard_BlackMarketUI()
    self:AddDialogs("BID_BLACKMARKET", {text = '确定要出价%s竞拍以下物品吗？', button1 = '确定', button2 = '取消'})
end







--聊天框，战斗记录
function WoWTools_ChineseMixin.Events:Blizzard_CombatLog()
    local function set_filter(frame)
        if not frame then
            return
        end
        for index, tab in pairs(frame) do
            if type(tab)=='table' then
                local name= tab.name
                local quickButtonName= tab.quickButtonName
                local tooltip= tab.tooltip
                name= name and self:SetText(name)
                quickButtonName= quickButtonName and self:SetText(quickButtonName)
                tooltip= tooltip and self:SetText(tooltip)
                if name then
                    frame[index].name= name
                end
                if quickButtonName then
                    frame[index].quickButtonName= quickButtonName
                end
                if tooltip then
                    frame[index].tooltip= tooltip
                end
            end
        end
    end
    set_filter(Blizzard_CombatLog_Filter_Defaults.filters)
    set_filter(Blizzard_CombatLog_Filters.filters )
end





--装备升级,界面
function WoWTools_ChineseMixin.Events:Blizzard_ItemUpgradeUI()
    ItemUpgradeFrameTitleText:SetText('物品升级')
    ItemUpgradeFrame.UpgradeButton:SetText('升级')
    ItemUpgradeFrame.ItemInfo.MissingItemText:SetText('将物品拖曳至此处升级。')
    ItemUpgradeFrame.MissingDescription:SetText('许多可装备的物品都可以进行升级，从而提高其物品等级。不同来源的物品升级所需的货币也各不相同。')
    ItemUpgradeFrame.ItemInfo.UpgradeTo:SetText('升级至：')
    ItemUpgradeFrame.UpgradeCostFrame.Label:SetText('总花费：')
    hooksecurefunc(ItemUpgradeFrame, 'PopulatePreviewFrames', function(frame)
        if frame.FrameErrorText:IsShown() then
            self:SetLabel(frame.FrameErrorText)--该物品已经升到满级了
        end
    end)
end



--小时图，时间
function WoWTools_ChineseMixin.Events:Blizzard_TimeManager()
    TimeManagerStopwatchFrameText:SetText('显示秒表')
    TimeManagerAlarmTimeLabel:SetText('提醒时间')
    TimeManagerAlarmMessageLabel:SetText('提醒信息')
    TimeManagerAlarmEnabledButtonText:SetText('开启提醒')
    TimeManagerMilitaryTimeCheckText:SetText('24小时模式')
    TimeManagerLocalTimeCheckText:SetText('使用本地时间')
    StopwatchTitle:SetText('秒表')
    hooksecurefunc('GameTime_UpdateTooltip', function()--GameTime.lua
        GameTooltip:SetText('时间信息', HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        GameTooltip:AddDoubleLine( '服务器时间：', GameTime_GetGameTime(true), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        GameTooltip:AddDoubleLine( '本地时间：', GameTime_GetLocalTime(true), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
    end)

end









--套装, 转换
function WoWTools_ChineseMixin.Events:Blizzard_ItemInteractionUI()
    ItemInteractionFrame.CurrencyCost.Costs:SetText('花费：')
    self:AddDialogs("ITEM_INTERACTION_CONFIRMATION_DELAYED", {button2 = '取消'})
    self:AddDialogs("ITEM_INTERACTION_CONFIRMATION_DELAYED_WITH_CHARGE_INFO", {button2 = '取消'})
end




function WoWTools_ChineseMixin.Events:Blizzard_MajorFactions()
    --解锁
    hooksecurefunc(MajorFactionButtonUnlockedStateMixin, 'Refresh', function(frame, majorFactionData)--Blizzard_MajorFactionsLandingTemplates.lua
        self:SetLabel(frame.Title, majorFactionData.name)
        frame.RenownLevel:SetFormattedText('%d级', majorFactionData.renownLevel or 0)
    end)
--没解锁
    hooksecurefunc(MajorFactionButtonLockedStateMixin, 'Refresh', function(frame, majorFactionData)
        self:SetLabel(frame.Title, majorFactionData.name)
        self:SetLabel(frame.StateInfo)
    end)

    hooksecurefunc(MajorFactionWatchFactionButtonMixin, 'OnLoad', function(frame)
        frame.Label:SetText('显示为经验条')
    end)

    --Blizzard_MajorFactionRenown.lua
    if MajorFactionRenownFrame and MajorFactionRenownFrame.SetUpMajorFactionData then--12.0没有了
        hooksecurefunc(MajorFactionRenownFrame, 'SetUpMajorFactionData', function(frame)
            local majorFactionData = C_MajorFactions.GetMajorFactionData(frame.majorFactionID) or {}
            if majorFactionData.name and majorFactionData.currentFactionID ~= frame.majorFactionID then
                self:SetLabel(frame.TrackFrame.Title, majorFactionData.name)
            end
        end)
    end
end


function WoWTools_ChineseMixin.Events:Blizzard_CustomizationUI()
    hooksecurefunc(CustomizationOptionCheckButtonMixin, 'SetupOption', function(frame)
        self:SetLabel(frame.Label)
    end)

    hooksecurefunc(CustomizationDropdownWithSteppersAndLabelMixin, 'SetupOption', function(lable, optionData)
        local cn= WoWTools_ChineseMixin:CN(optionData.name)
        if cn then
            lable:SetText(cn)
        end
    end)

--11.2.7没有了
    if CustomizationDropdownElementDetailsMixin then

        hooksecurefunc(CustomizationDropdownElementDetailsMixin, 'UpdateText', function(region, choiceData)
            if region.SelectionName and region.SelectionName:IsShown() and choiceData then
                local cn= WoWTools_ChineseMixin:CN(choiceData.name)
                if cn then
                    region.SelectionName:SetText(cn)
                end
            end
        end)

        hooksecurefunc(CustomizationDropdownElementDetailsMixin, 'Init', function(region, _, index)
            if not index then
                region.SelectionName:SetText('-选择-');
            end
        end)
    else--11.27
        hooksecurefunc(CustomizationElementDetailsMixin, 'UpdateText', function(frame)
            self:SetLabel(frame.SelectionName)
        end)
        hooksecurefunc(CustomizationElementDetailsMixin, 'Init', function(frame)
            self:SetLabel(frame.SelectionName)
        end)
    end
end

--飞龙，制定界面
function WoWTools_ChineseMixin.Events:Blizzard_CharacterCustomize()
    CharCustomizeFrame.RandomizeAppearanceButton.simpleTooltipLine= '随机外观'
end
--理发店
function WoWTools_ChineseMixin.Events:Blizzard_BarbershopUI()

    BarberShopFrame.CancelButton:SetText('取消')
    BarberShopFrame.ResetButton:SetText('重置')
    BarberShopFrame.AcceptButton:SetText('接受')

    --hooksecurefunc(BarberShopMixin, 'SetCustomizationChoice', function(f, optionID, choiceID)
end


--FSTACK
function WoWTools_ChineseMixin.Events:Blizzard_DebugTools()
    TableAttributeDisplay.VisibilityButton.Label:SetText('显示')
    TableAttributeDisplay.HighlightButton.Label:SetText('高亮')
    TableAttributeDisplay.DynamicUpdateButton.Label:SetText('动态更新')
end


--ETRACE
function WoWTools_ChineseMixin.Events:Blizzard_EventTrace()
    EventTraceTitleText:SetText('事件记录')

    EventTrace.SubtitleBar.ViewLog.Label:SetText('查看日志')
    EventTrace.SubtitleBar.ViewFilter.Label:SetText('过滤器')
    EventTrace.Log.Bar.Label:SetText('记录')
    hooksecurefunc(EventTrace, 'DisplayEvents', function(frame)
        frame.Log.Bar.Label:SetText('记录')
    end)
    hooksecurefunc(EventTrace, 'OnSearchDataProviderChanged', function(frame)
        frame.Log.Bar.Label:SetFormattedText('结果：%d', frame.searchDataProvider:GetSize() or 0)
    end)
    EventTrace.Log.Bar.DiscardAllButton.Label:SetText('全部清除')
    EventTrace.Log.Bar.PlaybackButton.Label:SetText(not EventTrace:IsLoggingPaused() and '开始' or '暂停')
    hooksecurefunc(EventTrace, 'UpdatePlaybackButton', function(frame)
        frame.Log.Bar.PlaybackButton.Label:SetText(not frame:IsLoggingPaused() and '开始' or '暂停')
    end)
    EventTrace.Log.Bar.MarkButton.Label:SetText('标记')

    EventTrace.Filter.Bar.Label:SetText('过滤')
    EventTrace.Filter.Bar.DiscardAllButton.Label:SetText('全部删除')
    EventTrace.Filter.Bar.UncheckAllButton.Label:SetText('全部取消')
    EventTrace.Filter.Bar.CheckAllButton.Label:SetText('全部选取')
end

--拆解大师Mk1型, 分解
function WoWTools_ChineseMixin.Events:Blizzard_ScrappingMachineUI()
    self:SetButton(ScrappingMachineFrame.ScrapButton)
    ScrappingMachineFrame:HookScript('OnShow', function(f)
        f:SetTitle(self:CN(C_ScrappingMachineUI.GetScrappingMachineName()) or '拆解大师Mk1型')
    end)
end







function WoWTools_ChineseMixin.Events:Blizzard_CooldownViewer()
    hooksecurefunc(CooldownViewerBuffBarItemMixin, 'RefreshName', function(frame)
        local nameFontString = frame:GetNameFontString()
        if not nameFontString:IsShown() then
            return
        end
        local spellID = frame:GetSpellID()
        if spellID then
            local cn= self:GetSpellName(spellID)
            if cn then
	            nameFontString:SetText(cn)
            end
        end
    end)

    if not CooldownViewerSettings then--冷却设置 11.2.5
        return
    end

    hooksecurefunc(CooldownViewerSettingsCategoryMixin, 'Init', function(frame, categoryObj)
        local cn= self:CN(categoryObj:GetTitle())
        if cn then
            frame.Header:SetHeaderText(cn)
        end
    end)

    hooksecurefunc(CooldownViewerSettingsBarItemMixin, 'RefreshData', function(frame)
        if not frame:IsEmptyCategory() then
            local spellID = frame:GetSpellID()
            if spellID then
                local cn= self:GetSpellName(spellID)
                if cn then
                    frame.Bar.Name:SetText(cn)
                end
            end
        end
    end)

    --self:HookButton(CooldownViewerSettings.SaveLayoutButton)
    --self:HookButton(CooldownViewerSettings.UndoButton)
    CooldownViewerSettings.UndoButton:SetCustomTextFormatter(function(_, enabled)
		return "恢复 " .. CreateAtlasMarkup(enabled and "common-icon-undo" or "common-icon-undo-disable");
	end);
    self:SetLabel(CooldownViewerSettingsTitleText)
    self:SetLabel(CooldownViewerSettings.SearchBox.Instructions)
end


function WoWTools_ChineseMixin.Events:Blizzard_ExpansionLandingPage()
    hooksecurefunc(WarWithinLandingOverlayMixin, 'RefreshOverlay', function(frame)
        self:SetLabel(frame.Header.Title)
    end)
    hooksecurefunc(DragonflightLandingOverlayMixin, 'RefreshOverlay', function(frame)
        self:SetLabel(frame.Header.Title)
    end)
end


--宝石
function WoWTools_ChineseMixin.Events:Blizzard_ItemSocketingUI()
   local region= select(3, ItemSocketingFrame:GetRegions())
   if region:GetObjectType()=='FontString' then
        self:SetLabel(region)
   end
   ItemSocketingSocketButton:SetText("应用")
end





function WoWTools_ChineseMixin.Events:Blizzard_GuildRename()
--公会重名
    self:HookLabel(GuildRenameFrame.RenameFlow.Description)
    self:SetLabel(GuildRenameFrame.RenameFlow.NameBox.Instructions)
    self:SetLabel(GuildRenameFrame.RenameFlow.CostLabel)
    self:HookLabel(GuildRenameFrameText)
    self:HookLabel(GuildRenameFrame.RenameFlow.StatusText)
    GuildRenameFrame:HookScript('OnShow', function(f)
        local name= self:GetUnitName()
        if name then
            f:SetTitle(name)
        end
    end)

--注册公会
    self:SetLabel(GuildRegistrarPurchaseText)
    self:SetLabel(GuildRegistrarCostLabel)
    self:SetLabel(GuildRegistrarFramePurchaseButtonText)
    self:SetLabel(GuildRegistrarFrameCancelButtonText)
    GuildRegistrarFrame:HookScript('OnShow', function()
         local name= self:GetUnitName()
        if name then
            GuildRegistrarFrameNpcNameText:SetText(name)
        end
    end)

--公会战旗
    TabardFrame:HookScript('OnShow', function(f)
        local name= self:GetUnitName()
        if name then
            TabardFrameNameText:SetText(name)
        end
    end)
    self:HookLabel(TabardFrameGreetingText)
    self:SetLabel(TabardFrameCostLabel)
    self:SetLabel(TabardFrameCustomization1Text)
    self:SetLabel(TabardFrameCustomization2Text)
    self:SetLabel(TabardFrameCustomization3Text)
    self:SetLabel(TabardFrameCustomization4Text)
    self:SetLabel(TabardFrameCustomization5Text)
    self:SetLabel(TabardFrameAcceptButtonText)
    self:SetLabel(TabardFrameCancelButtonText)

end


--帮助提示 HelpPlateCanvas HelpPlateTooltipMixin
function WoWTools_ChineseMixin.Events:Blizzard_HelpPlate()
    hooksecurefunc(HelpPlateTooltip, 'Init', function(frame, _, tooltipText)
        local cn= self:CN(tooltipText)
        if cn then
            frame.Text:SetText(cn)
            frame:SetHeight(frame.Text:GetHeight() + 30)
        end
    end)
end




--宠物对战
function WoWTools_ChineseMixin.Events:Blizzard_PetBattleUI()
    self:AddDialogs("PET_BATTLE_FORFEIT", {text = '确定要放弃比赛吗？你的对手将被判定获胜，你的宠物也将损失百分之%d的生命值。', button1 = '确定', button2 = '取消',})
    self:AddDialogs("PET_BATTLE_FORFEIT_NO_PENALTY", {text = '确定要放弃比赛吗？你的对手将被判定获胜。', button1 = '确定', button2 = '取消',})
    PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetText('待命')

    --self:HookLabel(PetBattlePrimaryUnitTooltip.CollectedText)
    self:SetLabel(PetBattlePrimaryUnitTooltip.StatsLabel)
    self:SetLabel(PetBattlePrimaryUnitTooltip.AbilitiesLabel)
    self:SetLabel(PetBattlePrimaryUnitTooltip.WeakToLabel)
    self:SetLabel(PetBattlePrimaryUnitTooltip.ResistantToLabel)
    self:SetLabel(PetBattlePrimaryUnitTooltip.SpeedAdvantage)
    self:SetLabel(PetBattlePrimaryUnitTooltip.TopVersusText)

    hooksecurefunc('PetBattleUnitTooltip_UpdateForUnit', function(frame, petOwner, petIndex)
--名称
        local speciesID= C_PetBattles.GetPetSpeciesID(petOwner, petIndex)
        local companionID= speciesID or select(4, C_PetJournal.GetPetInfoBySpeciesID(speciesID))
        local cnName= self:GetUnitName(nil, companionID)
        if cnName then
            frame.Name:SetText(cnName)
        end
--技能，名称
        local abilityID, name
        for i=1, NUM_BATTLE_PET_ABILITIES do
            abilityID= C_PetBattles.GetAbilityInfo(petOwner, petIndex, i)
            name= self:GetPetAblityName(abilityID)
            if name then
                frame['AbilityName'..i]:SetText(name)
            end
        end
--收集
        if frame.CollectedText:IsShown() then
            --speciesID = C_PetBattles.GetPetSpeciesID(Enum.BattlePetOwner.Enemy, petIndex)
            local numOwned, maxAllowed = C_PetJournal.GetNumCollectedInfo(speciesID)
            if (numOwned < maxAllowed) then
                frame.CollectedText:SetText(GREEN_FONT_COLOR_CODE..format('已收集（%d/%d）', numOwned, maxAllowed)..FONT_COLOR_CODE_CLOSE);
            else
                frame.CollectedText:SetText(RED_FONT_COLOR_CODE..format('已收集（%d/%d）', numOwned, maxAllowed)..FONT_COLOR_CODE_CLOSE);
            end
        end
    end)


    hooksecurefunc('PetBattleUnitFrame_UpdateDisplay', function(frame)
        local petOwner = frame.petOwner;
        local petIndex = frame.petIndex;
        if not petOwner
            or not petIndex
            or not frame.Name
            or frame==PetBattlePrimaryUnitTooltip
            or petIndex > C_PetBattles.GetNumPets(petOwner)
        then
            return
        end

        local speciesID= C_PetBattles.GetPetSpeciesID(petOwner, petIndex)
        local companionID= speciesID or select(4, C_PetJournal.GetPetInfoBySpeciesID(speciesID))
        local cnName= self:GetUnitName(nil, companionID)
        if cnName then
            if not frame.cnName then
                frame.cnName=  WoWTools_ChineseMixin:Cstr(frame)
                if petOwner==Enum.BattlePetOwner.Ally then
                    frame.cnName:SetPoint('BOTTOMLEFT', frame.Name, 'TOPLEFT')
                else
                    frame.cnName:SetPoint('BOTTOMRIGHT', frame.Name, 'TOPRIGHT')
                end
            end
            frame.cnName:SetText(cnName)
        end
    end)

--右击图像，菜单
    Menu.ModifyMenu("MENU_PET_BATTLE_PET", function(frame, root)
        local speciesID= C_PetBattles.GetPetSpeciesID(frame.petOwner, frame.petIndex)
        local companionID= speciesID or select(4, C_PetJournal.GetPetInfoBySpeciesID(speciesID))
        local cnName= self:GetUnitName(nil, companionID)
        if cnName then
            root:CreateTitle(cnName)
        end
    end)

--PetBattleUnitTooltip_OnLoad(self)
    PetBattlePrimaryUnitTooltip.healthTextFormat = "生命值：%d/%d";
	PetBattlePrimaryUnitTooltip.xpTextFormat = '经验值：%d/%d'

    hooksecurefunc('PetBattleWeatherFrame_Update', function(frame)
        local auraID = frame:IsShown() and C_PetBattles.GetAuraInfo(Enum.BattlePetOwner.Weather, PET_BATTLE_PAD_INDEX, 1)
        local abilityID = auraID and C_PetBattles.GetAbilityInfoByID(auraID)
        local cnName= self:GetPetAblityName(abilityID)
        if cnName then
            frame.Name:SetText(cnName)
        end
        self:SetLabel(frame.Label)
    end)

end




--[[function CooldownViewerBuffBarItemMixin:RefreshName()
	local nameFontString = self:GetNameFontString();
	if not nameFontString:IsShown() then
		return;
	end
	local nameText = self:GetNameText();
	nameFontString:SetText(nameText);
end
function CooldownViewerBuffBarItemMixin:SetBarContent(barContent)
	local iconFrame = self:GetIconFrame();
	local nameFontString = self:GetNameFontString();
	local point, relativeTo, relativePoint, offsetX, offsetY = "LEFT", iconFrame, "RIGHT", 0, 0;

	if barContent == Enum.CooldownViewerBarContent.IconAndName then
		iconFrame:Show();
		nameFontString:Show();
	elseif barContent == Enum.CooldownViewerBarContent.IconOnly then
		iconFrame:Show();
		nameFontString:Hide();
	elseif barContent == Enum.CooldownViewerBarContent.NameOnly then
		iconFrame:Hide();
		nameFontString:Show();
		relativeTo = self;
		relativePoint = "LEFT";
	else
		assertsafe(false, "Unknown value for bar content: %d", barContent);
	end

	self:GetBarFrame():SetPoint(point, relativeTo, relativePoint, offsetX, offsetY);
end
]]

function WoWTools_ChineseMixin.Events:Blizzard_RemixArtifactUI()
    self:HookLabel(RemixArtifactFrame.Header.Title)
    self:SetButton(RemixArtifactFrame.CommitConfigControls.CommitButton)
end









--local info = C_AlliedRaces.GetAllRacialAbilitiesFromID(raceID)
function WoWTools_ChineseMixin.Events:Blizzard_AlliedRacesUI()
    self:HookLabel(AlliedRacesFrameTitleText)
    self:HookLabel(AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName)
    self:SetLabel(AlliedRacesFrame.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.Title)
    self:HookLabel(AlliedRacesFrame.RaceInfoFrame.ScrollFrame.Child.RaceDescriptionText)
    self:SetLabel(AlliedRacesFrame.RaceInfoFrame.ScrollFrame.Child.RacialTraitsLabel)
    hooksecurefunc(AlliedRacesFrame, 'SetupAbilityPool', function(frame)
        for btn in frame.abilityPool:EnumerateActive() do
            self:SetLabel(btn.Text)
        end
    end)

end


function WoWTools_ChineseMixin.Events:Blizzard_TutorialManager()
    hooksecurefunc(TutorialPointerFrame, 'Show', function(f, _, _, anchorFrame)
        local frame = f:_GetFrame(anchorFrame)
        if frame then
            local name= frame:GetName()
            local index= name and name:match('%d+')
            index= index and tonumber(index) or 2
            local c=  _G['TutorialPointerFrame_'..(index-1)..'Content']
            if c and c.Text then
                self:HookLabel(c.Text)
                c:SetWidth(math.min(c.Text:GetStringWidth()+40, 200))
                c:SetHeight(c.Text:GetHeight()+40)
            end
            self:HookLabel(frame.Content.Text)
        end
    end)
    self:HookLabel(TutorialMainFrame_Frame.ContainerFrame.Text)--TutorialMainFrameMixin
    self:HookLabel(TutorialSingleKey_Frame.ContainerFrame.Text)--TutorialSingleKeyMixin
end


function WoWTools_ChineseMixin.Events:Blizzard_NewPlayerExperience()
    self:HookLabel(TutorialKeyboardMouseFrame_Frame.Text)--TutorialKeyboardMouseFrameMixin
    self:HookLabel(KeyboardMouseConfirmButtonText)

    self:HookLabel(TutorialWalk_Frame.ContainerFrame.Text)--TutorialWalkMixin
end


function WoWTools_ChineseMixin.Events:Blizzard_Minimap()
    MinimapCluster.ZoneTextButton.tooltipText = MicroButtonTooltipText('世界地图', "TOGGLEWORLDMAP")
    MinimapCluster.ZoneTextButton:HookScript('OnEvent', function(btn)
        btn.tooltipText = MicroButtonTooltipText('世界地图', "TOGGLEWORLDMAP")
    end)

    hooksecurefunc('Minimap_SetTooltip', function(pvpType, factionName)
        if
            GameTooltip:IsOwned(MinimapCluster.ZoneTextButton)
            and (factionName and factionName ~= "")
        then
            factionName= self:CN(factionName) or factionName
            if pvpType == "friendly" then
                GameTooltip:AddLine(format('（%s领地）', factionName), 0.1, 1.0, 0.1)
                GameTooltip:Show()
            elseif pvpType == "hostile" then
                GameTooltip:AddLine(format('（%s领地）', factionName), 1.0, 0.1, 0.1)
                GameTooltip:Show()
            end
        end
    end)
    WoWTools_ChineseMixin:HookLabel(MinimapZoneText)
end


function WoWTools_ChineseMixin.Events:Blizzard_WorldMap()
    for _, frame in ipairs(WorldMapFrame.overlayFrames or {}) do
        self:HookLabel(frame.Text)
    end
    self:HookLabel(WorldMapFrameTitleText)
    self:SetCNFont(WorldMapFrameHomeButtonText)
    WorldMapFrameHomeButtonText:SetText('世界')

    if EventSchedulerBaseLabelMixin then--11.2.7才有
                --[[local EntryType = EnumUtil.MakeEnum(
                "OngoingHeader",--1
                "OngoingEvent",
                "ScheduledHeader",3
                "ScheduledEvent",
                "Date",5
                "HiddenEventsLabel",
                "NoEventsLabel"
            )]]
        self:SetLabel(QuestMapFrame.EventsFrame.TitleText)
        hooksecurefunc(EventSchedulerBaseLabelMixin, 'Init', function(frame, data)
            if not data then
                self:SetLabel(frame.Label)
            elseif data.entryType ==  1 then
                frame.Label:SetText('进行中的活动')
            elseif data.entryType ==  3 then
                frame.Label:SetText('活动日程')
            elseif data.entryType ==  5 then
                local monthName = frame:CN(CALENDAR_FULLDATE_MONTH_NAMES[data.date.month])
                if monthName then
                    frame.Label:SetFormattedText('EVENT_SCHEDULER_DAY_FORMAT', monthName, data.date.day);
                else
                    frame:SetLabel(frame.Label)
                end
            elseif data.entryType == 6 then
                frame.Label:SetFormattedText('%d个活动已被隐藏', data.count);
            elseif data.entryType == 7 then
                frame.Label:SetText('没有可用的活动')
            end
        end)
    end
end









--插件
function WoWTools_ChineseMixin.Events:Blizzard_AddOnList()
    self:SetLabel(AddonListTitleText)--:SetText('插件列表')
    self:SetLabel(AddonList.SearchBox.Instructions)
    self:SetLabel(AddonList.Performance.Header)

    self:SetButton(AddonList.EnableAllButton)--:SetText('全部启用')
    self:SetButton(AddonList.DisableAllButton)--:SetText('全部禁用')
    self:HookButton(AddonList.OkayButton)
    self:SetButton(AddonList.CancelButton)--:SetText('取消')
    hooksecurefunc('AddonList_InitAddon', function(entry)
        if entry then
            self:HookLabel(entry.Status)
            self:HookLabel(entry.Reload)
        end
    end)
    self:SetFrame(AddonListForceLoad, nil, nil, 2)
    self:HookLabel(AddonList.Dropdown.Text)

--替换原生
    function AddonList:UpdatePerformance()
        local enabled = C_AddOnProfiler.IsEnabled()
        local showPerfUI = enabled and not InGlue()
        if not showPerfUI then
            return
        end
        local perfUI = self.Performance
        self:UpdateOverallMetric(perfUI.Current, '当前CPU：%s', Enum.AddOnProfilerMetric.RecentAverageTime)
        self:UpdateOverallMetric(perfUI.Average, '平均CPU：%s', Enum.AddOnProfilerMetric.SessionAverageTime)
        self:UpdateOverallMetric(perfUI.Peak, '峰值CPU：%s', Enum.AddOnProfilerMetric.PeakTime)
    end
end







--幻化 12.0 才有
function WoWTools_ChineseMixin.Events:Blizzard_Transmog()
    self:SetLabel(TransmogFrameTitleText)

    self:SetLabel(TransmogFrame.OutfitCollection.ShowEquippedGearSpellFrame.Label)
    self:SetLabel(TransmogFrame.OutfitCollection.PurchaseOutfitButton.Text)
    self:SetButton(TransmogFrame.OutfitCollection.SaveOutfitButton)

    self:SetLabel(TransmogFrame.CharacterPreview.HideIgnoredToggle.Text)

    self:HookLabel(TransmogFrame.WardrobeCollection.TabContent.ItemsFrame.ActiveSlotTitle)
    self:SetLabel(TransmogFrame.WardrobeCollection.TabContent.ItemsFrame.DisplayTypeUnassignedButton.Text)
    self:SetLabel(TransmogFrame.WardrobeCollection.TabContent.ItemsFrame.DisplayTypeEquippedButton.Text)

    self:SetLabel(TransmogFrame.WardrobeCollection.TabContent.CustomSetsFrame.NewCustomSetButton.Text)

    self:SetLabel(TransmogFrame.WardrobeCollection.TabContent.SituationsFrame.DescriptionText)
    self:SetLabel(TransmogFrame.WardrobeCollection.TabContent.SituationsFrame.EnabledToggle.Text)
    self:SetButton(TransmogFrame.WardrobeCollection.TabContent.SituationsFrame.DefaultsButton)
    self:SetButton(TransmogFrame.WardrobeCollection.TabContent.SituationsFrame.ApplyButton)
    hooksecurefunc(TransmogFrame.WardrobeCollection.TabContent.SituationsFrame, 'Refresh', function(frame)
        for pool in frame.SituationFramePool:EnumerateActive() do
            self:SetLabel(pool.Title)
        end
    end)
end


function WoWTools_ChineseMixin.Events:Blizzard_CompactRaidFrames()
    self:HookLabel(CompactRaidFrameManagerDisplayFrameModeControlDropdown.Text)
    self:HookLabel(CompactRaidFrameManagerDisplayFrameRestrictPingsDropdown.Text)
    self:HookLabel(CompactRaidFrameManagerDisplayFrameModeControlDropdown.Text)

    self:SetLabel(CompactRaidFrameManagerDisplayFrame.RestrictPingsLabel)
    self:SetLabel(CompactRaidFrameManagerLeavePartyButtonText)
    self:HookButton(CompactRaidFrameManagerLeaveInstanceGroupButton)
    self:HookLabel(parentBottomButtonsLeaveInstanceGroupButton)

    self:SetLabel(CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerUnitTab)
    self:SetLabel(CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerGroundTab)
end

function WoWTools_ChineseMixin.Events:Blizzard_GenericTraitUI()
    self:HookLabel(GenericTraitFrame.Header.Title)
end