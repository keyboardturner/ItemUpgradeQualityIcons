local ItemUpgradeQualityIcons, IUQI = ...
local _, L = ...

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
	[categoryEnum.Explorer] = {englishName = "Explorer", minLevel = 642, color = ITEM_POOR_COLOR},
	[categoryEnum.Adventurer] = {englishName = "Adventurer", minLevel = 655, color = WHITE_FONT_COLOR},
	[categoryEnum.Veteran] = {englishName = "Veteran", minLevel = 668, color = UNCOMMON_GREEN_COLOR},
	[categoryEnum.Champion] = {englishName = "Champion", minLevel = 681, color = RARE_BLUE_COLOR},
	[categoryEnum.Hero] = {englishName = "Hero", minLevel = 694, color = ITEM_EPIC_COLOR},
	[categoryEnum.Myth] = {englishName = "Myth", minLevel = 707, color = ITEM_LEGENDARY_COLOR},
	[categoryEnum.Awakened] = {englishName = "Awakened", minLevel = 493, color = ITEM_LEGENDARY_COLOR}, -- update later maybe, for now this is OLD
}

local categoryThemesCount = {
	[categoryEnum.Explorer] = 1,
	[categoryEnum.Adventurer] = 1,
	[categoryEnum.Veteran] = 1,
	[categoryEnum.Champion] = 1,
	[categoryEnum.Hero] = 1,
	[categoryEnum.Myth] = 1,
	[categoryEnum.Awakened] = 1,
}

