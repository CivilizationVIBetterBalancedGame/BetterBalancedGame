ExposedMembers.LuaEvents = LuaEvents

print("BCY: NO RNG script started")
include("SupportFunctions");

--Hook Functions
function OnCityBuiltBBCC(playerID, cityID, iX, iY)
	print("OnCityBuiltBBCC started")
	RecalculateMapYield(iX, iY)
end

function OnUIBCYAdjustCityYield(playerID, kParameters)
	print("BCY script called from UI event")
	GameEvents.GameplayBCYAdjustCityYield.Call(playerID, kParameters)
end

LuaEvents.UIBCYAdjustCityYield.Add(OnUIBCYAdjustCityYield)

function OnGameplayBCYAdjustCityYield(playerID, kParameters)
	print("Gameplay Script Called")
	RecalculateMapYield(kParameters.iX, kParameters.iY)
end

--function OnRandomEventOccurredBBCC(iType, iSeverity, iX, iY, iMitigation)
	--RecalculateMapYield(iX, iY)
--end
--Effect Functions
function RecalculateMapYield(iX, iY)
	local pCity = CityManager.GetCityAt(iX,iY)
	print("Check 0")
	if pCity == nil then
		return
	end
	print("Check 1")
	if GameConfiguration.GetValue("BBCC_SETTING") == 1 and Players[pCity:GetOwner()]:GetCities():GetCapitalCity()~=pCity then
		return
	end
	print("BCY no RNG: Yield Recalculation Started")
	local pPlot = Map.GetPlot(iX, iY)
	local iTerrain = pPlot:GetTerrainType()
	--flats
	if iTerrain==0 or iTerrain==3 or iTerrain==6 or iTerrain==9 or iTerrain==12 then
		for i=0,5 do
			local nYield = 0
			if pPlot:GetProperty(ExtraYieldPropertyDictionary(i))~=nil then
				nYield = pPlot:GetYield(i) - pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
			else
				nYield = math.max(pPlot:GetYield(i), GameInfo.Flat_CutOffYieldValues[i].Amount)
			end
			local nYieldDiff = nYield - GameInfo.Flat_CutOffYieldValues[i].Amount
			print("yield: "..GameInfo.Yields[i].YieldType.." value: "..tostring(nYield).." difference: "..tostring(nYieldDiff))
			if nYieldDiff > 0 then
				pPlot:SetProperty(ExtraYieldPropertyDictionary(i), nYieldDiff)
				print("Property set: "..tostring(ExtraYieldPropertyDictionary(i)).." amount: "..tostring(nYieldDiff))
			end
		end
	end
	--hills
	if iTerrain==1 or iTerrain==4 or iTerrain==7 or iTerrain==10 or iTerrain==13 then
		for i=0,5 do
			local nYield = 0
			if pPlot:GetProperty(ExtraYieldPropertyDictionary(i))~=nil then
				nYield = pPlot:GetYield(i) - pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
			else
				nYield = math.max(pPlot:GetYield(i), GameInfo.Hill_CutOffYieldValues[i].Amount)
			end
			local nYieldDiff = nYield - GameInfo.Hill_CutOffYieldValues[i].Amount
			print("yield: "..GameInfo.Yields[i].YieldType.." value: "..tostring(nYield).." difference: "..tostring(nYieldDiff))
			if nYieldDiff > 0 then
				pPlot:SetProperty(ExtraYieldPropertyDictionary(i), nYieldDiff)
				print("Property set: "..tostring(ExtraYieldPropertyDictionary(i)).." amount: "..tostring(nYieldDiff))
			end
		end
	end
end
--Game Events--
GameEvents.CityBuilt.Add(OnCityBuiltBBCC)
GameEvents.GameplayBCYAdjustCityYield.Add(OnGameplayBCYAdjustCityYield)

--support
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