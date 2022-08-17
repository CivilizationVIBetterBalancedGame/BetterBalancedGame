-- Copyright 2018, Firaxis Games

-- ===========================================================================
-- Includes
-- ===========================================================================



if Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68") == true then
	include("WorldRankings_Expansion2")
	print("WorldRankings for BBG XP2")
	else
	include("WorldRankings");
	print("WorldRankings for BBG")	
end



-- ===========================================================================
-- Constants
-- ===========================================================================
local PADDING_GENERIC_ITEM_BG:number = 25;
local SIZE_GENERIC_ITEM_MIN_Y:number = 54;
local DATA_FIELD_SELECTION:string = "Selection";
local PADDING_TAB_BUTTON_TEXT:number = 27;
local PADDING_VICTORY_LABEL_UNDERLINE:number = 90;
local SIZE_VICTORY_ICON_SMALL:number = 64;
local DATA_FIELD_OVERALL_PLAYERS_IM:string = "OverallPlayersIM";
local TEAM_RIBBON_PREFIX:string = "ICON_TEAM_RIBBON_";
local TEAM_RIBBON_SIZE_TOP_TEAM:number = 53;
local TEAM_RIBBON_SIZE:number = 44;
local TEAM_ICON_PREFIX:string = "Team";
local TEAM_ICON_SIZE_TOP_TEAM:number = 38;
local TEAM_ICON_SIZE:number = 28;
local SIZE_OVERALL_TOP_PLAYER_ICON:number = 48;
local SIZE_OVERALL_PLAYER_ICON:number = 36;
local SIZE_OVERALL_BG_HEIGHT:number = 100;
local SIZE_OVERALL_INSTANCE:number = 40;



-- ===========================================================================
-- Cached Functions
-- ===========================================================================
BASE_PopulateTabs = PopulateTabs;
BASE_PopulateOverallInstance = PopulateOverallInstance;
BASE_AddTab = AddTab;

g_victoryData.VICTORY_TRADITIONAL_DOMINATION = {
	GetText = function(p) 
		local total = NonWaterTiles();
		local current = 0;
		if (p:IsAlive()) then
			current = TilesInEmpire(p);
		end
		local str = Locale.Lookup("LOC_WORLD_RANKINGS_TRADITIONAL_DOMINATION_TT")
		str = str.."[NEWLINE]"..tostring(current).." / "..tostring(total)
		return str;
	end,
	GetScore = function(p)
		local current = 0;
		if (p:IsAlive()) then
			TilesInEmpire(p);
		end

		return current;
	end
};

-- ===========================================================================
-- Overrides
-- ===========================================================================

function PopulateOverallInstance(instance:table, victoryType:string, typeText:string)
	
	if victoryType ~= "VICTORY_TRADITIONAL_DOMINATION" then
		BASE_PopulateOverallInstance(instance,victoryType,typeText)
		else
		typeText = "CONQUEST"
		BASE_PopulateOverallInstance(instance,victoryType,typeText)
	end
	
end

function PopulateTabs()

	-- Clean up previous data
	m_ExtraTabs = {};
	m_TotalTabSize = 0;
	m_MaxExtraTabSize = 0;
	g_ExtraTabsIM:ResetInstances();
	g_TabSupportIM:ResetInstances();
	
	-- Deselect previously selected tab
	if g_TabSupport then
		g_TabSupport.SelectTab(nil);
		DeselectPreviousTab();
		DeselectExtraTabs();
	end

	-- Create TabSupport object
	g_TabSupport = CreateTabs(Controls.TabContainer, 42, 44, UI.GetColorValueFromHexLiteral(0xFF331D05));

	local defaultTab = AddTab(TAB_OVERALL, ViewOverall);

	-- Add default victory types in a pre-determined order
	if(GameConfiguration.IsAnyMultiplayer() or Game.IsVictoryEnabled("VICTORY_SCORE")) then
		BASE_AddTab(TAB_SCORE, ViewScore);
	end
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		AddTab(TAB_SCIENCE, ViewScience);
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		g_CultureInst = AddTab(TAB_CULTURE, ViewCulture);
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		AddTab(TAB_DOMINATION, ViewDomination);
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		AddTab(TAB_RELIGION, ViewReligion);
	end

	-- Add custom (modded) victory types
	for row in GameInfo.Victories() do
   	local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
            if (victoryType == "VICTORY_DIPLOMATIC") then
                AddTab(Locale.Lookup("LOC_TOOLTIP_DIPLOMACY_CONGRESS_BUTTON"), function() ViewDiplomatic(victoryType); end);
            elseif (victoryType == "VICTORY_TRADITIONAL_DOMINATION") then
				AddTab(Locale.Lookup("LOC_TOOLTIP_TRADITIONAL_DOMINATION_BUTTON"), function() ViewTraditionalDomination(victoryType); end);
			else
                AddTab(Locale.Lookup(row.Name), function() ViewGeneric(victoryType); end);
            end
		end
	end

	if m_TotalTabSize > (Controls.TabContainer:GetSizeX()*2) then
		Controls.ExpandExtraTabs:SetHide(false);
		for _, tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSizeX(m_MaxExtraTabSize);
		end
	else
		Controls.ExpandExtraTabs:SetHide(true);
	end

	Controls.ExpandExtraTabs:SetHide(true);

	g_TabSupport.SelectTab(defaultTab);
	g_TabSupport.CenterAlignTabs(0, 450, 32);
