-- ===========================================================================
--	Input for placing items on the world map.
--	Copyright 2015-2016, Firaxis Games
--
--	To hot-reload, save this then re-save the file that imports the file 
--	(e.g., WorldInput)
-- ===========================================================================
include("SupportFunctions.lua");
include("AdjacencyBonusSupport.lua");
include("PopupDialog");
include("Civ6Common.lua");
print("StrategicView_MapPlacement for BBG")

-- ===========================================================================
--	MEMBERS
-- ===========================================================================
local m_hexesDistrictPlacement			:table	= {};	-- Re-usable collection of hexes; what is sent across the wire.
local m_cachedSelectedPlacementPlotId	:number = -1;	-- Hex the cursor is currently focused on

local m_AdjacencyBonusDistricts : number = UILens.CreateLensLayerHash("Adjacency_Bonus_Districts");
local m_Districts : number = UILens.CreateLensLayerHash("Districts");

local bWasCancelled:boolean = true;

-- ===========================================================================
function SetInsertModeParams( tParameters:table )
	tParameters[CityOperationTypes.PARAM_INSERT_MODE] = UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_INSERT_MODE);
	tParameters[CityOperationTypes.PARAM_QUEUE_LOCATION] = UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_QUEUE_LOCATION);
	tParameters[CityOperationTypes.PARAM_QUEUE_SOURCE_LOCATION] = UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_QUEUE_SOURCE_LOCATION);
	tParameters[CityOperationTypes.PARAM_QUEUE_DESTINATION_LOCATION] = UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_QUEUE_DESTINATION_LOCATION);
end

-- ===========================================================================
-- Code related to the Wonder Placement interface mode
-- ===========================================================================
function ConfirmPlaceWonder( pInputStruct:table )
    local plotId = UI.GetCursorPlotID();
	if (not Map.IsPlot(plotId)) then
		return false;
	end

    local kPlot = Map.GetPlotByIndex(plotId);
			
	local eBuilding = UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_BUILDING_TYPE);

	local tParameters = {};
	tParameters[CityOperationTypes.PARAM_X] = kPlot:GetX();
	tParameters[CityOperationTypes.PARAM_Y] = kPlot:GetY();
	tParameters[CityOperationTypes.PARAM_BUILDING_TYPE] = eBuilding;
	
	SetInsertModeParams(tParameters);

	local pSelectedCity = UI.GetHeadSelectedCity();
	if (pSelectedCity ~= nil) then
		local pBuildingInfo = GameInfo.Buildings[eBuilding];
		local bCanStart, tResults = CityManager.CanStartOperation( pSelectedCity, CityOperationTypes.BUILD, tParameters, true);
		if pBuildingInfo ~= nil and bCanStart then
			
			local sConfirmText	:string = Locale.Lookup("LOC_DISTRICT_ZONE_CONFIRM_WONDER_POPUP", pBuildingInfo.Name);

			if (tResults ~= nil and tResults[CityOperationResults.SUCCESS_CONDITIONS] ~= nil) then
				if (table.count(tResults[CityOperationResults.SUCCESS_CONDITIONS]) ~= 0) then
					sConfirmText = sConfirmText .. "[NEWLINE]";
				end
				for i,v in ipairs(tResults[CityOperationResults.SUCCESS_CONDITIONS]) do
					sConfirmText = sConfirmText .. "[NEWLINE]" .. Locale.Lookup(v);
				end
			end
			local pPopupDialog :table = PopupDialogInGame:new("PlaceWonderAt_X" .. kPlot:GetX() .. "_Y" .. kPlot:GetY()); -- unique identifier
			pPopupDialog:AddText(sConfirmText);
			pPopupDialog:AddConfirmButton(Locale.Lookup("LOC_YES"), function()
				CityManager.RequestOperation(pSelectedCity, CityOperationTypes.BUILD, tParameters);
				UI.PlaySound("Build_Wonder");
				ExitPlacementMode();
			end);
			pPopupDialog:AddCancelButton(Locale.Lookup("LOC_NO"), nil);
			pPopupDialog:Open();
		end
	else
		ExitPlacementMode( true );
	end
						
	return true;
