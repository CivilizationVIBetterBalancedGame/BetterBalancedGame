------------------------------------------------------------------------------
--	FILE:	 bbg_script.lua
--	AUTHOR:  D. / Jack The Narrator
--	PURPOSE: Gameplay script - Centralises all the calls for BBG
------------------------------------------------------------------------------

-- 4.00
-- Mechanics:
-- Condemn now does 100 dmg (affected by Religious Strength) to religious units
-- Condemn mechanics now also reduce loyalty (-15) in your nearby cities (6 range) if they have the majority religion of the condemned units
-- Remove Heresy lower loyalty by -20 in cities not with a majority religion different from the inquisitor
-- All Inquisitor characteristics reverted to base game
-- Moksha religious strength reverted to base game
-- Itenirant preacher reverted to base game
-- Policies:
-- Lime card reverted base game but still never obselete
-- 3 siege cards at Military Tradition, Medieval Faires and Scorched Earth can boost Siege Production
-- Fixed the bug on the Naval Cards with UU
-- Civ/Leaders:
-- Mother Russia trait no longer give faith on tundra, but +1 passive. Border expansion reverted to base game
-- Dynastic Cycle trait (China) now only grant +1f +1p per wonder
-- Ethiopia's trait now only grant +1f on improved resources
-- Toqui trait (Mapuche) no longer applied to attack from the city's walls
-- Catherine the magnificient project is now moved to Mediaval Faires
-- Catherine Black Queen +1 visibility moved to Political Philosophy
-- Dromon reverted to base game
-- Quadriemes range reverted to 1
-- Georgia faith reverted to 4
-- Crusader reverted to +5


--include "bbg_stateutils"
--include "bbg_unitcommands"

include("SupportFunctions");
-- ===========================================================================
--	Constants
-- ===========================================================================
local iReligion_ScientificDecay = 0;
local iReligion_DecayTech = GameInfo.Technologies["TECH_SCIENTIFIC_THEORY"].Index

local iReligion_ByzantiumRange = 90; -- In tiles covered, 90 tiles covered = 5 tiles radius 
local iReligion_ByzantiumMultiplier = 5; -- multipler X unit base combat strength

local iTrait_GilgameshPillageRange = 6; -- In Radius 6 anything less than 6 excluding 6
local iTrait_GilgameshXPRange = 6; -- In Radius 6 anything less than 6 excluding 6

local iDomination_level = 0.60;

local NO_TEAM :number = -1;
local NO_PLAYER :number = -1;
local NO_PLOT :number = -1;
local NO_UNIT :number = -1;
local NO_DISTRICT :number = -1;
local NO_IMPROVEMENT :number = -1;
local NO_BUILDING :number = -1;

-- ===========================================================================
--	Function
-- ===========================================================================

function OnGameTurnStarted( turn:number )
	print ("BBG TURN STARTING: " .. turn);
	Check_DominationVictory()
	Check_Barbarians()
end

