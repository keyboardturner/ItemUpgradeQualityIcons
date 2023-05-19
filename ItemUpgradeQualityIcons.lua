TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
	local itemName, itemLink = TooltipUtil.GetDisplayedItem(tooltip)
	if not itemLink then return end

	local itemLinkValues = StringSplitIntoTable(":", itemLink)
	local numBonusIDs = tonumber(itemLinkValues[14])

	if not numBonusIDs then return end
	local stringToAdd = "";
	for i = 1, numBonusIDs do
		local upgradeID = tonumber(itemLinkValues[14 + i])
		if upgradeID >= 9294 and upgradeID <= 9301 then
			stringToAdd = "|A:Professions-ChatIcon-Quality-Tier1:20:20|a " -- Stuff to add before Explorer
		elseif upgradeID >= 9301 and upgradeID <= 9309 then
			stringToAdd = "|A:Professions-ChatIcon-Quality-Tier2:20:20|a " -- Stuff to add before Adventurer
		elseif upgradeID >= 9313 and upgradeID <= 9320 then
			stringToAdd = "|A:Professions-ChatIcon-Quality-Tier3:20:20|a " -- Stuff to add before Veteran
		elseif upgradeID >= 9321 and upgradeID <= 9329 then
			stringToAdd = "|A:Professions-ChatIcon-Quality-Tier4:20:20|a " -- Stuff to add before Champion
		elseif upgradeID >= 9330 and upgradeID <= 9334 then
			stringToAdd = "|A:Professions-ChatIcon-Quality-Tier5:20:20|a " -- Stuff to add before Hero
		end
	end

	-- Turning global string into pattern to match
	local patternToMatch = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING
	patternToMatch = patternToMatch:gsub("%%s", ")(.*)(")
	patternToMatch = patternToMatch:gsub("%%d", "[0-9]+")
	patternToMatch = "(" .. patternToMatch .. ")"

	-- Searching the line
	for i = 1, tooltip:NumLines() do
		local line = _G[tooltip:GetName().."TextLeft"..i]
		local text = line:GetText()
		
		if text and text:match(patternToMatch) then
			-- Replacing the line
			text = text:gsub(patternToMatch, "%1" .. stringToAdd .. "%2%3")
			
			line:SetText(text)
			line:Show()
		end
	end
end)