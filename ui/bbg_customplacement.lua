--file contains custom placement functions
--include("mapi_statemachine.lua")
--======================================================
--FlashyFeeds override that allows for custom placements
--======================================================
---======functions to replace original firaxis functions after inclusion of this file=======---

--Check all of these for GetDistrictID and see if needs replaceing with GetDistrictType

print("BBG CustomPlacement included")
local qQuery = "SELECT WonderType FROM WonderTerrainFeature_BBG WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN' OR FeatureType = 'FEATURE_OASIS'"
print(type(DB.Query(qQuery)))
print(GameInfo.Districts[-1188273497].Index)


function MAPI_CityCanStartOperation(pCity: object, iOperationType: number, tParameters: table, bResults: boolean)
	print("MAPI_CityCanStartOperation called")
	bResults = bResults or false
	local hashToCheck : number
	local iBuildingId = -1
	local iDistrictId = -1
	local iCustomPlacementId = -1
	local augmentedResults = {}
	local bEarlyFinish = false
	while bEarlyFinish == false do
		if iOperationType ~= CityOperationTypes.BUILD then
			bEarlyFinish = true
			break
		end
		if tParameters[CityOperationTypes.PARAM_BUILDING_TYPE]==nil and tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE] == nil then
			bEarlyFinish = true
			break
		elseif tParameters[CityOperationTypes.PARAM_BUILDING_TYPE]~=nil then
			hashToCheck = tParameters[CityOperationTypes.PARAM_BUILDING_TYPE]
			iBuildingId = GameInfo.Buildings[hashToCheck].Index
			print(iBuildingId)
		elseif tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE] ~=nil then
			hashToCheck = tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE]
			iDistrictId = GameInfo.Districts[hashToCheck].Index
			print(iDistrictId)
		end
		iCustomPlacementId = IDToPos(DB.Query("SELECT * FROM CustomPlacement"), hashToCheck, "Hash")
		print(iCustomPlacementId)
		
		if iCustomPlacementId == false then
			bEarlyFinish = true
			break
		else
			iCustomPlacementId = iCustomPlacementId -1
			print(GameInfo.CustomPlacement[iCustomPlacementId].ObjectType)
		end
		break
	end
	
	local bCanStart = false
	local tResults = {}
	bCanStart, tResults = CityManager.CanStartOperation(pCity, iOperationType, tParameters, bResults)  -- firaxis placement
	if (not bEarlyFinish) and (not bCanStart) then -- custom placement checks (only if firaxis is false)
		tResults = {}
		tResults[CityOperationResults.SUCCESS_CONDITIONS] = {}
		if bCanStart == false or GameInfo.CustomPlacement[iCustomPlacementId].OverridePlacement then
			local pPlot = Map.GetPlot(tParameters[CityOperationTypes.PARAM_X], tParameters[CityOperationTypes.PARAM_Y])
			local bDomainSea = false
			local kFunction = GameInfo.CustomPlacement[iCustomPlacementId].PlacementFunction
			print(kFunction)
			bCanStart = CustomPlacement[kFunction](pPlot, pCity:GetOwner(), pCity:GetID())
			if bCanStart then
				if iBuildingId ~= -1 then
					bDomainSea = GameInfo.Buildings[iBuildingId].MustBeAdjacentLand
					bCanStart, tTempResults = MAPI_CheckTile(pPlot, bDomainSea, bResults)
					if tTempResults~=nil or tTempResults~={} then
						tResults[CityOperationResults.SUCCESS_CONDITIONS] = tTempResultsl
					end
				elseif iDistrictId ~= -1 then
					bDomainSea = GameInfo.Districts[iDistrictId].AdjacentToLand
					bCanStart, tTempResults = MAPI_CheckTile(pPlot, bDomainSea, bResults)
					if tTempResults~=nil or tTempResults~={} then
						tResults[CityOperationResults.SUCCESS_CONDITIONS] = tTempResults
					end
				end
			end
		end
	end
	if bCanStart == true and (tResults ~= {} or tResults ~= nil) then -- returns
		return bCanStart, tResults
	else
		return bCanStart
	end
