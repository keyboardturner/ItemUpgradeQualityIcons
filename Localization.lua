local _, L = ...; -- Let's use the private table passed to every .lua 

local function defaultFunc(L, key)
 -- If this function was called, we have no localization for this key.
 -- We could complain loudly to allow localizers to see the error of their ways, 
 -- but, for now, just return the key as its own localization. This allows you to—avoid writing the default localization out explicitly.
 return key;
end
setmetatable(L, {__index=defaultFunc});

local LOCALE = GetLocale()

if LOCALE == "enUS" then
	-- The EU English game client also
	-- uses the US English locale code.

	L["iconLocation"] = "Icon Location"
	L["iconLocationTT"] = "Places where on the item slot the quality icon will be placed on."
	L["iconScale"] = "Icon Scale"
	L["iconScaleTT"] = "Size factor of the icon."
	L["TOPLEFT"] = "Top Left"
	L["TOP"] = "Top"
	L["TOPRIGHT"] = "Top Right"
	L["LEFT"] = "Left"
	L["CENTER"] = "Center"
	L["RIGHT"] = "Right"
	L["BOTTOMLEFT"] = "Bottom Left"
	L["BOTTOM"] = "Bottom"
	L["BOTTOMRIGHT"] = "Bottom Right"
	L["NONE"] = NONE
	L["iconOffsetX"] = "Horizontal Offset"
	L["iconOffsetXTT"] = "Move the icons left or right from default position"
	L["iconOffsetY"] = "Vertical Offset"
	L["iconOffsetYTT"] = "Move the icons up or down from default position"
	L["Default"] = DEFAULT
	L["Explorer"] = "Explorer"
	L["Adventurer"] = "Adventurer"
	L["Veteran"] = "Veteran"
	L["Champion"] = "Champion"
	L["Hero"] = "Hero"
	L["Myth"] = "Myth"
	L["Awakened"] = "Awakened"
	L["IconTheme"] = "%s Icon"
	L["IconThemeTT"] = "Icon that appears on %s items and tooltips."
	L["HideUpgradePrefix"] = "Hide \"Upgrade Level:\" Text"
	L["HideUpgradePrefixTT"] = "Hides the \"Upgrade Level:\" text in item tooltips."
	L["HideOutdatedIcons"] = "Hide Outdated Icons"
	L["HideOutdatedIconsTT"] = "Hides upgrade quality icons below the current season's minimum item level."

return end

if LOCALE == "esES" or LOCALE == "esMX" then
	-- Spanish translations go here
	L["iconLocation"] = "Ubicación del Icono"
	L["iconLocationTT"] = "Lugares donde se colocará el icono de calidad en la ranura del objeto."
	L["iconScale"] = "Escala del Icono"
	L["iconScaleTT"] = "Factor de tamaño del icono."
	L["TOPLEFT"] = "Superior Izquierda"
	L["TOP"] = "Superior"
	L["TOPRIGHT"] = "Superior Derecha"
	L["LEFT"] = "Izquierda"
	L["CENTER"] = "Centro"
	L["RIGHT"] = "Derecha"
	L["BOTTOMLEFT"] = "Inferior Izquierda"
	L["BOTTOM"] = "Inferior"
	L["BOTTOMRIGHT"] = "Inferior Derecha"
	L["NONE"] = NONE
	L["iconOffsetX"] = "Desplazamiento horizontal"
	L["iconOffsetXTT"] = "Mueve los iconos a la izquierda o derecha desde la posición predeterminada"
	L["iconOffsetY"] = "Desplazamiento vertical"
	L["iconOffsetYTT"] = "Mueve los iconos hacia arriba o abajo desde la posición predeterminada"
	L["Default"] = DEFAULT
	L["Explorer"] = "Expedicionario"
	L["Adventurer"] = "Aventurero"
	L["Veteran"] = "Veterano"
	L["Champion"] = "Campeón"
	L["Hero"] = "Héroe"
	L["Myth"] = "Mito"
	L["Awakened"] = "Despierto"
	L["IconTheme"] = "%s Icono"
	L["IconThemeTT"] = "Icono que aparece en los objetos %s y en las descripciones emergentes."
	L["HideUpgradePrefix"] = "Ocultar texto \"Nivel de mejora:\""
	L["HideUpgradePrefixTT"] = "Oculta el texto \"Nivel de mejora:\" en las descripciones emergentes de objetos."
	L["HideOutdatedIcons"] = "Ocultar iconos obsoletos"
	L["HideOutdatedIconsTT"] = "Oculta los iconos de calidad de mejora por debajo del nivel de objeto mínimo de la temporada actual."