function OnCombatOccurred(attackerPlayerID :number, attackerUnitID :number, defenderPlayerID :number, defenderUnitID :number, attackerDistrictID :number, defenderDistrictID :number)
	if(attackerPlayerID == NO_PLAYER 
		or defenderPlayerID == NO_PLAYER) then
		return;
	end

	local pAttackerPlayer = Players[attackerPlayerID];
	local pAttackerReligion = pAttackerPlayer:GetReligion()
	local pAttackerLeader = PlayerConfigurations[attackerPlayerID]:GetLeaderTypeName()
	local pDefenderPlayer = Players[defenderPlayerID];
	local pAttackingUnit :object = attackerUnitID ~= NO_UNIT and pAttackerPlayer:GetUnits():FindID(attackerUnitID) or nil;
	local pDefendingUnit :object = defenderUnitID ~= NO_UNIT and pDefenderPlayer:GetUnits():FindID(defenderUnitID) or nil;
	local pAttackingDistrict :object = attackerDistrictID ~= NO_DISTRICT and pAttackerPlayer:GetDistricts():FindID(attackerDistrictID) or nil;
	local pDefendingDistrict :object = defenderDistrictID ~= NO_DISTRICT and pDefenderPlayer:GetDistricts():FindID(defenderDistrictID) or nil;
	
	-- Attacker died to defender.
	if(pAttackingUnit ~= nil and pDefendingUnit ~= nil and (pDefendingUnit:IsDead() or pDefendingUnit:IsDelayedDeath())) then
		if pAttackerLeader == "LEADER_BASIL" then
			local x = pAttackingUnit:GetX()
			local y = pAttackingUnit:GetY()
			local power = pDefendingUnit:GetCombat()
			local religionType = pAttackerReligion:GetReligionTypeCreated()
			if x ~= nil and y ~= nil and power ~= nil and religionType ~= nil and religionType ~= -1 then
				ApplyByzantiumTrait(x,y,power,religionType,attackerPlayerID)
			end
		end
	end
	
	-- Gilga XP Sharing, Gilga is not attacker or defender
	local pDiplomacyAttacker:table = pAttackerPlayer:GetDiplomacy();
	local pDiplomacyDefender:table = pDefenderPlayer:GetDiplomacy();
		
	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local pCheckedPlayer = Players[iPlayerID]
		if iPlayerID ~= attackerUnitID and iPlayerID ~= defenderPlayerID then
			if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
				-- Attacker is allied with Gilgamesh
				if pDiplomacyAttacker:HasAllied(iPlayerID) == true and pAttackingUnit ~= nil then
					local plot = Map.GetPlot(pAttackingUnit:GetX(), pAttackingUnit:GetY())
					if plot ~= nil then
					local iPlotIndex = plot:GetIndex()
					-- Is Gilga also at war with Defender ?
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(defenderPlayerID) == true) then
					
					-- does Gilgamesh has one his unit nearby ?
					local playerGilgaUnits;
					playerGilgaUnits = pCheckedPlayer:GetUnits();	
					for k, unit in playerGilgaUnits:Members() do
						local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
						local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
						local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
						print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
						if distance_check ~= nil and distance_check > -1 then
							if distance_check < iTrait_GilgameshXPRange then
								ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,false)
							end
						end
					end	
					end
					end
				end
				
				-- Defender is allied with Gilgamesh
				if pDiplomacyDefender:HasAllied(iPlayerID) == true and pDefendingUnit ~= nil then
					local plot = Map.GetPlot(pDefendingUnit:GetX(), pDefendingUnit:GetY())
					if plot ~= nil then
					local iPlotIndex = plot:GetIndex()
					-- Is Gilga also at war with Defender ?
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(attackerPlayerID) == true) then
					
					-- does Gilgamesh has one his unit nearby ?
					local playerGilgaUnits;
					playerGilgaUnits = pCheckedPlayer:GetUnits();	
					for k, unit in playerGilgaUnits:Members() do
						local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
						local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
						local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
						print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
						if distance_check ~= nil and distance_check > -1 then
							if distance_check < iTrait_GilgameshXPRange then
								ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,false)
							end
						end
					end	
					end
					end
				end				
			end
		end
	end	

	-- Gilga XP Sharing, Gilga is attacker or defender
	if PlayerConfigurations[attackerPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
		for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			local pCheckedPlayer = Players[iPlayerID]
			if iPlayerID ~= attackerPlayerID and iPlayerID ~= defenderPlayerID then
				if pDiplomacyAttacker:HasAllied(iPlayerID) == true and pAttackingUnit ~= nil then
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(defenderPlayerID) == true) then
						local plot = Map.GetPlot(pAttackingUnit:GetX(), pAttackingUnit:GetY())
						if plot ~= nil then
						local iPlotIndex = plot:GetIndex()
					-- has the ally some unit nearby
						local playerGilgaUnits;
						playerGilgaUnits = pCheckedPlayer:GetUnits();	
						for k, unit in playerGilgaUnits:Members() do
							local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
							local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
							local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
							print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
							if distance_check ~= nil and distance_check > -1 then
								if distance_check < iTrait_GilgameshXPRange then
									ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,true)
								end
							end
						end	
						end
					end
				end
			end
		end
	end
	
	if PlayerConfigurations[defenderPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
		for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			local pCheckedPlayer = Players[iPlayerID]
			if iPlayerID ~= attackerPlayerID and iPlayerID ~= defenderPlayerID then
				if pDiplomacyDefender:HasAllied(iPlayerID) == true and pDefendingUnit ~= nil then
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(attackerPlayerID) == true) then
						local plot = Map.GetPlot(pDefendingUnit:GetX(), pDefendingUnit:GetY())
						if plot ~= nil then
						local iPlotIndex = plot:GetIndex()
					-- has the ally some unit nearby
						local playerGilgaUnits;
						playerGilgaUnits = pCheckedPlayer:GetUnits();	
						for k, unit in playerGilgaUnits:Members() do
							local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
							local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
							local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
							print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
							if distance_check ~= nil and distance_check > -1 then
								if distance_check < iTrait_GilgameshXPRange then
									ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,true)
								end
							end
						end
						end		
					end
				end
			end
		end
	end

end

function OnPillage(iUnitPlayerID :number, iUnitID :number, eImprovement :number, eBuilding :number, eDistrict :number, iPlotIndex :number)
	print("OnPillage",iUnitPlayerID)
	if(iUnitPlayerID == NO_PLAYER) then
		return;
	end

	local pUnitPlayer :object = Players[iUnitPlayerID];
	if(pUnitPlayer == nil) then
		return;
	end

	local pUnit :object = UnitManager.GetUnit(iUnitPlayerID, iUnitID);
	if (pUnit == nil) then
		return;
	end
	
	local pUnitPlayerConfig = PlayerConfigurations[iUnitPlayerID]
	if (pUnitPlayerConfig == nil) then
		return;
	end
			
	-- Check if an allied Gilga Unit is next to the plunderer
	local pDiplomacy:table = pUnitPlayer:GetDiplomacy();
	if (pDiplomacy == nil) then
		return;
	end
	
	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local pCheckedPlayer = Players[iPlayerID]
		if pCheckedPlayer ~= nil and iPlayerID ~= iUnitPlayerID then
			if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
				-- plundered is allied with Gilgamesh
				if pDiplomacy:HasAllied(iPlayerID) == true then
					-- Is Gilga also at war ?
					local pPlot = Map.GetPlotByIndex(iPlotIndex)
					local iVictim = pPlot:GetOwner()
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(iVictim) == true) then
					
					-- does Gilgamesh has one his unit nearby ?
					local playerGilgaUnits;
					playerGilgaUnits = pCheckedPlayer:GetUnits();	
					for k, unit in playerGilgaUnits:Members() do
						local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
						local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
						local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
						print("OnPillage - distance_check ",distance_check, UnitManager.GetTypeName(unit))
						if distance_check ~= nil and distance_check > -1 then
							if distance_check < iTrait_GilgameshPillageRange then
								ApplyGilgameshTrait_Pillage(iPlayerID,iUnitID,unitGilgaPlot,eImprovement,eBuilding,eDistrict)
								break
							end
						end
					end	
					end
				end
			end
		end
	end		
end

-- function OnTechBoost(playerID, iTechBoosted)
--	print("OnTechBoost",playerID, iTechBoosted)
--	local pPlayer = Players[playerID]
--	if (pPlayer == nil) or (iTechBoosted == nil) or (iTechBoosted < 0) then
--		return
--	end
--	local pConfig = PlayerConfigurations[playerID]
--
--	if pConfig ~= nil then
--		if pConfig:GetLeaderTypeName() == "LEADER_HAMMURABI" then
--			ApplyHammurabiTrait(playerID, iTechBoosted)
--		end
--	end
--end

-- ===========================================================================
--	Babylon
-- ===========================================================================