end

function MAPI_CityGetOperationTargets(pCity: object, iOperationType, tParameters: table)
	print("MAPI_CityGetOperationTargets called")
	local hashToCheck : number
	local iBuildingId = -1
	local iDistrictId = -1
	local iCustomPlacementId = -1
	local augmentedResults = {}
	augmentedResults[CityOperationResults.PLOTS]={}
	local bEarlyFinish = false
	while bEarlyFinish == false do
		print("Early Finish Loop")
		if iOperationType ~= CityOperationTypes.BUILD then
			bEarlyFinish = true
			print("bEarlyFinish 0")
			break
		end
		if tParameters[CityOperationTypes.PARAM_BUILDING_TYPE]==nil and tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE] == nil then
			bEarlyFinish = true
			print("bEarlyFinish 1")
			break
		elseif tParameters[CityOperationTypes.PARAM_BUILDING_TYPE]~=nil then
			hashToCheck = tParameters[CityOperationTypes.PARAM_BUILDING_TYPE]
			iBuildingId = GameInfo.Buildings[hashToCheck].Index
			print(iBuildingId)
		elseif tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE] ~=nil then
			hashToCheck = tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE]
			iDistrictId = GameInfo.Districts[hashToCheck].Index
			print(iDistrictId)
		end
		iCustomPlacementId = IDToPos(DB.Query("SELECT * FROM CustomPlacement"), hashToCheck, "Hash")
		print(iCustomPlacementId)
		if iCustomPlacementId == false then
			bEarlyFinish = true
			break
		else
			iCustomPlacementId = iCustomPlacementId - 1
		end
		if GameInfo.CustomPlacement[iCustomPlacementId].OverridePlacement == false then
			augmentedResults = CityManager.GetOperationTargets(pCity, iOperationType, tParameters)
		end
		break
	end
	if bEarlyFinish then
		return CityManager.GetOperationTargets(pCity, iOperationType, tParameters)
	end	
	local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
	for i = 0, 35 do
		local pTargetPlot = GetAdjacentTiles(pPlot, i)
		print(pTargetPlot)
		local bKeep = false
		if pTargetPlot ~= pPlot then
			if iBuildingId ~= -1 and MAPI_CanHaveBuilding(pTargetPlot, iBuildingId, pCity:GetOwner(), pCity:GetID()) then
				bKeep = true
				print("Kept")
			elseif iDistrictId ~= -1 and MAPI_CanHaveDistrict(pTargetPlot, iDistrictId, pCity:GetOwner(), pCity:GetID()) then
				bKeep = true
				print("Kept")
			end
		end
		if bKeep == true and (IDToPos(augmentedResults[CityOperationResults.PLOTS], pTargetPlot:GetIndex())==false) then
			table.insert(augmentedResults[CityOperationResults.PLOTS], pTargetPlot:GetIndex())
			print("Extra Plot inserted", pTargetPlot)
		end
	end
	return augmentedResults	
end