end

-- ===========================================================================
--	Find the artdef (texture) for the plots we are considering
-- ===========================================================================
function RealizePlotArtForWonderPlacement()
	-- Reset the master table of hexes, tracking what will be sent to the engine.
	m_hexesDistrictPlacement = {};	
	m_cachedSelectedPlacementPlotId = -1;
	local kNonShadowHexes:table = {};		-- Holds plot IDs of hexes to not be shadowed.

	UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
	UILens.SetActive("DistrictPlacement");	-- turn on all district layers and district adjacency bonus layers

	local pSelectedCity = UI.GetHeadSelectedCity();
	if pSelectedCity ~= nil then

		local buildingHash:number	= UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_BUILDING_TYPE);
		local building:table		= GameInfo.Buildings[buildingHash];
		local tParameters :table	= {};
		tParameters[CityOperationTypes.PARAM_BUILDING_TYPE] = buildingHash;

		local tResults :table = CityManager.GetOperationTargets( pSelectedCity, CityOperationTypes.BUILD, tParameters );
		-- Highlight the plots where the city can place the wonder
		if (tResults[CityOperationResults.PLOTS] ~= nil and table.count(tResults[CityOperationResults.PLOTS]) ~= 0) then			
			local kPlots		= tResults[CityOperationResults.PLOTS];			
			for i, plotId in ipairs(kPlots) do

				local kPlot		:table			= Map.GetPlotByIndex(plotId);						
				local plotInfo	:table			= GetViewPlotInfo( kPlot, m_hexesDistrictPlacement );
				plotInfo.hexArtdef				= "Placement_Valid"; 
				plotInfo.selectable				= true;
				m_hexesDistrictPlacement[plotId]= plotInfo;
				
				table.insert( kNonShadowHexes, plotId );
			end	
		end

		-- Plots that aren't owned, but could be (and hence, could be a great spot for that wonder!)		
		tParameters = {};
		tParameters[CityCommandTypes.PARAM_PLOT_PURCHASE] = UI.GetInterfaceModeParameter(CityCommandTypes.PARAM_PLOT_PURCHASE);
		local tResults = CityManager.GetCommandTargets( pSelectedCity, CityCommandTypes.PURCHASE, tParameters );
		if (tResults[CityCommandResults.PLOTS] ~= nil and table.count(tResults[CityCommandResults.PLOTS]) ~= 0) then
			local kPurchasePlots = tResults[CityCommandResults.PLOTS];
			for i, plotId in ipairs(kPurchasePlots) do
				
				-- Highlight any purchaseable plot the Wonder could go on
				local kPlot		:table			= Map.GetPlotByIndex(plotId);							
				
				if kPlot:CanHaveWonder(building.Index, pSelectedCity:GetOwner(), pSelectedCity:GetID()) then
					local plotInfo	:table			= GetViewPlotInfo( kPlot, m_hexesDistrictPlacement );
					plotInfo.hexArtdef				= "Placement_Purchase"; 
					plotInfo.selectable				= true;
					plotInfo.purchasable			= true;
					m_hexesDistrictPlacement[plotId]= plotInfo;
				end
			end
		end

		-- Send all the hex information to the engine for visualization.
		for i,plotInfo in pairs(m_hexesDistrictPlacement) do
			UILens.SetAdjacencyBonusDistict( plotInfo.index, plotInfo.hexArtdef, plotInfo.adjacent );
		end

		LuaEvents.StrategicView_MapPlacement_AddDistrictPlacementShadowHexes( kNonShadowHexes );
	end
end

-- ===========================================================================
--	Mode to place a Wonder Building
-- ===========================================================================
function OnInterfaceModeEnter_BuildingPlacement( eNewMode:number )
	UI.SetFixedTiltMode( true );
	UIManager:SetUICursor(CursorTypes.RANGE_ATTACK); --here?
	bWasCancelled = true; -- We assume it was cancelled unless explicitly not cancelled
	RealizePlotArtForWonderPlacement();
