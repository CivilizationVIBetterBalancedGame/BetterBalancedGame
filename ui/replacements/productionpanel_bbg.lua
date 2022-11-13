include("ProductionPanel")

--Note this is a rawest form of the GetData() parametric override.
--Big Idea add another include("BBG_ScriptOverrides") file with specific behaviour overides
--Have those overrides and the Types (building/district/unit/project) plus some extra parameters
--Build here a function OverrideResults(Type, ...) that would return a function defined in BBG_ScriptOverrides
--applied to the context of application.
--The OverrideResults function will be replacing my current two functions
--boolean check if monk and check for dynamic district prereq for aqueduct/damm/river watermil

local bMonkKotoku = false --Lua side, needed for enabling monk kotoku. 
--Sql side is split between base.sql change to monk as a unit and monks as religion, to allow for a different binding mechanism
--Same mechanism as any other faith purchase units and any other follower religious belief
--Sql side 2: change to kotoku itself. Located in xp1__rise_and_fall.sql
local bWatermil = false -- Lua side neede for enabling watermil and palgum on aqeuduct, bath, dam
--sql side for watermil in base.sql
--sql side for palgum in nfp_bbg_nfp_babylon.sql

function BBGCanProduce(row, pSelectedCity)
	local buildQueue	= pSelectedCity:GetBuildQueue();
	local bCanProduce = buildQueue:CanProduce( row.Hash, true )

	if bWatermil == false then
		return bCanProduce
	end

	if GameInfo.Buildings[row.Index].BuildingType~='BUILDING_PALGUM' and GameInfo.Buildings[row.Index].BuildingType~='BUILDING_WATER_MILL' then
		print('BBGCanProduce', GameInfo.Buildings[row.Index].BuildingType, bCanProduce)
		return bCanProduce
	end
	
	local iX = pSelectedCity:GetX()
	local iY = pSelectedCity:GetY()
	local pPlot = Map.GetPlot(iX, iY)

	local bHasAqueduct = false
	local bHasBath = false
	local bHasDam = false
	local pCityDistricts = pSelectedCity:GetDistricts()
	local bCanProduce = false
	for _, pDistrict in pCityDistricts:Members() do
		print("Detected districts", _)
		if GameInfo.Districts[pDistrict:GetType()].DistrictType == 'DISTRICT_AQUEDUCT' then
			bHasAqueduct = true
		end
		if GameInfo.Districts[pDistrict:GetType()].DistrictType == 'DISTRICT_BATH' then
			bHasBath = true
		end
		if GameInfo.Districts[pDistrict:GetType()].DistrictType == 'DISTRICT_DAM' then
			bHasDam = true
		end
	end
	if pPlot:IsRiver() then
		bCanProduce = true
		print("Watermill Can produce river", bCanProduce)
		return bCanProduce
	end

	if bHasAqueduct then
		bCanProduce = true
		print("Watermill Can produce aqueduct", bCanProduce)
		return bCanProduce
	end

	if pHasBath then
		bCanProduce = true
		print("Watermill Can produce Bath", bCanProduce)
		return bCanProduce
	end

	if pHasDam then
		bCanProduce = true
		print("Watermill Can produce Dam", bCanProduce)
		return bCanProduce
	end

end

function BBGDeductDynamicDistrictPrereq(row, pSelectedCity)
	local iPrereqDistrict = GameInfo.Buildings[row.Index].PrereqDistrict
	if bWatermil == false then
		return iPrereqDistrict
	end
	if GameInfo.Buildings[row.Index].BuildingType~='BUILDING_PALGUM' and GameInfo.Buildings[row.Index].BuildingType~='BUILDING_WATER_MILL' then
		return iPrereqDistrict
	else
		local iX = pSelectedCity:GetX()
		local iY = pSelectedCity:GetY()
		local pPlot = Map.GetPlot(iX, iY)
		local bHasAqueduct = false
		local bHasBath = false
		local bHasDam = false
		local iPrereqDistrict = 'DISTRICT_CITY_CENTER'
		local pCityDistricts = pSelectedCity:GetDistricts()
		for _, pDistrict in pCityDistricts:Members() do
			if GameInfo.Districts[pDistrict:GetType()].DistrictType == 'DISTRICT_AQUEDUCT' then
				bHasAqueduct = true
			end
			if GameInfo.Districts[pDistrict:GetType()].DistrictType == 'DISTRICT_BATH' then
				bHasBath = true
			end
			if GameInfo.Districts[pDistrict:GetType()].DistrictType == 'DISTRICT_DAM' then
				bHasDam = true
			end
		end
		if pPlot:IsRiver() then
			iPrereqDistrict = 'DISTRICT_CITY_CENTER'
			print('Watermill Prereq Center')
			return iPrereqDistrict
		end
		if bHasAqueduct then
			iPrereqDistrict = 'DISTRICT_AQUEDUCT'
			print('Watermill Prereq Aqueduct')
			return iPrereqDistrict
		end
		if bHasBath then
			iPrereqDistrict = 'DISTRICT_BATH'
			print('Watermill Prereq Bath')
			return iPrereqDistrict
		end
		if bHasDam then
			iPrereqDistrict = 'DISTRICT_DAM'
			print('Watermill Prereq Dam')
			return iPrereqDistrict
		end
	end
