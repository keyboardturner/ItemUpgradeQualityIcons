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
	[categoryEnum.Explorer] = {minLevel = 642, color = ITEM_POOR_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:%d:%d:0:0:128:128:1:31:73:107|t "},
	[categoryEnum.Adventurer] = {minLevel = 655, color = WHITE_FONT_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:%d:%d:0:0:128:128:1:47:1:35|t "},
	[categoryEnum.Veteran] = {minLevel = 668, color = UNCOMMON_GREEN_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:%d:%d:0:0:128:128:49:85:1:35|t "},
	[categoryEnum.Champion] = {minLevel = 681, color = RARE_BLUE_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:%d:%d:0:0:128:128:87:121:1:35|t "},
	[categoryEnum.Hero] = {minLevel = 694, color = ITEM_EPIC_COLOR, icon = "|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons.tga:%d:%d:0:0:128:128:1:35:37:71|t "},
	[categoryEnum.Myth] = {minLevel = 707, color = ITEM_LEGENDARY_COLOR, icon = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:86:122:42:78|t ", iconObsolete = "|TInterface\\AddOns\\ItemUpgradeQualityIcons\\ProfessionsQualityIcons:%d:%d:0:0:128:128:42:78:42:78|t "}, -- Thanks to Peterodox for supplying this new texture!
	[categoryEnum.Awakened] = {minLevel = 493, color = ITEM_LEGENDARY_COLOR, icon = "|A:ui-ej-icon-empoweredraid-large:%d:%d|a ", iconObsolete = "|A:ui-ej-icon-empoweredraid-large:%d:%d|a "}, -- update later maybe, for now this is OLD
}

local function setIcon(trackID, iconString)
	if not categoryDataTab[trackID] then return end
	categoryDataTab[trackID].icon = iconString;
end

local function getIcon(categoryData, isCurrentSeason, size)
	local iconString;
	if isCurrentSeason then
		-- Current season
		iconString = categoryData.icon
	else
		-- Previous season
		iconString = categoryData.iconObsolete
	end

	return iconString:format(size, size)
end

-- TOOLTIP ICON

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
				text = text:gsub(patternUpgradeLevel, "%1" .. getIcon(categoryData, isCurrentSeason, 20) .. "%2%3")

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

local function GetIconForTrack(trackID, iconSize)
	local categoryData = categoryDataTab[trackID]
	if not categoryData then return end -- Invalid/non-existent category

	return getIcon(categoryData, true, iconSize);
end

local function GetIconForLink(itemLink, iconSize)
	if not itemLink then return end

	local itemUpgradeData = C_Item.GetItemUpgradeInfo(itemLink)
	if not itemUpgradeData then return end

	local categoryData = categoryDataTab[itemUpgradeData.trackStringID]
	if not categoryData then return end -- Invalid/non-existent category

	local isCurrentSeason
	local _, _, _, ilvl = C_Item.GetItemInfo(itemLink)
	if ilvl >= categoryData.minLevel then
		isCurrentSeason = true
	end

	return getIcon(categoryData, isCurrentSeason, iconSize);
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
			Settings.SetOnValueChangedCallback(uniqueVariable, OnSettingChanged);

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



		local CreateDropdown = Settings.CreateDropdown or Settings.CreateDropDown
		local CreateCheckbox = Settings.CreateCheckbox or Settings.CreateCheckBox

		do
			local variable = "explorerTheme"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["explorerTheme"]
			local tooltip = L["explorerThemeTT"]

			local icon = getIcon(categoryDataTab[categoryEnum.Explorer], true, 20)
			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, icon..L["Default"])
				container:Add(2, "OtherAddonStyle1")
				container:Add(3, "OtherAddonStyle2")
				container:Add(4, "etc") -- probably need something to dynamically add icons here
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		do
			local variable = "adventurerTheme"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["adventurerTheme"]
			local tooltip = L["adventurerThemeTT"]

			local icon = getIcon(categoryDataTab[categoryEnum.Adventurer], true, 20)
			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, icon..L["Default"])
				container:Add(2, "OtherAddonStyle1")
				container:Add(3, "OtherAddonStyle2")
				container:Add(4, "etc")
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		do
			local variable = "veteranTheme"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["veteranTheme"]
			local tooltip = L["veteranThemeTT"]

			local icon = getIcon(categoryDataTab[categoryEnum.Veteran], true, 20)
			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, icon..L["Default"])
				container:Add(2, "OtherAddonStyle1")
				container:Add(3, "OtherAddonStyle2")
				container:Add(4, "etc")
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		do
			local variable = "championTheme"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["championTheme"]
			local tooltip = L["championThemeTT"]

			local icon = getIcon(categoryDataTab[categoryEnum.Champion], true, 20)
			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, icon..L["Default"])
				container:Add(2, "OtherAddonStyle1")
				container:Add(3, "OtherAddonStyle2")
				container:Add(4, "etc")
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		do
			local variable = "heroTheme"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["heroTheme"]
			local tooltip = L["heroThemeTT"]

			local icon = getIcon(categoryDataTab[categoryEnum.Hero], true, 20)
			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, icon..L["Default"])
				container:Add(2, "OtherAddonStyle1")
				container:Add(3, "OtherAddonStyle2")
				container:Add(4, "etc")
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		do
			local variable = "mythTheme"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["mythTheme"]
			local tooltip = L["mythThemeTT"]

			local icon = getIcon(categoryDataTab[categoryEnum.Myth], true, 20)
			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, icon..L["Default"])
				container:Add(2, "OtherAddonStyle1")
				container:Add(3, "OtherAddonStyle2")
				container:Add(4, "etc")
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(category, setting, GetOptions, tooltip)
		end

		Settings.RegisterAddOnCategory(category)

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
	end
end

EventUtil.ContinueOnAddOnLoaded("ItemUpgradeQualityIcons", OnAddonLoaded);


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

	-- Utility for addons to refresh everything
	RefreshAll = function()
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
	end,
};