return end

if LOCALE == "deDE" then
	-- German translations go here
	L["iconLocation"] = "Symbolposition"
	L["iconLocationTT"] = "Positionen, an denen das Qualitätssymbol im Ausrüstungsplatz angezeigt wird."
	L["iconScale"] = "Symbolskalierung"
	L["iconScaleTT"] = "Größenfaktor des Symbols."
	L["TOPLEFT"] = "Oben Links"
	L["TOP"] = "Oben"
	L["TOPRIGHT"] = "Oben Rechts"
	L["LEFT"] = "Links"
	L["CENTER"] = "Mitte"
	L["RIGHT"] = "Rechts"
	L["BOTTOMLEFT"] = "Unten Links"
	L["BOTTOM"] = "Unten"
	L["BOTTOMRIGHT"] = "Unten Rechts"
	L["NONE"] = NONE
	L["iconOffsetX"] = "Horizontaler Versatz"
	L["iconOffsetXTT"] = "Verschiebt die Symbole nach links oder rechts von der Standardposition"
	L["iconOffsetY"] = "Vertikaler Versatz"
	L["iconOffsetYTT"] = "Verschiebt die Symbole nach oben oder unten von der Standardposition"
	L["Default"] = DEFAULT
	L["Explorer"] = "Forscher"
	L["Adventurer"] = "Abenteurer"
	L["Veteran"] = "Veteran"
	L["Champion"] = "Champion"
	L["Hero"] = "Held"
	L["Myth"] = "Mythos"
	L["Awakened"] = "Erweckt"
	L["IconTheme"] = "%s Symbol"
	L["IconThemeTT"] = "Symbol, das auf %s-Gegenständen und in Tooltips erscheint."
	L["HideUpgradePrefix"] = "\"Aufwertungsstufe:\"-Text ausblenden"
	L["HideUpgradePrefixTT"] = "Blendet den Text \"Aufwertungsstufe:\" in Gegenstandstooltips aus."
	L["HideOutdatedIcons"] = "Veraltete Symbole ausblenden"
	L["HideOutdatedIconsTT"] = "Blendet Symbole für Aufwertungsqualität unterhalb der Mindestgegenstandsstufe der aktuellen Saison aus."

return end

if LOCALE == "frFR" then
	-- French translations go here
	L["iconLocation"] = "Emplacement de l’icône"
	L["iconLocationTT"] = "Emplacements où l’icône de qualité sera affichée sur l’emplacement d’objet."
	L["iconScale"] = "Échelle de l’icône"
	L["iconScaleTT"] = "Facteur de taille de l’icône."
	L["TOPLEFT"] = "En haut à gauche"
	L["TOP"] = "En haut"
	L["TOPRIGHT"] = "En haut à droite"
	L["LEFT"] = "À gauche"
	L["CENTER"] = "Centre"
	L["RIGHT"] = "À droite"
	L["BOTTOMLEFT"] = "En bas à gauche"
	L["BOTTOM"] = "En bas"
	L["BOTTOMRIGHT"] = "En bas à droite"
	L["NONE"] = NONE
	L["iconOffsetX"] = "Décalage horizontal"
	L["iconOffsetXTT"] = "Déplace les icônes vers la gauche ou la droite depuis la position par défaut"
	L["iconOffsetY"] = "Décalage vertical"
	L["iconOffsetYTT"] = "Déplace les icônes vers le haut ou le bas depuis la position par défaut"
	L["Default"] = DEFAULT
	L["Explorer"] = "Explorateur"
	L["Adventurer"] = "Aventurier"
	L["Veteran"] = "Vétéran"
	L["Champion"] = "Champion"
	L["Hero"] = "Héros"
	L["Myth"] = "Mythe"
	L["Awakened"] = "Éveillé"
	L["IconTheme"] = "%s Icône"
	L["IconThemeTT"] = "Icône qui apparaît sur les objets %s et dans les info-bulles."
	L["HideUpgradePrefix"] = "Masquer le texte « Niveau d’amélioration : »"
	L["HideUpgradePrefixTT"] = "Masque le texte « Niveau d’amélioration : » dans les info-bulles des objets."
	L["HideOutdatedIcons"] = "Masquer les icônes obsolètes"
	L["HideOutdatedIconsTT"] = "Masque les icônes de qualité d’amélioration inférieures au niveau d’objet minimum de la saison actuelle."