end

-- ===========================================================================
--	Guaranteed to be called when leaving building placement
-- ===========================================================================
function OnInterfaceModeLeave_BuildingPlacement( eNewMode:number )	
	LuaEvents.StrategicView_MapPlacement_ClearDistrictPlacementShadowHexes();
	UI.SetFixedTiltMode( false );
	local eCurrentMode:number = UI.GetInterfaceMode();
	if eCurrentMode ~= InterfaceModeTypes.VIEW_MODAL_LENS then
		-- Don't open the production panel if we're going to a modal lens as it will overwrite the modal lens
		LuaEvents.StrageticView_MapPlacement_ProductionOpen(bWasCancelled);
	end
end

-- ===========================================================================
--	Explicitly leaving district placement; may not be called if the user
--	is entering another mode by selecting a different UI element which in-turn
--	triggers the exit.
-- ===========================================================================
function ExitPlacementMode( isCancelled:boolean )
	bWasCancelled = isCancelled ~= nil and isCancelled or false;	
	UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
end

-- ===========================================================================
--	Confirm before placing a district down
-- ===========================================================================
function ConfirmPlaceDistrict( pInputStruct:table)
	
	local plotId = UI.GetCursorPlotID();
	if (not Map.IsPlot(plotId)) then
		return;
	end

	local kPlot = Map.GetPlotByIndex(plotId);
			
	local districtHash:number = UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_DISTRICT_TYPE);
	local purchaseYield = UI.GetInterfaceModeParameter(CityCommandTypes.PARAM_YIELD_TYPE);
	local bIsPurchase:boolean = false;
	if (purchaseYield ~= nil and (purchaseYield == YieldTypes.GOLD or purchaseYield == YieldTypes.FAITH)) then
		bIsPurchase = true;
	end

	local tParameters = {};
	tParameters[CityOperationTypes.PARAM_X] = kPlot:GetX();
	tParameters[CityOperationTypes.PARAM_Y] = kPlot:GetY();
	tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE] = districtHash;
	tParameters[CityCommandTypes.PARAM_YIELD_TYPE] = purchaseYield;

	SetInsertModeParams(tParameters);

	local pSelectedCity = UI.GetHeadSelectedCity();
	if (pSelectedCity ~= nil) then
		local pDistrictInfo = GameInfo.Districts[districtHash];
		local bCanStart;
		local tResults;
		if (bIsPurchase) then
			bCanStart, tResults = CityManager.CanStartCommand( pSelectedCity, CityCommandTypes.PURCHASE, tParameters, true);
			print("investigate purchase")
			print(bCanStart)
			if type(tResults)~="table" then
				print(tResults)
			else
				print(BuildRecursiveDataString(tResults))
			end
		else
			bCanStart, tResults = CityManager.CanStartOperation( pSelectedCity, CityOperationTypes.BUILD, tParameters, true);
			print("investigate build")
			print(bCanStart)
			if type(tResults)~="table" then
				print(tResults)
			else
				print(BuildRecursiveDataString(tResults))
			end
		end
		if pDistrictInfo ~= nil and bCanStart then
			
			local sConfirmText	:string = Locale.Lookup("LOC_DISTRICT_ZONE_CONFIRM_DISTRICT_POPUP", pDistrictInfo.Name);

			if (tResults ~= nil and tResults[CityOperationResults.SUCCESS_CONDITIONS] ~= nil) then
				if (table.count(tResults[CityOperationResults.SUCCESS_CONDITIONS]) ~= 0) then
					sConfirmText = sConfirmText .. "[NEWLINE]";
				end
				for i,v in ipairs(tResults[CityOperationResults.SUCCESS_CONDITIONS]) do
					print(type(v))
					local txt = Locale.Lookup("LOC_DISTRICT_ZONE_WILL_REMOVE_FEATURE", GameInfo.Features[12].Name)
					print(Locale.Lookup(txt))
					print(v)
					sConfirmText = sConfirmText .. "[NEWLINE]" .. Locale.Lookup(v);
				end
			end
			local pPopupDialog :table = PopupDialogInGame:new("PlaceDistrictAt_X" .. kPlot:GetX() .. "_Y" .. kPlot:GetY()); -- unique identifier
			pPopupDialog:AddText(sConfirmText);
			if (bIsPurchase) then
				if (IsTutorialRunning()) then
					CityManager.RequestCommand(pSelectedCity, CityCommandTypes.PURCHASE, tParameters);
					ExitPlacementMode();
				else
					pPopupDialog:AddConfirmButton(Locale.Lookup("LOC_YES"), function()
						CityManager.RequestCommand(pSelectedCity, CityCommandTypes.PURCHASE, tParameters);
						ExitPlacementMode();
					end);
				end
			else
				if (IsTutorialRunning()) then
					CityManager.RequestOperation(pSelectedCity, CityOperationTypes.BUILD, tParameters);
					ExitPlacementMode();
				else
					pPopupDialog:AddConfirmButton(Locale.Lookup("LOC_YES"), function()
						CityManager.RequestOperation(pSelectedCity, CityOperationTypes.BUILD, tParameters);
						ExitPlacementMode();
					end);
				end
			end

			if (not IsTutorialRunning()) then
				pPopupDialog:AddCancelButton(Locale.Lookup("LOC_NO"), nil);
				pPopupDialog:Open();
			end
		end
	else
		ExitPlacementMode( true );
	end
