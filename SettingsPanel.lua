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