return end

if LOCALE == "itIT" then
	-- French translations go here
	L["iconLocation"] = "Posizione dell’icona"
	L["iconLocationTT"] = "Luoghi in cui verrà posizionata l’icona di qualità nello slot dell’oggetto."
	L["iconScale"] = "Scala dell’icona"
	L["iconScaleTT"] = "Fattore di dimensione dell’icona."
	L["TOPLEFT"] = "In alto a sinistra"
	L["TOP"] = "In alto"
	L["TOPRIGHT"] = "In alto a destra"
	L["LEFT"] = "A sinistra"
	L["CENTER"] = "Centro"
	L["RIGHT"] = "A destra"
	L["BOTTOMLEFT"] = "In basso a sinistra"
	L["BOTTOM"] = "In basso"
	L["BOTTOMRIGHT"] = "In basso a destra"
	L["NONE"] = NONE
	L["iconOffsetX"] = "Scostamento orizzontale"
	L["iconOffsetXTT"] = "Sposta le icone a sinistra o a destra dalla posizione predefinita"
	L["iconOffsetY"] = "Scostamento verticale"
	L["iconOffsetYTT"] = "Sposta le icone verso l’alto o il basso dalla posizione predefinita"
	L["Default"] = DEFAULT
	L["Explorer"] = "Esploratore"
	L["Adventurer"] = "Avventuriero"
	L["Veteran"] = "Veterano"
	L["Champion"] = "Campione"
	L["Hero"] = "Eroe"
	L["Myth"] = "Mito"
	L["Awakened"] = "Risvegliato"
	L["IconTheme"] = "%s Icona"
	L["HideUpgradePrefix"] = "Nascondi testo \"Livello di potenziamento:\""
	L["HideUpgradePrefixTT"] = "Nasconde il testo \"Livello di potenziamento:\" nei tooltip degli oggetti."
	L["HideOutdatedIcons"] = "Nascondi icone obsolete"
	L["HideOutdatedIconsTT"] = "Nasconde le icone della qualità dei potenziamenti inferiori al livello oggetto minimo della stagione attuale."

return end

if LOCALE == "ptBR" then
	-- Brazilian Portuguese translations go here
	L["iconLocation"] = "Local do Ícone"
	L["iconLocationTT"] = "Locais onde o ícone de qualidade será exibido no espaço do item."
	L["iconScale"] = "Escala do Ícone"
	L["iconScaleTT"] = "Fator de tamanho do ícone."
	L["TOPLEFT"] = "Superior Esquerdo"
	L["TOP"] = "Superior"
	L["TOPRIGHT"] = "Superior Direito"
	L["LEFT"] = "Esquerda"
	L["CENTER"] = "Centro"
	L["RIGHT"] = "Direita"
	L["BOTTOMLEFT"] = "Inferior Esquerdo"
	L["BOTTOM"] = "Inferior"
	L["BOTTOMRIGHT"] = "Inferior Direito"
	L["NONE"] = NONE
	L["iconOffsetX"] = "Deslocamento horizontal"
	L["iconOffsetXTT"] = "Move os ícones para a esquerda ou direita da posição padrão"
	L["iconOffsetY"] = "Deslocamento vertical"
	L["iconOffsetYTT"] = "Move os ícones para cima ou para baixo da posição padrão"
	L["Default"] = DEFAULT
	L["Explorer"] = "Explorador"
	L["Adventurer"] = "Aventureiro"
	L["Veteran"] = "Veterano"
	L["Champion"] = "Campeão"
	L["Hero"] = "Herói"
	L["Myth"] = "Mito"
	L["Awakened"] = "Desperto"
	L["IconTheme"] = "%s Ícone"
	L["IconThemeTT"] = "Ícone que aparece nos itens %s e nas dicas de interface."
	L["HideUpgradePrefix"] = "Ocultar texto \"Nível de aprimoramento:\""
	L["HideUpgradePrefixTT"] = "Oculta o texto \"Nível de aprimoramento:\" nas dicas de itens."
	L["HideOutdatedIcons"] = "Ocultar ícones desatualizados"
	L["HideOutdatedIconsTT"] = "Oculta os ícones de qualidade de melhoria abaixo do nível mínimo de item da temporada atual."