end

function AddTab(label:string, onClickCallback:ifunction)

	local tabInst:table = g_TabSupportIM:GetInstance();
	tabInst.Button[DATA_FIELD_SELECTION] = tabInst.Selection;

	tabInst.Button:SetText(label);
	local textControl = tabInst.Button:GetTextControl();
	textControl:SetHide(false);

	local textSize:number = textControl:GetSizeX();
	tabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	tabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	tabInst.Selection:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT + 4);

	m_TotalTabSize = m_TotalTabSize + tabInst.Button:GetSizeX();
	if m_TotalTabSize > (Controls.TabContainer:GetSizeX() * 2) then
		g_TabSupportIM:ReleaseInstance(tabInst);
		AddExtraTab(label, onClickCallback);
	else
		g_TabSupport.AddTab(tabInst.Button, OnTabClicked(tabInst, onClickCallback));
	end

	return tabInst.Button;
end

function ViewTraditionalDomination(victoryType:string)
	ResetState(function() ViewTraditionalDomination(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
	local str:string = ""
	str = Locale.Lookup(victoryInfo.Description)..Locale.Lookup("LOC_WORLD_RANKINGS_TRADITIONAL_DOMINATION_DESC_LAST").."[COLOR_RED] "..tostring(GameConfiguration.GetValue("TRADITIONAL_DOMINATION_LEVEL")).." %[ENDCOLOR]"

    PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, str, "ICON_VICTORY_DOMINATION");


	local genericData:table = GatherGenericData();

	g_GenericIM:ResetInstances();
	g_GenericTeamIM:ResetInstances();

	local ourData:table = {};

	for i, teamData in ipairs(genericData) do
		local ourTeamData:table = { teamData, score };

		ourTeamData.teamData = teamData;
		local progress = Check_Progress_DominationVictory(teamData.TeamID)
		if progress == nil then
			progress = 0;
		end
		ourTeamData.score = progress;

		table.insert(ourData, ourTeamData);
	end

	table.sort(ourData, function(a, b)
		return a.score > b.score;
	end);

	for i, theData in ipairs(ourData) do
		if #theData.teamData.PlayerData > 1 then
			PopulateTradDomTeamInstance(g_GenericTeamIM:GetInstance(), theData.teamData, victoryType);
		else
			local uiGenericInstance:table = g_GenericIM:GetInstance();
			local pPlayer:table = Players[theData.teamData.PlayerData[1].PlayerID];
			if pPlayer ~= nil then
				local pStats:table = pPlayer:GetStats();
				if pStats == nil then
					UI.DataError("Stats not found for PlayerID:" .. theData.teamData.PlayerData[1].PlayerID .. "! WorldRankings XP2");
					return;
				end
				uiGenericInstance.ButtonBG:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_TRADITIONAL_DOMINATION_TT").."[NEWLINE]"..tostring(TilesInEmpire(pPlayer)).." / "..tostring(NonWaterTiles()));
			end
			PopulateTradDomInstance(uiGenericInstance, theData.teamData.PlayerData[1], victoryType, true);
		end
	end

	RealizeGenericStackSize();
end

function PopulateTradDomTeamInstance(instance:table, teamData:table, victoryType:string)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("GenericInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateTradDomInstance(instance.PlayerStackIM:GetInstance(), playerData, victoryType, true);
	end

	local requirementSetID:number = Game.GetVictoryRequirements(teamData.TeamID, victoryType);
	if requirementSetID ~= nil and requirementSetID ~= -1 then
		local detailsText:string = tostring(Check_Progress_DominationVictory(teamData.TeamID));
		local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
		for _, requirementID in ipairs(innerRequirements) do

			if detailsText ~= "" then
				detailsText = detailsText .. "[NEWLINE]";
			end

			local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
			local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

			if requirementText ~= nil then
				detailsText = detailsText .. requirementText;
				local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
				if playerData ~= nil then
					civIconClass:SetLeaderTooltip(playerData.PlayerID, requirementText);
				end
			else
				local requirementState:string = GameEffects.GetRequirementState(requirementID);
				local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
				if requirementState == "Met" or requirementState == "AlwaysMet" then
					detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
				else
					detailsText = detailsText .. "[ICON_Bolt]";
				end
				detailsText = detailsText .. requirementDetails.ID;
			end
			instance.Details:SetText(detailsText);
		end
	else
		instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonFrame:SetSizeY(itemSize);
end

function PopulateTradDomInstance(instance:table, playerData:table, victoryType:string, showTeamDetails:boolean )
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);
	
	if showTeamDetails then
		local requirementSetID:number = Game.GetVictoryRequirements(Players[playerData.PlayerID]:GetTeam(), victoryType);
		if requirementSetID ~= nil and requirementSetID ~= -1 then

			local detailsText:string = tostring(Check_Progress_DominationVictory(Players[playerData.PlayerID]:GetTeam(),playerData.PlayerID));
			local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
			if innerRequirements ~= nil then
				for _, requirementID in ipairs(innerRequirements) do

					if detailsText ~= "" then
						detailsText = detailsText .. " ";
					end
					local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
					local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);
					if requirementText ~= nil then
						detailsText = detailsText .. requirementText;
						local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
						civIconClass:SetLeaderTooltip(playerData.PlayerID, detailsText, requirementText);
					end
				end
			end
			instance.Details:SetText(detailsText);
		else
			instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
		end
	else
		instance.Details:SetText("");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonBG:SetSizeY(itemSize);
