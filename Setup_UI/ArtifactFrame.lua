


local function Init()
    hooksecurefunc(ArtifactFrame, 'SetTab', function(self, id)
        WoWTools_ChineseMixin:SetLabelText(ArtifactFrameTab1)
	    WoWTools_ChineseMixin:SetLabelText(ArtifactFrameTab2)
    end)

    --Blizzard_ArtifactPerks.lua ArtifactTitleTemplateMixin
    WoWTools_ChineseMixin:SetLabelText(ArtifactFrame.PerksTab.TitleContainer.ArtifactPower)
    WoWTools_ChineseMixin:SetRegions(ArtifactFrame.PerksTab.DisabledFrame, nil, nil, true)
    hooksecurefunc(ArtifactFrame.PerksTab.TitleContainer, 'RefreshTitle', function(self)
        local itemID, itemName= C_ArtifactUI.GetArtifactInfo()
        if not itemID then
            return
        end
        local name = WoWTools_ChineseMixin:GetItemName(itemID) or WoWTools_ChineseMixin:CN(itemName)
        if name then
            if C_ArtifactUI.IsArtifactDisabled() then
                self:GetParent().DisabledFrame.ArtifactName:SetText(name)
            else
                self.ArtifactName:SetText(name);
            end
        end
    end)
    
end


EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_ArtifactUI' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)