end

-- ===========================================================================
--	Find the artdef (texture) for the plot itself as well as the icons
--	that are on the borders signifying why a hex receives a certain bonus.
-- ===========================================================================
function RealizePlotArtForDistrictPlacement()
	-- Reset the master table of hexes, tracking what will be sent to the engine.
	m_hexesDistrictPlacement = {};	
	m_cachedSelectedPlacementPlotId = -1;
	local kNonShadowHexes:table = {};		-- Holds plot IDs of hexes to not be shadowed.

	UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
	UILens.SetActive("DistrictPlacement");	-- turn on all district layers and district adjacency bonus layers

	local pSelectedCity = UI.GetHeadSelectedCity();
	if pSelectedCity ~= nil then

		local districtHash:number	= UI.GetInterfaceModeParameter(CityOperationTypes.PARAM_DISTRICT_TYPE);
		local district:table		= GameInfo.Districts[districtHash];
		local tParameters :table	= {};
		tParameters[CityOperationTypes.PARAM_DISTRICT_TYPE] = districtHash;

		local tResults :table = CityManager.GetOperationTargets( pSelectedCity, CityOperationTypes.BUILD, tParameters );
		-- Highlight the plots where the city can place the district


		if (tResults[CityOperationResults.PLOTS] ~= nil and table.count(tResults[CityOperationResults.PLOTS]) ~= 0) then			
			local kPlots		= tResults[CityOperationResults.PLOTS];			
			for i, plotId in ipairs(kPlots) do

				local kPlot		:table			= Map.GetPlotByIndex(plotId);						
				local plotInfo	:table			= GetViewPlotInfo( kPlot, m_hexesDistrictPlacement );
				plotInfo.hexArtdef				= "Placement_Valid"; 
				plotInfo.selectable				= true;
				m_hexesDistrictPlacement[plotId]= plotInfo;
				
				local kAdjacentPlotBonuses:table = AddAdjacentPlotBonuses( kPlot, district.DistrictType, pSelectedCity, m_hexesDistrictPlacement );
				for plotIndex, districtViewInfo in pairs(kAdjacentPlotBonuses) do
					m_hexesDistrictPlacement[plotIndex] = districtViewInfo;
				end

				table.insert( kNonShadowHexes, plotId );
			end	
		end

		-- Plots that arent't owned, but could be (and hence, could be a great spot for that district!)		
		tParameters = {};
		tParameters[CityCommandTypes.PARAM_PLOT_PURCHASE] = UI.GetInterfaceModeParameter(CityCommandTypes.PARAM_PLOT_PURCHASE);
		local tResults = CityManager.GetCommandTargets( pSelectedCity, CityCommandTypes.PURCHASE, tParameters );
		if (tResults[CityCommandResults.PLOTS] ~= nil and table.count(tResults[CityCommandResults.PLOTS]) ~= 0) then
			local kPurchasePlots = tResults[CityCommandResults.PLOTS];
			for i, plotId in ipairs(kPurchasePlots) do
				
				-- Only highlight certain plots (usually if there is a bonus to be gained).
				local kPlot		:table			= Map.GetPlotByIndex(plotId);

				if kPlot:CanHaveDistrict(district.Index, pSelectedCity:GetOwner(), pSelectedCity:GetID()) then
					local plotInfo	:table			= GetViewPlotInfo( kPlot, m_hexesDistrictPlacement );
					plotInfo.hexArtdef				= "Placement_Purchase"; 
					plotInfo.selectable				= true;
					plotInfo.purchasable			= true;
					m_hexesDistrictPlacement[plotId]= plotInfo;
				end
			end
		end
		

		-- Send all the hex information to the engine for visualization.
		for i,plotInfo in pairs(m_hexesDistrictPlacement) do
			UILens.SetAdjacencyBonusDistict( plotInfo.index, plotInfo.hexArtdef, plotInfo.adjacent );
		end

		LuaEvents.StrategicView_MapPlacement_AddDistrictPlacementShadowHexes( kNonShadowHexes );
	end
