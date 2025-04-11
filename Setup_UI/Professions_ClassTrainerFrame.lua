


--专业，训练师
local function Init()
    WoWTools_ChineseMixin:AddDialogs("CONFIRM_PROFESSION", {text = format('你只能学习两个专业。你要学习|cffffd200%s|r作为你的第一个专业吗？', "XXX"), button1 = '接受', button2 = '取消'})
    WoWTools_ChineseMixin:HookDialog("CONFIRM_PROFESSION", 'OnShow', function(self)
        local prof1, prof2 = GetProfessions()
        if ( prof1 and not prof2 ) then
            self.text:SetFormattedText('你只能学习两个专业。你要学习|cffffd200%s|r作为你的第二个专业吗？', GetTrainerServiceSkillLine(ClassTrainerFrame.selectedService))
        elseif ( not prof1 ) then
            self.text:SetFormattedText('你只能学习两个专业。你要学习|cffffd200%s|r作为你的第一个专业吗？', GetTrainerServiceSkillLine(ClassTrainerFrame.selectedService))
        end
    end)
    ClassTrainerTrainButton:SetText('训练')

    hooksecurefunc('ClassTrainerFrame_InitServiceButton', function(skillButton, elementData)
        local skillIndex = elementData.skillIndex
        local isTradeSkill = elementData.isTradeSkill
        local serviceName, serviceType, _, reqLevel = GetTrainerServiceInfo(skillIndex)
        if ( not serviceName ) then
            serviceName = '未知'
        else
            local name= WoWTools_ChineseMixin:CN(serviceName)
            if not name then
                local itemLink= GetTrainerServiceItemLink(skillIndex)
                local itemID= itemLink and C_Item.GetItemInfoInstant(itemLink)
                if itemID then
                    local itemName= C_Item.GetItemNameByID(itemLink)
                    name= WoWTools_ChineseMixin:GetItemName(itemID) or WoWTools_ChineseMixin:CN(itemName)
                end
                if not name then
                    local data= C_TooltipInfo.GetTrainerService(skillIndex)
                    if data and not data.isAzeriteItem and data.id then
                        name= WoWTools_ChineseMixin:GetSpellName(data.id)
                    end
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
                skill= WoWTools_ChineseMixin:GetData(skill)
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
                    ability= WoWTools_ChineseMixin:GetData(ability)
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





EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_TrainerUI' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)