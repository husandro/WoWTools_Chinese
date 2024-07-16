local e= select(2, ...)

local function split(s, delimiter)
    if (s == nil) then
      return nil
    end
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end



local baseClass= UnitClassBase('player')
local col= '|c'..select(4, GetClassColor(baseClass))
local sex= UnitSex("player")
local name= col..UnitName('player')..'|r'
local faction= UnitFactionGroup('player')

--( ) . % + - * ? [ ^ $
local function expand_desc(desc)-- function WoWeuCN_Quests_ExpandUnitInfo(desc)
    if not desc then
        return
    end

    desc = desc:gsub("{name}", name)
    
    desc= desc:gsub('YOUR_GENDER%(.-;.-%)', function(s)--YOUR_GENDER(兄弟;小姐)
        local a,b= s:match('%((.-);(.-)%)')
        if a and b then
            if sex==3 then
                return '|cff'..a..'|r'
            else
                return '|cff'..b..'|r'
            end
        end
    end)


  return desc;
end

--[[player gender YOUR_GENDER(x;y)
  local nr_1, nr_2, nr_3 = 0;
  local WoWeuCN_Quests_forma = "";
  local nr_poz = string.find(desc, "YOUR_GENDER");    -- gdy nie znalazł, jest: nil
  while (nr_poz and nr_poz>0) do
     nr_1 = nr_poz + 1;
     while (string.sub(desc, nr_1, nr_1) ~= "(") do
        nr_1 = nr_1 + 1;
     end
     if (string.sub(desc, nr_1, nr_1) == "(") then
        nr_2 =  nr_1 + 1;
        while (string.sub(desc, nr_2, nr_2) ~= ";") do
           nr_2 = nr_2 + 1;
        end
        if (string.sub(desc, nr_2, nr_2) == ";") then
           nr_3 = nr_2 + 1;
           while (string.sub(desc, nr_3, nr_3) ~= ")") do
              nr_3 = nr_3 + 1;
           end
           if (string.sub(desc, nr_3, nr_3) == ")") then
              if (WoWeuCN_Quests_sex==3) then        -- female form
                 WoWeuCN_Quests_forma = string.sub(desc,nr_2+1,nr_3-1);
              else                        -- male form
                 WoWeuCN_Quests_forma = string.sub(desc,nr_1+1,nr_2-1);
              end
              desc = string.sub(desc,1,nr_poz-1) .. WoWeuCN_Quests_forma .. string.sub(desc,nr_3+1);
           end
        end
     end
     nr_poz = string.find(desc, "YOUR_GENDER");
  end

  if (WoWeuCN_Quests_sex==3) then
     desc = string.gsub(desc, "{race}", player_race.W2);
     desc = string.gsub(desc, "{class}", player_class.W2);
  else
     desc = string.gsub(desc, "{race}", player_race.W1);
     desc = string.gsub(desc, "{class}", player_class.W1);
  end]]

expand_desc('a')