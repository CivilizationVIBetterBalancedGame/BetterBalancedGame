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
			local nControlProp = pPlot:GetProperty(YieldPropertyDictionary(i))
			if nControlProp == nil then
				kParameters.Yields[i] = pPlot:GetYield(i)
			else
				kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
			end
		end
		UIEvents.UISetPlotProperty(iOwnerId, kParameters)
	elseif GameConfiguration.GetValue("BBCC_SETTING_YIELD") == 1 and CityManager.GetCityAt(iX, iY) ~= nil then
		print("BCY no RNG detected, city detected at: ", iX, iY)
		local kParameters = {}
		kParameters["iX"] = iX
		kParameters["iY"] = iY
		kParameters.Yields = {}
		for i =0,5 do
			local nControlProp = pPlot:GetProperty(YieldPropertyDictionary(i))
			if nControlProp == nil then
				kParameters.Yields[i] = pPlot:GetYield(i)
			else
				kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
			end
		end
		UIEvents.UISetPlotProperty(iOwnerId, kParameters)
	end	
end

--Events
Events.PlotYieldChanged.Add(OnPlotYieldChanged)
--BCY no rng setting (param names are still called BBCC)
if  then
	print("BCY: No RNG detected")
	Events.PlotYieldChanged.Add(OnBCYPlotYieldChanged)
end
--Support
function IDToPos(List, SearchItem, key)
	key = key or nil
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
	            return i;
	        end
	    else
	    	print(item[key])
	    	if item[key] == SearchItem then
	    		return i
	    	end
	    end
    end
    return false
end

function YieldPropertyDictionary(iYieldId)
	local YieldDict = {}
	YieldDict[0] = "EXTRA_YIELD_FOOD"
	YieldDict[1] = "EXTRA_YIELD_PRODUCTION"
	YieldDict[2] = "EXTRA_YIELD_GOLD"
	YieldDict[5] = "EXTRA_YIELD_FAITH"
	YieldDict[4] = "EXTRA_YIELD_CULTURE"
	YieldDict[3] = "EXTRA_YIELD_SCIENCE"
	return YieldDict[iYieldId]
end