--file contains custom placement functions
--include("mapi_statemachine.lua")

function ExposedMembers.MAPICheckTile(pPlot: object, bDomainSea: boolean, results: boolean)
	print("Step0")
	if pPlot == nil then
		return false
	end
	bDomainSea = bDomainSea or false -- default false
	results = results or false --report feature/improvement/building removal
	local succResults = {}
	print("Step1")
	local pPlayer = pPlot:GetOwner()
	local addToList = true
	while addToList == true do 
		print("Step1.1") -- terrain
		local posPlotTerrain = pPlot:GetTerrainType()
		if bDomainSea==false and ((posPlotTerrain == 2) or (posPlotTerrain == 5) or (posPlotTerrain == 8) or (posPlotTerrain == 11) or (posPlotTerrain == 14) or (posPlotTerrain == 15) or (posPlotTerrain == 16)) then
			addToList = addToList and false
		end
		if bDomainSea==true and ((posPlotTerrain ~= 15) and (posPlotTerrain ~= 16)) then
			addToList = addToList and false
		end
		print("Step1.2") -- placed districts
		if(pPlot:GetDistrictID() ~= -1 and pPlot:GetDistrictType() ~= nil) then
			addToList = addToList and false
		end
		print("Step1.3") -- placed wonders
		if pPlot:GetWonderType() ~= -1 or pPlot:GetWonderType()~= nil then
			addToList = addToList and false
		end
		print("Step1.4") -- feature
		local posPlotFeature = pPlot:GetFeatureType()
		if posPlotFeature ~= -1 and GameInfo.Features[posPlotFeature].Removable == false then
			addToList = addToList and false
		elseif posPlotFeature ~= -1 and GameInfo.Features[posPlotFeature].Removable then
			local strTech = GameInfo.Features[posPlotFeature].RemoveTech
			if strTech ~= nil then
				local iTech = IDToPos(GameInfo.Technologies(), GetHash(strTech), "Hash")
				if pPlayer:GetTechs():HasTech(iTech)==false then
					addToList = addToList and false
				end
			end
			if results and addToList then
				table.insert(succResults, Locale.Lookup("LOC_DISTRICT_ZONE_WILL_REMOVE_FEATURE", GameInfo.Features[posPlotFeature].Name))
			end
		end
		print("Step1.5") --resource
		local posPlotResource = pPlot:GetResourceType()
		if posPlotResource ~= -1 then 
			if GameInfo.Resources[posPlotResource].ResourceClassType == 'RESOURCECLASS_LUXORY' then
				addToList = addToList and false
			elseif GameInfo.Resources[posPlotResource].ResourceClassType == 'RESOURCECLASS_STRATEGIC' and pPlayer:GetResources():IsResourceVisible(posPlotResource) then
				addToList = addToList and false
			elseif GameInfo.Resources[posPlotResource].ResourceClassType == 'RESOURCECLASS_BONUS' then
				local resType = GameInfo.Resources[posPlotResource].ResourceType
				local iRemoveResId = IDToPos(GameInfo.Resource_Harvests(), resType, "ResourceType")
				local iTech = -1
				if iRemoveResId ~= false then
					local strTech = GameInfo.Resource_Harvests[iRemoveResId].PrereqTech
					if strTech ~= nil then
						iTech = IDToPos(GameInfo.Technologies(), GetHash(strTech), "Hash")
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
		break
	end
	if results == true then
		return addToList, succResults
	else
		return addToList
	end
end

ExposedMembers.CustomPlacement = {}
ExposedMembers.CustomPlacement["BBG_AQUEDUCT_CUSTOM_PLACEMENT"] = PlaceAqueduct_BBG
ExposedMembers.CustomPlacement["BBG_CANAL_CUSTOM_PLACEMENT"] = PlaceCanal_BBG
ExposedMembers.CustomPlacement["BBG_PANAMA_CANAL_CUSTOM_PLACEMENT"] = PlacePanama_BBG

--=======Placement Functions=======--
function PlaceAqueduct_BBG(pPlot:object, iPlayerId : number, iCityId: number)
	if pPlot == nil then
		return false
	end
	local iOwnerId = pPlot:GetOwner()
	if iOwnerId ~= iPlayerId then
		return false
	end
	local pCity = CityManager.GetCity(iPlayerId, iCityId)
	if pCity = nil then
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
			local sTestPlotFeature = GameInfo.Features[pTestPlot:GetFeatureType()].FeatureType
			local bIsCity = pTestPlot:IsCity()
			if IDToPos(tQueryResults, sTestPlotFeature)~= false then
				bFreshWater = true
			end
			if bIsCity == true then
				if pCityPlot == pTestPlot then
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

function PlaceCanal_BBG(pPlot:object, iPlayerId: number, iCityId: number, bPanama: boolean)
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
	if pCity = nil then
		return false
	end
	local pPlayer = Players[pPlot:GetOwner()]
	while bEarlyFinish = false do
		if pPlot == nil then
			bEarlyFinish = true
			break
		end
		if pPlayer:GetTechs():HasTech(39) == false then
			bEarlyFinish = true
			break
		end
		if ExposedMembers.MAPICheckTile(pPlot) == false then
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

function PlacePanama_BBG(pPlot:object, iPlayerId: number, iCityId: number)
	local bCanPlace = false
	local iOwnerId = pPlot:GetOwner()
	if iPlayerId ~= iOwnerId then
		return false
	end
	local pPlayer = Players[iPlayerId]
	local pCity = CityManager.GetCity(iPlayerId, iCityId)
	if pCity = nil then
		return false
	end
	local bEarlyFinish = false
	local bAdjCityCenter = false
	if ExposedMembers.MAPICheckTile(pPlot) == false then
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