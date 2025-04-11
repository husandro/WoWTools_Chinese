function WoWTools_ChineseMixin:GetRecipeName(recipeInfo, hyperlink)
    local name
    hyperlink= hyperlink or (recipeInfo and recipeInfo.hyperlink)

    local color
    if hyperlink then
        local item = Item:CreateFromItemLink(hyperlink)
        color= (item:GetItemQualityColor() or {}).color
        name= self:GetItemName(item:GetItemID()) or self:CN(item:GetItemName())
    end
    if not name and recipeInfo then
        name= self:GetSkillLineAbilityName(recipeInfo.skillLineAbilityID)
    end
    if name and color then
        name= WrapTextInColor(name, color)
    end

    return name
end