local id, e = ...



local function Init()
    hooksecurefunc('ClassTrainerFrame_InitServiceButton', function(skillButton, elementData)
        local skillIndex = elementData.skillIndex
        local isTradeSkill = elementData.isTradeSkill

        local serviceName, serviceType, _, reqLevel = GetTrainerServiceInfo(skillIndex)
        if ( not serviceName ) then
            serviceName = '未知'
        else
            local name= e.strText[serviceName]
            if not name then
                local itemLink= GetTrainerServiceItemLink(skillIndex)
                local itemID= itemLink and C_Item.GetItemInfoInstant(itemLink)
                if itemID then
                    local itemName= C_Item.GetItemNameByID(itemLink)
                    name= e.Get_Item_Search_Name(itemID) or e.strText[itemName]                    
                end
            end
            if name then
                serviceName= name
            end
        end


        local requirements = ""
        local separator = ""
        if reqLevel and reqLevel > 1 then
            if ( UnitLevel("player") >= reqLevel ) then
                requirements = requirements..format('等级 |cffffffff%d|r', reqLevel)
            else
                requirements = requirements..format('等级 |cffff2020%d|r', reqLevel)
            end
            separator = '，'
        end

        if ( isTradeSkill ) then
            local skill, rank, hasReq = GetTrainerServiceSkillReq(skillIndex)
            if ( skill ) then
                skill= e.cn(skill)
                if ( hasReq ) then
                    requirements = requirements..separator..format('%s (|cffffffff%d|r)', skill, rank )
                else
                    requirements = requirements..separator..format('%s (|cffff2020%d|r)', skill, rank )
                end
                separator = '，'
            end
        end

        -- Ability Requirements
        local numRequirements = GetTrainerServiceNumAbilityReq(skillIndex)
        local ability, hasReq
        if ( numRequirements > 0 ) then
            for i=1, numRequirements, 1 do
                ability, hasReq = GetTrainerServiceAbilityReq(skillIndex, i)
                if ( ability ) then
                    ability= e.cn(ability)
                    if ( hasReq ) then
                        requirements = requirements..separator..format('|cffffffff%s|r', ability )
                    else
                        requirements = requirements..separator..format('|cffff2020%s|r', ability )
                    end
                end
            end
        end

        if ( serviceType == "unavailable" ) then
            skillButton.name:SetText(GRAY_FONT_COLOR_CODE..serviceName..FONT_COLOR_CODE_CLOSE)
        else
            skillButton.name:SetText(serviceName)
        end

        if ( requirements ~= "" and serviceType ~= "used" ) then
            requirements = "需要："..requirements
        elseif ( serviceType == "used" ) then
            requirements = '已经学会'
        else
            requirements = ""
        end
        skillButton.subText:SetText(requirements)
    end)
end




--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_TrainerUI') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_TrainerUI' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()

    end
end)