local categoryIconThemes = {
	[categoryEnum.Explorer] = {
		["Default"] = {index = 1, name = L["Default"], icon = "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a"},
	},
	[categoryEnum.Adventurer] = {
		["Default"] = {index = 1, name = L["Default"], icon = "|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a"},
	},
	[categoryEnum.Veteran] = {
		["Default"] = {index = 1, name = L["Default"], icon = "|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a"},
	},
	[categoryEnum.Champion] = {
		["Default"] = {index = 1, name = L["Default"], icon = "|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a"},
	},
	[categoryEnum.Hero] = {
		["Default"] = {index = 1, name = L["Default"], icon = "|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a"},
	},
	[categoryEnum.Myth] = {
		["Default"] = {index = 1, name = L["Default"], icon = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:86:122:42:78|t"}, -- Thanks to Peterodox for supplying this new texture!
	},
	[categoryEnum.Awakened] = {
		["Default"] = {index = 1, name = L["Default"], icon = "|A:ui-ej-icon-empoweredraid-large:%d:%d|a"}
	},
}

local function GetIconForTrack(trackID, size)
	local iconTheme = IUQI_DB[categoryDataTab[trackID].englishName .. "Theme"];
	local iconString = (iconTheme and categoryIconThemes[trackID][iconTheme] or categoryIconThemes[trackID]["Default"]).icon;

	return iconString:format(size, size)
end

local function GetIconForLink(itemLink, iconSize)
	if not itemLink then return end

	local itemUpgradeData = C_Item.GetItemUpgradeInfo(itemLink)
	if not itemUpgradeData or not itemUpgradeData.trackStringID then return end

	return GetIconForTrack(itemUpgradeData.trackStringID, iconSize);
end

-- TOOLTIP ICON

local function SearchAndReplaceTooltipLine(tooltip)
	local _, itemLink = TooltipUtil.GetDisplayedItem(tooltip)
	if not itemLink then return end

	local itemUpgradeData = C_Item.GetItemUpgradeInfo(itemLink)
	if not itemUpgradeData then return end

	local categoryData = categoryDataTab[itemUpgradeData.trackStringID]
	if not categoryData then return end -- Invalid/non-existent category

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
				text = text:gsub(patternUpgradeLevel, "%1" .. GetIconForTrack(itemUpgradeData.trackStringID, 20) .. " %2%3")

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

-- CHARACTER FRAME ICON

local inventoryItemSlotsList = {
	[INVSLOT_HEAD] = { slotButton = CharacterHeadSlot },
	[INVSLOT_NECK] = { slotButton = CharacterNeckSlot },
	[INVSLOT_SHOULDER] = { slotButton = CharacterShoulderSlot },
	[INVSLOT_CHEST] = { slotButton = CharacterChestSlot },
	[INVSLOT_WRIST] = { slotButton = CharacterWristSlot },
	[INVSLOT_BACK] = { slotButton = CharacterBackSlot },

	[INVSLOT_WAIST] = { slotButton = CharacterWaistSlot },
	[INVSLOT_LEGS] = { slotButton = CharacterLegsSlot },
	[INVSLOT_FEET] = { slotButton = CharacterFeetSlot },
	[INVSLOT_HAND] = { slotButton = CharacterHandsSlot },
	[INVSLOT_FINGER1] = { slotButton = CharacterFinger0Slot },
	[INVSLOT_FINGER2] = { slotButton = CharacterFinger1Slot },
	[INVSLOT_TRINKET1] = { slotButton = CharacterTrinket0Slot },
	[INVSLOT_TRINKET2] = { slotButton = CharacterTrinket1Slot },

	[INVSLOT_MAINHAND] = { slotButton = CharacterMainHandSlot },
	[INVSLOT_OFFHAND] = { slotButton = CharacterSecondaryHandSlot },
};

local function IconLocation(frame,relativeTo)
	if not IUQI_DB then
		frame:SetPoint("TOPLEFT", relativeTo, "TOPLEFT", -3, 2)
		return
	end

	if IUQI_DB.iconLocation == 10 then
		frame:ClearAllPoints();
		return
	end

	local XVar = 1
	local YVar = 1

	if IUQI_DB.iconOffsetX then
		XVar = IUQI_DB.iconOffsetX
	end
	if IUQI_DB.iconOffsetY then
		YVar = IUQI_DB.iconOffsetY
	end

	local positions = {
		[1] = {"TOPLEFT", relativeTo, "TOPLEFT", -3*XVar, 2*YVar},
		[2] = {"TOP", relativeTo, "TOP", 0*XVar, 2*YVar},
		[3] = {"TOPRIGHT", relativeTo, "TOPRIGHT", 3*XVar, 2*YVar},
		[4] = {"LEFT", relativeTo, "LEFT", -3*XVar, 0*YVar},
		[5] = {"CENTER", relativeTo, "CENTER", 0*XVar, 0*YVar},
		[6] = {"RIGHT", relativeTo, "RIGHT", 3*XVar, 0*YVar},
		[7] = {"BOTTOMLEFT", relativeTo, "BOTTOMLEFT", -3*XVar, -2*YVar},
		[8] = {"BOTTOM", relativeTo, "BOTTOM", 0*XVar, -2*YVar},
		[9] = {"BOTTOMRIGHT", relativeTo, "BOTTOMRIGHT", 3*XVar, -2*YVar},
		[10] = {nil, nil, nil, 0, 0},
	};

	frame:ClearAllPoints();
	frame:SetPoint(unpack(positions[IUQI_DB.iconLocation] or positions[1]));
end

local function IconScale(frame)
	if not IUQI_DB then return end
	frame:SetScale(IUQI_DB.iconScale);
end

local function UpdateIcon(iconButton, itemLink)
	if not iconButton then return end

	if not iconButton.IUQI_iconFrame then
		iconButton.IUQI_iconFrame = iconButton:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	end

	IconLocation(iconButton.IUQI_iconFrame,iconButton)
	IconScale(iconButton.IUQI_iconFrame)

	local iconString = GetIconForLink(itemLink, 18)

	if iconString then
		iconButton.IUQI_iconFrame:SetText(iconString)
	else
		iconButton.IUQI_iconFrame:SetText("")
	end
end

-- CONTAINERS

-- Updates a single slot's upgrade frame
local function UpdateInventory(slotIndex)
	local inventoryItemSlot = inventoryItemSlotsList[slotIndex]
	if not inventoryItemSlot then return end

	local itemLink = GetInventoryItemLink("player", slotIndex)
	UpdateIcon(inventoryItemSlot.slotButton, itemLink)
end

-- Update a bag/bank frame
local function UpdateContainerFrame(containerFrame)
	if not containerFrame then return end

	for _, itemButton in containerFrame:EnumerateValidItems() do
		local itemLink = C_Container.GetContainerItemLink(itemButton:GetBagID(), itemButton:GetID())
		UpdateIcon(itemButton, itemLink)
	end
end

local function UpdateBankSlot(itemButton)
	local itemLink = C_Container.GetContainerItemLink(itemButton:GetBankTabID(), itemButton:GetContainerSlotID())
	UpdateIcon(itemButton, itemLink)
end

-- Update equipment flyout frame (the buttons showing when Alt-hovering a gear slot)
local function UpdateEquipmentFlyoutFrames(self)
	for _, iconButton in ipairs(self.buttons) do
		if not iconButton or not iconButton.location then return end
		-- Retrieve the link from the bag slot or inventory slot (depending on item location)
		local itemLocation = iconButton.location
		if type(itemLocation) == "table" then return end
		local player, bank, bags, voidStorage, slot, bag, tab, voidSlot = EquipmentManager_UnpackLocation(itemLocation)
		local itemLink;
		if bags then
			-- Item in player/bank bags (must be first as player or bank will also be true)
			itemLink = C_Container.GetContainerItemLink(bag, slot)
		elseif player then
			-- Item on player inventory
			itemLink = GetInventoryItemLink("player", slot)
		elseif bank then
			-- Item in bank
			local bankItemButton = _G["BankFrameItem" .. (slot - 63)]; -- idk why it's offset by 63 leave me alone
			itemLink = C_Container.GetContainerItemLink(bankItemButton:GetBagID(), bankItemButton:GetID())
		end

		UpdateIcon(iconButton, itemLink)
	end
end

-- EVENTS CALLBACKS

-- Updates all slots on login/reload
EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function(_, slotIndex, isEmpty)
	for slotIndex = 1, 17 do
		UpdateInventory(slotIndex)
	end

	-- Update bag slots when something changes inside it (moving items around)
	-- NOTE: Registering it here rather than immediately, as it seems to taint half the UI if triggered too early...
	EventRegistry:RegisterFrameEventAndCallback("BAG_UPDATE", function(_, bagIndex)
		if bagIndex < 13 then
			UpdateContainerFrame(ContainerFrameUtil_GetShownFrameForID(bagIndex))
		end
	end)
end)

