local id, e = ...





local function Init_Event(arg1)
    if arg1=='Blizzard_MacroUI' then
        MacroFrameTab1:SetText('通用宏')
        MacroFrameTab2:SetText('专用宏', 0.3)
        MacroSaveButton:SetText('保存')
        MacroCancelButton:SetText('取消')
        MacroDeleteButton:SetText('删除')
        MacroNewButton:SetText('新建')
        MacroExitButton:SetText('退出')

        e.dia("CONFIRM_DELETE_SELECTED_MACRO", {text= '确定要删除这个宏吗？', button1= '是', button2= '取消'})










    







    elseif arg1=="Blizzard_GuildBankUI" then--公会银行
        GuildBankFrameTab1:SetText('公会银行')
            GuildItemSearchBox.Instructions:SetText('搜索')
            GuildBankFrame.WithdrawButton:SetText('提取')
            GuildBankFrame.DepositButton:SetText('存放')
            GuildBankMoneyLimitLabel:SetText('可用数量：')
            hooksecurefunc(GuildBankFrame, 'UpdateTabs', function(self)--Blizzard_GuildBankUI.lua
                local name, isViewable, canDeposit, numWithdrawals, remainingWithdrawals, disableAll, titleText, withdrawalText
                local numTabs = GetNumGuildBankTabs()
                local currentTab = GetCurrentGuildBankTab()
                -- Set buyable tab
                local tabToBuyIndex
                if ( numTabs < MAX_BUY_GUILDBANK_TABS ) then
                    tabToBuyIndex = numTabs + 1
                end
                -- Disable and gray out all tabs if in the moneyLog since the tab is irrelevant
                if ( self.mode == "moneylog" ) then
                    disableAll = 1
                end
                for i=1, MAX_GUILDBANK_TABS do
                    local tab = self.BankTabs[i]
                    local tabButton = tab.Button
                    name, _, isViewable = GetGuildBankTabInfo(i)
                    if ( not name or name == "" ) then
                        name = format('标签%d', i)
                    end
                    if ( i == tabToBuyIndex and IsGuildLeader() ) then
                        tabButton.tooltip = '购买新的公会银行标签'
                        if ( disableAll or self.mode == "log" or self.mode == "tabinfo" ) then
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
                if ( self.mode == "moneylog" ) then
                    titleText = '金币记录'
                    withdrawalText = nil
                elseif ( self.mode == "log" ) then
                    if ( titleText ) then
                        titleText = format('%s 记录', titleText)
                    end
                elseif ( self.mode == "tabinfo" ) then
                    withdrawalText = nil
                    if ( titleText ) then
                        titleText = format('%s 信息', titleText)
                    end
                end
                -- Get selected tab info
                name, _, _, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo(currentTab)
                if ( titleText and (self.mode ~= "moneylog" and titleText ~= BUY_GUILDBANK_TAB) ) then
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
                    self.TabTitle:SetText(titleText)
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
                    self.LimitLabel:SetText(format('%s的每日提取额度剩余：|cffffffff%s|r', withdrawalText, stackString))
                end
            end)
        GuildBankFrameTab2:SetText('记录')
        GuildBankFrameTab3:SetText('金币记录')
        GuildBankFrameTab4:SetText('信息')
            GuildBankInfoSaveButton:SetText('保存改变')














    elseif arg1=='Blizzard_InspectUI' then--玩家, 观察角色, 界面
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




























    elseif arg1=='Blizzard_ArtifactUI' then
        --Blizzard_ArtifactUI.lua
        e.dia("CONFIRM_ARTIFACT_RESPEC", {text = '确定要重置你的神器专长吗？|n|n这将消耗%s点|cffe6cc80神器能量|r。', button1 = '是', button2 = '否'})
        e.dia("NOT_ENOUGH_POWER_ARTIFACT_RESPEC", {text = '你没有足够的|cffe6cc80神器能量|r来重置你的专长。|n|n需要%s点|cffe6cc80神器能量|r。', button1 = '确定'})

        --Blizzard_ArtifactPerks.lua
        e.dia("CONFIRM_RELIC_REPLACE", {text = '你确定要替换此圣物吗？已有的圣物将被摧毁。', button1 = '接受', button2 = '取消'})

    elseif arg1=='Blizzard_Soulbinds' then
        e.dia("SOULBIND_DIALOG_MOVE_CONDUIT", {text = '一个导灵器只能同时被放置在一个插槽内，所以之前插槽里的该导灵器已被移除。', button1 = '接受'})
        e.dia("SOULBIND_DIALOG_INSTALL_CONDUIT_UNUSABLE", {text = '此插槽目前未激活。你确定想在此添加一个导灵器吗？', button1 = '接受', button2 = '取消'})

    elseif arg1=='Blizzard_AnimaDiversionUI' then--Blizzard_AnimaDiversionUI.lua
        e.dia("ANIMA_DIVERSION_CONFIRM_CHANNEL", {text = '你确定想引导心能到%s吗？|n|n|cffffd200%s|r', button1 = '是', button2 = '取消'})
        e.dia("ANIMA_DIVERSION_CONFIRM_REINFORCE", {text = '你确定想强化%s吗？|n|n|cffffd200这样会永久激活此地点，而且无法撤销。|r', button1 = '是', button2 = '取消'})

        e.dia("SOULBIND_CONDUIT_NO_CHANGES_CONFIRMATION", {text = '你对你的导灵器进行了改动，但并没有应用这些改动。你确定想要离开吗？', button1 = '离开', button2 = '取消'})

    elseif arg1=='Blizzard_CovenantSanctum' then--Blizzard_CovenantSanctumUpgrades.lua
        e.dia("CONFIRM_ARTIFACT_RESPEC", {button1 = '是', button2 = '否'})
        e.hookDia("CONFIRM_ARTIFACT_RESPEC", 'OnShow', function(self, data)
            if data then
                local costString = GetGarrisonTalentCostString(data.talent)
                self.text:SetFormattedText('把|cff20ff20%s|r升到%d级会花费|n%s', data.talent.name, data.talent.tier + 1, costString)
            end
        end)




    











    elseif arg1=='Blizzard_PlayerChoice' then
        e.dia("CONFIRM_PLAYER_CHOICE", {button1 = '确定', button2 = '取消'})
        e.dia("CONFIRM_PLAYER_CHOICE_WITH_CONFIRMATION_STRING", {button1 = '接受', button2 = '拒绝'})
        hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, 'SetupHeader', function (self)
            if self.Header:IsShown() then
                e.set(self.Header.Text,self.optionInfo.header)
            end
        end)
        local rarityToString ={
            [Enum.PlayerChoiceRarity.Common] = "|cffffffff普通|r|n|n",
            [Enum.PlayerChoiceRarity.Uncommon] = "|cff1eff00优秀|r|n|n",
            [Enum.PlayerChoiceRarity.Rare] = "|cff0070dd精良|r|n|n",
            [Enum.PlayerChoiceRarity.Epic] = "|cffa335ee史诗|r|n|n",
        }
        hooksecurefunc(PlayerChoiceFrame, 'SetupOptions', function(self)----Blizzard_PlayerChoice.lua
            for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
                optionFrame.OptionText:SetText((rarityToString[optionFrame.optionInfo.rarity] or "")..e.cn(optionFrame.optionInfo.description))
            end
        end)
        hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, 'OnEnter', function(self)
            if self.optionInfo and not self.optionInfo.spellID then
                local header= e.cn(self.optionInfo.header)
                if self.optionInfo.rarityColor then
                    header= self.optionInfo.rarityColor:WrapTextInColorCode(header)
                end
                GameTooltip_SetTitle(GameTooltip, header)
                if self.optionInfo.rarity and self.optionInfo.rarityColor then
                    local rarityStringIndex = self.optionInfo.rarity + 1
                    GameTooltip_AddColoredLine(GameTooltip, e.cn(_G["ITEM_QUALITY"..rarityStringIndex.."_DESC"]), self.optionInfo.rarityColor)
                end
                GameTooltip_AddNormalLine(GameTooltip, e.cn(self.optionInfo.description))
                GameTooltip:Show()
            end
        end)

        hooksecurefunc(GenericPlayerChoiceToggleButton, 'UpdateButtonState', function(self)--PlayerChoiceToggleButtonMixin
            if self:IsShown() then
                local choiceFrameShown = PlayerChoiceFrame:IsShown()
                local choiceInfo = C_PlayerChoice.GetCurrentPlayerChoiceInfo() or {}
                self.Text:SetText(choiceFrameShown and '隐藏' or e.cn(choiceInfo.pendingChoiceText))
            end
        end)








    elseif arg1=='Blizzard_GarrisonTemplates' then--Blizzard_GarrisonSharedTemplates.lua
        e.dia("CONFIRM_FOLLOWER_UPGRADE", {button1 = '是', button2 = '否'})
        e.dia("CONFIRM_FOLLOWER_ABILITY_UPGRADE", {button1 = '是', button2 = '否'})
        e.dia("CONFIRM_FOLLOWER_TEMPORARY_ABILITY", {text = '确定要赋予%s这个临时技能吗？', button1 = '是', button2 = '否'})
        e.dia("CONFIRM_FOLLOWER_EQUIPMENT", {button1 = '是', button2 = '否'})

    elseif arg1=='Blizzard_ClassTrial' then--Blizzard_WeeklyRewards.lua
        e.dia("CLASS_TRIAL_CHOOSE_BOOST_TYPE", {text = '你希望使用哪种角色直升？', button1 = '接受', button2 = '接受', button3 = '取消'})
        e.dia("CLASS_TRIAL_CHOOSE_BOOST_LOGOUT_PROMPT", {text = '要使用此角色直升服务，请登出游戏，返回角色选择界面。', button1 = '立刻返回角色选择画面', button2 = '取消'})

    elseif arg1=='Blizzard_GarrisonUI' then--要塞
        e.dia("DEACTIVATE_FOLLOWER", {button1 = '是', button2 = '否'})
        e.hookDia("DEACTIVATE_FOLLOWER", 'OnShow', function(self)
            local quality = C_Garrison.GetFollowerQuality(self.data)
            local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data)..FONT_COLOR_CODE_CLOSE
            local cost = GetMoneyString(C_Garrison.GetFollowerActivationCost())
            local uses = C_Garrison.GetNumFollowerDailyActivations()
            self.text:SetFormattedText('确定要遣散|n%s吗？|n|n重新激活一名追随者需要花费%s。|n你每天可重新激活%d名追随者。', name, cost, uses)
        end)

        e.dia("ACTIVATE_FOLLOWER", {button1 = '是', button2 = '否'})
        e.hookDia("ACTIVATE_FOLLOWER", 'OnShow', function(self)
            local quality = C_Garrison.GetFollowerQuality(self.data)
            local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data)..FONT_COLOR_CODE_CLOSE
            local cost = GetMoneyString(C_Garrison.GetFollowerActivationCost())
            local uses = C_Garrison.GetNumFollowerDailyActivations()
            self.text:SetFormattedText('确定要激活|n%s吗？|n|n你今天还能激活%d名追随者，这将花费：', name, cost, uses)
        end)

        e.dia("CONFIRM_RECRUIT_FOLLOWER", {text  = '确定要招募%s吗？', button1 = '是', button2 = '否'})

        e.dia("DANGEROUS_MISSIONS", {button1 = '确定', button2 = '取消'})
        e.hookDia("DANGEROUS_MISSIONS", 'OnShow', function(self)
            local warningIconText = "|T" .. STATICPOPUP_TEXTURE_ALERT .. ":15:15:0:-2|t"
            self.text:SetFormattedText('|n %s |cffff2020警告！|r %s |n|n你即将执行一项高危行动。如果行动失败，所有参与任务的舰船都有一定几率永久损毁。', warningIconText, warningIconText)
        end)

        e.dia("GARRISON_SHIP_RENAME", {text  = '输入你想要的名字：', button1 = '接受', button2 = '取消', button3= '默认'})

        e.dia("GARRISON_SHIP_DECOMMISSION", {button1 = '是', button2 = '否'})
        e.hookDia("GARRISON_SHIP_DECOMMISSION", 'OnShow', function(self)
            local quality = C_Garrison.GetFollowerQuality(self.data.followerID)
            local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data.followerID)..FONT_COLOR_CODE_CLOSE
            self.text:SetFormattedText('你确定要永久报废|n%s吗？|n|n你将无法重新获得这艘舰船。', name)
        end)

        e.dia("GARRISON_CANCEL_UPGRADE_BUILDING", {text  = '确定要取消这次建筑升级吗？升级的费用将被退还。', button1 = '是', button2 = '否'})
        e.dia("GARRISON_CANCEL_BUILD_BUILDING", {text  = '确定要取消建造这座建筑吗？建造的费用将被退还。', button1 = '是', button2 = '否'})
        e.dia("COVENANT_MISSIONS_CONFIRM_ADVENTURE", {text  = '开始冒险？', button1 = '确认', button2 = '取消'})
        e.dia("COVENANT_MISSIONS_HEAL_CONFIRMATION", {text  = '你确定要彻底治愈这名追随者吗？', button1 = '确认', button2 = '取消'})
        e.dia("COVENANT_MISSIONS_HEAL_ALL_CONFIRMATION", {text  = '你确定要付出%s，治疗所有受伤的伙伴？', button1 = '治疗全部', button2 = '取消'})

    elseif arg1=='Blizzard_RuneforgeUI' then--Blizzard_RuneforgeCreateFrame.lua
        e.dia("CONFIRM_RUNEFORGE_LEGENDARY_CRAFT", {button1 = '是', button2 = '否'})
        e.hookDia("CONFIRM_RUNEFORGE_LEGENDARY_CRAFT", 'OnShow', function(self, data)
            self.text:SetText(data.title)
            local text= data and data.title or ''
            local a= text:match(e.Magic(RUNEFORGE_LEGENDARY_UPGRADING_CONFIRMATION))
            local b= text:match(e.Magic(RUNEFORGE_LEGENDARY_CRAFTING_CONFIRMATION))
            if a then
                self.text:SetFormattedText('你确定要花费%s给这件传说装备升级吗？', a)
            elseif b then
                self.text:SetFormattedText('你确定要花费%s打造这件传说装备吗？', b)
            end
        end)
        --set_GameTooltip_func(RuneforgeFrameResultTooltip)

    elseif arg1=='Blizzard_ClickBindingUI' then
        e.dia("CONFIRM_LOSE_UNSAVED_CLICK_BINDINGS", {text  = '你有未保存的点击施法按键绑定。如果你现在关闭，会丢失所有改动。', button1 = '确定', button2 = '取消'})
        e.dia("CONFIRM_RESET_CLICK_BINDINGS", {text  = '确定将所有点击施法按键绑定重置为默认值吗？\n', button1 = '确定', button2 = '取消'})


        ClickBindingFrameTitleText:SetText('关于点击施法按键绑定')
        ClickBindingFrame.TutorialFrame:SetTitle('关于点击施法按键绑定')

        ClickBindingFrame.SaveButton:SetText('保存')
        ClickBindingFrame.AddBindingButton:SetText('添加绑定')
        ClickBindingFrame.ResetButton:SetText('恢复默认设置')
        ClickBindingFrame.EnableMouseoverCastCheckbox.Label:SetText('鼠标悬停施法')
        ClickBindingFrame.EnableMouseoverCastCheckbox:HookScript('OnEnter', function()
            GameTooltip:SetText('启用后，鼠标悬停到一个单位框体并使用一个键盘快捷键施放法术时，会直接对该单位施法，无需将该单位设为目标。', nil, nil, nil, nil, true)

        end)
        ClickBindingFrame.MouseoverCastKeyDropDown.Label:SetText('鼠标悬停施法按键')
        ClickBindingFrame.TutorialFrame.SummaryText:SetText('将法术和宏绑定到鼠标点击')
        ClickBindingFrame.TutorialFrame.InfoText:SetText('通过点击单位框体施放绑定的法术和宏')
        ClickBindingFrame.TutorialFrame.AlternateText:SetText('可以使用Shift键、Ctrl键或者Alt键来设定其他的点击绑定')
        ClickBindingFrame.TutorialFrame.ThrallName:SetText('萨尔')
        ClickBindingFrame.SpellbookPortrait:HookScript('OnEnter', function()
            GameTooltip_SetTitle(GameTooltip, MicroButtonTooltipText('法术书和专业', "TOGGLESPELLBOOK"))
            GameTooltip:Show()
        end)
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
        hooksecurefunc(ClickBindingFrame, 'SetUnboundText', function(self, elementData)
            self.UnboundText:SetFormattedText('%s 解除绑定', NameAndIconFromElementData(elementData))
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
        hooksecurefunc(ClickBindingLineMixin, 'Init', function(self, elementData)
            e.set(self.BindingText, BindingTextFromElementData(elementData))

            e.set(self.Name, ColoredNameAndIconFromElementData(elementData))
        end)
        hooksecurefunc(ClickBindingHeaderMixin, 'Init', function(self, elementData)
	        e.set(self.Name, ColoredNameAndIconFromElementData(elementData))
        end)

    elseif arg1=='Blizzard_ProfessionsTemplates' then
        e.dia("PROFESSIONS_RECRAFT_REPLACE_OPTIONAL_REAGENT", {button1 = '接受', button2 = '取消'})
        e.hookDia("PROFESSIONS_RECRAFT_REPLACE_OPTIONAL_REAGENT", 'OnShow', function(self, data)
            self.text:SetFormattedText('你想替换%s吗？\n它会在再造时被摧毁。', e.cn(data.itemName))
        end)

    elseif arg1=='Blizzard_BlackMarketUI' then
        e.dia("BID_BLACKMARKET", {text = '确定要出价%s竞拍以下物品吗？', button1 = '确定', button2 = '取消'})

   

    elseif arg1=='Blizzard_DeathRecap' then
        DeathRecapFrame.CloseButton:SetText('关闭')
        DeathRecapFrame.Title:SetText('死亡摘要')


    elseif arg1=='Blizzard_CombatLog' then--聊天框，战斗记录
        local function set_filter(self)
            if not self then
                return
            end
            for index, tab in pairs(self) do
                if type(tab)=='table' then
                    local name= tab.name
                    local quickButtonName= tab.quickButtonName
                    local tooltip= tab.tooltip
                    name= name and e.strText[name]
                    quickButtonName= quickButtonName and e.strText[quickButtonName]
                    tooltip= tooltip and e.strText[tooltip]
                    if name then
                        self[index].name= name
                    end
                    if quickButtonName then
                        self[index].quickButtonName= quickButtonName
                    end
                    if tooltip then
                        self[index].tooltip= tooltip
                    end
                end
            end
        end
        set_filter(Blizzard_CombatLog_Filter_Defaults.filters)
        set_filter(Blizzard_CombatLog_Filters.filters )

    elseif arg1=='Blizzard_ItemUpgradeUI' then--装备升级,界面
        ItemUpgradeFrameTitleText:SetText('物品升级')
        ItemUpgradeFrame.UpgradeButton:SetText('升级')
        ItemUpgradeFrame.ItemInfo.MissingItemText:SetText('将物品拖曳至此处升级。')
        ItemUpgradeFrame.MissingDescription:SetText('许多可装备的物品都可以进行升级，从而提高其物品等级。不同来源的物品升级所需的货币也各不相同。')
        ItemUpgradeFrame.ItemInfo.UpgradeTo:SetText('升级至：')
        ItemUpgradeFrame.UpgradeCostFrame.Label:SetText('总花费：')
        hooksecurefunc(ItemUpgradeFrame, 'PopulatePreviewFrames', function(self)
            if self.FrameErrorText:IsShown() then
                e.set(self.FrameErrorText)--该物品已经升到满级了
            end
        end)


    elseif arg1=='Blizzard_Settings' then--Blizzard_SettingsPanel.lua 
        local label2= e.Cstr(SettingsPanel.CategoryList)
        label2:SetPoint('RIGHT', SettingsPanel.ClosePanelButton, 'LEFT', -2, 0)
        label2:SetText(id..' 语言翻译 提示：请要不在战斗中修改选项')

        SettingsPanel.Container.SettingsList.Header.DefaultsButton:SetText('默认设置')
        e.dia('GAME_SETTINGS_APPLY_DEFAULTS', {text= '你想要将所有用户界面和插件设置重置为默认状态，还是只重置这个界面或插件的设置？', button1= '所有设置', button2= '取消', button3= '这些设置'})--Blizzard_Dialogs.lua
        SettingsPanel.GameTab.Text:SetText('游戏')
        SettingsPanel.AddOnsTab.Text:SetText('插件')
        SettingsPanel.NineSlice.Text:SetText('选项')
        SettingsPanel.CloseButton:SetText('关闭')
        SettingsPanel.ApplyButton:SetText('应用')

        SettingsPanel.NineSlice.Text:SetText('选项')
        SettingsPanel.SearchBox.Instructions:SetText('搜索')

    elseif arg1=='Blizzard_TimeManager' then--小时图，时间
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

    elseif arg1=='Blizzard_ArchaeologyUI' then
        ArchaeologyFrameTitleText:SetText('考古学')
        ArchaeologyFrameSummaryPageTitle:SetText('种族')
        ArchaeologyFrameCompletedPage.infoText:SetText('你还没有完成任何神器。寻找碎片及钥石以完成神器。')
        ArchaeologyFrameCompletedPage.titleBig:SetText('已完成神器')
        ArchaeologyFrameCompletedPage.titleMid:SetText('已完成的普通神器')

        ArchaeologyFrameCompletedPage.titleTop:SetText('已完成的普通神器')

        ArchaeologyFrameArtifactPage.historyTitle:SetText('历史')
        ArchaeologyFrameArtifactPage.raceRarity:SetText('种族')
        if ArchaeologyFrame.backButton then
            ArchaeologyFrame.backButton:SetText('后退')
        end
        ArchaeologyFrameArtifactPageSolveFrameSolveButton:SetText('解密')

        hooksecurefunc(ArchaeologyFrame.summaryPage, 'UpdateFrame', function(self)
            self.pageText:SetFormattedText('第%d页', self.currentPage)
        end)
        hooksecurefunc(ArchaeologyFrame.completedPage, 'UpdateFrame', function(self)
            self.pageText:SetFormattedText('第%d页', self.currentPage)
            self.titleTop:SetText(self.currData.onRare and '已完成的精良神器' or '已完成的普通神器')
        end)
        hooksecurefunc('ArchaeologyFrame_CurrentArtifactUpdate', function(self)
            local RaceName, _, RaceitemID	= GetArchaeologyRaceInfo(self.raceID, true)

            local runeName
            if RaceitemID and RaceitemID > 0 then
                runeName = C_Item.GetItemInfo(RaceitemID)
            end
            if runeName then
                for i=1, ARCHAEOLOGY_MAX_STONES do
                    local slot= self.solveFrame["keystone"..i]
                    if slot and slot:IsShown() then
                        if ItemAddedToArtifact(i) then
                            self.solveFrame["keystone"..i].tooltip = format('点此以移除 |cnGREEN_FONT_COLOR:%s|r 。', runeName)
                        else
                            self.solveFrame["keystone"..i].tooltip = format('点此以从你的背包中选择一块 |cnGREEN_FONT_COLOR:%s|r 来降低完成该神器所需要的碎片数量。', runeName)
                        end
                    end
                end
            end

            if select(3, GetSelectedArtifactInfo()) == 0 then --Common Item
                self.raceRarity:SetText(RaceName.." - |cffffffff普通|r")
            else
                self.raceRarity:SetText(RaceName.." - |cff0070dd精良|r")
            end
        end)

        ArchaeologyFrame.rankBar:HookScript('OnEnter', function()
            GameTooltip:SetText('考古学技能', HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
			GameTooltip:Show()
        end)

        ArchaeologyFrameArtifactPageSolveFrameStatusBar:HookScript('OnEnter', function()
            local _, _, _, _, _, maxCount = GetArchaeologyRaceInfo(ArchaeologyFrame.artifactPage.raceID)
            GameTooltip:SetText(format('拼出该神器所需的碎片数量。\n\n每个种族的碎片最多只能保存%d块。', maxCount), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
			GameTooltip:Show()
        end)
        ArchaeologyFrameHelpPageTitle:SetText('考古学')
        ArchaeologyFrameHelpPageHelpScrollHelpText:SetText('你需要搜集散落在世界各处的神器碎片来将它们复原为完整的神器。你能够在挖掘场里找到这些碎片，挖掘场的位置会标记在你的地图上。在挖掘场使用调查技能，你的调查工具就会显示出神器碎片大致的埋藏方向和位置。在前往一个新的挖掘地址前你可以在一个挖掘场中收集六次碎片。当你拥有了足够的碎片之后，你就可以破译隐藏在神器中的秘密，了解更多关于艾泽拉斯昔日的历史和传说。寻宝愉快！')
        ArchaeologyFrameHelpPageDigTitle:SetText('考古学地图位置标记')

        ArchaeologyFrameSummarytButton:HookScript('OnEnter', function()
            GameTooltip:SetText('当前神器')
        end)
        ArchaeologyFrameCompletedButton:HookScript('OnEnter', function()
            GameTooltip:SetText('已完成神器')
        end)

    elseif arg1=='Blizzard_ItemInteractionUI' then--套装, 转换
        ItemInteractionFrame.CurrencyCost.Costs:SetText('花费：')
        e.dia("ITEM_INTERACTION_CONFIRMATION_DELAYED", {button2 = '取消'})
        e.dia("ITEM_INTERACTION_CONFIRMATION_DELAYED_WITH_CHARGE_INFO", {button2 = '取消'})
         --[[
        hooksecurefunc(ItemInteractionFrame, 'LoadInteractionFrameData', function(self, frameData)
            local title= e.strText[frameData.titleText]
            if title then
                self:SetTitle(title);
            end
            local name= e.strText[frameData.buttonText]
            if name then
                self.ButtonFrame.ActionButton:SetText(name)
            end
            info= frameData
            for k, v in pairs(info) do if v and type(v)=='table' then print('|cff00ff00---',k, '---STAR') for k2,v2 in pairs(v) do print(k2,v2) end print('|cffff0000---',k, '---END') else print(k,v) end end print('|cffff00ff——————————')
        end)
       
        需要内容
    hooksecurefunc(ItemInteractionFrame, 'UpdateDescription', function(self, description)
        local desc= e.strText[description]
        if desc then
            self.Description:SetText(desc)
        end
    end]]
        

    elseif arg1=='Blizzard_MajorFactions' then
        hooksecurefunc(MajorFactionButtonUnlockedStateMixin, 'Refresh', function(self, majorFactionData)--Blizzard_MajorFactionsLandingTemplates.lua
            e.set(self.Title, majorFactionData.name)
            self.RenownLevel:SetFormattedText('%d级', majorFactionData.renownLevel or 0)
        end)
        hooksecurefunc(MajorFactionWatchFactionButtonMixin, 'OnLoad', function(self)
            self.Label:SetText('显示为经验条')
        end)

        --Blizzard_MajorFactionRenown.lua
        hooksecurefunc(MajorFactionRenownFrame, 'SetUpMajorFactionData', function(self)
            local majorFactionData = C_MajorFactions.GetMajorFactionData(self.majorFactionID) or {}
---@diagnostic disable-next-line: undefined-field
            if majorFactionData.name and majorFactionData.currentFactionID ~= self.majorFactionID then
                e.set(self.TrackFrame.Title, majorFactionData.name)
            end
        end)



    elseif arg1=='Blizzard_CharacterCustomize' then--飞龙，制定界面
        CharCustomizeFrame.RandomizeAppearanceButton.simpleTooltipLine= '随机外观'

    elseif arg1=='Blizzard_DebugTools' then--FSTACK
        TableAttributeDisplay.VisibilityButton.Label:SetText('显示')
        TableAttributeDisplay.HighlightButton.Label:SetText('高亮')
        TableAttributeDisplay.DynamicUpdateButton.Label:SetText('动态更新')



    elseif arg1=='Blizzard_EventTrace' then--ETRACE
        EventTraceTitleText:SetText('事件记录')

        EventTrace.SubtitleBar.ViewLog.Label:SetText('查看日志')
        EventTrace.SubtitleBar.ViewFilter.Label:SetText('过滤器')
        EventTrace.Log.Bar.Label:SetText('记录')
        hooksecurefunc(EventTrace, 'DisplayEvents', function(self)
            self.Log.Bar.Label:SetText('记录')
        end)
        hooksecurefunc(EventTrace, 'OnSearchDataProviderChanged', function(self)
            self.Log.Bar.Label:SetFormattedText('结果：%d', self.searchDataProvider:GetSize() or 0)
        end)
        EventTrace.Log.Bar.DiscardAllButton.Label:SetText('全部清除')
        EventTrace.Log.Bar.PlaybackButton.Label:SetText(EventTrace:IsLoggingPaused() and '|cnRED_FONT_COLOR:开始' or '|cnGREEN_FONT_COLOR:暂停')
        hooksecurefunc(EventTrace, 'UpdatePlaybackButton', function(self)
            self.Log.Bar.PlaybackButton.Label:SetText(self:IsLoggingPaused() and '|cnRED_FONT_COLOR:开始' or '|cnGREEN_FONT_COLOR:暂停')
        end)
        EventTrace.Log.Bar.MarkButton.Label:SetText('标记')

        EventTrace.Filter.Bar.Label:SetText('过滤')
        EventTrace.Filter.Bar.DiscardAllButton.Label:SetText('全部删除')
        EventTrace.Filter.Bar.UncheckAllButton.Label:SetText('全部取消')
        EventTrace.Filter.Bar.CheckAllButton.Label:SetText('全部选取')

    elseif arg1=='Blizzard_ScrappingMachineUI' then--分解
        ScrappingMachineFrame.ScrapButton:SetText('拆解')
        C_Timer.After(0.3, function() ScrappingMachineFrameTitleText:SetText('拆解大师Mk1型') end)

    elseif arg1=='Blizzard_BarbershopUI' then--理发店
        BarberShopFrame.CancelButton:SetText('取消')
        BarberShopFrame.ResetButton:SetText('重置')
        BarberShopFrame.AcceptButton:SetText('接受')
    end
end
























--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(_, _, arg1)
    Init_Event(arg1)
end)
