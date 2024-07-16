local e= select(2, ...)
--[[
local function split(s, delimiter)
    if (s == nil) then
      return nil
    end
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end]]



local baseClass= UnitClassBase('player')
--local col= '|c'..select(4, GetClassColor(baseClass))

local sex= UnitSex("player")
local sexCol= sex==3 and '|cffff00ff%s|r' or '|cff00ff00%s|r'

local name= '|c'..select(4, GetClassColor(baseClass))..UnitName('player')..'|r'
local race= format(sexCol, e.cn(UnitRace('player')))
local class= format(sexCol, e.cn(UnitClass('player')))



--( ) . % + - * ? [ ^ $
local function expand_desc(desc)-- function WoWeuCN_Quests_ExpandUnitInfo(desc)
   if not desc then
      return
   end

   desc= desc:gsub("{name}", name)

   desc= desc:gusb("{race}", race)

   desc= desc:gsub("{class}", class)

   desc= desc:gsub('YOUR_GENDER%(.-;.-%)', function(s)--YOUR_GENDER(兄弟;小姐)
      local a,b= s:match('%((.-);(.-)%)')
      if a and b then
         return format(sexCol, sex==3 and a or b)--3	Female
      end
   end)

  return desc;
end


function e.Get_Quest_Info(questID, isName, isObject, isDesc)
   local data= e.Get_Quest_Data(questID)
   if data then
      if isName then
         return data['T']

      elseif isObject then
         return data['O']

      else
         local desc= expand_desc(data['D'])
         if isDesc then
            return desc

         else
            data['D']= desc
            return data
         end
      end
   end
end