-- Update slots when opening the frame
EventRegistry:RegisterCallback("CharacterFrame.Show", function(_, slotIndex, isEmpty)
	for slotIndex = 1, 17 do
		UpdateInventory(slotIndex)
	end	
end)

-- Update a slot when gear changes
EventRegistry:RegisterFrameEventAndCallback("PLAYER_EQUIPMENT_CHANGED", function(_, slotIndex, isEmpty)
	UpdateInventory(slotIndex)
end)

-- Update bag slots when opening the bag frame
EventRegistry:RegisterCallback("ContainerFrame.OpenBag", function()
	for bagID = 0, 12 do
		local containerFrame = ContainerFrameUtil_GetShownFrameForID(bagID)
		if containerFrame then
			UpdateContainerFrame(containerFrame)
		end
	end
end)

-- Update bank slot when it is refreshed
hooksecurefunc(BankPanelItemButtonMixin, "Refresh", function(self) UpdateBankSlot(self) end)

-- Update loot frame when opened
EventRegistry:RegisterFrameEventAndCallback("LOOT_OPENED", function()
	for slotIndex = 1, GetNumLootItems() do
		-- Find loot element in the scrollbox
		local lootElement = LootFrame.ScrollBox:FindFrameByPredicate(function(frame)
			return frame:GetSlotIndex() == slotIndex
		end)

		-- Update it
		if lootElement then
			local iconButton = lootElement.Item
			local itemLink = GetLootSlotLink(slotIndex)
			UpdateIcon(iconButton, itemLink)
		end
	end
end)

-- Update equipment flyout frame when displaying it
EquipmentFlyoutFrame:HookScript("OnShow", UpdateEquipmentFlyoutFrames)
-- Update equipment flyout frame when it gets updated (gear changed)
EquipmentFlyoutFrame:HookScript("OnEvent", UpdateEquipmentFlyoutFrames)


-- SavedVariables Defaults
local defaultsTable = {
	iconLocation = 1,
	iconScale = 1,
	iconOffsetX = 1,
	iconOffsetY = 1,
};

local function RegisterThemeIcon(trackID, themeKey, themeName, trackIcon)
	assert(themeKey ~= nil and strtrim(themeKey) ~= "", "Theme key can't be nil")
	assert(themeName ~= nil and strtrim(themeName) ~= "", "Theme name can't be nil")
	assert(categoryIconThemes[trackID][themeKey] == nil, "Theme key already exists for " .. categoryDataTab[trackID].englishName)
	categoryThemesCount[trackID] = categoryThemesCount[trackID] + 1;
	categoryIconThemes[trackID][themeKey] = {index = categoryThemesCount[trackID], name = themeName, icon = trackIcon}
end

local function RefreshAll()
	-- Refresh inventory
	for slotIndex = 1, 17 do
		UpdateInventory(slotIndex);
	end
	-- Refresh bags
	for bagID = 0, 12 do
		local containerFrame = ContainerFrameUtil_GetShownFrameForID(bagID);
		if containerFrame then
			UpdateContainerFrame(containerFrame);
		end
	end
	-- Refresh equipment flyout if shown
	if EquipmentFlyoutFrame:IsShown() then
		UpdateEquipmentFlyoutFrames(EquipmentFlyoutFrame);
	end