function ApplyHammurabiTrait(playerID, iTechBoosted)
	print("ApplyHammurabiTrait",playerID, iTechBoosted)
	local pPlayer = Players[playerID]
	if (pPlayer == nil) or (iTechBoosted == nil) or (iTechBoosted < 0) then
		return
	end	
	
	local TechBoosted = {}
	
	for Tech in GameInfo.Technologies() do
		if Tech.Index == iTechBoosted then
			TechBoosted = Tech
			break
		end
	end
	
	local iSpeedCostMultiplier = GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier
	local pPlayerTechs = pPlayer:GetTechs()
	if pPlayerTechs:CanResearch(iTechBoosted) then
		local team = pPlayer:GetTeam()
		local bNotGainedViaTeam = true
		if (team == nil) or (team == -1) then
			local cost = TechBoosted.Cost
			if cost ~= nil and iSpeedCostMultiplier ~= nil then
				cost = cost * iSpeedCostMultiplier/100
			end
			pPlayerTechs:SetResearchProgress(TechBoosted.Index,cost)
			else
			for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
				local pTeamPlayer = Players[iPlayerID]
				if (pTeamPlayer ~= nil) and (iPlayerID ~= playerID) then
					if (pTeamPlayer:GetTeam() == team) then
						local pTeamTech = pTeamPlayer:GetTechs()
						if (pTeamTech:HasTech(iTechBoosted) == true) then
							bNotGainedViaTeam = false
						end
					end
				end
			end
		end
		
		if (bNotGainedViaTeam == true) then
			local cost = TechBoosted.Cost
			if cost ~= nil and iSpeedCostMultiplier ~= nil then
				cost = cost * iSpeedCostMultiplier/100
			end
			print("ApplyHammurabiTrait bNotGainedViaTeam == true",bNotGainedViaTeam,TechBoosted.Index,cost)
			pPlayerTechs:SetResearchProgress(TechBoosted.Index,cost)
			return
		end
	end	
		
end

-- ===========================================================================
--	Bizantium
-- ===========================================================================
function ApplyByzantiumTrait(x,y,power,religionType,playerID)
	if x == nil or y == nil or power == nil or religionType == nil then
		return
	end
	local religionInfo = GameInfo.Religions[religionType]

	local pPlot = Map.GetPlot(x, y)
	for i = 1, iReligion_ByzantiumRange do
		local plotScanned = GetAdjacentTiles(pPlot, i)
		if plotScanned ~= nil then
			if plotScanned:IsCity() then
				local pCity = Cities.GetCityInPlot(plotScanned)
				local pCityReligion = pCity:GetReligion()
				local impact = power * iReligion_ByzantiumMultiplier
				print("playerID "..tostring(playerID))
				print("playerID "..tostring(religionType))
				print("playerID "..tostring(impact))
				pCityReligion:AddReligiousPressure(playerID, religionType, impact, -1);
				print("Added Religious Pressure",impact,pCity:GetName())
				local message:string  = "+"..tostring(impact)
				if religionInfo ~= nil then
					message = message.." "..tostring("[ICON_Religion]")
					else
					message = message.." [ICON_Religion]"
				end
				Game.AddWorldViewText(0, message, pCity:GetX(), pCity:GetY());
			end
		end
	end
end

-- ===========================================================================
--	Sumer
-- ===========================================================================

function ApplyGilgameshTrait_Pillage(iPlayer,refunit,pPlot,eImprovement,eBuilding,eDistrict)
	local pillageAwards;
	local pillageAmount;
	local pPlayer = Players[iPlayer]
	
	if (pPlayer == nil) then
		return
	end
	
	if eImprovement ~= nil and eImprovement > -1 then
		pillageAwards = GameInfo.Improvements[eImprovement].PlunderType
		pillageAmount = GameInfo.Improvements[eImprovement].PlunderAmount
	end
	if eBuilding ~= nil and eBuilding > -1 then
		pillageAwards = GameInfo.Buildings[eBuilding].PlunderType
		pillageAmount = GameInfo.Buildings[eBuilding].PlunderAmount
	end
	if eDistrict ~= nil and eDistrict > -1 then
		pillageAwards = GameInfo.Districts[eDistrict].PlunderType
		pillageAmount = GameInfo.Districts[eDistrict].PlunderAmount
	end
	
	local playerEra = pPlayer:GetEras();
	
	if playerEra == nil then 
		return; 
	end
	local eraNum = 0
	for era in GameInfo.Eras() do
		if(playerEra:GetEra() == era.Index) then
			eraNum = era.ChronologyIndex
		end
	end
	eraNum = eraNum - 1
	local eraBonus = math.floor(pillageAmount / 3) * tonumber(eraNum)	
	local playerTechs = pPlayer:GetTechs();		
	if playerTechs == nil then 
		return; 
	end
	local techNum = 0
	for tech in GameInfo.Technologies() do
		if(playerTechs:HasTech(tech.Index)) then
			techNum = techNum + 1
		end
	end
	
	local playerCulture = pPlayer:GetCulture();
	if playerCulture == nil then 
		return; 
	end
	local civicNum = 0
	for civic in GameInfo.Civics() do
		if(playerCulture:HasCivic(civic.Index)) then
			civicNum = civicNum + 1
		end
	end
	local researchBonus = math.max(techNum,civicNum,0)
	researchBonus = researchBonus * (math.floor(pillageAmount/10))
	
	local iSpeedCostMultiplier = GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier
	if iSpeedCostMultiplier ~= nil and iSpeedCostMultiplier > -1 then
		pillageAmount = math.floor( (pillageAmount + researchBonus + eraBonus) * iSpeedCostMultiplier /100)
		else
		return
	end

	local message:string  = "+"..tostring(pillageAmount)
	if pillageAwards == "PLUNDER_CULTURE" then
		pPlayer:GetCulture():ChangeCurrentCulturalProgress(pillageAmount)
		message = message.."[ICON_Culture]"
		elseif pillageAwards == "PLUNDER_SCIENCE" then
		pPlayer:GetTechs():ChangeCurrentResearchProgress(pillageAmount)
		message = message.."[ICON_Science]"
		elseif pillageAwards == "PLUNDER_FAITH" then
		pPlayer:GetReligion():ChangeFaithBalance(pillageAmount)		
		message = message.."[ICON_Faith]"
		elseif pillageAwards == "PLUNDER_GOLD" then
		pPlayer:GetTreasury():ChangeGoldBalance(pillageAmount)		
		message = message.."[ICON_Gold]"
		elseif pillageAwards == "PLUNDER_HEAL" then
		pPlayer:GetReligion():ChangeFaithBalance(pillageAmount)	
		message = message.."[ICON_Faith]"
	end

	
	local messageData : table = {
		MessageType = 0;
		MessageText = message;
		PlotX = pPlot:GetX();
		PlotY = pPlot:GetY();
		Visibility = RevealedState.VISIBLE;
	}
	Game.AddWorldViewText(messageData);
