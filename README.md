# ItemUpgradeQualityIcons


<p>I found the upgrade system names to not be very great at expressing the rank they are. Much of the time, this led to gear-hoarding in my bags because I was never certain which items to discard or keep.</p>
<p>&nbsp;</p>
<p>What this addon aims to resolve is to better express these ranks using the profession quality icons.</p>
<p>In Patch 10.1, gear has upgrade levels. For example, a piece of gear will show "Upgrade Level: Champion 4/8". This addon would supplement that, adding the icons used by profession crafting quality to instead show "Upgrade Level:&nbsp;<img src="https://wow.zamimg.com/uploads/screenshots/normal/1067034.png" alt="" width="20" height="21" />&nbsp;<span style="font-size: 1.2rem;">Champion 4/8". Below is&nbsp; chart of each upgrade level / icon that would display.</span></p>
<p>&nbsp;</p>
<p>Rank / Quality:</p>
<p>Explorer - Single Copper Dot&nbsp;<img src="https://wow.zamimg.com/uploads/screenshots/normal/1067031.png" alt="" width="20" height="20" /></p>
<p>Adventurer - Double Silver Dot&nbsp;<img src="https://wow.zamimg.com/uploads/screenshots/normal/1067032.png" alt="" width="20" height="11" /></p>
<p>Veteran - Triple Gold Dot&nbsp;<img src="https://wow.zamimg.com/uploads/screenshots/normal/1067033.png" alt="" width="20" height="16" /></p>
<p>Champion - Quadruple Teal Dot&nbsp;<img src="https://wow.zamimg.com/uploads/screenshots/normal/1067034.png" alt="" width="20" height="21" /></p>
<p>Hero - Pentagold&nbsp;<img src="https://wow.zamimg.com/uploads/screenshots/normal/1067035.png" alt="" width="20" height="19" /></p>
<p>Myth - Hexagem &nbsp;<img src="https://i.imgur.com/P9Xuq2h.png" alt=""width="35" height="35" />(made by [Peterodox](https://twitter.com/Peterodox))</p>

<p>&nbsp;</p>
<h4>BUG REPORTING</h4>
<p>If you want to report an issue, <span style="text-decoration: underline;">please state the language you're playing in</span> and/or if any particular <span style="text-decoration: underline;">additional addons causing issues</span>.</p>

<h4>API and Custom Icons</h4>
<p>API functions available can be found in the global variable `IUQI_API` along with several functions for useage with other addons.</p>
<p>Adding custom icons can also be done via an addon:</p>
<p>Example usage:</p>

`IUQI_API.RegisterThemeIcon(IUQI_API.categoryEnum.Explorer, "MyThemeKey", "MyThemeName", "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");`

<p>Theme name can be localized (as it appears on the dropdown) but key is used for identifying current selected theme and SHOULD remain locale-agnostic</p>
<p>Size MUST be %d in the texture/atlas string for formatting</p>

<p>Full addon example:</p>

```
local function OnAddonLoaded()
	if IUQI_API then
		IUQI_API.RegisterThemeIcon(IUQI_API.categoryEnum.Explorer, "MyThemeKey", "MyThemeName", "|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a");
	end
end

EventUtil.ContinueOnAddOnLoaded("ItemUpgradeQualityIcons", OnAddonLoaded);
```

A link to my discord for addon projects and other things can be found [here](https://discord.gg/tA4rrmjPp8).
