local e= select(2, ...)












--快速快捷键模式
--QuickKeybind.xml
QuickKeybindFrame.Header.Text:SetText('快速快捷键模式')
QuickKeybindFrame.InstructionText:SetText('你处于快速快捷键模式。将鼠标移到一个按钮上并按下你想要的按键，即可设置那个按钮的快捷键。')
QuickKeybindFrame.CancelDescriptionText:SetText('取消会使你离开快速快捷键模式。')
QuickKeybindFrame.OkayButton:SetText('确定')
QuickKeybindFrame.DefaultsButton:SetText('恢复默认设置')
QuickKeybindFrame.CancelButton:SetText('取消')
QuickKeybindFrame.UseCharacterBindingsButton.text:SetText('角色专用按键设置')









WoWTools_ChineseMixin:Cstr(nil, {changeFont= QuickKeybindFrame.OutputText, size=16})
local function set_SetOutputText(self, text)
    if not text then
        return
    end
    if text==KEYBINDINGFRAME_MOUSEWHEEL_ERROR then
        self.OutputText:SetText('|cnRED_FONT_COLOR:无法将鼠标滚轮的上下滚动状态绑定在动作条上|r')
    elseif text==KEY_BOUND then
        self.OutputText:SetText('|cnGREEN_FONT_COLOR:按键设置成功|r')
    else
        local a, b, c= WoWTools_ChineseMixin:Magic(PRIMARY_KEY_UNBOUND_ERROR), WoWTools_ChineseMixin:Magic(KEY_UNBOUND_ERROR), WoWTools_ChineseMixin:Magic(SETTINGS_BIND_KEY_TO_COMMAND_OR_CANCEL)
        local finda, findb= text:match(a), text:match(b)
        local findc1, findc2= text:match(c)
        if finda then
            self.OutputText:SetFormattedText('|cffff0000主要动作 |cffff00ff%s|r 现在没有绑定！|r', e.strText[finda] or finda)
        elseif findb then
            self.OutputText:SetFormattedText('|cffff0000动作 |cffff00ff%s|r 现在没有绑定！|r', e.strText[findb] or findb)
        elseif findc1 and findc2 then
            self.OutputText:SetFormattedText('设置 |cnGREEN_FONT_COLOR:%s|r 的快捷键，或者按 %s 取消', e.strText[findc1] or findc1, findc2)
        end
    end
end
hooksecurefunc(QuickKeybindFrame, 'SetOutputText', set_SetOutputText)
hooksecurefunc(SettingsPanel, 'SetOutputText', set_SetOutputText)










--快捷键
hooksecurefunc(KeyBindingFrameBindingTemplateMixin,'Init', function(self)
    local label= self.Text or self.Label
    if label then
        WoWTools_ChineseMixin:Set_Label_Text(label, label:GetText())
    end
end)