end

function MonkOverride(UnitType)
	if GameConfiguration.GetValue("BBGTS_MONK_NERF") == false then
		return false
	end
	if UnitType == 'UNIT_WARRIOR_MONK' then
		return true
	else
		return false
	end
end
-- ===========================================================================
-- Parametric Overide--
-- ===========================================================================

function GetData()
	local playerID	:number = Game.GetLocalPlayer();
	local pPlayer	:table = Players[playerID];
	if (pPlayer == nil) then
		Close();
		return nil;
	end

	local pSelectedCity:table = UI.GetHeadSelectedCity();
	if pSelectedCity == nil then
		Close();
		return nil;
	end

	local cityGrowth	= pSelectedCity:GetGrowth();
	local cityCulture	= pSelectedCity:GetCulture();
	local buildQueue	= pSelectedCity:GetBuildQueue();
	local playerTreasury= pPlayer:GetTreasury();
	local playerReligion= pPlayer:GetReligion();
	local cityGold		= pSelectedCity:GetGold();
	local cityBuildings = pSelectedCity:GetBuildings();
	local cityDistricts = pSelectedCity:GetDistricts();
	local cityID		= pSelectedCity:GetID();
		
	local new_data = {
		City				= pSelectedCity,
		Population			= pSelectedCity:GetPopulation(),
		Owner				= pSelectedCity:GetOwner(),
		Damage				= pPlayer:GetDistricts():FindID( pSelectedCity:GetDistrictID() ):GetDamage(),
		TurnsUntilGrowth	= cityGrowth:GetTurnsUntilGrowth(),
		CurrentTurnsLeft	= buildQueue:GetTurnsLeft(),
		FoodSurplus			= cityGrowth:GetFoodSurplus(),
		CulturePerTurn		= cityCulture:GetCultureYield(),
		TurnsUntilExpansion = cityCulture:GetTurnsUntilExpansion(),
		DistrictItems		= {},
		BuildingItems		= {},
		UnitItems			= {},
		ProjectItems		= {},
		BuildingPurchases	= {},
		UnitPurchases		= {},
		DistrictPurchases	= {},
	};
		
	m_CurrentProductionHash = buildQueue:GetCurrentProductionTypeHash();
	m_PreviousProductionHash = buildQueue:GetPreviousProductionTypeHash();

	--Must do districts before buildings
	for row in GameInfo.Districts() do
		if row.Hash == m_CurrentProductionHash then
			new_data.CurrentProduction = row.Name;
				
			if(GameInfo.DistrictReplaces[row.DistrictType] ~= nil) then
				new_data.CurrentProductionType = GameInfo.DistrictReplaces[row.DistrictType].ReplacesDistrictType;
			else
				new_data.CurrentProductionType = row.DistrictType;
			end
		end
			
		local isInPanelList 		:boolean = (row.Hash ~= m_CurrentProductionHash or not row.OnePerCity) and not row.InternalOnly;
		local bHasProducedDistrict	:boolean = cityDistricts:HasDistrict( row.Index );
		if isInPanelList and ( buildQueue:CanProduce( row.Hash, true ) or bHasProducedDistrict ) then
			local isCanProduceExclusion, results = buildQueue:CanProduce( row.Hash, false, true );
			local isDisabled			:boolean = not isCanProduceExclusion;
				
			-- If at least one valid plot is found where the district can be built, consider it buildable.
			local plots :table = GetCityRelatedPlotIndexesDistrictsAlternative( pSelectedCity, row.Hash );
			if plots == nil or table.count(plots) == 0 then
				-- No plots available for district. Has player had already started building it?
				local isPlotAllocated :boolean = false;
				local pDistricts 		:table = pSelectedCity:GetDistricts();
				for _, pCityDistrict in pDistricts:Members() do
					if row.Index == pCityDistrict:GetType() then
						isPlotAllocated = true;
						break;
					end
				end
				-- If not, this district can't be built. Guarantee that isDisabled is set.
				if not isPlotAllocated then
					isDisabled = true;
				elseif results ~= nil then
					local pFailureReasons : table = results[CityCommandResults.FAILURE_REASONS];
					if pFailureReasons ~= nil and table.count( pFailureReasons ) > 0 then
						for i,v in ipairs(pFailureReasons) do
							if v == TXT_DISTRICT_REPAIR_LOCATION_FLOODED then
								isDisabled = true;
								break;
							end
						end
					end
				end
			elseif isDisabled and results ~= nil then
				-- TODO this should probably be handled in the exposure, for example:
				-- BuildQueue::CanProduce(nDistrictHash, bExclusionTest, bReturnResults, bAllowPurchasingPlots)
				local pFailureReasons : table = results[CityCommandResults.FAILURE_REASONS];
				if pFailureReasons ~= nil and table.count( pFailureReasons ) > 0 then
					-- There are available plots to purchase, it could still be available
					isDisabled = false;
					for i,v in ipairs(pFailureReasons) do
						-- If its disabled for another reason, keep it disabled
						if v ~= "LOC_DISTRICT_ZONE_NO_SUITABLE_LOCATION" then
							isDisabled = true;
							break;
						end
					end
				end
			end
				
			local allReasons			:string = ComposeFailureReasonStrings( isDisabled, results );
			local sToolTip				:string = ToolTipHelper.GetToolTip(row.DistrictType, Game.GetLocalPlayer()) .. allReasons;
				
			local iProductionCost		:number = buildQueue:GetDistrictCost( row.Index );
			local iProductionProgress	:number = buildQueue:GetDistrictProgress( row.Index );

			sToolTip = sToolTip .. "[NEWLINE][NEWLINE]";
			sToolTip = sToolTip .. ComposeProductionCostString( iProductionProgress, iProductionCost);

			local iMaintenanceCost		:number = row.Maintenance or 0;
			if (iMaintenanceCost ~= nil and iMaintenanceCost > 0) then
				local yield = GameInfo.Yields["YIELD_GOLD"];
				if(yield) then
					sToolTip = sToolTip .. "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_MAINTENANCE", iMaintenanceCost, yield.IconString, yield.Name);
				end
			end

			local bIsContaminated:boolean = cityDistricts:IsContaminated( row.Index );
			local iContaminatedTurns:number = 0;
			if bIsContaminated then
				for _, pDistrict in cityDistricts:Members() do
					local kDistrictDef:table = GameInfo.Districts[pDistrict:GetType()];
					if kDistrictDef.PrimaryKey == row.DistrictType then
						local kFalloutManager = Game.GetFalloutManager();
						local pDistrictPlot:table = Map.GetPlot(pDistrict:GetX(), pDistrict:GetY());
						iContaminatedTurns = kFalloutManager:GetFalloutTurnsRemaining(pDistrictPlot:GetIndex());
					end
				end
			end

			table.insert( new_data.DistrictItems, {
				Type				= row.DistrictType, 
				Name				= row.Name, 
				ToolTip				= sToolTip, 
				Hash				= row.Hash, 
				Kind				= row.Kind, 
				TurnsLeft			= buildQueue:GetTurnsLeft( row.DistrictType ), 
				Disabled			= isDisabled, 
				Repair				= cityDistricts:IsPillaged( row.Index ),
				Contaminated		= bIsContaminated,
				ContaminatedTurns	= iContaminatedTurns,
				Cost				= iProductionCost, 
				Progress			= iProductionProgress,
				HasBeenBuilt		= bHasProducedDistrict,
				IsComplete			= cityDistricts:IsComplete( row.Index )
			});
		end

		-- Can it be purchased with gold?
		local isAllowed, kDistrict = ComposeDistrictForPurchase( row, pSelectedCity, "YIELD_GOLD", playerTreasury, "LOC_BUILDING_INSUFFICIENT_FUNDS" );
		if isAllowed then
			table.insert( new_data.DistrictPurchases, kDistrict );
		end

		-- Can it be purchased with faith?
		local isAllowed, kDistrict = ComposeDistrictForPurchase( row, pSelectedCity, "YIELD_FAITH", playerReligion, "LOC_BUILDING_INSUFFICIENT_FAITH" );
		if isAllowed then
			table.insert( new_data.DistrictPurchases, kDistrict );
		end
	end

	--Must do buildings after districts
	for row in GameInfo.Buildings() do
		if row.Hash == m_CurrentProductionHash then
			new_data.CurrentProduction = row.Name;
			new_data.CurrentProductionType= row.BuildingType;
		end

		local bCanProduce = BBGCanProduce(row, pSelectedCity)
		local iPrereqDistrict = "";
		local DynamicPrereqDistrict = BBGDeductDynamicDistrictPrereq(row, pSelectedCity) --FlashyFeeds override
		if DynamicPrereqDistrict ~= nil then 											   --FlashyFeeds override
			iPrereqDistrict = DynamicPrereqDistrict; 									   --FlashyFeeds override
				
			--Only add buildings if the prereq district is not the current production (this can happen when repairing)
			if new_data.CurrentProductionType == DynamicPrereqDistrict then 			   --FlashyFeeds override
				bCanProduce = false;
			end
		end

		if row.Hash ~= m_CurrentProductionHash and (not row.MustPurchase or cityBuildings:IsPillaged(row.Hash)) and bCanProduce then
			local isCanStart, results			 = buildQueue:CanProduce( row.Hash, false, true );
			local isDisabled			:boolean = not isCanStart;

			-- Did it fail and it is a Wonder?  If so, if it failed because of *just* NO_SUITABLE_LOCATION, we can look for an alternate.
			if (isDisabled and row.IsWonder and results ~= nil and results[CityOperationResults.NO_SUITABLE_LOCATION] ~= nil and results[CityOperationResults.NO_SUITABLE_LOCATION] == true) then
				local pPurchaseablePlots :table = GetCityRelatedPlotIndexesWondersAlternative( pSelectedCity, row.Hash );
				if (pPurchaseablePlots and #pPurchaseablePlots > 0) then
					isDisabled = false;
				end
			end

			local allReasons			 :string = ComposeFailureReasonStrings( isDisabled, results );
			local sToolTip 				 :string = ToolTipHelper.GetBuildingToolTip( row.Hash, playerID, pSelectedCity ) .. allReasons;

			local iProductionCost		:number = buildQueue:GetBuildingCost( row.Index );
			local iProductionProgress	:number = buildQueue:GetBuildingProgress( row.Index );
			sToolTip = sToolTip .. "[NEWLINE][NEWLINE]";
			sToolTip = sToolTip .. ComposeProductionCostString( iProductionProgress, iProductionCost);

			local iMaintenanceCost		:number = row.Maintenance or 0;
			if (iMaintenanceCost ~= nil and iMaintenanceCost > 0) then
				local yield = GameInfo.Yields["YIELD_GOLD"];
				if(yield) then
					sToolTip = sToolTip .. "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_MAINTENANCE", iMaintenanceCost, yield.IconString, yield.Name);
				end
			end

			sToolTip = sToolTip .. "[NEWLINE]" .. AddBuildingExtraCostTooltip(row.Hash);
				
			table.insert( new_data.BuildingItems, {
				Type			= row.BuildingType, 
				Name			= row.Name, 
				ToolTip			= sToolTip, 
				Hash			= row.Hash, 
				Kind			= row.Kind, 
				TurnsLeft		= buildQueue:GetTurnsLeft( row.Hash ), 
				Disabled		= isDisabled, 
				Repair			= cityBuildings:IsPillaged( row.Hash ), 
				Cost			= iProductionCost, 
				Progress		= iProductionProgress, 
				IsWonder		= row.IsWonder,
				PrereqDistrict	= iPrereqDistrict,
				PrereqBuildings	= row.PrereqBuildingCollection
			});
		end
			
		-- Can it be purchased with gold?
		if row.PurchaseYield == "YIELD_GOLD" then
			local isAllowed, kBldg = ComposeBldgForPurchase( row, pSelectedCity, "YIELD_GOLD", playerTreasury, "LOC_BUILDING_INSUFFICIENT_FUNDS" );
			if isAllowed then
				table.insert( new_data.BuildingPurchases, kBldg );
			end
		end
		-- Can it be purchased with faith?
		if row.PurchaseYield == "YIELD_FAITH" or cityGold:IsBuildingFaithPurchaseEnabled( row.Hash ) then
			local isAllowed, kBldg = ComposeBldgForPurchase( row, pSelectedCity, "YIELD_FAITH", playerReligion, "LOC_BUILDING_INSUFFICIENT_FAITH" );
			if isAllowed then
				table.insert( new_data.BuildingPurchases, kBldg );
			end
		end
	end

	-- Sort BuildingItems to ensure Buildings are placed behind any Prereqs for that building
	table.sort(new_data.BuildingItems, 
		function(a, b)
			if a.IsWonder then
				return false;
			end
			if a.Disabled == false and b.Disabled == true then
				return true;
			end
			return false;
		end
	);

	for row in GameInfo.Units() do
		if row.Hash == m_CurrentProductionHash then
			new_data.CurrentProduction = row.Name;
			new_data.CurrentProductionType= row.UnitType;
		end

		local kBuildParameters = {};
		kBuildParameters.UnitType = row.Hash;
		kBuildParameters.MilitaryFormationType = MilitaryFormationTypes.STANDARD_MILITARY_FORMATION;

		-- Can it be built normally?
		if not row.MustPurchase and buildQueue:CanProduce( kBuildParameters, true ) and not MonkOverride(row.UnitType) then --FlashyFeeds: Removes Monk From Generic Prod Queuethen
			local isCanProduceExclusion, results	 = buildQueue:CanProduce( kBuildParameters, false, true );
			local nProductionCost		:number = buildQueue:GetUnitCost( row.Index );
			local nProductionProgress	:number = buildQueue:GetUnitProgress( row.Index );
			local isDisabled				:boolean = not isCanProduceExclusion;
			local sAllReasons				 :string = ComposeFailureReasonStrings( isDisabled, results );
			local sToolTip					 :string = ToolTipHelper.GetUnitToolTip( row.Hash, MilitaryFormationTypes.STANDARD_MILITARY_FORMATION, buildQueue ) .. sAllReasons;
				
			local kUnit :table = {
				Type				= row.UnitType, 
				Name				= row.Name, 
				ToolTip				= sToolTip, 
				Hash				= row.Hash, 
				Kind				= row.Kind, 
				TurnsLeft			= buildQueue:GetTurnsLeft( row.Hash ), 
				Disabled			= isDisabled, 
				Civilian			= row.FormationClass == "FORMATION_CLASS_CIVILIAN",
				Cost				= nProductionCost, 
				Progress			= nProductionProgress, 
				Corps				= false,
				CorpsCost			= 0,
				CorpsTurnsLeft		= 1,
				CorpsTooltip		= "",
				CorpsName			= "",
				Army				= false,
				ArmyCost			= 0,
				ArmyTurnsLeft		= 1,
				ArmyTooltip			= "",
				ArmyName			= "",
				ReligiousStrength	= row.ReligiousStrength,
				IsCurrentProduction = row.Hash == m_CurrentProductionHash
			};
				
			-- Should we present options for building Corps or Army versions?
			if results ~= nil then
				if results[CityOperationResults.CAN_TRAIN_CORPS] then
					kBuildParameters.MilitaryFormationType = MilitaryFormationTypes.CORPS_MILITARY_FORMATION;
					local bCanProduceCorps, kResults = buildQueue:CanProduce( kBuildParameters, false, true);
					kUnit.Corps			= true;
					kUnit.CorpsDisabled = not bCanProduceCorps;
					kUnit.CorpsCost		= buildQueue:GetUnitCorpsCost( row.Index );
					kUnit.CorpsTurnsLeft	= buildQueue:GetTurnsLeft( row.Hash, MilitaryFormationTypes.CORPS_MILITARY_FORMATION );
					kUnit.CorpsTooltip, kUnit.CorpsName = ComposeUnitCorpsStrings( row, nProductionProgress, buildQueue );
					local sFailureReasons:string = ComposeFailureReasonStrings( kUnit.CorpsDisabled, kResults );
					kUnit.CorpsTooltip = kUnit.CorpsTooltip .. sFailureReasons;
					kUnit.Cost= kUnit.CorpsCost;
				end
				if results[CityOperationResults.CAN_TRAIN_ARMY] then
					kBuildParameters.MilitaryFormationType = MilitaryFormationTypes.ARMY_MILITARY_FORMATION;
					local bCanProduceArmy, kResults = buildQueue:CanProduce( kBuildParameters, false, true );
					kUnit.Army			= true;
					kUnit.ArmyDisabled	= not bCanProduceArmy;
					kUnit.ArmyCost		= buildQueue:GetUnitArmyCost( row.Index );
					kUnit.ArmyTurnsLeft	= buildQueue:GetTurnsLeft( row.Hash, MilitaryFormationTypes.ARMY_MILITARY_FORMATION );
					kUnit.ArmyTooltip, kUnit.ArmyName = ComposeUnitArmyStrings( row, nProductionProgress, buildQueue );		
					local sFailureReasons:string = ComposeFailureReasonStrings( kUnit.ArmyDisabled, kResults );
					kUnit.ArmyTooltip = kUnit.ArmyTooltip .. sFailureReasons;
					kUnit.Cost = kUnit.CorpsCost;
				end
			end
				
			table.insert(new_data.UnitItems, kUnit );
		end
			
		-- Can it be purchased with gold?
		if row.PurchaseYield == "YIELD_GOLD" then
			local isAllowed, kUnit = ComposeUnitForPurchase( row, pSelectedCity, "YIELD_GOLD", playerTreasury, "LOC_BUILDING_INSUFFICIENT_FUNDS" );
			if isAllowed then
				table.insert( new_data.UnitPurchases, kUnit );
			end
		end
		-- Can it be purchased with faith?
		if row.PurchaseYield == "YIELD_FAITH" or cityGold:IsUnitFaithPurchaseEnabled( row.Hash ) then
			local isAllowed, kUnit = ComposeUnitForPurchase( row, pSelectedCity, "YIELD_FAITH", playerReligion, "LOC_BUILDING_INSUFFICIENT_FAITH" );
			if isAllowed then
				table.insert( new_data.UnitPurchases, kUnit );
			end
		end 
	end
	
	if (pBuildQueue == nil) then
		pBuildQueue = pSelectedCity:GetBuildQueue();
	end

	for row in GameInfo.Projects() do
		if row.Hash == m_CurrentProductionHash then
			new_data.CurrentProduction = row.Name;
			new_data.CurrentProductionType= row.ProjectType;
		end

		if buildQueue:CanProduce( row.Hash, true ) then
			local isCanProduceExclusion, results = buildQueue:CanProduce( row.Hash, false, true );
			local isDisabled			:boolean = not isCanProduceExclusion;
				
			local allReasons		:string	= ComposeFailureReasonStrings( isDisabled, results );
			local sToolTip			:string = ToolTipHelper.GetProjectToolTip( row.Hash) .. allReasons;
				
			local iProductionCost		:number = buildQueue:GetProjectCost( row.Index );
			local iProductionProgress	:number = buildQueue:GetProjectProgress( row.Index );
			sToolTip = sToolTip .. "[NEWLINE]" .. ComposeProductionCostString( iProductionProgress, iProductionCost );
				
			table.insert(new_data.ProjectItems, {
				Type				= row.ProjectType,
				Name				= row.Name, 
				ToolTip				= sToolTip, 
				Hash				= row.Hash, 
				Kind				= row.Kind, 
				TurnsLeft			= buildQueue:GetTurnsLeft( row.ProjectType ), 
				Disabled			= isDisabled, 
				Cost				= iProductionCost, 
				Progress			= iProductionProgress,
				IsCurrentProduction = row.Hash == m_CurrentProductionHash,
				IsRepeatable		= row.MaxPlayerInstances ~= 1 and true or false,
			});
		end
	end

	return new_data;
end