end

local function OnAddonLoaded()

	do
		if IUQI_DB == nil then
			IUQI_DB = CopyTable(defaultsTable);
		end

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

		local function OnSettingChanged(_, setting, value)
			local variable = setting:GetVariable()

			if strsub(variable, 1, 3) == "IUQI_" then
				variable = strsub(variable, 4); -- remove our prefix so it matches existing savedvar keys
			end
		end

		local category, layout = Settings.RegisterVerticalLayoutCategory("Item Upgrade Quality Icons")
		--local subcategory, layout2 = Settings.RegisterVerticalLayoutSubcategory(category, "my very own subcategory")

		local CreateDropdown = Settings.CreateDropdown or Settings.CreateDropDown
		local CreateCheckbox = Settings.CreateCheckbox or Settings.CreateCheckBox

		local function RegisterSetting(variableKey, defaultValue, name)
			local uniqueVariable = "IUQI_" .. variableKey; -- these have to be unique or calamity ensues, savedvars will be unaffected

			local setting;
			setting = Settings.RegisterAddOnSetting(category, uniqueVariable, variableKey, IUQI_DB, type(defaultValue), name, defaultValue);

			setting:SetValue(IUQI_DB[variableKey]);
			--Settings.SetOnValueChangedCallback(uniqueVariable, OnSettingChanged);

			return setting;
		end

		do
			local variable = "iconLocation"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["iconLocation"]
			local tooltip = L["iconLocationTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, L["TOPLEFT"])
				container:Add(2, L["TOP"])
				container:Add(3, L["TOPRIGHT"])
				container:Add(4, L["LEFT"])
				container:Add(5, L["CENTER"])
				container:Add(6, L["RIGHT"])
				container:Add(7, L["BOTTOMLEFT"])
				container:Add(8, L["BOTTOM"])
				container:Add(9, L["BOTTOMRIGHT"])
				container:Add(10, L["NONE"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		do
			local variable = "iconScale"
			local name = L["iconScale"]
			local tooltip = L["iconScaleTT"]
			local defaultValue = 1
			local minValue = .5
			local maxValue = 1.5
			local step = .1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(category, setting, options, tooltip)
		end

		do
			local variable = "iconOffsetX"
			local name = L["iconOffsetX"]
			local tooltip = L["iconOffsetXTT"]
			local defaultValue = 1
			local minValue = -10
			local maxValue = 10
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(category, setting, options, tooltip)
		end

		do
			local variable = "iconOffsetY"
			local name = L["iconOffsetY"]
			local tooltip = L["iconOffsetYTT"]
			local defaultValue = 1
			local minValue = -10
			local maxValue = 10
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(category, setting, options, tooltip)
		end

		-- THEME SETTINGS

		local function CreateThemeSettingDropdown(trackID, trackName)
			local variable = trackName .. "Theme"
			local defaultValue = "Default"
			local name = string.format(L["IconTheme"], L[trackName])
			local tooltip = string.format(L["IconThemeTT"], L[trackName])

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				
				local themes = {}
				for key, theme in pairs(categoryIconThemes[trackID]) do
					table.insert(themes, {key = key, name = theme.name, index = theme.index, icon = theme.icon})
				end

				-- keep the Default option to the top
				table.sort(themes, function(a, b)
					return a.index < b.index
				end)

				for _, theme in ipairs(themes) do
					container:Add(theme.key, theme.icon:format(16, 16) .. " " .. theme.name)
				end

				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			Settings.SetOnValueChangedCallback("IUQI_" .. variable, RefreshAll);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		CreateThemeSettingDropdown(categoryEnum.Explorer, "Explorer")
		CreateThemeSettingDropdown(categoryEnum.Adventurer, "Adventurer")
		CreateThemeSettingDropdown(categoryEnum.Veteran, "Veteran")
		CreateThemeSettingDropdown(categoryEnum.Champion, "Champion")
		CreateThemeSettingDropdown(categoryEnum.Hero, "Hero")
		CreateThemeSettingDropdown(categoryEnum.Myth, "Myth")

		Settings.RegisterAddOnCategory(category)

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
	end
end

EventUtil.ContinueOnAddOnLoaded("ItemUpgradeQualityIcons", OnAddonLoaded);

RegisterThemeIcon(categoryEnum.Explorer, "Adventurer", L["Adventurer"], "|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a");
RegisterThemeIcon(categoryEnum.Explorer, "Veteran", L["Veteran"], "|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a");
RegisterThemeIcon(categoryEnum.Explorer, "Champion", L["Champion"], "|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a");
RegisterThemeIcon(categoryEnum.Explorer, "Hero", L["Hero"], "|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a");
RegisterThemeIcon(categoryEnum.Explorer, "Myth", L["Myth"], "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:86:122:42:78|t");

RegisterThemeIcon(categoryEnum.Adventurer, "Explorer", L["Explorer"], "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");
RegisterThemeIcon(categoryEnum.Adventurer, "Veteran", L["Veteran"], "|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a");
RegisterThemeIcon(categoryEnum.Adventurer, "Champion", L["Champion"], "|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a");
RegisterThemeIcon(categoryEnum.Adventurer, "Hero", L["Hero"], "|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a");
RegisterThemeIcon(categoryEnum.Adventurer, "Myth", L["Myth"], "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:86:122:42:78|t");

RegisterThemeIcon(categoryEnum.Veteran, "Explorer", L["Explorer"], "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");
RegisterThemeIcon(categoryEnum.Veteran, "Adventurer", L["Adventurer"], "|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a");
RegisterThemeIcon(categoryEnum.Veteran, "Champion", L["Champion"], "|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a");
RegisterThemeIcon(categoryEnum.Veteran, "Hero", L["Hero"], "|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a");
RegisterThemeIcon(categoryEnum.Veteran, "Myth", L["Myth"], "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:86:122:42:78|t");

RegisterThemeIcon(categoryEnum.Champion, "Explorer", L["Explorer"], "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");
RegisterThemeIcon(categoryEnum.Champion, "Adventurer", L["Adventurer"], "|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a");
RegisterThemeIcon(categoryEnum.Champion, "Veteran", L["Veteran"], "|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a");
RegisterThemeIcon(categoryEnum.Champion, "Hero", L["Hero"], "|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a");
RegisterThemeIcon(categoryEnum.Champion, "Myth", L["Myth"], "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:86:122:42:78|t");

RegisterThemeIcon(categoryEnum.Hero, "Explorer", L["Explorer"], "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");
RegisterThemeIcon(categoryEnum.Hero, "Adventurer", L["Adventurer"], "|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a");
RegisterThemeIcon(categoryEnum.Hero, "Veteran", L["Veteran"], "|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a");
RegisterThemeIcon(categoryEnum.Hero, "Champion", L["Champion"], "|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a");
RegisterThemeIcon(categoryEnum.Hero, "Myth", L["Myth"], "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:86:122:42:78|t");

RegisterThemeIcon(categoryEnum.Myth, "Explorer", L["Explorer"], "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");
RegisterThemeIcon(categoryEnum.Myth, "Adventurer", L["Adventurer"], "|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a");
RegisterThemeIcon(categoryEnum.Myth, "Veteran", L["Veteran"], "|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a");
RegisterThemeIcon(categoryEnum.Myth, "Champion", L["Champion"], "|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a");
RegisterThemeIcon(categoryEnum.Myth, "Hero", L["Hero"], "|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a");

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

IUQI_API = {
	-- Enum for easy access to item track ID
	categoryEnum = CopyTable(categoryEnum),

	-- Function to attach the quality icon to a given button based on the item link content
	UpdateIcon = UpdateIcon,

	-- Individual functions to retrieve the quality icon text and apply icon location and scale to a frame if UpdateIcon doesn't suit the needs
	GetIconForLink = GetIconForLink,
	GetIconForTrack = GetIconForTrack,
	IconLocation = IconLocation,
	IconScale = IconScale,

	-- Refresh functions
	UpdateInventory = UpdateInventory,
	UpdateContainerFrame = UpdateContainerFrame,
	UpdateBankSlot = UpdateBankSlot,
	UpdateEquipmentFlyoutFrames = UpdateEquipmentFlyoutFrames,

	-- Function to add new icon options
	-- Example usage: IUQI_API.RegisterThemeIcon(IUQI_API.categoryEnum.Explorer, "MyThemeKey", "MyThemeName", "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");
	-- Theme name can be localized (as it appears on the dropdown) but key is used for identifying current selected theme and SHOULD remain locale-agnostic
	-- Size MUST be %d in the texture/atlas string for formatting
	RegisterThemeIcon = RegisterThemeIcon,

	-- Utility for addons to refresh everything
	RefreshAll = RefreshAll,
};