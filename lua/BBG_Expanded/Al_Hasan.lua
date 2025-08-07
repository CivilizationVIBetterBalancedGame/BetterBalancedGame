--==========================================================================================================================
-- SUK_LORENZO_COREFUNCTIONS
-- Author: Sukritact
--==========================================================================================================================
print("loaded")
--==========================================================================================================================
-- UTILITY FUNCTIONS
--==========================================================================================================================
	-- Get Players With Trait
	-- Credits to Chrisy for this function
	--------------------------------------------------------------
		function GetPlayersWithTrait(sTrait)
			local tValid = {}
			iLength = 0

			for k, v in pairs(PlayerManager.GetWasEverAliveIDs()) do
				local leaderType = PlayerConfigurations[v]:GetLeaderTypeName()
				for trait in GameInfo.LeaderTraits() do
					if trait.LeaderType == leaderType and trait.TraitType == sTrait then
						tValid[v] = Players[v]
						iLength = iLength + 1
					end
				end
				if not tValid[v] then
					local civType = PlayerConfigurations[v]:GetCivilizationTypeName()
					for trait in GameInfo.CivilizationTraits() do
						if trait.CivilizationType == civType and trait.TraitType == sTrait then
							tValid[v] = Players[v]
							iLength = iLength + 1
						end
					end
				end
			end
			return tValid, iLength
		end
	--------------------------------------------------------------
	-- Iterate Plots in Range
	--------------------------------------------------------------
		function IterPlotsInRange(iX, iY, iRange, bExcludeCenter)
			local tTempTable = {}

			for dx = (iRange * -1), iRange do
				for dy = (iRange * -1), iRange do
					if bExcludeCenter and (iX == dx) and (iY == dy) then
						-- do nothing
					else
						local pOtherPlot = Map.GetPlotXYWithRangeCheck(iX, iY, dx, dy, iRange);
						if pOtherPlot then
							table.insert(tTempTable, pOtherPlot)
						end
					end
				end
			end

			local iNum = 0
			local iMax = #tTempTable
			return function ()
				iNum = iNum + 1
				if iNum <= iMax then return tTempTable[iNum] end
			end
		end
--==========================================================================================================================
-- Fishing Boats built by a Jahazi yield +1 Gold, +1 Culture.
--==========================================================================================================================
	local 	sJahaziTrait		= "TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI"
	local 	tJahaziPlayers,
			iNumJahaziPlayers	= GetPlayersWithTrait(sJahaziTrait)

	local iBuildImprovement	= GameInfo.UnitOperations.UNITOPERATION_BUILD_IMPROVEMENT.Hash
	local iFishingBoat		= GameInfo.Improvements.IMPROVEMENT_FISHING_BOATS.Index
	local sJahaziAbiltiy	= "ABILITY_SUK_JAHAZI"

	local sJahazi_Key		= "SUK_JAHAZI"

	function OnUnitOperationStarted(iPlayer, iUnit, iOperation, iData)
		if not tJahaziPlayers[iPlayer] then return end

		if iOperation ~= iBuildImprovement then return end
		if iData ~= iFishingBoat then return end

		local pUnit = UnitManager.GetUnit(iPlayer, iUnit)
		local iPlotIndex = pUnit:GetProperty(sJahazi_Key)

		if (not iPlotIndex) or (iPlotIndex < 0) then return end
		local pPlot = Map.GetPlotByIndex(iPlotIndex)

		pPlot:SetProperty(sJahazi_Key, 1)
	end
	---------------------------
	function OnJahaziMoved(iPlayer, iUnit)
		if not tJahaziPlayers[iPlayer] then return end

		local pUnit = UnitManager.GetUnit(iPlayer, iUnit)
		if not pUnit then return end

		local pUnitAbility = pUnit:GetAbility()
		local iCurrentCount = pUnitAbility:GetAbilityCount(sJahaziAbiltiy)

		if iCurrentCount < 1 then return end

		local iPlotIndex = Map.GetPlotIndex(pUnit:GetX(), pUnit:GetY())
		if iPlotIndex < 0 then return end

		pUnit:SetProperty(sJahazi_Key, iPlotIndex)
	end
	---------------------------
	function OnImprovementRemovedFromMap(iX, iY, iPlayer)
		local pPlot = Map.GetPlot(iX, iY)
		local iProperty = pPlot:GetProperty(sJahazi_Key)
		if iProperty and iProperty > 0 then
			pPlot:SetProperty(sJahazi_Key, 0)
		end
	end
	---------------------------
	if iNumJahaziPlayers > 0 then
		Events.UnitOperationStarted.Add(OnUnitOperationStarted)

		Events.UnitAddedToMap.Add(OnJahaziMoved)
		Events.UnitMoved.Add(OnJahaziMoved)

		Events.ImprovementRemovedFromMap.Add(OnImprovementRemovedFromMap)
	end