end

function ApplyGilgameshTrait_XP(iPlayer,pUnit,pPlot,isGilgaUnit)
	local XPAmount = 2
	local pPlayer = Players[iPlayer]
	
	if (pPlayer == nil) or (pUnit == nil) then
		return
	end
		
	local unitXP = pUnit:GetExperience()
	unitXP:ChangeExperience(XPAmount)

		
	local message:string  = "+"..tostring(XPAmount)
	message = message.."XP"
	
	if isGilgaUnit == false then
		return
	end
	
	local messageData : table = {
		MessageType = 0;
		MessageText = message;
		PlotX = pPlot:GetX();
		PlotY = pPlot:GetY();
		Visibility = RevealedState.VISIBLE;
	}
	--Game.AddWorldViewText(messageData);
end

-- ===========================================================================
--	Religion
-- ===========================================================================

function ApplyScientificTheory(iPlayerID:number)
	-- Remove Religious Pressure in Cities whose religions are not like the main religion
	local pPlayer = Players[iPlayerID]
	local pReligion = pPlayer:GetReligion()
	if pReligion == nil then
		return
	end
	local iMainReligion = pReligion:GetReligionInMajorityOfCities()
	local pPlayerCities = pPlayer:GetCities();
	for i, pCity in pPlayerCities:Members() do
		if pCity ~= nil then
			local pCityReligion = pCity:GetReligion()
			local iCityReligion = pCityReligion:GetMajorityReligion()
			if iCityReligion ~= iMainReligion then
				pCity:GetReligion():AddReligiousPressure(iPlayerID, iCityReligion, iReligion_ScientificDecay, -1);
				print("Reduced Religious Pressure in", pCity:GetName())
			end
		end
	end	
	
end

-- ===========================================================================
--	Domination
-- ===========================================================================

function Check_DominationVictory()
	local teamIDs = GetAliveMajorTeamIDs();
	local hasWon = false
	local victoryTeam = -99
	local iDomination_level = 1
	print("TRADITIONAL_DOMINATION_LEVEL",GameConfiguration.GetValue("VICTORY_TRADITIONAL_DOMINATION"))
	if GameConfiguration.GetValue("VICTORY_TRADITIONAL_DOMINATION") == false or GameConfiguration.GetValue("VICTORY_TRADITIONAL_DOMINATION") == nil then
		return
    else
		if GameConfiguration.GetValue("TRADITIONAL_DOMINATION_LEVEL") ~= nil then
			iDomination_level = GameConfiguration.GetValue("TRADITIONAL_DOMINATION_LEVEL") / 100
		end
	end

	for _, teamID in ipairs(teamIDs) do
		if(teamID ~= nil) then
			--local progress = Game.GetVictoryProgressForTeam(victoryType, teamID);
			local progress = true
			if(progress ~= nil) then

				-- PlayerData
				local playerCount:number = 0;
				local teamGenericScore = 0;

				for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
					if Players[playerID]:GetTeam() == teamID then
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
							else
							genericScore = 0
						end
						teamGenericScore = teamGenericScore + genericScore
						if teamGenericScore > iDomination_level then
							hasWon = true
							victoryTeam = teamID
						end
						playerCount = playerCount + 1;
					end
				end
			end
		end
	end
	
	if hasWon == false or victoryTeam == -99 then
		return
	end

	for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if Players[playerID]:GetTeam() == victoryTeam then
			local pPlayer:table = Players[playerID];
			local pCapCity = pPlayer:GetCities():GetCapitalCity()
			if pCapCity ~= nil then
				-- Add Victory Flag
				print("Add Victory Flag",playerID)
				local flag = GameInfo.Buildings["BUILDING_TRADITIONAL_DOMINATION_VICTORY_FLAG"]
				if pCapCity:GetBuildings():HasBuilding(flag.Index) == false then
					pCapCity:GetBuildQueue():CreateBuilding(flag.Index)
				end
			end
		end
	end	

end

-- ===========================================================================
--	Barbarians
-- ===========================================================================
local iBarbs_Original_Weight = 0.50;
local iBarbs_Spawn_Chance = 0.75;
local iBarbs_Naval_Weight = 0.30;
local iBarbs_Minimum_Horse_Turn = 15;

