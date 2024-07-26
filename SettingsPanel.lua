local e= select(2, ...)


hooksecurefunc(SettingsCategoryListButtonMixin, 'Init', function(self, initializer)--列表 Blizzard_CategoryList.lua
    local category = initializer.data.category
    if category then
        e.set(self.Label, category:GetName())
    end
end)
hooksecurefunc(SettingsCategoryListHeaderMixin, 'Init', function(self, initializer)
    e.set(self.Label, initializer.data.label)
end)

--选项
hooksecurefunc(SettingsPanel.Container.SettingsList.ScrollBox, 'Update', function(frame)
    if not frame:GetView() or not frame:IsVisible() then
        return
    end
    --标提
    e.set(SettingsPanel.Container.SettingsList.Header.Title)
    for _, btn in pairs(frame:GetFrames() or {}) do
        local lable
        if btn.Button then--按钮
            lable= btn.Button.Text or btn.Button
            if lable then
                e.set(lable)
            end
        end
        if btn.DropDown and btn.DropDown.Button and btn.DropDown.Button.SelectionDetails  then--下拉，菜单info= btn
            lable= btn.DropDown.Button.SelectionDetails.SelectionName
            if lable then
                e.set(lable)
            end
        end
        lable= btn.Text or btn.Label or btn.Title
        if lable then
            e.set(lable)
        elseif btn.Text and btn.data and btn.data.name and btn.data.name then
            e.set(btn.Text, btn.data.name)
        end
    end
end)
hooksecurefunc('BindingButtonTemplate_SetupBindingButton', function(_, button)--BindingUtil.lua
    local text= button:GetText()
    if text==GRAY_FONT_COLOR:WrapTextInColorCode(NOT_BOUND) then
        button:SetText(GRAY_FONT_COLOR:WrapTextInColorCode('未设置'))
    else
        e.set(button, text)
    end
end)

hooksecurefunc(KeyBindingFrameBindingTemplateMixin, 'Init', function(self, initializer)
    e.set(self.Label)
end)

















local function Init()
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

end






--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_Settings') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_Settings' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()

    end
end)