function MAPI_CanHaveDistrict(pPlot: object, iDistrictId: number, iOwnerPlayerId: number, iCityId: number)
	print("MAPI_CanHaveDistrict called")
	local iCustomPlacementId = IDToPos(DB.Query("SELECT * FROM CustomPlacement"), GetHash(GameInfo.Districts[iDistrictId].DistrictType), "Hash")
	if  iCustomPlacementId == false then
		return pPlot:CanHaveDistrict(iDistrictId, iOwnerPlayerId, iCityId)
	else
		iCustomPlacementId = iCustomPlacementId - 1
	end
	local pCity = CityManager.GetCity(iOwnerPlayerId, iCityId)
	if pCity == nil then --invalid input
		return false
	end
	local cityX = pCity:GetX()
	local cityY = pCity:GetY()
	local nDistance = Map.GetPlotDistance(pPlot:GetX(), pPlot:GetY(), cityX, cityY)
	if nDistance > 3 then --too far away
		return false
	end
	local pOwnerCityForPlot = Cities.GetPlotPurchaseCity(pPlot)
	if pOwnerCityForPlot == nil then
		return false
	end
	if pOwnerCityForPlot:GetID() ~= iCityId and pPlot:GetOwner() == iOwnerPlayerId then -- owned by player but a different city
		return false
	end
	local bDomainSea = false
	if GameInfo.Districts[iDistrictId].AdjacentToLand == true then
		bDomainSea = true
	end
	local bCanPlace = MAPI_CheckTile(pPlot, bDomainSea)
	print("After Tile Checked Result:", bCanPlace)
	if bCanPlace then
		local kFunction = GameInfo.CustomPlacement[iCustomPlacementId].PlacementFunction
		print("Placement Function", kFunction)
		bCanPlace = CustomPlacement[kFunction](pPlot, iOwnerPlayerId, iCityId)
		print("After CustomPlacementCheck", bCanPlace)
	end
	bCanPlace = bCanPlace or pPlot:CanHaveDistrict(iDistrictId, iOwnerPlayerId, iCityId)
	return bCanPlace
end

function MAPI_CanHaveWonder(pPlot:object, iBuildingId: number, iOwnerPlayerId: number, iCityId: number)
	print("MAPI_CanHaveWonder called")
	local iCustomPlacementId = IDToPos(DB.Query("SELECT * FROM CustomPlacement"), GetHash(GameInfo.Buildings[iBuildingId].BuildingType), "Hash")
	if  iCustomPlacementId == false then
		return pPlot:CanHaveWonder(iBuildingId, iOwnerPlayerId, iCityId)
	else
		iCustomPlacementId = iCustomPlacementId - 1
	end
	local pCity = CityManager.GetCity(iOwnerPlayerId, iCityId)
	if pCity == nil then --invalid input
		return false
	end
	local cityX = pCity:GetX()
	local cityY = pCity:GetY()
	local nDistance = Map.GetPlotDistance(pPlot:GetX(), pPlot:GetY(), cityX, cityY)
	if nDistance > 3 then --too far away
		return false
	end
	local pOwnerCityForPlot = Cities.GetPlotPurchaseCity(pPlot)
	if pOwnerCityForPlot == nil then
		return false
	end
	if pOwnerCityForPlot:GetID() ~= iCityId and pPlot:GetOwner() == iOwnerPlayerId then -- owned by player but a different city
		return false
	end
	local bDomainSea = false
	if GameInfo.Buildings[iBuildingId].MustBeAdjacentLand == true then
		bDomainSea = true
	end
	local bCanPlace = MAPI_CheckTile(pPlot, bDomainSea)
	print("After Tile Check", bCanPlace)
	if bCanPlace then
		local kFunction = GameInfo.CustomPlacement[iCustomPlacementId].PlacementFunction
		print("Placement Function", kFunction)
		bCanPlace = CustomPlacement[kFunction](pPlot, iOwnerPlayerId, iCityId)
		print("After CustomPlacementCheck", bCanPlace)
	end
	bCanPlace = bCanPlace or pPlot:CanHaveWonder(iBuildingId, iOwnerPlayerId, iCityId)
	return bCanPlace
