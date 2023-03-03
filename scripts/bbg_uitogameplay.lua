UIEvents = ExposedMembers.LuaEvents
print("BBG UI to Gameplay Script started")
--- Inca Scrits
-- Constants: populating the table of features from which we remove inca bug yields
tRemoveIncaYieldsFromFeatures = {}
local qQuery = "SELECT WonderType FROM WonderTerrainFeature_BBG WHERE TerrainClassType<>'TERRAIN_CLASS_MOUNTAIN' OR TerrainClassType IS NULL"
tRemoveIncaYieldsFromFeatures=DB.Query(qQuery)
--for i, row in ipairs(tRemoveIncaYieldsFromFeatures) do
	--print(i, row.WonderType)
--end
--Exp bug
function OnPromotionFixExp(iUnitPlayerID: number, iUnitID : number)
	UIEvents.UIPromotionFixExp(iUnitPlayerID, iUnitID)
end
--Inca bug
function OnIncaPlotYieldChanged(iX, iY)
	--print("OnIncaPlotYieldChanged started for", iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		--print("No Owner -> Exit")
		return
	end
	local sCivilizationType = PlayerConfigurations[iOwnerId]:GetCivilizationTypeName()
	--do nothing if not inca
	if sCivilizationType ~= "CIVILIZATION_INCA" then
		--print("Not Owned by Inca -> Exit")
		return
	end
	--do nothing if not impassible
	if not pPlot:IsImpassable() then
		return
	end

	local iFeatureId = pPlot:GetFeatureType()
	if iFeatureId ~= -1 then
		--print(GameInfo.Features[iFeatureId].FeatureType)
		if IDToPos(tRemoveIncaYieldsFromFeatures, GameInfo.Features[iFeatureId].FeatureType, "WonderType")==false then
			--print("No Match -> Exit")
			return
		end
		--print(GameInfo.Features[iFeatureId].FeatureType.." feature detected at: ", iX, iY)
		local kParameters = {}
		kParameters["iX"] = iX
		kParameters["iY"] = iY
		kParameters.Yields = {}
		for i =0,5 do
			local nControlProp = pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
			if nControlProp == nil then
				kParameters.Yields[i] = pPlot:GetYield(i)
			else
				kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
			end
		end
		UIEvents.UISetPlotProperty(iOwnerId, kParameters)
	end
end
--BCY no rng remove disaster yields
function OnBCYPlotYieldChanged(iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		return
	end
	local pCity = CityManager.GetCityAt(iX, iY)
	if pCity == nil then
		return
	end
	if CityManager.GetCity(iOwnerId, pCity:GetID()) == nil then
		return
	end
	local kParameters = {}
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	kParameters.Yields = {}
	for i =0,5 do
		local nControlProp = pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
		if nControlProp == nil then
			kParameters.Yields[i] = pPlot:GetYield(i) -- food
		else
			kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
		end
	end
	UIEvents.UIBCYAdjustCityYield(iOwnerId, kParameters)
end
--Communism
function OnCityWorkerChanged(iPlayerID, iCityID, iX, iY)
	local pPlayer = Players[iPlayerID]
	--print("OnCityWorkerChanged: Citizen Changed")
	--print("parameters", iPlayerID, iCityID, iX, iY)
	local pPlayerCulture = pPlayer:GetCulture()
	local iGovID = pPlayerCulture:GetCurrentGovernment()
	if iGovID == 8 or pPlayerCulture:IsPolicyActive(105) then
		UIEvents.UIBBGWorkersChanged(iPlayerID, iCityID, iX, iY)
	end
end

function OnGovernmentChanged(iPlayerID, iGovID)
	UIEvents.UIBBGGovChanged(iPlayerID, iGovID)
end

--Amani
function OnGovernorAssigned(iCityOwnerID, iCityID, iGovernorOwnerID, iGovernorType)
	--print("OnGovernorAssigned")
	--print(iCityOwnerID, iCityID, iGovernorOwnerID, iGovernorType)
	if iGovernorType ~= 1 then -- not amani
		return
	end
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iCityOwnerID, iCityID)
	if pTargetCity == nil then
		return
	end
	--above all mandatory checks that amani is assigned
	--set player property
	local tAmani = {}
	tAmani["iCityID"] = iCityID
	tAmani["iMinorID"] = iCityOwnerID
	tAmani["Status"] = 0 
	--0: establishing, 1: established, -1 not assigned
	UIEvents.UISetAmaniProperty(iGovernorOwnerID, tAmani)
end

function OnTradeRouteActivityChanged(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	--print("OnTradeRouteActivityChanged")
	--print(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	local pOriginPlayer = Players[iOriginPlayerID]
	if pOriginPlayer == nil then
		return
	end
	local pTargetPlayer = Players[iTargetPlayerID]
	if pTargetPlayer == nil then
		return
	end
	local pOriginCity = CityManager.GetCity(iOriginPlayerID, iOriginCityID)
	if pOriginCity == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iTargetPlayerID, iTargetCityID)
	if pTargetCity == nil then
		return
	end
	--above mandatory checks
	if pTargetPlayer:IsMajor() then -- script only works for CS
		return
	end
	--recalculate trade plot properties
	local pCityOutTrade = pOriginCity:GetTrade():GetOutgoingRoutes()
	local bControl = false
	if pCityOutTrade ~= nil then
		for _, route in ipairs(pCityOutTrade) do
			if route.DestinationCityPlayer == iTargetPlayerID then
				bControl = true
			end
		end
	end
	if bControl == true then
		--print("Sending Add trader req")
		UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, iTargetPlayerID)
	else
		--print("Sending Remove trader req")
		UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, 0-iTargetPlayerID)
	end
