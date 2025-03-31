-- Turning global string into pattern to match
local patternUpgradeLevel = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING -- ITEM_UPGRADE_FRAME_CURRENT_UPGRADE_FORMAT_STRING also works
patternUpgradeLevel = patternUpgradeLevel:gsub("%%s", ")(.*)(")
patternUpgradeLevel = patternUpgradeLevel:gsub("%%d", "[0-9]+")
patternUpgradeLevel = "(" .. patternUpgradeLevel .. ")"

local patternIlvl = ITEM_LEVEL

-- Apostr-off (because the french are weird)
patternIlvl = patternIlvl:gsub("'", ".");
patternIlvl = patternIlvl:gsub("’", ".");

patternIlvl = "^" .. patternIlvl:gsub("%%d", "([0-9]+)") .. "$" -- Our actual proper pattern matching.
--patternIlvl = "^" .. patternIlvl:gsub("%%1%$d", "([0-9]+)") .. "$" -- This was the old code for Russian

local categoryEnum = {
	Explorer = 970,
	Adventurer = 971,
	Veteran = 972,
	Champion = 973,
	Hero = 974,
	Myth = 978, -- 10.1.5
	Awakened = 1 -- Until reused, no idea what its ID is and no point figuring it out
};

-- Item category data
local categoryDataTab = {
	[categoryEnum.Explorer] = {minLevel = 597, color = ITEM_POOR_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier1:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:1:31:73:107|t "},
	[categoryEnum.Adventurer] = {minLevel = 610, color = WHITE_FONT_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier2:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:1:47:1:35|t "},
	[categoryEnum.Veteran] = {minLevel = 623, color = UNCOMMON_GREEN_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier3:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:49:85:1:35|t "},
	[categoryEnum.Champion] = {minLevel = 636, color = RARE_BLUE_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier4:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:87:121:1:35|t "},
	[categoryEnum.Hero] = {minLevel = 649, color = ITEM_EPIC_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier5:20:20|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:20:20:0:0:128:128:1:35:37:71|t "},
	[categoryEnum.Myth] = {minLevel = 662, color = ITEM_LEGENDARY_COLOR, icon = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:20:20:0:0:128:128:86:122:42:78|t ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:20:20:0:0:128:128:42:78:42:78|t "}, -- Thanks to Peterodox for supplying this new texture!
	[categoryEnum.Awakened] = {minLevel = 493, color = ITEM_LEGENDARY_COLOR, icon = "|A:ui-ej-icon-empoweredraid-large:20:20|a ", iconObsolete = "|A:ui-ej-icon-empoweredraid-large:20:20|a "}, -- update later maybe, for now this is OLD
}

local function SearchAndReplaceTooltipLine(tooltip)
	local _, itemLink = TooltipUtil.GetDisplayedItem(tooltip)
	if not itemLink then return end

	local itemUpgradeData = C_Item.GetItemUpgradeInfo(itemLink)
	if not itemUpgradeData then return end

	local categoryData = categoryDataTab[itemUpgradeData.trackStringID]
	if not categoryData then return end -- Invalid/non-existent category

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
				if ilvl >= categoryData.minLevel then

					isCurrentSeason = true;

					-- Not showing ilvl range on a max upgraded item
					local itemMaxLevel = itemUpgradeData.maxItemLevel

					if ilvl ~= itemMaxLevel then
						text = text .. "/" .. itemMaxLevel

						line:SetText(text)
						line:Show()
					end
				end
			elseif text:match(patternUpgradeLevel) then
				-- Ilvl line is always above the upgrade line, so this order works
				if isCurrentSeason then
					-- Current season
					text = text:gsub(patternUpgradeLevel, "%1" .. categoryData.icon .. "%2%3")
				else
					-- Previous season
					text = text:gsub(patternUpgradeLevel, "%1" .. categoryData.iconObsolete .. "%2%3")
				end

				line:SetText(text)
				line:Show()

				-- We can break, no more relevant lines
				break
			end
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
	-- Searching the line
	SearchAndReplaceTooltipLine(tooltip)
end);
