





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

WoWTools_ChineseMixin:SetLabel(GearManagerPopupFrame.BorderBox.EditBoxHeaderText)
WoWTools_ChineseMixin:HookLabel(GearManagerPopupFrame.BorderBox.IconTypeDropdown.Text)
WoWTools_ChineseMixin:SetLabel(GearManagerPopupFrame.BorderBox.IconDragArea.IconDragAreaContent.IconDragText)
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


    hooksecurefunc('PaperDollTitlesPane_InitButton', function(btn)
        if not btn.OnEnter then
            WoWTools_ChineseMixin:SetCNFont(btn:GetFontString())

            btn:SetScript('OnLeave', function() GameTooltip:Hide() end)

            btn:HookScript('OnEnter', function(f)
                if not f.titleId or f.titleId<0 then
                    return
                end

                local cn= WoWTools_ChineseMixin:GetTitleName(f.titleId)
                if cn then
                    GameTooltip:SetOwner(f, "ANCHOR_LEFT")
                    GameTooltip_SetTitle(GameTooltip, format(cn, UnitName('player')), nil)
                    GameTooltip_AddNormalLine(GameTooltip, GetTitleName(f.titleId), nil)
                    GameTooltip:Show()
                end
            end)
            btn.get_name= true
        end

        local name= btn.titleId==-1 and '无头衔' or WoWTools_ChineseMixin:GetTitleName(btn.titleId)
        if name then
            btn:SetText(format(name, ''))
        end
    end)

--[[hooksecurefunc(PaperDollFrame.TitleManagerPane.ScrollBox, 'Update', function(frame)
    for _, btn in pairs(frame:GetFrames() or {}) do
        if not btn.get_name then
            WoWTools_ChineseMixin:SetCNFont(btn:GetFontString())

            btn:HookScript('OnLeave', GameTooltip_Hide)

            btn:HookScript('OnEnter', function(f)
                if f.titleId==-1 then
                    return
                end
                local name= f.titleId==-1 and '无头衔' or WoWTools_ChineseMixin:GetTitleName(f.titleId)
                if name then
                    GameTooltip:SetOwner(f, "ANCHOR_LEFT")
                    GameTooltip_SetTitle(GameTooltip, format(name, UnitName('player')), nil)
                    GameTooltip_AddNormalLine(GameTooltip, GetTitleName(f.titleId), nil)
                    GameTooltip:Show()
                end
            end)
            btn.get_name= true
        end

        local name= btn.titleId==-1 and '无头衔' or WoWTools_ChineseMixin:GetTitleName(btn.titleId)
        if name then
            btn:SetText(format(name, ''))
        end
    end
end)]]