end

function OnGovernorChanged(iPlayerID, iGovernorID)
	--print("OnGovernorChanged")
	--print(iPlayerID, iGovernorID)
	local pPlayer = Players[iPlayerID]
	if pPlayer==nil then
		return
	end
	if iGovernorID ~= 1 then --not amani
		return
	end
	local tAmani = pPlayer:GetProperty("AMANI")
	if tAmani == nil then
		return
	end
	local pPlayerGovernors = pPlayer:GetGovernors()
	local pPlayerGovernor = GetAppointedGovernor(iPlayerID, iGovernorID)
	if pPlayerGovernor:IsEstablished(1) and tAmani~=nil then
		local pCity = CityManager.GetCity(tAmani.iMinorID, tAmani.iCityID)
		if pPlayerGovernor:GetAssignedCity() == pCity then
			--amani established -> recalculate amani yields and plot properties
			tAmani.Status = 1
			UIEvents.UISetAmaniProperty(iPlayerID, tAmani)
		end
	elseif pPlayerGovernor:IsEstablished(1) == false and tAmani.iCityID ~= nil then
		--amani removed -> recalculate amani yields and plot properties, player properties as well
		tAmani.Status = -1
		UIEvents.UISetAmaniProperty(iPlayerID, tAmani)
	end
end

function OnUnitGreatPersonCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	--print("Class ID", iGPClassID, "Individual ID", iGPIndividualID)
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_QIN_ALT" then
		return
	end
	--iGPClassID:
	--0 = General
	--1 = Admiral
	--2 = Engineer
	--3 = Merchant
	--4 = Prophet
	--5 = Scientist
	--6 = Writer
	--7 = Artist
	--8 = Musician
	--9 = Comandante
	if iGPClassID ~= 0 then
		return
	end
	if iGPIndividualID == 58 then
		return
	end
	UIEvents.UIGPGeneralUnifierCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
end

