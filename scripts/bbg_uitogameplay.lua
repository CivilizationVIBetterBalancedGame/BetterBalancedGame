UIEvents = ExposedMembers.LuaEvents

--- Inca Scrits
-- Constants: populating the table of features from which we remove inca bug yields
local tRemoveIncaYieldsFromFeatures = {}
local qQuery = "SELECT WonderType FROM WonderTerrainFeature_BBG WHERE TerrainClassType<>'TERRAIN_CLASS_MOUNTAIN'"
tRemoveIncaYieldsFromFeatures=DB.Query(qQuery)

--
function OnIncaPlotYieldChanged(iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		return
	end
	local sCivilizationType = PlayerConfigurations[iOwnerId]:GetCivilizationTypeName()
	--do nothing if not inca
	if sCivilizationType ~= "CIVILIZATION_INCA" then
		return
	end
	--do nothing if not impassible
	if not pPlot:IsImpassable() then
		return
	end

	local iFeatureId = pPlot:GetFeatureType()
	if iFeatureId ~= -1 then
		if IDToPos(tRemoveIncaYieldsFromFeatures, GameInfo.Features[iFeatureId], WonderType)==false then
			return
		end
		local kParameters = {}
		kParameters["iX"] = iX
		kParameters["iY"] = iY
		kParameters.Yields = {}
		for i =0,5 do
			local nControlProp = pPlot:GetProperty(YieldPropertyDictionary[i])
			if nControlProp == nil then
				kParameters.Yields[i] = pPlot:GetYield(i) -- food
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
	local kParameters = {}
	kParameters["iX"] = iX
	kParameters["iY"] = iY
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

function YieldPropertyDictionary(iYieldId)
	local YieldDict = {}
	YieldDict[0] = "EXTRA_YIELD_FOOD"
	YieldDict[1] = "EXTRA_YIELD_PRODUCTION"
	YieldDict[2] = "EXTRA_YIELD_GOLD"
	YieldDict[3] = "EXTRA_YIELD_FAITH"
	YieldDict[4] = "EXTRA_YIELD_CULTURE"
	YieldDict[5] = "EXTRA_YIELD_SCIENCE"
	return YieldDict[iYieldId]
end