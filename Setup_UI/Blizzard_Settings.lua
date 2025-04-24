


hooksecurefunc(SettingsCategoryListButtonMixin, 'Init', function(self, initializer)--列表 Blizzard_CategoryList.lua
    local category = not InCombatLockdown() and initializer.data.category
    if category then
        WoWTools_ChineseMixin:SetLabel(self.Label, category:GetName())
    end
end)
hooksecurefunc(SettingsCategoryListHeaderMixin, 'Init', function(self, initializer)
    if not InCombatLockdown() then
        WoWTools_ChineseMixin:SetLabel(self.Label, initializer.data.label)
    end
end)

--选项
hooksecurefunc(SettingsPanel.Container.SettingsList.ScrollBox, 'Update', function(frame)
    if not frame:GetView() or not frame:IsVisible() or InCombatLockdown() then
        return
    end

    WoWTools_ChineseMixin:SetLabel(SettingsPanel.Container.SettingsList.Header.Title)--标提
    for _, btn in pairs(frame:GetFrames() or {}) do
        local lable
        if btn.Button then--按钮
            lable= btn.Button.Text or btn.Button
            if lable then
                WoWTools_ChineseMixin:SetLabel(lable)
            end
        end
        if btn.DropDown and btn.DropDown.Button and btn.DropDown.Button.SelectionDetails  then--下拉，菜单info= btn
            lable= btn.DropDown.Button.SelectionDetails.SelectionName
            if lable then
                WoWTools_ChineseMixin:SetLabel(lable)
            end
        end
        lable= btn.Text or btn.Label or btn.Title
        if lable then
            WoWTools_ChineseMixin:SetLabel(lable)
        elseif btn.Text and btn.data and btn.data.name and btn.data.name then
            WoWTools_ChineseMixin:SetLabel(btn.Text, btn.data.name)
        end
        if btn.SubTextContainer then
            WoWTools_ChineseMixin:SetLabel(btn.SubTextContainer.SubText)
        end
    end
end)







hooksecurefunc('BindingButtonTemplate_SetupBindingButton', function(_, button)--BindingUtil.lua
    if InCombatLockdown() then
        return
    end
    local text= button:GetText()
    if text==GRAY_FONT_COLOR:WrapTextInColorCode(NOT_BOUND) then
        button:SetText(GRAY_FONT_COLOR:WrapTextInColorCode('未设置'))
    else
        WoWTools_ChineseMixin:SetLabel(button, text)
    end
end)

hooksecurefunc(KeyBindingFrameBindingTemplateMixin, 'Init', function(self)
    if not InCombatLockdown() then
        WoWTools_ChineseMixin:SetLabel(self.Label)
    end
end)

WoWTools_ChineseMixin:HookLabel(SettingsPanel.OutputText)








hooksecurefunc(SettingsAdvancedQualityControlsMixin, 'Init', function(self, settings, raid, cbrHandles)
    if raid then
		WoWTools_ChineseMixin:SetLabel(self.GraphicsQuality.Text, SETTINGS_RAID_GRAPHICS_QUALITY)
	else
        WoWTools_ChineseMixin:SetLabel(self.GraphicsQuality.Text, BASE_GRAPHICS_QUALITY)
	end
    WoWTools_ChineseMixin:SetLabel(self.ShadowQuality.Text, SHADOW_QUALITY)
	WoWTools_ChineseMixin:SetLabel(self.LiquidDetail.Text, LIQUID_DETAIL)
	WoWTools_ChineseMixin:SetLabel(self.ParticleDensity.Text, PARTICLE_DENSITY)
	WoWTools_ChineseMixin:SetLabel(self.SSAO.Text, SSAO_LABEL)
	WoWTools_ChineseMixin:SetLabel(self.DepthEffects.Text, DEPTH_EFFECTS)
	WoWTools_ChineseMixin:SetLabel(self.ComputeEffects.Text, COMPUTE_EFFECTS)
	WoWTools_ChineseMixin:SetLabel(self.OutlineMode.Text, OUTLINE_MODE)
	WoWTools_ChineseMixin:SetLabel(self.TextureResolution.Text, TEXTURE_DETAIL)
	WoWTools_ChineseMixin:SetLabel(self.SpellDensity.Text, SPELL_DENSITY)
	WoWTools_ChineseMixin:SetLabel(self.ProjectedTextures.Text, PROJECTED_TEXTURES)
	WoWTools_ChineseMixin:SetLabel(self.ViewDistance.Text, FARCLIP)
	WoWTools_ChineseMixin:SetLabel(self.EnvironmentDetail.Text, ENVIRONMENT_DETAIL)
	WoWTools_ChineseMixin:SetLabel(self.GroundClutter.Text, GROUND_CLUTTER)

    local p=self:GetParent()
    WoWTools_ChineseMixin:SetLabel(p.BaseTab.Text)
    WoWTools_ChineseMixin:SetLabel(p.RaidTab.Text)

end)


--颜色，物品品质
hooksecurefunc(ItemQualityColorOverrideMixin, 'Init', function(self)
    WoWTools_ChineseMixin:SetLabel(self.Header)
    for _, frame in ipairs(self.colorOverrideFrames) do
        WoWTools_ChineseMixin:SetLabel(frame.Text)
    end
end)




function WoWTools_ChineseMixin.Events:Blizzard_Settings()
    SettingsPanel.Container.SettingsList.Header.DefaultsButton:SetText('默认设置')
    WoWTools_ChineseMixin:AddDialogs('GAME_SETTINGS_APPLY_DEFAULTS', {text= '你想要将所有用户界面和插件设置重置为默认状态，还是只重置这个界面或插件的设置？', button1= '所有设置', button2= '取消', button3= '这些设置'})--Blizzard_Dialogs.lua
    SettingsPanel.GameTab.Text:SetText('游戏')
    SettingsPanel.AddOnsTab.Text:SetText('插件')
    SettingsPanel.NineSlice.Text:SetText('选项')
    SettingsPanel.CloseButton:SetText('关闭')
    SettingsPanel.ApplyButton:SetText('应用')

    SettingsPanel.NineSlice.Text:SetText('选项')
    SettingsPanel.SearchBox.Instructions:SetText('搜索')
end