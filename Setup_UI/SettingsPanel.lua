


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




--[[

local function InitControlDropdown(containerFrame, _, name, tooltip)
    if not containerFrame:IsShown() then
        return
    end
    WoWTools_ChineseMixin:SetLabel(containerFrame.Text, name)

    local tooltipFunc = GenerateClosure(Settings.InitTooltip, WoWTools_ChineseMixin:GetData(name), WoWTools_ChineseMixin:GetData(tooltip))
    containerFrame:SetTooltipFunc(tooltipFunc)
end

local function InitControlSlider(containerFrame, _, name, tooltip)
    if not containerFrame:IsShown() then
        return
    end
    WoWTools_ChineseMixin:SetLabel(containerFrame.Text, name)
    local sliderWithSteppers = containerFrame.SliderWithSteppers
    local initTooltip = GenerateClosure(Settings.InitTooltip, WoWTools_ChineseMixin:GetData(name), WoWTools_ChineseMixin:GetData(tooltip))
    sliderWithSteppers.Slider:SetTooltipFunc(initTooltip)
    containerFrame:SetTooltipFunc(initTooltip)
end
    if raid then
		WoWTools_ChineseMixin:SetLabel(self.GraphicsQuality.Text, SETTINGS_RAID_GRAPHICS_QUALITY)
	else
        WoWTools_ChineseMixin:SetLabel(self.GraphicsQuality.Text, BASE_GRAPHICS_QUALITY)
	end
    InitControlDropdown(self.ShadowQuality, nil, SHADOW_QUALITY, OPTION_TOOLTIP_SHADOW_QUALITY)
	InitControlDropdown(self.LiquidDetail, nil, LIQUID_DETAIL, OPTION_TOOLTIP_LIQUID_DETAIL)
	InitControlDropdown(self.ParticleDensity, nil, PARTICLE_DENSITY, OPTION_TOOLTIP_PARTICLE_DENSITY)
	InitControlDropdown(self.SSAO, nil,	SSAO_LABEL, OPTION_TOOLTIP_SSAO)
	InitControlDropdown(self.DepthEffects, nil, DEPTH_EFFECTS, OPTION_TOOLTIP_DEPTH_EFFECTS)
	InitControlDropdown(self.ComputeEffects, nil, COMPUTE_EFFECTS, OPTION_TOOLTIP_COMPUTE_EFFECTS)
	InitControlDropdown(self.OutlineMode, nil, OUTLINE_MODE, OPTION_TOOLTIP_OUTLINE_MODE)
	InitControlDropdown(self.TextureResolution, nil, TEXTURE_DETAIL, OPTION_TOOLTIP_TEXTURE_DETAIL)
	InitControlDropdown(self.SpellDensity, nil, SPELL_DENSITY, OPTION_TOOLTIP_SPELL_DENSITY)
	InitControlDropdown(self.ProjectedTextures, nil, PROJECTED_TEXTURES, OPTION_TOOLTIP_PROJECTED_TEXTURES)
	InitControlSlider(	self.ViewDistance, nil, FARCLIP, OPTION_TOOLTIP_FARCLIP)
	InitControlSlider(	self.EnvironmentDetail, nil,	ENVIRONMENT_DETAIL, OPTION_TOOLTIP_ENVIRONMENT_DETAILs)
	InitControlSlider(	self.GroundClutter, nil,	GROUND_CLUTTER, OPTION_TOOLTIP_GROUND_CLUTTER)

]]

hooksecurefunc(SettingsAdvancedQualityControlsMixin, 'Init', function(self, settings, raid, cbrHandles)
    if raid then
		WoWTools_ChineseMixin:SetLabel(self.GraphicsQuality.Text, SETTINGS_RAID_GRAPHICS_QUALITY)
	else
        WoWTools_ChineseMixin:SetLabel(self.GraphicsQuality.Text, BASE_GRAPHICS_QUALITY)
	end
    WoWTools_ChineseMixin:SetLabel(self.ShadowQuality, SHADOW_QUALITY)
	WoWTools_ChineseMixin:SetLabel(self.LiquidDetail, LIQUID_DETAIL)
	WoWTools_ChineseMixin:SetLabel(self.ParticleDensity, PARTICLE_DENSITY)
	WoWTools_ChineseMixin:SetLabel(self.SSAO, SSAO_LABEL)
	WoWTools_ChineseMixin:SetLabel(self.DepthEffects, DEPTH_EFFECTS)
	WoWTools_ChineseMixin:SetLabel(self.ComputeEffects, COMPUTE_EFFECTS)
	WoWTools_ChineseMixin:SetLabel(self.OutlineMode, OUTLINE_MODE)
	WoWTools_ChineseMixin:SetLabel(self.TextureResolution, TEXTURE_DETAIL)
	WoWTools_ChineseMixin:SetLabel(self.SpellDensity, SPELL_DENSITY)
	WoWTools_ChineseMixin:SetLabel(self.ProjectedTextures, PROJECTED_TEXTURES)
	WoWTools_ChineseMixin:SetLabel(self.ViewDistance, FARCLIP)
	WoWTools_ChineseMixin:SetLabel(self.EnvironmentDetail, ENVIRONMENT_DETAIL)
	WoWTools_ChineseMixin:SetLabel(self.GroundClutter, GROUND_CLUTTER)

end)


hooksecurefunc(Settings, 'InitTooltip', function(name, tooltip)
    GameTooltip_SetTitle(SettingsTooltip, WoWTools_ChineseMixin:GetData(name))
	if tooltip then
		if type(tooltip) == "function" then
			GameTooltip_AddNormalLine(SettingsTooltip, WoWTools_ChineseMixin:GetData(tooltip()))
		else
			GameTooltip_AddNormalLine(SettingsTooltip, WoWTools_ChineseMixin:GetData(tooltip))
		end
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