function OnUnitGreatPersonActivatedQinUnifier(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iGPClassID ~= 0 then
		return
	end
	--print("Class ID", iGPClassID, "Individual ID", iGPIndividualID)
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_QIN_ALT" then
		if iGPIndividualID == 176 or iGPIndividualID == 67 or iGPIndividualID == 74 then --timur, sudirman (177 bbg changed him), monash. vijaya
			UIEvents.UIUnifierSameUnitUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
		elseif iGPIndividualID == 71 then -- zhukov
			UIEvents.UIUnifierSamePlayerUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
		end
	end
end

function OnUnitGreatPersonActivatedNotQinUnifier(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iGPClassID ~= 0 then
		return
	end
	--print("Track suntzu")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_QIN_ALT" and iGPIndividualID == 58 then
		UIEvents.UINotUnifierDeleteSunTzu(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	end
end

function OnUnitMoved(iPlayerID, iUnitID, iX, iY, bVis, bStateChange)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~= 'LEADER_QIN_ALT' then
		return
	end
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then
		return
	end
	local pGreatPerson = pUnit:GetGreatPerson()
	local iGPClassID = pGreatPerson:GetClass()
	local iGPIndividualID = pGreatPerson:GetIndividual()
	--print(pGreatPerson, iGPClassID, iGPIndividualID)
	if iGPClassID~=0 and (iGPIndividualID~=176 or iGPIndividualID~=67 or iGPIndividualID~=74) then
		return
	end
	UIEvents.UIUnifierTrackRelevantGenerals(iPlayerID, iGPIndividualID, iX, iY)
end

--Support
function GetAppointedGovernor(playerID:number, governorTypeIndex:number)
	-- Make sure we're looking for a valid governor
	if playerID < 0 or governorTypeIndex < 0 then
		return nil;
	end

	-- Get the player governor list
	local pGovernorDef = GameInfo.Governors[governorTypeIndex];
	local pPlayer:table = Players[playerID];
	local pPlayerGovernors:table = pPlayer:GetGovernors();
	local bHasGovernors, tGovernorList = pPlayerGovernors:GetGovernorList();

	-- Find and return the governor from the governor list
	if pPlayerGovernors:HasGovernor(pGovernorDef.Hash) then
		for i,governor in ipairs(tGovernorList) do
			if governor:GetType() == governorTypeIndex then
				return governor;
			end
		end
	end

	-- Return nil if this player has not appointed that governor
	return nil;
end

function IDToPos(List, SearchItem, key, multi)
	--print(SearchItem)
	multi = multi or false
	--print(multi)
	key = key or nil
	--print(key)
	local results = {}
	if List == {} then
		return false
	end
    if SearchItem==nil then
        return print("Search Error")
    end
    for i, item in ipairs(List) do
    	if key == nil then
    		--print(item)
	        if item == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	        end
	    else
	    	--print(item[key])
	    	if item[key] == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	    	end
	    end
    end
    if results == {} or #results==0 or results==nil then
    	return false
    else
    	--print("IDtoPos Results:")
    	for _, item in ipairs(results) do
    		--print(item)
    	end
    	return results
    end
end

function ExtraYieldPropertyDictionary(iYieldId)
	local YieldDict = {}
	YieldDict[0] = "EXTRA_YIELD_FOOD"
	YieldDict[1] = "EXTRA_YIELD_PRODUCTION"
	YieldDict[2] = "EXTRA_YIELD_GOLD"
	YieldDict[5] = "EXTRA_YIELD_FAITH"
	YieldDict[4] = "EXTRA_YIELD_CULTURE"
	YieldDict[3] = "EXTRA_YIELD_SCIENCE"
	return YieldDict[iYieldId]
end

function BuildRecursiveDataString(data: table)
	local str: string = ""
	for k,v in pairs(data) do
		if type(v)=="table" then
			--print("BuildRecursiveDataString: Table Detected")
			local deeper_data = v
			local new_string = BuildRecursiveDataString(deeper_data)
			--print("NewString ="..new_string)
			str = "table: "..new_string.."; "
		else
			str = str..tostring(k)..": "..tostring(v).." "
		end
	end
	return str
end

--=========Events=========--

function Initialize()
	--Exp bug
	Events.UnitPromoted.Add(OnPromotionFixExp);
	--Communism
	--Events.CityWorkerChanged.Add(OnCityWorkerChanged)
	--Events.GovernmentChanged.Add(OnGovernmentChanged)
	print("Delete Communism UI hooks added(ignored)")
	--Amani
	Events.GovernorAssigned.Add(OnGovernorAssigned)
	Events.GovernorChanged.Add(OnGovernorChanged)
	Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged)
	print("Delete Amani UI hooks added")
	--delete suntzu after use for non-unifier
	Events.UnitGreatPersonActivated.Add(OnUnitGreatPersonActivatedNotQinUnifier)
	print("Delete Suntzu UI Hook added")
	local tMajorIDs = PlayerManager.GetAliveMajorIDs()
	for i, iPlayerID in ipairs(tMajorIDs) do
		if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_QIN_ALT" then
			--Qin Unifier
			Events.UnitGreatPersonCreated.Add(OnUnitGreatPersonCreated)
			Events.UnitGreatPersonActivated.Add(OnUnitGreatPersonActivatedQinUnifier)
			Events.UnitMoved.Add(OnUnitMoved)
		elseif PlayerConfigurations[iPlayerID]:GetCivilizationTypeName() == "CIVILIZATION_INCA" then
			--inca dynamic yield cancelation
			Events.PlotYieldChanged.Add(OnIncaPlotYieldChanged)
		end
	end
	--BCY no rng setting (param names are still called BBCC)
	if GameConfiguration.GetValue("BBCC_SETTING_YIELD") == 1 then
		print("BCY: No RNG detected")
		Events.PlotYieldChanged.Add(OnBCYPlotYieldChanged)
	end
end

--====Activation====--
Initialize()