end
---
function MAPI_CheckTile(pPlot: object, bDomainSea: boolean, results: boolean)
	print("MAPI_CheckTile called")
	print("Step0")
	if pPlot == nil then
		return false
	end
	bDomainSea = bDomainSea or false -- default false
	results = results or false --report feature/improvement/building removal
	local succResults = {}
	print("Step1")
	local pPlayer = Players[pPlot:GetOwner()]
	print(pPlayer, pPlot:GetOwner())
	if pPlayer == nil then
		print("Nil player")	
		return false
	end
	local addToList = true
	
	print("Step1.1") -- terrain
	local posPlotTerrain = pPlot:GetTerrainType()
	print("terrainType", posPlotTerrain)
	if bDomainSea==false and ((posPlotTerrain == 2) or (posPlotTerrain == 5) or (posPlotTerrain == 8) or (posPlotTerrain == 11) or (posPlotTerrain == 14) or (posPlotTerrain == 15) or (posPlotTerrain == 16)) then
		addToList = addToList and false
	end
	if bDomainSea==true and ((posPlotTerrain ~= 15) and (posPlotTerrain ~= 16)) then
		addToList = addToList and false
	end
	print("Step1.1 Result", addToList)

	print("Step1.2") -- placed districts
	if(pPlot:GetDistrictID() ~= -1 and pPlot:GetDistrictType() ~= nil) then
		addToList = addToList and false
	end
	print("Step1.2 Result", addToList)
	
	print("Step1.3") -- placed wonders
	if pPlot:GetWonderType() ~= -1 then
		addToList = addToList and false
	end
	print("Step1.3 Result", addToList)

	print("Step1.4") -- feature
	local posPlotFeature = pPlot:GetFeatureType()
	if posPlotFeature ~= -1 and GameInfo.Features[posPlotFeature].Removable == false then
		addToList = addToList and false
	elseif posPlotFeature ~= -1 and GameInfo.Features[posPlotFeature].Removable then
		local strTech = GameInfo.Features[posPlotFeature].RemoveTech
		print(strTech)
		if strTech ~= nil then
			local iTech = GameInfo.Technologies[strTech].Index
			print(iTech)
			if pPlayer:GetTechs():HasTech(iTech)==false then
				addToList = addToList and false
			end
		end
		if results and addToList then
			table.insert(succResults, Locale.Lookup("LOC_DISTRICT_ZONE_WILL_REMOVE_FEATURE", GameInfo.Features[posPlotFeature].Name))
		end
	end
	print("Step1.4 Result", addToList)

	print("Step1.5") --resource
	local posPlotResource = pPlot:GetResourceType()
	if posPlotResource ~= -1 then 
		if GameInfo.Resources[posPlotResource].ResourceClassType == 'RESOURCECLASS_LUXORY' then
			addToList = addToList and false
		elseif GameInfo.Resources[posPlotResource].ResourceClassType == 'RESOURCECLASS_STRATEGIC' and pPlayer:GetTechs():HasTech(GameInfo.Technologies[GameInfo.Resources[posPlotResource].PrereqTech]) then
			addToList = addToList and false
		elseif GameInfo.Resources[posPlotResource].ResourceClassType == 'RESOURCECLASS_ARTIFACT' and pPlayer:GetCulture():HasCivic(GameInfo.Civics[GameInfo.Resources[posPlotResource].PrereqCivic]) then
			addToList = addToList and false
		elseif GameInfo.Resources[posPlotResource].ResourceClassType == 'RESOURCECLASS_BONUS' then
			local resType = GameInfo.Resources[posPlotResource].ResourceType
			local iRemoveResId = IDToPos(DB.Query("SELECT * FROM Resource_Harvests"), resType, "ResourceType")
			local iTech = -1
			if iRemoveResId ~= false then
				iRemoveResId = iRemoveResId - 1
				print(iRemoveResId)
				local strTech = GameInfo.Resource_Harvests[iRemoveResId].PrereqTech
				print(strTech)
				if strTech ~= nil then
					iTech = GameInfo.Technologies[strTech].Index
					if pPlayer:GetTechs():HasTech(iTech) == false then
						addToList = addToList and false
					end				
				end
			end
			if results and addToList then
				table.insert(succResults, Locale.Lookup("LOC_DISTRICT_ZONE_WILL_HARVEST_RESOURCE", GameInfo.Resources[posPlotResource].Name))
			end
		end
	end
	print("Step1.5 Result", addToList)

	print("Step1.6") -- improvement
	local posPlotImprovement = pPlot:GetImprovementType()
	if posPlotImprovement ~= -1 then
		if GameInfo.Improvements[posPlotImprovement].Removable == false then
			addToList = addToList and false
		end
		if results and addToList then
			table.insert(succResults, Locale.Lookup("LOC_DISTRICT_ZONE_WILL_REMOVE_IMPROVEMENT", GameInfo.Improvements[posPlotImprovement].Name))
		end
	end
	print("Step1.6 Result", addToList)

	if results == true then
		return addToList, succResults
	else
		return addToList
	end
