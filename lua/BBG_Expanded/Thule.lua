-- Lime_Thule_Functions
-- Author: Lime
-- DateCreated: 11/1/2017 16:54:54
--------------------------------------------------------------
--============================================================
-- INCLUDES
--============================================================
include("InstanceManager.lua");
include("SupportFunctions.lua");

--============================================================
-- Functions =================================================
--============================================================

----------------------------------------------------------------------------------------------------------------------------
-- Is Thule Civilization
----------------------------------------------------------------------------------------------------------------------------

function HasCivilizationTrait(civilizationType, traitType)
	for row in GameInfo.CivilizationTraits() do
		if (row.CivilizationType == civilizationType and row.TraitType == traitType) then return true end
	end
	return false
end

function getCityPopulation(PlotX, PlotY)
	local cityOfInterest = Map.GetCityPlot.GetWorkingCity(PlotX, PlotY)
	return cityOfInterest.GetCitizens()
end

-------------------------------------------------------------------------
-- Whale-Spawning
----------------------------------------------------------------------------------------------------------------------------
-- creates a Dummy "whalesperm" improvement, which is immediately replaced with the whales luxury
----------------------------------------------------------------------------------------------------------------------------

local whaleSperm		= GameInfo.Improvements['IMPROVEMENT_LIME_THULE_WHALESPERM'].Index 
local whaleResource		= GameInfo.Resources['RESOURCE_WHALES'].Index

function LimeThule_SpawnWhale(PlotX, PlotY, ImprovementID, PlayerID, ResourceID, Unknown1, Unknown2)
	if (ImprovementID == whaleSperm) then									-- not restricted to player, just needs to be able to make the dummy improvement
		local whaleplot = Map.GetPlot(PlotX, PlotY)
		--print("The Whalesperm improvement has been made! It is at grid X" .. PlotX .. ",Y" .. PlotY)
		if (Cities.GetPlotPurchaseCity(whaleplot:GetIndex()):GetPopulation() >= 2) then
			Cities.GetPlotPurchaseCity(whaleplot:GetIndex()):ChangePopulation(-1)
			--print("The necessary population has been sacrificed")
			ImprovementBuilder.SetImprovementType(whaleplot, -1, 0)
			--print("Whalesperm has been removed to make way for whales...")
			ResourceBuilder.SetResourceType(whaleplot, whaleResource, 1)
			--print("Whales successfully sperminated!")
			else
			ImprovementBuilder.SetImprovementType(whaleplot, -1, 0) -- formerly necessary, now a failsafe
			--print("url city is 2 shit for whales git fukt")
		end
	end
end

Events.ImprovementAddedToMap.Add(LimeThule_SpawnWhale);

print("Load Successful");