-- Note that the EU Portuguese WoW client also
-- uses the Brazilian Portuguese locale code.
return end

if LOCALE == "ruRU" then
	-- Russian translations go here
	L["iconLocation"] = "Расположение иконки"
	L["iconLocationTT"] = "Места, где будет размещена иконка качества на ячейке предмета."
	L["iconScale"] = "Масштаб иконки"
	L["iconScaleTT"] = "Масштаб (размер) иконки."
	L["TOPLEFT"] = "Верхний левый угол"
	L["TOP"] = "Верх"
	L["TOPRIGHT"] = "Верхний правый угол"
	L["LEFT"] = "Слева"
	L["CENTER"] = "Центр"
	L["RIGHT"] = "Справа"
	L["BOTTOMLEFT"] = "Нижний левый угол"
	L["BOTTOM"] = "Низ"
	L["BOTTOMRIGHT"] = "Нижний правый угол"
	L["NONE"] = NONE
	L["iconOffsetX"] = "Горизонтальное смещение"
	L["iconOffsetXTT"] = "Перемещает значки влево или вправо от позиции по умолчанию"
	L["iconOffsetY"] = "Вертикальное смещение"
	L["iconOffsetYTT"] = "Перемещает значки вверх или вниз от позиции по умолчанию"
	L["Default"] = DEFAULT
	L["Explorer"] = "Исследователь"
	L["Adventurer"] = "Искатель приключений"
	L["Veteran"] = "Ветеран"
	L["Champion"] = "Защитник"
	L["Hero"] = "Герой"
	L["Myth"] = "Легенда"
	L["Awakened"] = "Пробужденный герой"
	L["IconTheme"] = "%s Герб"
	L["IconThemeTT"] = "Значок, который отображается на предметах %s и во всплывающих подсказках."
	L["HideUpgradePrefix"] = "Скрыть текст \"Уровень улучшения:\""
	L["HideUpgradePrefixTT"] = "Скрывает текст \"Уровень улучшения:\" в подсказках предметов."
	L["HideOutdatedIcons"] = "Скрывать устаревшие значки"
	L["HideOutdatedIconsTT"] = "Скрывает значки качества улучшений ниже минимального уровня предметов текущего сезона."

return end

if LOCALE == "koKR" then
	-- Korean translations go here
	L["iconLocation"] = "아이콘 위치"
	L["iconLocationTT"] = "품질 아이콘이 아이템 칸에 표시될 위치입니다."
	L["iconScale"] = "아이콘 크기"
	L["iconScaleTT"] = "아이콘의 크기 배율입니다."
	L["TOPLEFT"] = "왼쪽 상단"
	L["TOP"] = "상단"
	L["TOPRIGHT"] = "오른쪽 상단"
	L["LEFT"] = "왼쪽"
	L["CENTER"] = "가운데"
	L["RIGHT"] = "오른쪽"
	L["BOTTOMLEFT"] = "왼쪽 하단"
	L["BOTTOM"] = "하단"
	L["BOTTOMRIGHT"] = "오른쪽 하단"
	L["NONE"] = NONE
	L["iconOffsetX"] = "가로 이동"
	L["iconOffsetXTT"] = "아이콘을 기본 위치에서 좌우로 이동합니다"
	L["iconOffsetY"] = "세로 이동"
	L["iconOffsetYTT"] = "아이콘을 기본 위치에서 위아래로 이동합니다"
	L["Default"] = DEFAULT
	L["Explorer"] = "탐험가"
	L["Adventurer"] = "모험가"
	L["Veteran"] = "노련가"
	L["Champion"] = "챔피언"
	L["Hero"] = "영웅"
	L["Myth"] = "신화"
	L["Awakened"] = "각성"
	L["IconTheme"] = "%s 문장"
	L["IconThemeTT"] = "%s 아이템과 툴팁에 표시되는 아이콘입니다."
	L["HideUpgradePrefix"] = "\"업그레이드 레벨:\" 텍스트 숨기기"
	L["HideUpgradePrefixTT"] = "아이템 툴팁에서 \"업그레이드 레벨:\" 텍스트를 숨깁니다."
	L["HideOutdatedIcons"] = "오래된 아이콘 숨기기"
	L["HideOutdatedIconsTT"] = "현재 시즌의 최소 아이템 레벨보다 낮은 강화 품질 아이콘을 숨깁니다."