end

CustomPlacement = {}

--=======Placement Functions=======--
function PlaceAqueduct_BBG(pPlot:object, iPlayerId : number, iCityId: number)
	print("PlaceAqueduct_BBG called")
	if pPlot == nil then
		return false
	end
	local iOwnerId = pPlot:GetOwner()
	if iOwnerId ~= iPlayerId then
		return false
	end
	local pCity = CityManager.GetCity(iPlayerId, iCityId)
	if pCity == nil then
		return false
	end
	local pCityPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
	local bFreshWater = false
	local bAdjCityCenter = false
	local qQuery = "SELECT WonderType FROM WonderTerrainFeature_BBG WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN' OR FeatureType = 'FEATURE_OASIS'"
	local tQueryResults = {}
	local bCanPlace = false
	for i, row in ipairs(DB.Query(qQuery)) do
		table.insert(tQueryResults, row.WonderType)
	end
	for i=0,5 do
		local pTestPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), i)
		if pTestPlot ~= nil then
			local iFeatureId = pTestPlot:GetFeatureType()
			if iFeatureId ~= -1 then
				local sTestPlotFeature = GameInfo.Features[pTestPlot:GetFeatureType()].FeatureType
				print(sTestPlotFeature)
				
				if IDToPos(tQueryResults, sTestPlotFeature)~= false then
					bFreshWater = true
					print("Custom Wonder Detected, count as fresh water", bFreshWater)
				end
			end
			local bIsCity = pTestPlot:IsCity()
			if bIsCity == true then
				print("City Center Detected")
				if pCityPlot == pTestPlot then
					print("City Centers Match")
					bAdjCityCenter = true
				end
			end
		end
	end
	if bAdjCityCenter and bFreshWater then
		bCanPlace = true
	end
	return bCanPlace
end

CustomPlacement["BBG_AQUEDUCT_CUSTOM_PLACEMENT"] = PlaceAqueduct_BBG

function PlaceCanal_BBG(pPlot:object, iPlayerId: number, iCityId: number, bPanama: boolean)
	print("PlaceCanal_BBG called")
	bPanama = bPanama or false --internal variable only used for panama placement
	if pPlot == nil then
		return false
	end 
	local tAdjPlots = {}
	local bCanPlace = false
	local bEarlyFinish = false
	local iOwnerId = pPlot:GetOwner()
	if iPlayerId~=iOwnerId then
		return false
	end
	local pCity = CityManager.GetCity(iPlayerId, iCityId)
	if pCity == nil then
		return false
	end
	local pPlayer = Players[pPlot:GetOwner()]
	while bEarlyFinish == false do
		if pPlot == nil then
			bEarlyFinish = true
			break
		end
		if pPlayer:GetTechs():HasTech(39) == false then
			bEarlyFinish = true
			break
		end
		if MAPI_CheckTile(pPlot) == false then
			bEarlyFinish = true
			break
		end
		break
	end
	if not bEarlyFinish then
		for i=0,5 do
			tAdjPlots[i] = false
			local pTestPlot = Map.GetAdjacentPlot(pPlot:GetX(),pPlot:GetY(), i)
			if pTestPlot ~= nil then
				if pTestPlot:IsCity() or pTestPlot:GetTerrainType() == 15 or pTestPlot:GetTerrainType() == 16 then
					tAdjPlots[i] = true
				end
				if bPanama and GameInfo.Buildings[pTestPlot:GetWonderType()].BuildingType == 'BUILDING_PANAMA_CANAL' then
					tAdjPlots[i] = true
				end
			end
		end
		for i = 0, 2 do
			if tAdjPlots[i] then
				for j=0, 5 do
					if j~=AblGrpAdd(i,1,6) and j~=AblGrpAdd(i,-1,6) then
						if tAdjPlots[j] then
							bCanPlace = true
							break
						end
					end
				end
			end
			if bCanPlace then
				break
			end
		end
	end
	return bCanPlace
