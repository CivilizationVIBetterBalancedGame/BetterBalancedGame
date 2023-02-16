UIEvents = ExposedMembers.LuaEvents
print("BBG UI to Gameplay Script started")
--- Inca Scrits
-- Constants: populating the table of features from which we remove inca bug yields
tRemoveIncaYieldsFromFeatures = {}
local qQuery = "SELECT WonderType FROM WonderTerrainFeature_BBG WHERE TerrainClassType<>'TERRAIN_CLASS_MOUNTAIN' OR TerrainClassType IS NULL"
tRemoveIncaYieldsFromFeatures=DB.Query(qQuery)
for i, row in ipairs(tRemoveIncaYieldsFromFeatures) do
	print(i, row.WonderType)
end
--
function OnIncaPlotYieldChanged(iX, iY)
	print("OnIncaPlotYieldChanged started for", iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		print("No Owner -> Exit")
		return
	end
	local sCivilizationType = PlayerConfigurations[iOwnerId]:GetCivilizationTypeName()
	--do nothing if not inca
	if sCivilizationType ~= "CIVILIZATION_INCA" then
		print("Not Owned by Inca -> Exit")
		return
	end
	--do nothing if not impassible
	if not pPlot:IsImpassable() then
		return
	end

	local iFeatureId = pPlot:GetFeatureType()
	if iFeatureId ~= -1 then
		print(GameInfo.Features[iFeatureId].FeatureType)
		if IDToPos(tRemoveIncaYieldsFromFeatures, GameInfo.Features[iFeatureId].FeatureType, "WonderType")==false then
			print("No Match -> Exit")
			return
		end
		print(GameInfo.Features[iFeatureId].FeatureType.." feature detected at: ", iX, iY)
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

--Events
Events.PlotYieldChanged.Add(OnIncaPlotYieldChanged)
--BCY no rng setting (param names are still called BBCC)
if GameConfiguration.GetValue("BBCC_SETTING_YIELD") == 1 then
	print("BCY: No RNG detected")
	Events.PlotYieldChanged.Add(OnBCYPlotYieldChanged)
end
--Support
function IDToPos(List, SearchItem, key, multi)
	multi = multi or false
	key = key or nil
	local results = {}
	if List == {} then
		return false
	end
    if SearchItem==nil then
        return print("Search Error")
    end
    for i, item in ipairs(List) do
    	if key == nil then
    		print(item)
	        if item == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	        end
	    else
	    	print(item[key])
	    	if item[key] == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	    	end
	    end
    end
    if result == {} then
    	return false
    else
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