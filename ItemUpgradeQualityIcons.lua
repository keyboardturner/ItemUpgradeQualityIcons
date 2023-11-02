-- Turning global string into pattern to match
local patternUpgradeLevel = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING
patternUpgradeLevel = patternUpgradeLevel:gsub("%%s", ")(.*)(")
patternUpgradeLevel = patternUpgradeLevel:gsub("%%d", "[0-9]+")
patternUpgradeLevel = "(" .. patternUpgradeLevel .. ")"

local LOCALE = GetLocale()

local patternIlvl = ITEM_UPGRADE_ITEM_LEVEL_STAT_FORMAT

if LOCALE == "ruRU" then
	patternIlvl = "^" .. patternIlvl:gsub("%%1%$d", "([0-9]+)") .. "$" -- For some godawful reason, russian and russian alone is a different format.
else
	patternIlvl = "^" .. patternIlvl:gsub("%%d", "([0-9]+)") .. "$" -- Our actual proper pattern matching.
end


local categoryEnum = {
	Explorer = "Explorer",
	Adventurer = "Adventurer",
	Veteran = "Veteran",
	Champion = "Champion",
	Hero = "Hero",
	Myth = "Myth", -- 10.1.5
};

if LOCALE == "enUS" or LOCALE == "enCN" or LOCALE == "enGB" or LOCALE == "enTW" then

	-- Name keys (should have a way to localize keys)
	categoryEnum = {
		Explorer = "Explorer",
		Adventurer = "Adventurer",
		Veteran = "Veteran",
		Champion = "Champion",
		Hero = "Hero",
		Myth = "Myth",
	};

elseif LOCALE == "deDE" then

	categoryEnum = {
		Explorer = "Forscher",
		Adventurer = "Abenteurer",
		Veteran = "Veteran",
		Champion = "Champion",
		Hero = "Held",
		Myth = "Mythos",
	};

elseif LOCALE == "esES" or LOCALE == "esMX" then

	categoryEnum = {
		Explorer = "Expedicionario",
		Adventurer = "Aventurero",
		Veteran = "Veterano",
		Champion = "Campeón",
		Hero = "Héroe",
		Myth = "Mito",
	};

elseif LOCALE == "frFR" then

	categoryEnum = {
		Explorer = "Explorateur",
		Adventurer = "Aventurier",
		Veteran = "Vétéran",
		Champion = "Champion",
		Hero = "Héros",
		Myth = "Mythe",
	};

elseif LOCALE == "itIT" then

	categoryEnum = {
		Explorer = "Esploratore",
		Adventurer = "Avventuriero",
		Veteran = "Veterano",
		Champion = "Campione",
		Hero = "Eroe",
		Myth = "Mito",
	};

elseif LOCALE == "ptBR" then

	categoryEnum = {
		Explorer = "Explorador",
		Adventurer = "Aventureiro",
		Veteran = "Veterano",
		Champion = "Campeão",
		Hero = "Herói",
		Myth = "Mito",
	};

elseif LOCALE == "ruRU" then

	categoryEnum = {
		Explorer = "Исследователь",
		Adventurer = "Искатель приключений",
		Veteran = "Ветеран",
		Champion = "Защитник",
		Hero = "Герой",
		Myth = "Легенда",
	};

elseif LOCALE == "koKR" then

	categoryEnum = {
		Explorer = "탐험가",
		Adventurer = "모험가",
		Veteran = "노련가",
		Champion = "챔피언",
		Hero = "영웅",
		Myth = "신화",
	};

elseif LOCALE == "zhCN" then

	categoryEnum = {
		Explorer = "探索者",
		Adventurer = "冒险者",
		Veteran = "老兵",
		Champion = "勇士",
		Hero = "英雄",
		Myth = "神话",
	};

elseif LOCALE == "zhTW" then

	categoryEnum = {
		Explorer = "探索者",
		Adventurer = "冒险者",
		Veteran = "老兵",
		Champion = "勇士",
		Hero = "英雄",
		Myth = "神話",
	};

end


-- Item category data
local categoryDataTab = {
	[categoryEnum.Explorer] = {minLevel = 415, maxLevel = 437, color = ITEM_POOR_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier1:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:1:31:73:107|t "},
	[categoryEnum.Adventurer] = {minLevel = 428, maxLevel = 450, color = WHITE_FONT_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier2:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:1:47:1:35|t "},
	[categoryEnum.Veteran] = {minLevel = 441, maxLevel = 463, color = UNCOMMON_GREEN_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier3:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:49:85:1:35|t "},
	[categoryEnum.Champion] = {minLevel = 454, maxLevel = 476, color = RARE_BLUE_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier4:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:87:121:1:35|t "},
	[categoryEnum.Hero] = {minLevel = 467, maxLevel = 483, color = ITEM_EPIC_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier5:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:1:35:37:71|t "},
	[categoryEnum.Myth] = {minLevel = 480, maxLevel = 489, color = ITEM_LEGENDARY_COLOR, icon = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:20:20:0:0:128:128:86:122:42:78|t ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:20:20:0:0:128:128:42:78:42:78|t "}, -- Thanks to Peterodox for supplying this new texture!
}

local function SearchAndReplaceTooltipLine(tooltip, category)

	local categoryData;

	-- Retrieving the upgrade line (need to do first because of fallback detection)
	local upgradeLevelLine;
	for i = 1, tooltip:NumLines() do
		local line = _G[tooltip:GetName().."TextLeft"..i]
		local text
		if line then
			text = line:GetText()
		end
		
		if text and text:match(patternUpgradeLevel) then
			-- No category = fallback method
			if not category then
				local beforeText, afterText
				beforeText, category, afterText = text:match(patternUpgradeLevel)
			end

			categoryData = category and categoryDataTab[category]

			if not categoryData then return end -- Invalid/non-existent category

			upgradeLevelLine = line

			break
		end
	end

	-- Invalid/non-existent category
	if not categoryData then
		return
	end

	local isCurrentSeason;

	-- Editing the ilvl line
	for i = 1, tooltip:NumLines() do
		local line = _G[tooltip:GetName().."TextLeft"..i]
		local text
		if line then
			text = line:GetText()
		end

		if text then
			-- Checking if ilvl line and retrieving the ilvl value
			local ilvl = tonumber(text:match(patternIlvl));
			if ilvl then
				-- Checking if the ilvl is in the right range (otherwise it's a previous season item)
				if ilvl >= categoryData.minLevel and ilvl <= categoryData.maxLevel then

					isCurrentSeason = true;

					-- Not showing ilvl range on a max upgraded item
					if ilvl ~= categoryData.maxLevel then
						text = text .. "/" .. categoryData.maxLevel

						line:SetText(text)
						line:Show()
					end

					break
				end
			end
		end
	end

	-- Editing the upgrade line
	if categoryData and upgradeLevelLine then
		local text = upgradeLevelLine:GetText()

		if isCurrentSeason then
			-- Current season
			text = text:gsub(patternUpgradeLevel, "%1" .. categoryData.icon .. "%2%3")
		else
			-- Previous season
			text = text:gsub(patternUpgradeLevel, "%1" .. categoryData.iconObsolete .. "%2%3")
		end

		upgradeLevelLine:SetText(text)
		upgradeLevelLine:Show()
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
		if upgradeID == nil then
			return
		end
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
		elseif upgradeID >= 9380 and upgradeID <= 9382 then	-- 10.1.5
			category = categoryEnum.Myth
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
