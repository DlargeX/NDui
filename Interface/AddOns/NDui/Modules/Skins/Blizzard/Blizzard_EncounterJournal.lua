local _, ns = ...
local B, C, L, DB = unpack(ns)

local r, g, b = DB.r, DB.g, DB.b

local function reskinHeader(header)
	for i = 4, 18 do
		select(i, header.button:GetRegions()):SetTexture("")
	end
	B.Reskin(header.button)
	header.descriptionBG:SetAlpha(0)
	header.descriptionBGBottom:SetAlpha(0)
	header.description:SetTextColor(1, 1, 1)
	header.button.title:SetTextColor(1, 1, 1)
	header.button.expandedIcon:SetWidth(20) -- don't wrap the text
end

local function reskinSectionHeader()
	local index = 1
	while true do
		local header = _G["EncounterJournalInfoHeader"..index]
		if not header then return end
		if not header.styled then
			reskinHeader(header)
			header.button.bg = B.ReskinIcon(header.button.abilityIcon)
			header.styled = true
		end

		if header.button.abilityIcon:IsShown() then
			header.button.bg:Show()
		else
			header.button.bg:Hide()
		end

		index = index + 1
	end
end

C.themes["Blizzard_EncounterJournal"] = function()
	-- Tabs
	for i = 1, 5 do
		local tab = EncounterJournal.Tabs[i]
		if tab then
			B.ReskinTab(tab)
			if i ~= 1 then
				tab:ClearAllPoints()
				tab:SetPoint("TOPLEFT", EncounterJournal.Tabs[i-1], "TOPRIGHT", -15, 0)
			end
		end
	end

	-- Side tabs
	local tabs = {"overviewTab", "modelTab", "bossTab", "lootTab"}
	for _, name in pairs(tabs) do
		local tab = EncounterJournal.encounter.info[name]
		local bg = B.SetBD(tab)
		bg:SetInside(tab, 2, 2)

		tab:SetNormalTexture(0)
		tab:SetPushedTexture(0)
		tab:SetDisabledTexture(0)
		local hl = tab:GetHighlightTexture()
		hl:SetColorTexture(r, g, b, .2)
		hl:SetInside(bg)

		if name == "overviewTab" then
			tab:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", 9, -35)
		end
	end

	-- Instance select
	EncounterJournalInstanceSelectBG:SetAlpha(0)
	B.ReskinDropDown(EncounterJournal.instanceSelect.ExpansionDropdown)
	B.ReskinTrimScroll(EncounterJournal.instanceSelect.ScrollBar)

	hooksecurefunc(EncounterJournal.instanceSelect.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				child:SetNormalTexture(0)
				child:SetHighlightTexture(0)
				child:SetPushedTexture(0)

				local bg = B.CreateBDFrame(child.bgImage)
				bg:SetPoint("TOPLEFT", 3, -3)
				bg:SetPoint("BOTTOMRIGHT", -4, 2)

				child.styled = true
			end
		end
	end)

	-- Encounter frame
	EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	EncounterJournalInstanceSelectBG:Hide()
	EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()

	EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, .8, 0)
	EncounterJournal.encounter.instance.LoreScrollingFont:SetTextColor(CreateColor(1, 1, 1))
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor("P", 1, 1, 1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, .8, 0)

	B.CreateBDFrame(EncounterJournalEncounterFrameInfoModelFrame, .25)
	EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	hooksecurefunc(EncounterJournal.encounter.info.BossesScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				B.Reskin(child, true)
				local hl = child:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .25)
				hl:SetInside(child.__bg)

				child.text:SetTextColor(1, 1, 1)
				child.creature:SetPoint("TOPLEFT", 0, -4)

				child.styled = true
			end
		end
	end)
	hooksecurefunc("EncounterJournal_ToggleHeaders", reskinSectionHeader)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, _, index)
		local header = self.overviews[index]
		if not header.styled then
			reskinHeader(header)
			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object)
		local parent = object:GetParent()
		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor("P", 1, 1, 1)
					bullet.styled = true
				end
			end
		end
	end)

	hooksecurefunc(EncounterJournal.encounter.info.LootContainer.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if child.boss and not child.styled then
				child.boss:SetTextColor(1, 1, 1)
				child.slot:SetTextColor(1, 1, 1)
				child.armorType:SetTextColor(1, 1, 1)
				child.bossTexture:SetAlpha(0)
				child.bosslessTexture:SetAlpha(0)
				child.IconBorder:SetAlpha(0)
				child.icon:SetPoint("TOPLEFT", 1, -1)
				B.ReskinIcon(child.icon)

				local bg = B.CreateBDFrame(child, .25)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)

				child.styled = true
			end
		end
	end)

	-- Search results
	EncounterJournalSearchBox:SetFrameLevel(15)
	local showAllResults = EncounterJournalSearchBox.showAllResults
	local previewContainer = EncounterJournalSearchBox.searchPreviewContainer
	B.StripTextures(previewContainer)
	local bg = B.SetBD(previewContainer)
	bg:SetPoint("TOPLEFT", -3, 3)
	bg:SetPoint("BOTTOMRIGHT", showAllResults, 3, -3)

	for i = 1, EncounterJournalSearchBox:GetNumChildren() do
		local child = select(i, EncounterJournalSearchBox:GetChildren())
		if child.iconFrame then
			B.StyleSearchButton(child)
		end
	end
	B.StyleSearchButton(showAllResults)

	do
		local result = EncounterJournalSearchResults
		result:SetPoint("BOTTOMLEFT", EncounterJournal, "BOTTOMRIGHT", 15, -1)
		B.StripTextures(result)
		local bg = B.SetBD(result)
		bg:SetPoint("TOPLEFT", -10, 0)
		bg:SetPoint("BOTTOMRIGHT")

		B.ReskinClose(EncounterJournalSearchResultsCloseButton)
		B.ReskinTrimScroll(result.ScrollBar)

		hooksecurefunc(result.ScrollBox, "Update", function(self)
			for i = 1, self.ScrollTarget:GetNumChildren() do
				local child = select(i, self.ScrollTarget:GetChildren())
				if not child.styled then
					B.StripTextures(child, 2)
					B.ReskinIcon(child.icon)
					local bg = B.CreateBDFrame(child, .25)
					bg:SetInside()

					child:SetHighlightTexture(DB.bdTex)
					local hl = child:GetHighlightTexture()
					hl:SetVertexColor(r, g, b, .25)
					hl:SetInside(bg)

					child.styled = true
				end
			end
		end)
	end

	-- Various controls
	B.ReskinPortraitFrame(EncounterJournal)
	B.ReskinInput(EncounterJournalSearchBox)
	B.ReskinTrimScroll(EncounterJournal.encounter.instance.LoreScrollBar)
	B.ReskinTrimScroll(EncounterJournal.encounter.info.BossesScrollBar)
	B.ReskinTrimScroll(EncounterJournal.encounter.info.LootContainer.ScrollBar)
	B.ReskinTrimScroll(EncounterJournal.encounter.info.overviewScroll.ScrollBar)
	B.ReskinTrimScroll(EncounterJournal.encounter.info.detailsScroll.ScrollBar)
	B.ReskinDropDown(EncounterJournal.encounter.info.LootContainer.filter)
	B.ReskinDropDown(EncounterJournal.encounter.info.LootContainer.slotFilter)
	B.ReskinDropDown(EncounterJournalEncounterFrameInfoDifficulty)


	-- Suggest frame
	local suggestFrame = EncounterJournal.suggestFrame

	-- Suggestion 1
	local suggestion = suggestFrame.Suggestion1
	suggestion.bg:Hide()
	B.CreateBDFrame(suggestion, .25)
	suggestion.icon:SetPoint("TOPLEFT", 135, -15)
	B.CreateBDFrame(suggestion.icon)

	local centerDisplay = suggestion.centerDisplay
	centerDisplay.title.text:SetTextColor(1, 1, 1)
	centerDisplay.description.text:SetTextColor(.9, .9, .9)
	B.Reskin(suggestion.button)

	local reward = suggestion.reward
	reward.text:SetTextColor(.9, .9, .9)
	reward.iconRing:Hide()
	reward.iconRingHighlight:SetTexture("")
	B.CreateBDFrame(reward.icon):SetFrameLevel(3)
	B.ReskinArrow(suggestion.prevButton, "left")
	B.ReskinArrow(suggestion.nextButton, "right")

	-- Suggestion 2 and 3
	for i = 2, 3 do
		local suggestion = suggestFrame["Suggestion"..i]

		suggestion.bg:Hide()
		B.CreateBDFrame(suggestion, .25)
		suggestion.icon:SetPoint("TOPLEFT", 10, -10)
		B.CreateBDFrame(suggestion.icon)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("TOPLEFT", 85, -10)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)
		B.Reskin(centerDisplay.button)

		local reward = suggestion.reward
		reward.iconRing:Hide()
		reward.iconRingHighlight:SetTexture("")
		B.CreateBDFrame(reward.icon):SetFrameLevel(3)
	end

	-- Hook functions
	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = suggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]
			suggestion.iconRing:Hide()

			if data.iconPath then
				suggestion.icon:SetMask("")
				suggestion.icon:SetTexCoord(unpack(DB.TexCoord))
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion"..i]
				if not suggestion then break end

				local data = self.suggestions[i]
				suggestion.iconRing:Hide()

				if data.iconPath then
					suggestion.icon:SetMask("")
					suggestion.icon:SetTexCoord(unpack(DB.TexCoord))
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		local rewardData = suggestion.reward.data
		if rewardData then
			suggestion.reward.icon:SetMask("")
			suggestion.reward.icon:SetTexCoord(unpack(DB.TexCoord))
		end
	end)

	-- LootJournal

	local lootJournal = EncounterJournal.LootJournal
	B.StripTextures(lootJournal)

	local iconColor = DB.QualityColors[Enum.ItemQuality.Legendary or 5] -- legendary color
	B.ReskinTrimScroll(lootJournal.ScrollBar)

	hooksecurefunc(lootJournal.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				child.Background:SetAlpha(0)
				child.BackgroundOverlay:SetAlpha(0)
				child.UnavailableOverlay:SetAlpha(0)
				child.UnavailableBackground:SetAlpha(0)
				child.CircleMask:Hide()
				child.bg = B.ReskinIcon(child.Icon)
				child.bg:SetBackdropBorderColor(iconColor.r, iconColor.g, iconColor.b)

				local bg = B.CreateBDFrame(child, .25)
				bg:SetPoint("TOPLEFT", 3, 0)
				bg:SetPoint("BOTTOMRIGHT", -2, 1)

				child.styled = true
			end
		end
	end)

	-- ItemSetsFrame
	if EncounterJournal.LootJournalItems then
		B.StripTextures(EncounterJournal.LootJournalItems)
		B.ReskinDropDown(EncounterJournal.LootJournalViewDropdown)

		local function reskinBar(bar)
			if not bar.styled then
				bar.ItemLevel:SetTextColor(1, 1, 1)
				bar.Background:Hide()
				B.CreateBDFrame(bar, .25)

				bar.styled = true
			end

			local itemButtons = bar.ItemButtons
			for i = 1, #itemButtons do
				local button = itemButtons[i]
				if not button.bg then
					button.bg = B.ReskinIcon(button.Icon)
					B.ReskinIconBorder(button.Border, true, true)
				end
			end
		end

		local itemSetsFrame = EncounterJournal.LootJournalItems.ItemSetsFrame
		B.ReskinTrimScroll(itemSetsFrame.ScrollBar)

		hooksecurefunc(itemSetsFrame.ScrollBox, "Update", function(self)
			self:ForEachFrame(reskinBar)
		end)
		B.ReskinDropDown(itemSetsFrame.ClassDropdown)
	end

	-- Monthly activities
	local frame = EncounterJournalMonthlyActivitiesFrame
	if frame then
		B.StripTextures(frame)
		B.ReskinTrimScroll(frame.FilterList.ScrollBar)
		B.ReskinTrimScroll(frame.ScrollBar)
		if frame.ThemeContainer then
			frame.ThemeContainer:SetAlpha(0)
		end

		local function replaceBlackColor(text, r, g, b)
			if r == 0 and g == 0 and b == 0 then
				text:SetTextColor(.7, .7, .7)
			end
		end

		local function handleText(button)
			local container = button.TextContainer
			if container and not container.styled then
				hooksecurefunc(container.NameText, "SetTextColor", replaceBlackColor)
				hooksecurefunc(container.ConditionsText, "SetTextColor", replaceBlackColor)
				container.styled = true
			end
		end

		hooksecurefunc(frame.ScrollBox, "Update", function(self)
			self:ForEachFrame(handleText)
		end)
	end
end