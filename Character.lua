local id, e= ...
    
    



local function Init()
    --角色
    CharacterFrameTab1:SetText('角色')
    CharacterFrameTab1:HookScript('OnEnter', function()
        GameTooltip:SetText(MicroButtonTooltipText('角色信息', "TOGGLECHARACTER0"), 1.0,1.0,1.0 )
    end)
        PAPERDOLL_SIDEBARS[1].name= '角色属性'
            CharacterStatsPane.ItemLevelCategory.Title:SetText('物品等级')
            CharacterStatsPane.AttributesCategory.Title:SetText('属性')
            CharacterStatsPane.EnhancementsCategory.Title:SetText('强化属性')
            hooksecurefunc('PaperDollFrame_SetLabelAndText', function(statFrame, label)--PaperDollFrame.lua
                if statFrame.Label then
                    local text= e.strText[label]
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
                GearManagerPopupFrame.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription:SetText('点击在列表中浏览')
                GearManagerPopupFrame.BorderBox.OkayButton:SetText('确认')
                GearManagerPopupFrame.BorderBox.CancelButton:SetText('取消')
                hooksecurefunc('PaperDollEquipmentManagerPane_InitButton', function(button, elementData)
                    if elementData.addSetButton then
                        button.text:SetText('新的方案')
                    end
                end)
    CharacterFrameTab2:SetText('声望')
    CharacterFrameTab2:HookScript('OnEnter', function()
        GameTooltip:SetText(MicroButtonTooltipText('声望', "TOGGLECHARACTER2"), 1.0,1.0,1.0 )
    end)

end


--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)