end

-- ===========================================================================
--	Show the different potential district placement areas...
-- ===========================================================================
function OnInterfaceModeEnter_DistrictPlacement( eNewMode:number )
	RealizePlotArtForDistrictPlacement();
	bWasCancelled = true; -- We assume it was cancelled unless explicitly not cancelled
	UI.SetFixedTiltMode( true );
end

function OnInterfaceModeLeave_DistrictPlacement( eNewMode:number )
	LuaEvents.StrategicView_MapPlacement_ClearDistrictPlacementShadowHexes();	
	UI.SetFixedTiltMode( false );
	local eCurrentMode:number = UI.GetInterfaceMode();
	if eCurrentMode ~= InterfaceModeTypes.VIEW_MODAL_LENS then
		-- Don't open the production panel if we're going to a modal lens as it will overwrite the modal lens
		LuaEvents.StrageticView_MapPlacement_ProductionOpen(bWasCancelled);
	end
end

-- ===========================================================================
--	
-- ===========================================================================
function OnCityMadePurchase_StrategicView_MapPlacement(owner:number, cityID:number, plotX:number, plotY:number, purchaseType, objectType)
	if owner ~= Game.GetLocalPlayer() then
		return;
	end
    if purchaseType == EventSubTypes.PLOT then

		-- Make sure city made purchase and it's the right mode.
		if (UI.GetInterfaceMode() == InterfaceModeTypes.DISTRICT_PLACEMENT) then
			-- Clear existing art then re-realize
			UILens.ClearLayerHexes( m_AdjacencyBonusDistricts );
			UILens.ClearLayerHexes( m_Districts );
			RealizePlotArtForDistrictPlacement();
		elseif (UI.GetInterfaceMode() == InterfaceModeTypes.BUILDING_PLACEMENT) then
			-- Clear existing art then re-realize
			UILens.ClearLayerHexes( m_AdjacencyBonusDistricts );
			UILens.ClearLayerHexes( m_Districts );
			RealizePlotArtForWonderPlacement();
		end
    end
end

