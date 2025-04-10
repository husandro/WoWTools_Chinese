local e= select(2, ...)


local function Init()
    hooksecurefunc(ArtifactFrame, 'SetTab', function(self, id)
        WoWTools_ChineseMixin:Set_Label_Text(ArtifactFrameTab1)
	    WoWTools_ChineseMixin:Set_Label_Text(ArtifactFrameTab2)
    end)

    --Blizzard_ArtifactPerks.lua ArtifactTitleTemplateMixin
    WoWTools_ChineseMixin:Set_Label_Text(ArtifactFrame.PerksTab.TitleContainer.ArtifactPower)
    WoWTools_ChineseMixin:SetRegions(ArtifactFrame.PerksTab.DisabledFrame, nil, nil, true)
    hooksecurefunc(ArtifactFrame.PerksTab.TitleContainer, 'RefreshTitle', function(self)
        local itemID, itemName= C_ArtifactUI.GetArtifactInfo()
        if not itemID then
            return
        end
        local name = WoWTools_ChineseMixin:Get_Item_Name(itemID) or e.strText[itemName]
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