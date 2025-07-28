





PAPERDOLL_SIDEBARS[1].name= '角色属性'
CharacterStatsPane.ItemLevelCategory.Title:SetText('物品等级')
CharacterStatsPane.AttributesCategory.Title:SetText('属性')
CharacterStatsPane.EnhancementsCategory.Title:SetText('强化属性')
WoWTools_ChineseMixin:SetLabel(CharacterTrialLevelErrorText)

hooksecurefunc('PaperDollFrame_SetLabelAndText', function(statFrame, label)--PaperDollFrame.lua
    if statFrame.Label then
        local text= WoWTools_ChineseMixin:CN(label)
        if text then
            statFrame.Label:SetFormattedText('%s：', text)
        end
    end
end)


PAPERDOLL_SIDEBARS[2].name= '头衔'
PAPERDOLL_SIDEBARS[3].name= '装备管理'
PaperDollFrameEquipSetText:SetText('装备')
PaperDollFrameSaveSetText:SetText('保存')

GearManagerPopupFrame.BorderBox.EditBoxHeaderText:SetText('输入方案名称（最多16个字符）：')
GearManagerPopupFrame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader:SetText('选择一个图标：')
WoWTools_ChineseMixin:HookLabel(GearManagerPopupFrame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription)
GearManagerPopupFrame.BorderBox.OkayButton:SetText('确认')
GearManagerPopupFrame.BorderBox.CancelButton:SetText('取消')
hooksecurefunc('PaperDollEquipmentManagerPane_InitButton', function(button, elementData)
    if elementData.addSetButton then
        button.text:SetText('新的方案')
    end
end)



hooksecurefunc(CharacterFrame, 'SetTitle', function(frame)
    if frame.activeSubframe== 'PaperDollFrame' then
        local titleID = GetCurrentTitle()
        if titleID and titleID>0 then
            local title= WoWTools_ChineseMixin:GetTitleName(titleID)
            if title then
                CharacterFrameTitleText:SetFormattedText(title, NORMAL_FONT_COLOR:WrapTextInColorCode(UnitName("player")))
            end
        end
    else
        WoWTools_ChineseMixin:SetLabel(CharacterFrameTitleText)
    end
end)

CharacterFrameTab1:SetText('角色')
CharacterFrameTab1:HookScript('OnEnter', function()
    GameTooltip:SetText(MicroButtonTooltipText('角色信息', "TOGGLECHARACTER0"), 1.0,1.0,1.0 )
end)

CharacterFrameTab2:SetText('声望')
CharacterFrameTab2:HookScript('OnEnter', function()
    GameTooltip:SetText(MicroButtonTooltipText('声望', "TOGGLECHARACTER2"), 1.0,1.0,1.0 )
end)

CharacterFrameTab3:SetText('货币')
CharacterFrameTab3:HookScript('OnEnter', function()
    GameTooltip:SetText(MicroButtonTooltipText('货币', "TOGGLECURRENCY"), 1.0,1.0,1.0 )
end)



--
hooksecurefunc(PaperDollFrame.TitleManagerPane.ScrollBox, 'Update', function(frame)
    for _, btn in pairs(frame:GetFrames() or {}) do
        if not btn.get_name then

            function btn:get_name()
                local name= self.titleId==-1 and '无头衔' or WoWTools_ChineseMixin:GetTitleName(self.titleId)
                return name
            end

            WoWTools_ChineseMixin:SetCNFont(btn:GetFontString())

            btn:HookScript('OnLeave', GameTooltip_Hide)

            btn:HookScript('OnEnter', function(self)
                if self.titleId==-1 then
                    return
                end
                local name= self:get_name()
                if name then
                    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                    GameTooltip_SetTitle(GameTooltip, format(name, UnitName('player')), nil)
                    GameTooltip_AddNormalLine(GameTooltip, GetTitleName(self.titleId), nil)
                    GameTooltip:Show()
                end
            end)
        end

        local name= btn:get_name()
        if name then
            btn:SetText(format(name, ''))
        end
    end
end)