--==========================================================================================================================
-- Pillar Tomb
-- +1 Gold per turn in this city each time a
-- Great Person is expended within one tile. (Capped at +10)
--==========================================================================================================================
	-- local sPillarTombTrait				= "TRAIT_CIVILIZATION_BUILDING_SUK_PILLAR_TOMB"
	-- local tPillarTombPlayers, iNumValid	= GetPlayersWithTrait(sPillarTombTrait)

	-- local iPillarTomb	= GameInfo.Buildings["BUILDING_SUK_PILLAR_TOMB"].Index
	-- local sModifier		= "BUILDING_SUK_PILLAR_TOMB_GOLD"

	-- if iNumValid < 1 then print("No Swahili players active: aborting"); return end
	-- ---------------------------
	-- function OnUnitGreatPersonActivated(iPlayer, iUnit, eGreatPerson, eGreatPersonIndividual)
	-- 	if not tPillarTombPlayers[iPlayer] then return end

	-- 	local pPlayer = Players[iPlayer]
	-- 	if not pPlayer then return end

	-- 	local pUnit = pPlayer:GetUnits():FindID(iUnit);
	-- 	if not pUnit then return end
	-- 	if pUnit:GetX() > -1 then return end

	-- 	local iPlot = pUnit:GetProperty(sPillarTombTrait)
	-- 	local pPlot = Map.GetPlotByIndex(iPlot)
	-- 	if not pPlot then return end

	-- 	local iX = pPlot:GetX()
	-- 	local iY = pPlot:GetY()

	-- 	for pIterPlot in IterPlotsInRange(iX, iY, 1) do
	-- 		if pIterPlot:IsCity() and pIterPlot:GetOwner() == iPlayer then
	-- 			pCity = CityManager.GetCityAt(pIterPlot:GetX(), pIterPlot:GetY())
	-- 			if not pCity then return end
	-- 			if not pCity:GetBuildings():HasBuilding(iPillarTomb) then return end

	-- 			local iNum =  pCity:GetProperty(sPillarTombTrait) or 0
	-- 			if iNum >= 10 then return end

	-- 			pCity:AttachModifierByID(sModifier)
	-- 			pCity:SetProperty(sPillarTombTrait, iNum+1)
	-- 			return
	-- 		end
	-- 	end
	-- end

	-- Events.UnitGreatPersonActivated.Add(OnUnitGreatPersonActivated)
	-- ---------------------------
	-- function OnGreatPersonMoved(iPlayer, iUnit)
	-- 	if not tPillarTombPlayers[iPlayer] then return end

	-- 	local pUnit = UnitManager.GetUnit(iPlayer, iUnit)
	-- 	if not pUnit then return end
	-- 	if pUnit:GetGreatPerson():GetClass() < 0 then return end

	-- 	local iPlotIndex = Map.GetPlotIndex(pUnit:GetX(), pUnit:GetY())
	-- 	if iPlotIndex < 0 then return end

	-- 	pUnit:SetProperty(sPillarTombTrait, iPlotIndex)
	-- end

	-- Events.UnitAddedToMap.Add(OnGreatPersonMoved)
	-- Events.UnitMoved.Add(OnGreatPersonMoved)
--==========================================================================================================================
--==========================================================================================================================