end

CustomPlacement["BBG_CANAL_CUSTOM_PLACEMENT"] = PlaceCanal_BBG

function PlacePanama_BBG(pPlot:object, iPlayerId: number, iCityId: number)
	print("PlacePanama_BBG called")
	local bCanPlace = false
	local iOwnerId = pPlot:GetOwner()
	if iPlayerId ~= iOwnerId then
		return false
	end
	local pPlayer = Players[iPlayerId]
	local pCity = CityManager.GetCity(iPlayerId, iCityId)
	if pCity == nil then
		return false
	end
	local bEarlyFinish = false
	local bAdjCityCenter = false
	if MAPI_CheckTile(pPlot) == false then
		bEarlyFinish = true
	end
	while not bEarlyFinish do
		for i=0,5 do
			local pTestPlot = Map.GetAdjacentPlot(pPlot:GetX(),pPlot:GetY(), i)
			if pTestPlot~=nil then
				if pTestPlot:IsCity() then
					bAdjCityCenter = true
					bEarlyFinish = true
					break
				end
			end
		end
		if bEarlyFinish then
			break
		end
		for i=0,5 do
			local pTestPlot1 = Map.GetAdjacentPlot(pPlot:GetX(),pPlot:GetY(), i)
			local pTestPlot2 = Map.GetAdjacentPlot(pPlot:GetX(),pPlot:GetY(), OppDirection(i))
			if pTestPlot1 ~= nil and pTestPlot2~= nil then
				if (pTestPlot1:GetTerrainType()==15 or pTestPlot1:GetTerrainType()==16) and PlaceCanal_BBG(pTestPlot2, iPlayerId, iCityId, true) then
					bCanPlace = true
					bEarlyFinish = true
					break
				elseif (pTestPlot2:GetTerrainType()==15 or pTestPlot2:GetTerrainType()==16) and PlaceCanal_BBG(pTestPlot1, iPlayerId, iCityId, true) then
					bCanPlace = true
					bEarlyFinish = true
					break
				elseif PlaceCanal_BBG(pTestPlot1, iPlayerId, iCityId, true) and PlaceCanal_BBG(pTestPlot2, iPlayerId, iCityId, true) then
					bCanPlace = true
					bEarlyFinish = true
					break
				end
			end
		end
		if bEarlyFinish then
			break
		end
		break
	end
	return bCanPlace and (not bAdjCityCenter)
end

CustomPlacement["BBG_PANAMA_CANAL_CUSTOM_PLACEMENT"] = PlacePanama_BBG

print("IsType", type(CustomPlacement["BBG_AQUEDUCT_CUSTOM_PLACEMENT"]))
--======Support======--
function AblGrpAdd(x,y,base)
	local modX = x
	local modY = y
	if x<0 then
		local res = 0 - math.floor(x/base)
		modX = x + base*res
	end
	if y<0 then
		local res = 0 - math.floor(x/base)
		modY = y + base*res
	end
	return math.fmod(modX+modY, base)
end

function OppDirection(iDirection)
	local directionreverse = {}
	directionreverse[0]=3
	directionreverse[1]=4
	directionreverse[2]=5
	directionreverse[3]=0
	directionreverse[4]=1
	directionreverse[5]=2
	return directionreverse[iDirection]
end

function IDToPos(List, SearchItem, key)
	key = key or nil
	if List == {} then
		return false
	end
    if SearchItem==nil then
        return
    end
    for i, item in ipairs(List) do
    	if key == nil then
	        if item == SearchItem then
	            return i;
	        end
	    else
	    	if item[key] == SearchItem then
	    		return i
	    	end
	    end
    end
    return false
end

function GetHash(t)
	local r = GameInfo.Types[t];
	if(r) then
		return r.Hash;
	else
		return 0;
	end
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