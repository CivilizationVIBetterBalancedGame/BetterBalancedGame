-- JFD_MacedonOlympias_Functions
-- Author: JFD
-- DateCreated: 4/14/2017 12:16:59 AM
--==========================================================================================================================
-- INCLUDES
--==========================================================================================================================
include("Civ6Common.lua")
--==========================================================================================================================
-- UTILITY FUNCTIONS
--==========================================================================================================================
-- UTILS
----------------------------------------------------------------------------------------------------------------------------
--g_CivilizationTraits_Table
local g_CivilizationTraits_Table = {}		 
local g_CivilizationTraits_Count = 1	 
for _, row in ipairs(DB.Query("SELECT * FROM CivilizationTraits")) do 
	g_CivilizationTraits_Table[g_CivilizationTraits_Count] = row
	g_CivilizationTraits_Count = g_CivilizationTraits_Count + 1
end

--g_LeaderTraits_Table
local g_LeaderTraits_Table = {}		 
local g_LeaderTraits_Count = 1	 
for _, row in ipairs(DB.Query("SELECT * FROM LeaderTraits")) do 
	g_LeaderTraits_Table[g_LeaderTraits_Count] = row
	g_LeaderTraits_Count = g_LeaderTraits_Count + 1
end

--Game_GetPlayersWithTrait
function Game_GetPlayersWithTrait(traitType)
	local playerTraits = {}
	for _, playerID in ipairs(PlayerManager.GetWasEverAliveIDs()) do
		local leaderType = PlayerConfigurations[playerID]:GetLeaderTypeName()
		--g_LeaderTraits_Table
		local leaderTraitsTable = g_LeaderTraits_Table
		local numLeaderTraits = #leaderTraitsTable
		for index = 1, numLeaderTraits do
			local row = leaderTraitsTable[index]
			if (row.LeaderType == leaderType and row.TraitType == traitType) then 
				playerTraits[playerID] = true
			end
		end
		if (not playerTraits[playerID]) then
			local civType = PlayerConfigurations[playerID]:GetCivilizationTypeName()
			--g_CivilizationTraits_Table
			local civTraitsTable = g_CivilizationTraits_Table
			local numCivTraits = #civTraitsTable
			for index = 1, numCivTraits do
				local row = civTraitsTable[index]
				if (row.CivilizationType == civType and row.TraitType == traitType) then 
					playerTraits[playerID] = true
				end
			end
		end
	end
		
	return playerTraits
end
----------------------------------------------------------------------------------------------------------------------------
--Player_IsLocal
local localPlayerID = Game.GetLocalPlayer()
function Player_IsLocalPlayer(playerID)
	local player = Players[playerID]
	if (playerID == localPlayerID and player:IsHuman() and player:IsTurnActive()) then
		return true
	else
		return false
	end
end
--==========================================================================================================================
-- CORE FUNCTIONS
--==========================================================================================================================
-- GLOBALS
----------------------------------------------------------------------------------------------------------------------------
local player_HasTrait = Game_GetPlayersWithTrait("TRAIT_LEADER_JFD_CABEIRI_MYSTERIES") 
----------------------------------------------------------------------------------------------------------------------------
--JFD_MacedonOlympias_OnPlayerGaveInfluenceToken
local unitGreatPersonClassGeneralID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_GENERAL"].Index	  
local unitGreatPersonClassProphetID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_PROPHET"].Index	 
local unitGreatPersonClassTheologian = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_JFD_THEOLOGIAN"] 
local unitGreatPersonClassTheologianID = nil
if unitGreatPersonClassTheologian then
	unitGreatPersonClassTheologianID = unitGreatPersonClassTheologian.Index	
end
function JFD_MacedonOlympias_OnPlayerGaveInfluenceToken(playerID, otherPlayerID, numEnvoys)
	local player = Players[playerID]
	local playerConfig = PlayerConfigurations[playerID]
	local leaderType = playerConfig:GetLeaderTypeName()
	
	--CABEIRI MYSTERIES
	if (not player_HasTrait[playerID]) then return end

	local eraID = player:GetEras():GetEra()+1
	local numGGP = (5*numEnvoys)
	local numGPP = (5*numEnvoys)
	local otherLeaderType = PlayerConfigurations[otherPlayerID]:GetLeaderTypeName()
	local otherLeaderInfo = GameInfo.Leaders[otherLeaderType]
	if (otherLeaderType == "LEADER_MINOR_CIV_RELIGIOUS" 
	or otherLeaderInfo.InheritFrom == "LEADER_MINOR_CIV_RELIGIOUS"
	or otherLeaderInfo.InheritFrom == "LEADER_MINOR_CIV_MILITARISTIC" 
	or otherLeaderType == "LEADER_MINOR_CIV_MILITARISTIC") then 
		numGGP = numGGP*2
	end
	player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassGeneralID, numGGP)
	player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassProphetID, numGPP)
	if unitGreatPersonClassTheologian then
		player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassTheologianID, numGPP)
	end
	if Player_IsLocalPlayer(playerID) then
		local capital = player:GetCities():GetCapitalCity()
		Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_FLOAT_FOOD]+{1_Num} Great General Points[ENDCOLOR]", numGGP), capital:GetX(), capital:GetY(), 0)	
		Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_FLOAT_FOOD]+{1_Num} Great Prophet Points[ENDCOLOR]", numGPP), capital:GetX(), capital:GetY(), 0)
		
		Game.AddWorldViewText(ReportingStatusTypes.DEFAULT, Locale.Lookup("LOC_TRAIT_LEADER_JFD_CABEIRI_MYSTERIES_POINTS_NOTIFICATION", numGGP, numGPP), -1, -1, -1)
	end
end
GameEvents.OnPlayerGaveInfluenceToken.Add(JFD_MacedonOlympias_OnPlayerGaveInfluenceToken);
----------------------------------------------------------------------------------------------------------------------------
--JFD_MacedonOlympias_PantheonFounded
function JFD_MacedonOlympias_PantheonFounded(playerID)
	 local player = Players[playerID]
	local playerConfig = PlayerConfigurations[playerID]
	local leaderType = playerConfig:GetLeaderTypeName()

	--CABEIRI MYSTERIES
	if (not player_HasTrait[playerID]) then return end

	local numEnvoys = 1
	player:GetInfluence():ChangeTokensToGive(numEnvoys)
	if Player_IsLocalPlayer(playerID) then
		local capital = player:GetCities():GetCapitalCity()
		Game.AddWorldViewText(playerID, Locale.Lookup("+{1_Num} [ICON_ENVOY] Envoy"), capital:GetX(), capital:GetY(), 0)	

		Game.AddWorldViewText(ReportingStatusTypes.DEFAULT, Locale.Lookup("LOC_TRAIT_LEADER_JFD_CABEIRI_MYSTERIES_ENVOY_NOTIFICATION", numEnvoys), -1, -1, -1)
	end
end
Events.PantheonFounded.Add(JFD_MacedonOlympias_PantheonFounded);
--==========================================================================================================================
--==========================================================================================================================

