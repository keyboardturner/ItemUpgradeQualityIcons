-- Turning global string into pattern to match
local patternToMatch = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING
patternToMatch = patternToMatch:gsub("%%s", ")(.*)(")
patternToMatch = patternToMatch:gsub("%%d", "[0-9]+")
patternToMatch = "(" .. patternToMatch .. ")"

local LOCALE = GetLocale()

local categoryEnum = {
	Explorer = "Explorer",
	Adventurer = "Adventurer",
	Veteran = "Veteran",
	Champion = "Champion",
	Hero = "Hero",
};

if LOCALE == "enUS" then

-- Name keys (should have a way to localize keys)
categoryEnum = {
	Explorer = "Explorer",
	Adventurer = "Adventurer",
	Veteran = "Veteran",
	Champion = "Champion",
	Hero = "Hero",
};

elseif LOCALE == "deDE" then

categoryEnum = {
	Explorer = "Forscher",
	Adventurer = "Abenteurer",
	Veteran = "Veteran",
	Champion = "Champion",
	Hero = "Held",
};

elseif LOCALE == "esES" then

categoryEnum = {
	Explorer = "Expedicionario",
	Adventurer = "Aventurero",
	Veteran = "Veterano",
	Champion = "Campeón",
	Hero = "Héroe",
};

elseif LOCALE == "frFR" then

categoryEnum = {
	Explorer = "Explorateur",
	Adventurer = "Aventurier",
	Veteran = "Vétéran",
	Champion = "Champion",
	Hero = "Héros",
};

elseif LOCALE == "itIT" then

categoryEnum = {
	Explorer = "Esploratore",
	Adventurer = "Avventuriero",
	Veteran = "Veterano",
	Champion = "Campione",
	Hero = "Eroe",
};

elseif LOCALE == "ptBR" then

categoryEnum = {
	Explorer = "Explorador",
	Adventurer = "Aventureiro",
	Veteran = "Veterano",
	Champion = "Campeão",
	Hero = "Herói",
};

elseif LOCALE == "ruRU" then

categoryEnum = {
	Explorer = "Исследователь",
	Adventurer = "Искатель приключений",
	Veteran = "Ветеран",
	Champion = "Защитник",
	Hero = "Герой",
};

elseif LOCALE == "koKR" then

categoryEnum = {
	Explorer = "탐험가",
	Adventurer = "모험가",
	Veteran = "노련가",
	Champion = "챔피언",
	Hero = "영웅",
};

elseif LOCALE == "zhCN" then

categoryEnum = {
	Explorer = "探索者",
	Adventurer = "冒险者",
	Veteran = "老兵",
	Champion = "勇士",
	Hero = "英雄",
};

elseif LOCALE == "zhTW" then

categoryEnum = {
	Explorer = "探索者",
	Adventurer = "冒险者",
	Veteran = "老兵",
	Champion = "勇士",
	Hero = "英雄",
};

end


-- Name to atlas array 
local categoryStringToAdd = {
	[categoryEnum.Explorer] = "|A:Professions-ChatIcon-Quality-Tier1:20:20|a ",
	[categoryEnum.Adventurer] = "|A:Professions-ChatIcon-Quality-Tier2:20:20|a ",
	[categoryEnum.Veteran] = "|A:Professions-ChatIcon-Quality-Tier3:20:20|a ",
	[categoryEnum.Champion] = "|A:Professions-ChatIcon-Quality-Tier4:20:20|a ",
	[categoryEnum.Hero] = "|A:Professions-ChatIcon-Quality-Tier5:20:20|a ",
};

local function SearchAndReplaceTooltipLine(tooltip, stringToAdd)
	for i = 1, tooltip:NumLines() do
		local line = _G[tooltip:GetName().."TextLeft"..i]
		local text = line:GetText()
		
		if text and text:match(patternToMatch) then
			local beforeText, categoryText, afterText = text:match(patternToMatch)
		
			-- No string = fallback method
			if not stringToAdd then
				stringToAdd = categoryStringToAdd[categoryText]
			end
		
			-- Replacing the line
			if stringToAdd then
				text = text:gsub(patternToMatch, "%1" .. stringToAdd .. "%2%3")
			end
			
			line:SetText(text)
			line:Show()
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
	local itemName, itemLink = TooltipUtil.GetDisplayedItem(tooltip)
	if not itemLink then return end

	local itemLinkValues = StringSplitIntoTable(":", itemLink)
	local numBonusIDs = tonumber(itemLinkValues[14])

	if not numBonusIDs then return end
	local stringToAdd;
	for i = 1, numBonusIDs do
		local upgradeID = tonumber(itemLinkValues[14 + i])
		if upgradeID >= 9294 and upgradeID <= 9301 then
			stringToAdd = categoryStringToAdd[categoryEnum.Explorer] -- Stuff to add before Explorer
		elseif upgradeID >= 9301 and upgradeID <= 9309 then
			stringToAdd = categoryStringToAdd[categoryEnum.Adventurer] -- Stuff to add before Adventurer
		elseif upgradeID >= 9313 and upgradeID <= 9320 then
			stringToAdd = categoryStringToAdd[categoryEnum.Veteran] -- Stuff to add before Veteran
		elseif upgradeID >= 9321 and upgradeID <= 9329 then
			stringToAdd = categoryStringToAdd[categoryEnum.Champion] -- Stuff to add before Champion
		elseif upgradeID >= 9330 and upgradeID <= 9334 then
			stringToAdd = categoryStringToAdd[categoryEnum.Hero] -- Stuff to add before Hero
		end
	end

	-- Searching the line
	SearchAndReplaceTooltipLine(tooltip)
	
	-- Compare tooltips
	if tooltip.shoppingTooltips then
		for _, shoppingTooltip in ipairs(tooltip.shoppingTooltips) do
			SearchAndReplaceTooltipLine(shoppingTooltip)
		end
	end
end);