function Check_Barbarians()
	-- GameInfo.BarbarianTribes[0].TribeType
	local BarbsSetting = GameConfiguration.GetValue("BARBS_SETTING")
	if BarbsSetting == nil or BarbsSetting == 0 or  BarbsSetting == -1 then
		return
	end
	
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	if currentTurn == startTurn + 1 then
		print("Original Barb Placement")
		PlaceOriginalBarbCamps()
		return
		elseif currentTurn < startTurn + 3 then
		return
	end
	
	
	local currentCamps = CountBarbCamps()
	local maxCamps = PlayerManager.GetAliveMajorsCount()
	for i, playerID in ipairs(PlayerManager.GetAliveIDs()) do
		if Players[playerID] ~= nil then
			if Players[playerID]:IsMajor() then
				local pPlayerConfig:table = PlayerConfigurations[playerID];
				if pPlayerConfig and pPlayerConfig:GetLeaderTypeName() == "LEADER_SPECTATOR" then
					maxCamps = math.max(maxCamps - 1,0)
				end
			end
		end
	end	
	maxCamps = math.floor(maxCamps * 2.25) - 2
	
	if BarbsSetting == 2 then
		maxCamps = maxCamps * 3
	end
	if BarbsSetting == 3 then
		maxCamps = math.max(maxCamps  - 2, 1)
		iBarbs_Spawn_Chance = iBarbs_Spawn_Chance * 0.66
	end
		
	local rng = RandRange(1, 100, "BBG - Check_Barbarians()");
	rng = rng / 100	
		
	if currentCamps < maxCamps and rng < iBarbs_Spawn_Chance then
		print("Total Camp",currentCamps,maxCamps,"Will Add a Barb Camp")
		AddBarbCamps()
		else
		print("Total Camp",currentCamps,maxCamps,"No need to add Camp")
	end
end

function AddBarbCamps()
	print("		AddBarbCamps()")			
	local rng = RandRange(1, 100, "BBG - AddBarbCamps()");
	rng = rng / 100
	local iCount = Map.GetPlotCount();
	local validPlots = {};
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	local BarbsSetting = GameConfiguration.GetValue("BARBS_SETTING")
	local bNaval = true
	if rng < iBarbs_Naval_Weight then
		if BarbsSetting ~= 3 or currentTurn > startTurn + iBarbs_Minimum_Horse_Turn then
		-- Coastal
		-- Any Coastal tiles at least 5 plots away from anyone
		for plotIndex = 0, iCount-1, 1 do
			local pPlot = Map.GetPlotByIndex(plotIndex)
			local bValid = false
			
			-- Check Coastal
			if pPlot:IsCoastalLand() == true and pPlot:IsImpassable() == false and pPlot:IsNaturalWonder() == false and pPlot:IsLake() == false  and pPlot:GetOwner() == -1 then
				bValid = true
			end
			
			if bValid == true then
				local count = 0
				for i = 1, 36 do
					local plotScanned = GetAdjacentTiles(pPlot, i)
					if plotScanned ~= nil then
						if plotScanned:IsWater() == true then
							count = count + 1
						end
						if plotScanned:GetImprovementType() ~= -1 then
							bValid = false
							--print("Barbs: Can't Place Here it: Too close to other Barbs",plotScanned:GetX(),plotScanned:GetY())
							break
						end
					end
				end
				if count < 6 then
					bValid = false
				end
			end
			
			
			-- Check Vision
			if bValid == true then
				for i, playerID in ipairs(PlayerManager.GetAliveIDs()) do
					if playerID < 60 then
						local pVis = PlayerVisibilityManager.GetPlayerVisibility(playerID)
						if pVis ~= nil then
							if pVis:GetState(plotIndex) == RevealedState.VISIBLE then
								bValid = false
								break
							end
						end
					end	
				end
			end
			
			-- Check Buffer
			if bValid == true then
				for i, playerID in ipairs(PlayerManager.GetAliveIDs()) do
					if Players[playerID] ~= nil then
						if Players[playerID]:IsMajor() then
							local pPlayerConfig:table = PlayerConfigurations[playerID];
							if pPlayerConfig and pPlayerConfig:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
								local playerCities = Players[playerID]:GetCities()
								for j, city in playerCities:Members() do
									if Map.GetPlotDistance(pPlot:GetX(),pPlot:GetY(),city:GetX(),city:GetY()) < 5 then
										bValid = false
										break
									end
								end
								if bValid == false then
									break
								end
							end
						end
					end
				end	
			end	

			-- Insert 
			if bValid == true then
				--print("Barbs Add: Valid Plot!",pPlot:GetX(), pPlot:GetY())
				local tmp = {plot = pPlot, id = -1, team = -1} 
				table.insert(validPlots, tmp)
			end		
		end
		
		end
		
		
		else
		bNaval = false
		-- Non-Coastal
		for plotIndex = 0, iCount-1, 1 do
			local pPlot = Map.GetPlotByIndex(plotIndex)
			local bValid = false
			local bValidTerrain = true
			local bHorse = false
			local iTargetID = -1
			-- First Check
			if pPlot:IsWater() or pPlot:IsImpassable() or pPlot:IsNaturalWonder() or pPlot:GetOwner() ~= -1 then
				bValidTerrain = false
			end
			
			-- Check Vision
			if bValidTerrain == true then
				for i, playerID in ipairs(PlayerManager.GetAliveIDs()) do
					if playerID < 60 then
						local pVis = PlayerVisibilityManager.GetPlayerVisibility(playerID)
						if pVis ~= nil then
							if pVis:GetState(plotIndex) == RevealedState.VISIBLE then
								bValidTerrain = false
								break
							end
						end
					end	
				end
			end
						
			-- Assign Players
			if bValidTerrain == true then
				for i, playerID in ipairs(PlayerManager.GetAliveIDs()) do
					if Players[playerID] ~= nil then
						if Players[playerID]:IsMajor() then
							local pPlayerConfig:table = PlayerConfigurations[playerID];
							if pPlayerConfig and pPlayerConfig:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
								local playerCities = Players[playerID]:GetCities()
								for j, city in playerCities:Members() do
									if Map.GetPlotDistance(pPlot:GetX(),pPlot:GetY(),city:GetX(),city:GetY()) == 7 then
										bValid = true
										iTargetID = playerID
										break
									end
								end
								if bValid == true then
									break
								end
							end
						end
					end
				end	
			end
			
			-- Check no other barbs are too close
			if bValid == true then
				for i = 1, 36 do
					local plotScanned = GetAdjacentTiles(pPlot, i)
					if plotScanned ~= nil then
						if plotScanned:GetImprovementType() ~= -1 then
							bValid = false
							--print("Barbs: Can't Place Here it: Too close to other Barbs",plotScanned:GetX(),plotScanned:GetY())
							break
						end
					end
				end
			end
			
			
			
			--Now Check there is no Horses nearby do it would not turn as a Horse camp
		
			if bValid == true and currentTurn > startTurn + iBarbs_Minimum_Horse_Turn then
				for i = 1, 36 do
					local plotScanned = GetAdjacentTiles(pPlot, i)
					if plotScanned ~= nil then
						if plotScanned:GetResourceType() == 42 then
							bHorse = true
							--print("Barbs: Can't Place Here it Would Turn into Horse Camp",plotScanned:GetResourceType(),plotScanned:GetX(),plotScanned:GetY())
							break
						end
					end
				end
			end
			
			-- Insert 
			if bValid == true then
				--print("Barbs: Valid Plot!",pPlot:GetX(), pPlot:GetY())
				local tmp = {plot = pPlot, id = iTargetID, team = Players[iTargetID]:GetTeam(), horse = bHorse} 
				table.insert(validPlots, tmp)
			end
		end	
	
	end
	
	local shuffledPlots = GetShuffledCopyOfTable(validPlots)
	
	-- Place on the map: Naval
	if shuffledPlots ~= nil and bNaval == true then
		for j, plotTable in ipairs(shuffledPlots) do
			if plotTable.id == -1 then
				local pPlot = plotTable.plot
				-- PLACE TRIBE NAVAL IF UNTARGETTED
				PlaceBarbarianCamp(pPlot:GetX(), pPlot:GetY(),-1,0)
				return
			end	
		end
	end
	
	-- Place on the map: Melee
	-- Balance
	local BarbBalance = {}
	for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do 
		local pPlayer = Players[playerID]
		if pPlayer ~= nil then
			if Game.GetProperty("BARB_"..playerID.."_"..pPlayer:GetTeam()) ~= nil then
				local tmp = { id = playerID, team = pPlayer:GetTeam(), team_score = 0, score = Game.GetProperty("BARB_"..playerID.."_"..pPlayer:GetTeam())}
				table.insert(BarbBalance, tmp)
			end		
		end
	end
	
	-- Aggregate score & sort

	for i = -1, 60, 1 do
		local team_score_tmp = 0
		for j, score in ipairs(BarbBalance) do 
			if score.team == i then
				team_score_tmp = score.score + team_score_tmp
			end
		end
		for j, score in ipairs(BarbBalance) do 
			if score.team == i then
				score.team_score = team_score_tmp
			end
		end	
	end
		
	table.sort (BarbBalance, function(a, b) return (((a.team_score == b.team_score) and (a.score < b.score)) or ((a.team_score < b.team_score))); end)
	for i, score in ipairs(BarbBalance) do 
		print("BARB: TEAM",score.team,score.team_score,"ID",score.id,score.score,PlayerConfigurations[score.id]:GetLeaderTypeName())
	end
	-- Place going for the least impacted player so far:
	for i, score in ipairs(BarbBalance) do 
		for j, plotTable in ipairs(shuffledPlots) do
			if plotTable.id == score.id then
				local pPlot = plotTable.plot
				if plotTable.horse == true then
					PlaceBarbarianCamp(pPlot:GetX(), pPlot:GetY(),score.id,1)
					return
					else
					PlaceBarbarianCamp(pPlot:GetX(), pPlot:GetY(),score.id,2)
					return
				end
			end	
		end
	end	