end



function GetAliveMajorTeamIDs()
	local ti = 1;
	local result = {};
	local duplicate_team = {};
	for i,v in ipairs(PlayerManager.GetAliveMajors()) do
		local teamId = v:GetTeam();
		if(duplicate_team[teamId] == nil) then
			duplicate_team[teamId] = true;
			result[ti] = teamId;
			ti = ti + 1;
		end
	end

	return result;
end

function Check_Progress_DominationVictory(requested_teamID,requested_playerID)

	local teamGenericScore = 0;
			-- PlayerData
			local playerCount:number = 0;
				

			for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
					if Players[playerID]:GetTeam() == requested_teamID then
						local pPlayer:table = Players[playerID];
						local genericScore = 0
						local land = 0
						for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do
							local pPlot = Map.GetPlotByIndex(iPlotIndex)
							if (pPlot:IsWater() == false) then
								land = land + 1;
								if (pPlot:GetOwner() == playerID) then
									genericScore = genericScore + 1;
								end
							end
						end
						if land ~= 0 then
							genericScore = genericScore / land
							genericScore = math.floor(genericScore * 1000) / 10
							else
							genericScore = 0
						end
						teamGenericScore = teamGenericScore + genericScore
						playerCount = playerCount + 1;
						if requested_playerID ~= nil then
							if playerID == requested_playerID then
								return genericScore
							end
						end
					end
			end

	
	return teamGenericScore
	
	

end

function TilesInEmpire(pPlayer)
	if pPlayer:GetID() == nil then
		return 0
	end
	local land_in_empire = 0
	for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		if (pPlot:IsWater() == false) then
			if (pPlot:GetOwner() == pPlayer:GetID()) then
				land_in_empire = land_in_empire + 1;
			end
		end
	end	
	return land_in_empire
end

function NonWaterTiles()
	local dry_land = 0
	for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		if (pPlot:IsWater() == false) then
			dry_land  = dry_land  + 1;
		end
	end	
	return dry_land 
end