-- ===========================================================================
--	Whenever the mouse moves while in district or wonder placement mode.
-- ===========================================================================
function RealizeCurrentPlaceDistrictOrWonderPlot()
	local currentPlotId	:number = UI.GetCursorPlotID();
	if (not Map.IsPlot(currentPlotId)) then
		return;
	end

	if currentPlotId == m_cachedSelectedPlacementPlotId then
		return;
	end

	-- Reset the artdef for the currently selected hex
	if m_cachedSelectedPlacementPlotId ~= nil and m_cachedSelectedPlacementPlotId ~= -1 then
		local hex:table = m_hexesDistrictPlacement[m_cachedSelectedPlacementPlotId];
		if hex ~= nil and hex.hexArtdef ~= nil and hex.selectable then			
			UILens.UnFocusHex( m_Districts, hex.index, hex.hexArtdef );
		end
	end

	m_cachedSelectedPlacementPlotId = currentPlotId;

	-- New HEX update it to the selected form.
	if m_cachedSelectedPlacementPlotId ~= -1 then
		local hex:table = m_hexesDistrictPlacement[m_cachedSelectedPlacementPlotId];
		if hex ~= nil and hex.hexArtdef ~= nil and hex.selectable then			
			UILens.FocusHex( m_Districts, hex.index, hex.hexArtdef );
		end
	end
end

--==========Support========--
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

function IDToPos(List, SearchItem)
	if List == nil then
		return false
	end
	if List == {} then
		return false
	end
    if SearchItem==nil then
        return
    end
    for i, item in ipairs(List) do
        if item == SearchItem then
            return i;
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

function GetAdjacentTiles(plot, index)
	-- This is an extended version of Firaxis, moving like a clockwise snail on the hexagon grids
	local gridWidth, gridHeight = Map.GetGridSize();
	local count = 0;
	local k = 0;
	local adjacentPlot = nil;
	local adjacentPlot2 = nil;
	local adjacentPlot3 = nil;
	local adjacentPlot4 = nil;
	local adjacentPlot5 = nil;


	-- Return Spawn if index < 0
	if(plot ~= nil and index ~= nil) then
		if (index < 0) then
			return plot;
		end

		else

		__Debug("GetAdjacentTiles: Invalid Arguments");
		return nil;
	end

	

	-- Return Starting City Circle if index between #0 to #5 (like Firaxis' GetAdjacentPlot) 
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			if (adjacentPlot ~= nil and index == i) then
				return adjacentPlot
			end
		end
	end

	-- Return Inner City Circle if index between #6 to #17

	count = 5;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot2 = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
		end

		for j = i, i+1 do
			--__Debug(i, j)
			k = j;
			count = count + 1;

			if (k == 6) then
				k = 0;
			end

			if (adjacentPlot2 ~= nil) then
				if(adjacentPlot2:GetX() >= 0 and adjacentPlot2:GetY() < gridHeight) then
					adjacentPlot = Map.GetAdjacentPlot(adjacentPlot2:GetX(), adjacentPlot2:GetY(), k);

					else

					adjacentPlot = nil;
				end
			end
		

			if (adjacentPlot ~=nil) then
				if(index == count) then
					return adjacentPlot
				end
			end

		end
	end

	-- #18 to #35 Outer city circle
	count = 0;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 1;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 2;
			if(index == count) then
				return adjacentPlot2;
			end
		end

	end

	--  #35 #59 These tiles are outside the workable radius of the city
	local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			terrainType = adjacentPlot2:GetTerrainType();
			if (adjacentPlot2 ~=nil) then
				count = 36 + i * 4;
				if(index == count) then
					return adjacentPlot2;
				end
			end

		end

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 1;
					if(index == count) then
						return adjacentPlot2;
					end
				end
			end


		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 2;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
					else
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
				end
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 3;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

	end

	--  > #60 to #90

local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i); --first ring
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i); --2nd ring
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i); --3rd ring
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i); --4th ring
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5;
			if(index == count) then
				return adjacentPlot2; --5th ring
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot5 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
				end
				else
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i +1);
				end
			end
		end


		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 1;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1);
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 2;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 3;
			if(index == count) then
				return adjacentPlot2;
			end

		end
		
		adjacentPlot2 = nil

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0); --5th ring
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1); --5th ring
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 4;
			if(index == count) then
				return adjacentPlot2;
			end

		end

	end

end