end

function CountBarbCamps()
	local count = 0
	local iCount = Map.GetPlotCount();
	for plotIndex = 0, iCount-1, 1 do
		local pPlot = Map.GetPlotByIndex(plotIndex)
		if pPlot:GetImprovementType() == 0 then
			count = count + 1
		end
	end
	return count
end

function PlaceOriginalBarbCamps()
	
	local BarbsSetting = GameConfiguration.GetValue("BARBS_SETTING")
	local base = PlayerManager.GetAliveMajorsCount()
	base = tonumber(base)
	local placed_camps = 0
	print("PlaceOriginalBarbCamps()",base,BarbsSetting)
	if base > 0 then
		local iCount = Map.GetPlotCount();
		local validPlots = {};
		-- Scan all the Map
		for plotIndex = 0, iCount-1, 1 do
			local pPlot = Map.GetPlotByIndex(plotIndex)
			local bValid = false
			local bValidTerrain = true
			local iTargetID = -1
			-- First Check
			if pPlot:IsWater() or pPlot:IsImpassable() or pPlot:IsNaturalWonder() or pPlot:GetOwner() ~= -1 then
				bValidTerrain = false
			end
			
			
			-- Assign Players
			if bValidTerrain == true then
				for i, playerID in ipairs(PlayerManager.GetAliveIDs()) do
					if Players[playerID] ~= nil then
						if Players[playerID]:IsMajor() then
							local pPlayerConfig:table = PlayerConfigurations[playerID];
							if pPlayerConfig and pPlayerConfig:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
								local sPlot = Players[playerID]:GetStartingPlot()
								if Map.GetPlotDistance(pPlot:GetX(),pPlot:GetY(),sPlot:GetX(),sPlot:GetY()) == 7 then
									bValid = true
									iTargetID = playerID
									break
								end
							end
						end
					end
				end	
			end
			-- We have a plot within 7 tiles of a spawn check it is not near than 7 of another Major
			if bValid == true then
				for i, playerID in ipairs(PlayerManager.GetAliveIDs()) do
					if Players[playerID] ~= nil then
						local pPlayerConfig:table = PlayerConfigurations[playerID];
						if pPlayerConfig and pPlayerConfig:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
							local sPlot = Players[playerID]:GetStartingPlot()
							if sPlot ~= nil then
								if (Map.GetPlotDistance(pPlot:GetX(),pPlot:GetY(),sPlot:GetX(),sPlot:GetY()) < 7 and Players[playerID]:IsMajor()) or Map.GetPlotDistance(pPlot:GetX(),pPlot:GetY(),sPlot:GetX(),sPlot:GetY()) < 4 then
									bValid = false
									--print("Barbs: Can't Place Here it Would Be Next To Another Player",PlayerConfigurations[playerID]:GetLeaderTypeName(),sPlot:GetX(),sPlot:GetY())
									break
								end
							end
						end
					end
				end	
			end
			
			-- Now Check there is no Horses nearby do it would not turn as a Horse camp
		
			--if bValid == true then
			--	for i = 1, 36 do
			--		local plotScanned = GetAdjacentTiles(pPlot, i)
			--		if plotScanned ~= nil then
			--			if plotScanned:GetResourceType() == 42 then
			--				bValid = false
			--				--print("Barbs: Can't Place Here it Would Turn into Horse Camp",plotScanned:GetResourceType(),plotScanned:GetX(),plotScanned:GetY())
			--				break
			--			end
			--		end
			--	end
			--end
			
			-- Insert 
			if bValid == true then
				--print("Barbs: Valid Plot!",pPlot:GetX(), pPlot:GetY(),id)
				local tmp = {plot = pPlot, id = iTargetID, team = Players[iTargetID]:GetTeam()} 
				table.insert(validPlots, tmp)
			end
		end
		
		-- Place on the map
		if validPlots ~= nil then
			for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
				if Players[playerID] ~= nil then
					if (Players[playerID]:IsMajor()) and PlayerConfigurations[playerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
							local rng = RandRange(1, 100, "BBG - Place Original Camp()");
							rng = rng / 100
						--print("Barbs: Valid Plot!",playerID,rng)
						if rng < iBarbs_Original_Weight then
							for j, plotTable in ipairs(validPlots) do
								--print("Barbs: Valid Plot!",j,plotTable.id)
								if plotTable.id == playerID then
									local pPlot = plotTable.plot
									-- Only place Improvement
									PlaceBarbarianCamp(pPlot:GetX(), pPlot:GetY(),playerID,2)
									break
								end
							end
						end
					end
				end	
			end	
		end
		
	end
end



function PlaceBarbarianCamp(x, y, playerID, tribeType)
	local BARBARIAN_ID = 62;
	local BARB_CAMP_ID = 0;
	local targetId = playerID;
	local targetTeam = -1;
	if Players[targetId] ~= nil then
		targetTeam = Players[targetId]:GetTeam();
	end
	local tribeScore = 1
	if tribeType == 1 then
		tribeScore = 2
	end
	-- Check XML for any and all Improvements flagged as "Barb Camps" and distribute them.
	local pPlot = Map.GetPlot(x,y);	
	--ImprovementBuilder.SetImprovementType(pPlot, BARB_CAMP_ID, BARBARIAN_ID);

	for i = 0, 90 do
		local plotScanned = GetAdjacentTiles(pPlot, i)
		if plotScanned ~= nil then
			if plotScanned:GetImprovementType() == BARB_CAMP_ID then
				print("Already has a Barbarian Camp Nearby")
				return
			end
		end
	end

	local pBarbManager = Game.GetBarbarianManager();
	
	

   ImprovementBuilder.SetImprovementType(pPlot, -1, NO_PLAYER);   


   local iTribeNumber = pBarbManager:CreateTribeOfType(tribeType, pPlot:GetIndex());
	print("Placed Barbarian camp at",x,y,playerID,tribeType)
	if Game.GetProperty("BARB_"..targetId.."_"..targetTeam ) == nil or tonumber(Game.GetProperty("BARB_"..targetId.."_"..targetTeam )) == nil then
		Game.SetProperty("BARB_"..targetId.."_"..targetTeam ,1)
		else
		local num = tonumber(Game.GetProperty("BARB_"..targetId.."_"..targetTeam )) + tribeScore
		Game.SetProperty("BARB_"..targetId.."_"..targetTeam ,num)
	end	
	
end

function InitBarbData()
	for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if Players[playerID] ~= nil then
			if Players[playerID]:IsMajor() and PlayerConfigurations[playerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
				Game.SetProperty("BARB_"..playerID.."_"..Players[playerID]:GetTeam(),0)
			end
		end	
	end	
end



-- ===========================================================================
--	Tools
-- ===========================================================================

function GetAliveMajorTeamIDs()
	print("GetAliveMajorTeamIDs()")
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

function GetShuffledCopyOfTable(incoming_table)
	-- Designed to operate on tables with no gaps. Does not affect original table.
	local len = table.maxn(incoming_table);
	local copy = {};
	local shuffledVersion = {};
	-- Make copy of table.
	for loop = 1, len do
		copy[loop] = incoming_table[loop];
	end
	-- One at a time, choose a random index from Copy to insert in to final table, then remove it from the copy.
	local left_to_do = table.maxn(copy);
	for loop = 1, len do
		local random_index = 1 + TerrainBuilder.GetRandomNumber(left_to_do, "Shuffling table entry - Lua");
		table.insert(shuffledVersion, copy[random_index]);
		table.remove(copy, random_index);
		left_to_do = left_to_do - 1;
	end
	return shuffledVersion
end

function GetAdjacentTiles(plot, index)
	-- This is an extended version of Firaxis, moving like a clockwise snail on the hexagon grids
	local gridWidth, gridHeight = Map.GetGridSize();
	local count = 0;
	local k = 0;
	local adjacentPlot = nil;
	local adjacentPlot2 = nil;
	local adjacentPlot3 = nil;
	local adjacentPlot4 = nil;
	local adjacentPlot5 = nil;


	-- Return Spawn if index < 0
	if(plot ~= nil and index ~= nil) then
		if (index < 0) then
			return plot;
		end

		else

		__Debug("GetAdjacentTiles: Invalid Arguments");
		return nil;
	end

	

	-- Return Starting City Circle if index between #0 to #5 (like Firaxis' GetAdjacentPlot) 
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			if (adjacentPlot ~= nil and index == i) then
				return adjacentPlot
			end
		end
	end

	-- Return Inner City Circle if index between #6 to #17

	count = 5;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot2 = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
		end

		for j = i, i+1 do
			--__Debug(i, j)
			k = j;
			count = count + 1;

			if (k == 6) then
				k = 0;
			end

			if (adjacentPlot2 ~= nil) then
				if(adjacentPlot2:GetX() >= 0 and adjacentPlot2:GetY() < gridHeight) then
					adjacentPlot = Map.GetAdjacentPlot(adjacentPlot2:GetX(), adjacentPlot2:GetY(), k);

					else

					adjacentPlot = nil;
				end
			end
		

			if (adjacentPlot ~=nil) then
				if(index == count) then
					return adjacentPlot
				end
			end

		end
	end

	-- #18 to #35 Outer city circle
	count = 0;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 1;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 2;
			if(index == count) then
				return adjacentPlot2;
			end
		end

	end

	--  #35 #59 These tiles are outside the workable radius of the city
	local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			terrainType = adjacentPlot2:GetTerrainType();
			if (adjacentPlot2 ~=nil) then
				count = 36 + i * 4;
				if(index == count) then
					return adjacentPlot2;
				end
			end

		end

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 1;
					if(index == count) then
						return adjacentPlot2;
					end
				end
			end


		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 2;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
					else
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
				end
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 3;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

	end

	--  > #60 to #90

local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i); --first ring
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i); --2nd ring
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i); --3rd ring
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i); --4th ring
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5;
			if(index == count) then
				return adjacentPlot2; --5th ring
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot5 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
				end
				else
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i +1);
				end
			end
		end


		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 1;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1);
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 2;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 3;
			if(index == count) then
				return adjacentPlot2;
			end

		end
		
		adjacentPlot2 = nil

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0); --5th ring
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1); --5th ring
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 4;
			if(index == count) then
				return adjacentPlot2;
			end

		end

	end

