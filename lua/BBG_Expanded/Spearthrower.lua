-- Spearthrower_Functions
-- Author: Calcifer

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

function FireIsBorn_RecalculateCity(pPlayer, pCity)
	print("FireIsBorn_RecalculateCity called")
	local tFireIsBorn = pPlayer:GetProperty("FIREISBORN")
	local tCsTraders = pCity:GetProperty("CS_TRADERS")
	local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
	local bFireIsBornCS = pPlot:GetProperty("FIRE_IS_BORN_ESTABLISHED_CS")
	local bTraderToFireIsBorn = pPlot:GetProperty("TRADER_TO_FIRE_IS_BORN_CS")
	if tFireIsBorn ~= nil then
		print("Player FIREISBORN Property Detected")
		local iMinorID = tFireIsBorn["iMinorID"]
		print("FireIsBorn iMinorID", iMinorID)
		if tFireIsBorn.Status == 1 and bFireIsBornCS == nil then
			pPlot:SetProperty("FIRE_IS_BORN_ESTABLISHED_CS", 1) -- assign fire is born modifier control property
			print("Fire is born control Property assigned")
		elseif (tFireIsBorn.Status == 0 or tFireIsBorn.Status == -1) and bFireIsBornCS == 1 then
			pPlot:SetProperty("FIRE_IS_BORN_ESTABLISHED_CS", nil) -- remove amani modifier control property
			print("Fire is born control property removed")
		end
		if tCsTraders ~= nil then
			print("City CS property Detected")
			local vSearchResult = IDToPos(tCsTraders, iMinorID)
			--debug lines
			if tCsTraders~= nil or tCsTraders~={} then
				for i, iMinorIDs in ipairs(tCsTraders) do
					print(pCity, "trader to", iMinorIDs)
				end
			end
			print("Search Result", vSearchResult)
			print("bTraderToFireIsBorn", bTraderToFireIsBorn)
			if vSearchResult == false and bTraderToFireIsBorn == 1 then
				pPlot:SetProperty("TRADER_TO_FIRE_IS_BORN_CS", nil) --remove trader modifier control property
				print("trader control property removed")
			elseif vSearchResult~=false and bTraderToFireIsBorn == nil then
				pPlot:SetProperty("TRADER_TO_FIRE_IS_BORN_CS", 1) -- assign trader modifier control property
				print("trader control property assigned")
			end
		end
	end
end

function FireIsBorn_RecalculatePlayer(pPlayer)
	print("FireIsBorn_RecalculatePlayer called")
	local pPlayerCities = pPlayer:GetCities()
	for i, pCity in pPlayerCities:Members() do
		FireIsBorn_RecalculateCity(pPlayer, pCity)
	end
end

function OnGameplaySetFireIsBornProperty(iGovernorOwnerID, kParameters)
	print("OnGameplaySetFireIsBornProperty called")
	local iGovernorOwnerID = kParameters["iGovernorOwnerID"]
	local tFireIsBorn = kParameters["tFireIsBorn"]
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer == nil then
		return
	end
	pPlayer:SetProperty("FIREISBORN", tFireIsBorn)
	FireIsBorn_RecalculatePlayer(pPlayer)
end

function OnGameplaySetCSTrader(iOriginPlayerID, kParameters)
	print("OnGameplaySetCSTrader called")
	local iOriginPlayerID = kParameters["iOriginPlayerID"]
	local iOriginCityID = kParameters["iOriginCityID"]
	local iTargetPlayerID = kParameters["iTargetPlayerID"]
	local pPlayer = Players[iOriginPlayerID]
	if pPlayer == nil then
		return
	end
	local pCity = CityManager.GetCity(iOriginPlayerID, iOriginCityID)
	if pCity == nil then
		return
	end
	local tCsTraders = pCity:GetProperty("CS_TRADERS")
	if tCsTraders == nil then
		tCsTraders = {}
	end
	--debug control
	if tCsTraders~= nil or tCsTraders~={} then
		for i, iMinorIDs in ipairs(tCsTraders) do
			print(pCity, "trader to", iMinorIDs)
		end
	end
	if iTargetPlayerID > 0 then
		print("Adding CS ID to trader list")
		table.insert(tCsTraders, iTargetPlayerID)
		--debug lines
		if tCsTraders~= nil or tCsTraders~={} then
			for i, iMinorIDs in ipairs(tCsTraders) do
				print(pCity, "trader to", iMinorIDs)
			end
		end
	elseif iTargetPlayerID<0 then
		print("Removing CS ID from trader list", 0-iTargetPlayerID)
		local iRemovePos = IDToPos(tCsTraders, 0-iTargetPlayerID)
		if iRemovePos~=false then
			table.remove(tCsTraders, iRemovePos)
		end
		--debug lines
		if tCsTraders~= nil or tCsTraders~={} then
			for i, iMinorIDs in ipairs(tCsTraders) do
				print(pCity, "trader to", iMinorIDs)
			end
		end
	end
	pCity:SetProperty("CS_TRADERS", tCsTraders)
	FireIsBorn_RecalculateCity(pPlayer, pCity)
end

function Initialize()
	-- Events.GovernorAssigned.Add(OnGovernorAssigned)
	-- Events.GovernorChanged.Add(OnGovernorChanged)
	GameEvents.GameplaySetFireIsBornProperty.Add(OnGameplaySetFireIsBornProperty)
	GameEvents.GameplaySetCSTrader.Add(OnGameplaySetCSTrader)
end

Initialize()