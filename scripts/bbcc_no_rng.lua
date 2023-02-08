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
	if pCity == nil then
		return
	end
	print("BCY: Yield Recalculation Started")
	local pPlot = Map.GetPlot(iX, iY)
	local nFood = pPlot:GetYield(0)
	print("Food",nFood)
	local nProd = pPlot:GetYield(1)
	print("Prod", nProd)
	local nGold = pPlot:GetYield(2)
	print("Gold", nGold)
	local nFaith = pPlot:GetYield(5)
	print("Faith", nFaith)
	local nCult = pPlot:GetYield(4)
	print("Cult", nCult)
	local nSci = pPlot:GetYield(3)
	print("Sci", nSci)
	local iTerrain = pPlot:GetTerrainType()
	--flats
	if iTerrain==0 or iTerrain==3 or iTerrain==6 or iTerrain==9 or iTerrain==12 then
		local nFoodDiff = nFood - GameInfo.Flat_CutOffYieldValues[0].Amount
		if nFoodDiff>0 then
			for i=1, nFoodDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_FOOD_BBCC')
			end
		end
		local nProdDiff = nProd - GameInfo.Flat_CutOffYieldValues[1].Amount
		if nProdDiff>0 then
			for i=1, nProdDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_PROD_BBCC')
			end
		end
		local nGoldDiff = nGold - GameInfo.Flat_CutOffYieldValues[2].Amount
		if nGoldDiff>0 then
			for i=1, nGoldDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_GOLD_BBCC')
			end
		end
		local nFaithDiff = nFaith - GameInfo.Flat_CutOffYieldValues[3].Amount
		if nFaithDiff>0 then
			for i=1, nFaithDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_FAITH_BBCC')
			end
		end
		local nCultDiff = nCult - GameInfo.Flat_CutOffYieldValues[4].Amount
		if nCultDiff>0 then
			for i=1, nCultDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_CULT_BBCC')
			end
		end
		local nSciDiff = nSci - GameInfo.Flat_CutOffYieldValues[5].Amount
		if nSciDiff>0 then
			for i=1, nSciDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_SCI_BBCC')
			end
		end
	end
	--hills
	if iTerrain==1 or iTerrain==4 or iTerrain==7 or iTerrain==10 or iTerrain==13 then
		local nFoodDiff = nFood - GameInfo.Hill_CutOffYieldValues[0].Amount
		if nFoodDiff>0 then
			for i=1, nFoodDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_FOOD_BBCC')
			end
		end
		local nProdDiff = nProd - GameInfo.Hill_CutOffYieldValues[1].Amount
		if nProdDiff>0 then
			for i=1, nProdDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_PROD_BBCC')
			end
		end
		local nGoldDiff = nGold - GameInfo.Hill_CutOffYieldValues[2].Amount
		if nGoldDiff>0 then
			for i=1, nGoldDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_GOLD_BBCC')
			end
		end
		local nFaithDiff = nFaith - GameInfo.Hill_CutOffYieldValues[3].Amount
		if nFaithDiff>0 then
			for i=1, nFaithDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_FAITH_BBCC')
			end
		end
		local nCultDiff = nCult - GameInfo.Hill_CutOffYieldValues[4].Amount
		if nCultDiff>0 then
			for i=1, nCultDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_CULT_BBCC')
			end
		end
		local nSciDiff = nSci - GameInfo.Hill_CutOffYieldValues[5].Amount
		if nSciDiff>0 then
			for i=1, nSciDiff do
				pCity:AttachModifierByID('MODIFIER_REMOVE_DYN_SCI_BBCC')
			end
		end
	end
end
--Game Events--
GameEvents.CityBuilt.Add(OnCityBuiltBBCC)
GameEvents.GameplayBCYAdjustCityYield.Add(OnGameplayBCYAdjustCityYield)