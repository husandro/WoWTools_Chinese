if select(4,GetBuildInfo())>=110000  then--11版本
    return
end
local e= select(2, ...)


local function Init()
    for _, tabID in pairs(ClassTalentFrame:GetTabSet() or {}) do
       local btn= ClassTalentFrame:GetTabButton(tabID)
       e.set(btn)
       
   end

   --Blizzard_ClassTalentTalentsTab.lua
   ClassTalentFrame.TalentsTab.ApplyButton:SetText('应用改动')
   ClassTalentFrame.TalentsTab.SearchBox.Instructions:SetText('搜索')
   hooksecurefunc(ClassTalentFrame.TalentsTab.ApplyButton, 'SetDisabledTooltip', function(self, canChangeError)
       if canChangeError then
           if canChangeError ==  TALENT_FRAME_REFUND_INVALID_ERROR  then
               self.disabledTooltip = '你必须修复所有错误。忘却天赋来释放点数，并在其他地方花费这些点数来构建可用的配置。'
           elseif canChangeError== ERR_TALENT_FAILED_UNSPENT_TALENT_POINTS then
               self.disabledTooltip= '你必须花费所有可用的天赋点才能应用改动'
           end
       end
   end)

   hooksecurefunc(ClassTalentFrame.TalentsTab.ClassCurrencyDisplay, 'SetPointTypeText', function(self, text)
       self.CurrencyLabel:SetFormattedText('%s 可用点数', e.strText[ClassTalentFrame.TalentsTab:GetClassName()] or text)
   end)
   hooksecurefunc(ClassTalentFrame.TalentsTab.SpecCurrencyDisplay, 'SetPointTypeText', function(self, text)
       self.CurrencyLabel:SetFormattedText('%s 可用点数', e.strText[ClassTalentFrame.TalentsTab:GetSpecName()] or text)
   end)
   ClassTalentFrame.TalentsTab.InspectCopyButton:SetTextToFit('复制配置代码')

   if ClassTalentFrame.SpecTab.numSpecs and ClassTalentFrame.SpecTab.numSpecs>0 and ClassTalentFrame.SpecTab.SpecContentFramePool then
       local sex= UnitSex("player")
       local SPEC_STAT_STRINGS = {
           [LE_UNIT_STAT_STRENGTH] = '力量',
           [LE_UNIT_STAT_AGILITY] = '敏捷',
           [LE_UNIT_STAT_INTELLECT] = '智力',
       }
       for frame in pairs(ClassTalentFrame.SpecTab.SpecContentFramePool.activeObjects or {}) do
           frame.ActivatedText:SetText('激活')
           frame.ActivateButton:SetText('激活')
           if frame.RoleName then
               e.set(frame.RoleName)
           end
           frame.SampleAbilityText:SetText('典型技能')
           if frame.specIndex then
               local specID, _, description, _, _, primaryStat = GetSpecializationInfo(frame.specIndex, false, false, nil, sex)
               if specID and primaryStat and primaryStat ~= 0 then
                   frame.Description:SetText(
                        (e.cn(description) or '')
                        .."|n"
                        ..format('主要属性：%s', SPEC_STAT_STRINGS[primaryStat])
                    )
               end
               e.set(frame.SpecName)
           end

       end
   end

   ClassTalentFrame.TalentsTab.UndoButton.tooltipText= '取消待定改动'
   --Blizzard_WarmodeButtonTemplate.lua
   ClassTalentFrame.TalentsTab.WarmodeButton:HookScript('OnEnter', function(self)
       --GameTooltip:SetOwner(self, "ANCHOR_LEFT", 14, 0)
       GameTooltip:AddLine(' ')
       GameTooltip:AddLine('战争模式')
       --GameTooltip_SetTitle(GameTooltip, '战争模式')
       if C_PvP.IsWarModeActive() or self:GetWarModeDesired() then
           GameTooltip_AddInstructionLine(GameTooltip, '|cnGREEN_FONT_COLOR:开启')
       end
       local wrap = true
       local warModeRewardBonus = C_PvP.GetWarModeRewardBonus()
       GameTooltip_AddNormalLine(GameTooltip, format('加入战争模式即可激活世界PvP，使任务的奖励和经验值提高%1$d%%，并可以在野外使用PvP天赋。', warModeRewardBonus), wrap)
       local canToggleWarmode = C_PvP.CanToggleWarMode(true)
       local canToggleWarmodeOFF = C_PvP.CanToggleWarMode(false)

       if(not canToggleWarmode or not canToggleWarmodeOFF) then
           if (not C_PvP.ArePvpTalentsUnlocked()) then
               GameTooltip_AddErrorLine(GameTooltip, format('|cnRED_FONT_COLOR:在%d级解锁', C_PvP.GetPvpTalentsUnlockedLevel()), wrap)
           else
               local warmodeErrorText
               if(not C_PvP.CanToggleWarModeInArea()) then
                   if(self:GetWarModeDesired()) then
                       if(not canToggleWarmodeOFF and not IsResting()) then
                           warmodeErrorText = UnitFactionGroup("player") == PLAYER_FACTION_GROUP[0] and '战争模式可以在任何休息区域关闭，但只能在奥格瑞玛或瓦德拉肯开启。' or '战争模式可以在任何休息区域关闭，但只能在暴风城或瓦德拉肯开启。'
                       end
                   else
                       if(not canToggleWarmode) then
                           warmodeErrorText = UnitFactionGroup("player") == PLAYER_FACTION_GROUP[0] and '只能在奥格瑞玛或瓦德拉肯进入战争模式。' or '只能在暴风城或瓦德拉肯进入战争模式。'
                       end
                   end
               end
               if(warmodeErrorText) then
                   GameTooltip_AddErrorLine(GameTooltip, '|cnRED_FONT_COLOR:'..warmodeErrorText, wrap)
               elseif (UnitAffectingCombat("player")) then
                   GameTooltip_AddErrorLine(GameTooltip, '|cnRED_FONT_COLOR:你正处于交战状态', wrap)
               end
           end
       end
       GameTooltip:Show()
   end)

   e.dia("CONFIRM_LEARN_SPEC", {button1 = '是', button2 = '否',})
   e.hookDia("CONFIRM_LEARN_SPEC", 'OnShow', function(self)
       if (self.data.previewSpecCost and self.data.previewSpecCost > 0) then
           self.text:SetFormattedText('激活此专精需要花费%s。确定要学习此专精吗？', GetMoneyString(self.data.previewSpecCost))
       else
           self.text:SetText('你确定要学习这种天赋专精吗？')
       end
   end)

   e.dia("CONFIRM_EXIT_WITH_UNSPENT_TALENT_POINTS", {text = '你还有未分配的天赋。你确定要关闭这个窗口？', button1 = '是', button2 = '否'})

   hooksecurefunc(ClassTalentFrame, 'UpdateFrameTitle', function(self)
       local tabID = self:GetTab()
       if self:IsInspecting() then
           local inspectUnit = self:GetInspectUnit()
           if inspectUnit then
               self:SetTitle(format('天赋 - %s', UnitName(self:GetInspectUnit())))
           else
               self:SetTitle(format('天赋链接 (%s %s)', self:GetSpecName(), self:GetClassName()))
           end
       elseif tabID == self.specTabID then
           self:SetTitle('专精')
       else -- tabID == self.talentTabID
           self:SetTitle('天赋')
       end
   end)

   --Blizzard_ClassTalentLoadoutEditDialog.lua
   e.dia("LOADOUT_CONFIRM_DELETE_DIALOG", {text = '你确定要删除配置%s吗？', button1 = '删除', button2 = '取消'})
   e.dia("LOADOUT_CONFIRM_SHARED_ACTION_BARS", {text = '此配置的动作条会被你共享的动作条替换。', button1 = '接受', button2 = '取消'})
   ClassTalentLoadoutEditDialog.UsesSharedActionBars:HookScript('OnEnter', function()
       GameTooltip:AddLine(' ')
       GameTooltip_AddNormalLine(GameTooltip, '默认条件下，每个配置都有自己保存的一套动作条。\n\n所有开启此选项的配置都会共享同样的动作条。')
       GameTooltip:Show()
   end)

   --Blizzard_ClassTalentLoadoutImportDialog.xml
   ClassTalentLoadoutImportDialog.Title:SetText('导入配置')
   ClassTalentLoadoutImportDialog.ImportControl.Label:SetText('导入文本')
   ClassTalentLoadoutImportDialog.ImportControl.InputContainer.EditBox.Instructions:SetText('在此粘贴配置代码')
   ClassTalentLoadoutImportDialog.NameControl.Label:SetText('新配置名称')
   ClassTalentLoadoutImportDialog.AcceptButton:SetText('导入')
   ClassTalentLoadoutImportDialog.CancelButton:SetText('取消')
   ClassTalentLoadoutImportDialog.AcceptButton.disabledTooltip = '输入可用的配置代码'

   --Blizzard_ClassTalentLoadoutEditDialog.xml
   ClassTalentLoadoutEditDialog.Title:SetText('配置设定')
   ClassTalentLoadoutEditDialog.NameControl.Label:SetText('名字')
   ClassTalentLoadoutEditDialog.UsesSharedActionBars.Label:SetText('使用共享的动作条')
   ClassTalentLoadoutEditDialog.AcceptButton:SetText('接受')
   ClassTalentLoadoutEditDialog.DeleteButton:SetText('删除')
   ClassTalentLoadoutEditDialog.CancelButton:SetText('取消')

   --Blizzard_ClassTalentLoadoutCreateDialog.xml
   ClassTalentLoadoutCreateDialog.Title:SetText('新配置')
   ClassTalentLoadoutCreateDialog.NameControl.Label:SetText('名字')
   ClassTalentLoadoutCreateDialog.AcceptButton:SetText('保存')
   ClassTalentLoadoutCreateDialog.CancelButton:SetText('取消')
end











--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_ClassTalentUI') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_ClassTalentUI' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)