end


-- ===========================================================================
--	Tools
-- ===========================================================================

function GetAliveMajorTeamIDs()
	print("GetAliveMajorTeamIDs()")
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

function GetShuffledCopyOfTable(incoming_table)
	-- Designed to operate on tables with no gaps. Does not affect original table.
	local len = table.maxn(incoming_table);
	local copy = {};
	local shuffledVersion = {};
	-- Make copy of table.
	for loop = 1, len do
		copy[loop] = incoming_table[loop];
	end
	-- One at a time, choose a random index from Copy to insert in to final table, then remove it from the copy.
	local left_to_do = table.maxn(copy);
	for loop = 1, len do
		local random_index = 1 + TerrainBuilder.GetRandomNumber(left_to_do, "Shuffling table entry - Lua");
		table.insert(shuffledVersion, copy[random_index]);
		table.remove(copy, random_index);
		left_to_do = left_to_do - 1;
	end
	return shuffledVersion
end

function GetAdjacentTiles(plot, index)
	-- This is an extended version of Firaxis, moving like a clockwise snail on the hexagon grids
	local gridWidth, gridHeight = Map.GetGridSize();
	local count = 0;
	local k = 0;
	local adjacentPlot = nil;
	local adjacentPlot2 = nil;
	local adjacentPlot3 = nil;
	local adjacentPlot4 = nil;
	local adjacentPlot5 = nil;


	-- Return Spawn if index < 0
	if(plot ~= nil and index ~= nil) then
		if (index < 0) then
			return plot;
		end

		else

		__Debug("GetAdjacentTiles: Invalid Arguments");
		return nil;
	end



	-- Return Starting City Circle if index between #0 to #5 (like Firaxis' GetAdjacentPlot)
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			if (adjacentPlot ~= nil and index == i) then
				return adjacentPlot
			end
		end
	end

	-- Return Inner City Circle if index between #6 to #17

	count = 5;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot2 = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
		end

		for j = i, i+1 do
			--__Debug(i, j)
			k = j;
			count = count + 1;

			if (k == 6) then
				k = 0;
			end

			if (adjacentPlot2 ~= nil) then
				if(adjacentPlot2:GetX() >= 0 and adjacentPlot2:GetY() < gridHeight) then
					adjacentPlot = Map.GetAdjacentPlot(adjacentPlot2:GetX(), adjacentPlot2:GetY(), k);

					else

					adjacentPlot = nil;
				end
			end


			if (adjacentPlot ~=nil) then
				if(index == count) then
					return adjacentPlot
				end
			end

		end
	end

	-- #18 to #35 Outer city circle
	count = 0;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 1;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 2;
			if(index == count) then
				return adjacentPlot2;
			end
		end

	end

	--  #35 #59 These tiles are outside the workable radius of the city
	local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			terrainType = adjacentPlot2:GetTerrainType();
			if (adjacentPlot2 ~=nil) then
				count = 36 + i * 4;
				if(index == count) then
					return adjacentPlot2;
				end
			end

		end

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 1;
					if(index == count) then
						return adjacentPlot2;
					end
				end
			end


		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 2;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
					else
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
				end
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 3;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

	end

	--  > #60 to #90

local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i); --first ring
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i); --2nd ring
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i); --3rd ring
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i); --4th ring
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5;
			if(index == count) then
				return adjacentPlot2; --5th ring
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot5 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
				end
				else
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i +1);
				end
			end
		end


		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 1;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1);
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 2;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 3;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0); --5th ring
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1); --5th ring
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 4;
			if(index == count) then
				return adjacentPlot2;
			end

		end

	end

end





-- ===========================================================================
--	Initialize
-- ===========================================================================

function Initialize()

	print("BBG - Gameplay Script Launched")
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	
	-- turn checked effects:
	GameEvents.OnGameTurnStarted.Add(OnGameTurnStarted);

	-- combat effect:
	GameEvents.OnCombatOccurred.Add(OnCombatOccurred);
	
	-- pillage effect:
	GameEvents.OnPillage.Add(OnPillage)
	
	-- tech boost effect:
	-- Events.TechBoostTriggered.Add(OnTechBoost);
end

Initialize();