return end

if LOCALE == "zhCN" then
	-- Simplified Chinese translations go here
	L["iconLocation"] = "图标位置"
	L["iconLocationTT"] = "质量图标在物品栏位中的显示位置。"
	L["iconScale"] = "图标缩放"
	L["iconScaleTT"] = "图标的缩放大小系数。"
	L["TOPLEFT"] = "左上"
	L["TOP"] = "上方"
	L["TOPRIGHT"] = "右上"
	L["LEFT"] = "左侧"
	L["CENTER"] = "中间"
	L["RIGHT"] = "右侧"
	L["BOTTOMLEFT"] = "左下"
	L["BOTTOM"] = "下方"
	L["BOTTOMRIGHT"] = "右下"
	L["NONE"] = NONE
	L["iconOffsetX"] = "水平偏移"
	L["iconOffsetXTT"] = "将图标从默认位置向左或向右移动"
	L["iconOffsetY"] = "垂直偏移"
	L["iconOffsetYTT"] = "将图标从默认位置向上或向下移动"
	L["Default"] = DEFAULT
	L["Explorer"] = "探索者"
	L["Adventurer"] = "冒险者"
	L["Veteran"] = "老兵"
	L["Champion"] = "勇士"
	L["Hero"] = "英雄"
	L["Myth"] = "神话"
	L["Awakened"] = "觉醒"
	L["IconTheme"] = "%s 图标"
	L["IconThemeTT"] = "显示在 %s 物品和提示中的图标。"
	L["HideUpgradePrefix"] = "隐藏“升级等级：”文本"
	L["HideUpgradePrefixTT"] = "在物品提示中隐藏“升级等级：”文本。"
	L["HideOutdatedIcons"] = "隐藏过时图标"
	L["HideOutdatedIconsTT"] = "隐藏低于当前赛季最低物品等级的升级品质图标。"

return end

if LOCALE == "zhTW" then
	-- Traditional Chinese translations go here
	L["iconLocation"] = "圖示位置"
	L["iconLocationTT"] = "品質圖示將顯示於物品欄位的哪個位置。"
	L["iconScale"] = "圖示縮放"
	L["iconScaleTT"] = "圖示的大小縮放比例。"
	L["TOPLEFT"] = "左上"
	L["TOP"] = "上方"
	L["TOPRIGHT"] = "右上"
	L["LEFT"] = "左側"
	L["CENTER"] = "中間"
	L["RIGHT"] = "右側"
	L["BOTTOMLEFT"] = "左下"
	L["BOTTOM"] = "下方"
	L["BOTTOMRIGHT"] = "右下"
	L["NONE"] = NONE
	L["iconOffsetX"] = "水平偏移"
	L["iconOffsetXTT"] = "將圖示從預設位置向左或向右移動"
	L["iconOffsetY"] = "垂直偏移"
	L["iconOffsetYTT"] = "將圖示從預設位置向上或向下移動"
	L["Default"] = DEFAULT
	L["Explorer"] = "探險者"
	L["Adventurer"] = "冒險者"
	L["Veteran"] = "精兵"
	L["Champion"] = "勇士"
	L["Hero"] = "英雄"
	L["Myth"] = "神話"
	L["Awakened"] = "覺醒"
	L["IconTheme"] = "%s 圖示"
	L["IconThemeTT"] = "顯示在 %s 物品和提示中的圖示。"
	L["HideUpgradePrefix"] = "隱藏「升級等級：」文字"
	L["HideUpgradePrefixTT"] = "在物品提示中隱藏「升級等級：」文字。"
	L["HideOutdatedIcons"] = "隱藏過時圖示"
	L["HideOutdatedIconsTT"] = "隱藏低於目前賽季最低物品等級的升級品質圖示。"

return end
