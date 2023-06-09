-- Turning global string into pattern to match
local patternUpgradeLevel = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING
patternUpgradeLevel = patternUpgradeLevel:gsub("%%s", ")(.*)(")
patternUpgradeLevel = patternUpgradeLevel:gsub("%%d", "[0-9]+")
patternUpgradeLevel = "(" .. patternUpgradeLevel .. ")"

local LOCALE = GetLocale()

local patternIlvl = ITEM_UPGRADE_ITEM_LEVEL_STAT_FORMAT

if LOCALE == "ruRU" then
	patternIlvl = "^" .. patternIlvl:gsub("%%1%$d", "[0-9]+") .. "$" -- For some godawful reason, russian and russian alone is a different format.
else
	patternIlvl = "^" .. patternIlvl:gsub("%%d", "[0-9]+") .. "$" -- Our actual proper pattern matching.
end


local categoryEnum = {
	Explorer = "Explorer",
	Adventurer = "Adventurer",
	Veteran = "Veteran",
	Champion = "Champion",
	Hero = "Hero",
	--Myth = "Myth", -- 10.1.5, will change soon
};

if LOCALE == "enUS" or LOCALE == "enCN" or LOCALE == "enGB" or LOCALE == "enTW" then

	-- Name keys (should have a way to localize keys)
	categoryEnum = {
		Explorer = "Explorer",
		Adventurer = "Adventurer",
		Veteran = "Veteran",
		Champion = "Champion",
		Hero = "Hero",
		--Myth = "Myth",
	};

elseif LOCALE == "deDE" then

	categoryEnum = {
		Explorer = "Forscher",
		Adventurer = "Abenteurer",
		Veteran = "Veteran",
		Champion = "Champion",
		Hero = "Held",
	};

elseif LOCALE == "esES" or LOCALE == "esMX" then

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


-- Item category data
local categoryDataTab = {
	[categoryEnum.Explorer] = {minLevel = 376, maxLevel = 398, color = ITEM_POOR_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier1:20:20|a "},
	[categoryEnum.Adventurer] = {minLevel = 389, maxLevel = 411, color = WHITE_FONT_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier2:20:20|a "},
	[categoryEnum.Veteran] = {minLevel = 402, maxLevel = 424, color = UNCOMMON_GREEN_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier3:20:20|a "},
	[categoryEnum.Champion] = {minLevel = 415, maxLevel = 437, color = RARE_BLUE_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier4:20:20|a "},
	[categoryEnum.Hero] = {minLevel = 428, maxLevel = 441, color = ITEM_EPIC_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier5:20:20|a "},
	--[categoryEnum.Myth] = {minLevel = 441, maxLevel = 447, color = ITEM_LEGENDARY_COLOR, icon = "|A:BossBanner-SkullCircle:20:20|a "},
}

local function SearchAndReplaceTooltipLine(tooltip, category)
	-- Editing the upgrade line (need to do first because of fallback detection)
	local categoryData;

	for i = 1, tooltip:NumLines() do
		local line = _G[tooltip:GetName().."TextLeft"..i]
		local text = line:GetText()
		
		if text and text:match(patternUpgradeLevel) then
			-- No category = fallback method
			if not category then
				local beforeText, afterText
				beforeText, category, afterText = text:match(patternUpgradeLevel)
			end

			categoryData = category and categoryDataTab[category]

			if not categoryData then return end -- Invalid/non-existent category

			-- Replacing the line
			text = text:gsub(patternUpgradeLevel, "%1" .. categoryData.icon .. "%2%3")
			
			line:SetText(text)
			line:Show()
			
			break
		end
	end

	-- Invalid/non-existent category
	if not categoryData then
		return
	end
	
	-- Editing the ilvl line
	for i = 1, tooltip:NumLines() do
		local line = _G[tooltip:GetName().."TextLeft"..i]
		local text = line:GetText()

		if text and text:match(patternIlvl) then
			text = text .. "/" .. categoryData.maxLevel

			line:SetText(text)
			line:Show()

			break
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
	local _, itemLink = TooltipUtil.GetDisplayedItem(tooltip)
	if not itemLink then return end

	local itemLinkValues = StringSplitIntoTable(":", itemLink)
	local numBonusIDs = tonumber(itemLinkValues[14])

	if not numBonusIDs then return end
	local category;
	for i = 1, numBonusIDs do
		local upgradeID = tonumber(itemLinkValues[14 + i])
		if upgradeID then
			if upgradeID >= 9294 and upgradeID <= 9301 then
				category = categoryEnum.Explorer
			elseif upgradeID >= 9301 and upgradeID <= 9309 then
				category = categoryEnum.Adventurer
			elseif upgradeID >= 9313 and upgradeID <= 9320 then
				category = categoryEnum.Veteran
			elseif upgradeID >= 9321 and upgradeID <= 9329 then
				category = categoryEnum.Champion
			elseif upgradeID >= 9330 and upgradeID <= 9334 then
				category = categoryEnum.Hero
			--elseif upgradeID >= 9380 and upgradeID <= 9382 then	-- 10.1.5, will change soon
				--category = categoryEnum.Myth
			end
		end
	end

	-- Searching the line
	SearchAndReplaceTooltipLine(tooltip) -- (tooltip, category) once Blizz fixes the stale tooltips issue
	
	-- Compare tooltips
	if tooltip.shoppingTooltips then
		for _, shoppingTooltip in ipairs(tooltip.shoppingTooltips) do
			SearchAndReplaceTooltipLine(shoppingTooltip)
		end
	end
end);
