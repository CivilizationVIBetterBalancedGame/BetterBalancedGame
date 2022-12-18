-------------------------------------------------------------------------------
-- TRADE PANEL
-------------------------------------------------------------------------------
print("TradeRouteChooser BBG loaded")

include("InstanceManager");
include("SupportFunctions");
include("Colors");
include("TradeSupport");

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================

local DESTINATION_SCROLLPANEL_RELATIVE_Y:number = -34;

-- ===========================================================================
--	VARIABLES
-- ===========================================================================

local m_RouteChoiceIM			: table = InstanceManager:new("RouteChoiceInstance", "Top", Controls.RouteChoiceStack);

-- Note, we are tracking the owner/ID for the origin/destination cities.  It is not safe to hold on to a C++ side object pointer
local m_originCityOwner			: number = -1;	-- City where the trade route will begin
local m_originCityID			: number = -1;
local m_destinationCityOwner	: number = -1;	-- City where the trade route will end, nil if none selected
local m_destinationCityID		: number = -1;
local m_pTradeOverviewContext	: table = nil;	-- Trade Overview context

local m_selectedUnit			:table = nil;

-- These can be set by other contexts to have a route selected automatically after the chooser opens
local m_postOpenSelectPlayerID:number = -1;
local m_postOpenSelectCityID:number = -1;

-- Filtered and unfiltered lists of possible destinations

-- Table of entries, where the entry contains the city owner/ID and path from the origin.
local m_unfilteredDestinations:table = {};
-- Table of indices into the unfiltered table
local m_filteredDestinations:table = {};

-- Stores filter list and tracks the currently selected list
local m_filterList:table = {};
local m_filterSelected:number = 1;
local m_filterSelectedName:string = "LOC_ROUTECHOOSER_FILTER_ALL";

local m_TradeRoute : number = UILens.CreateLensLayerHash("TradeRoutes");

-- ===========================================================================
function GetOriginCity()
	if m_originCityOwner ~= -1 then
		return CityManager.GetCity(m_originCityOwner, m_originCityID);
	end
end

-- ===========================================================================
function GetDestinationCity()
	if m_destinationCityOwner ~= -1 then
		return CityManager.GetCity(m_destinationCityOwner, m_destinationCityID);
	end
end

-- ===========================================================================
function FindDestinationEntry(cityOwner:number, cityID:number)

	for index, entry in ipairs(m_unfilteredDestinations) do
		if entry.id == cityID and entry.owner == cityOwner then
			return entry;
		end
	end

end

-- ===========================================================================
--	Refresh
-- ===========================================================================
function Refresh()
	m_selectedUnit = UI.GetHeadSelectedUnit();
	if m_selectedUnit == nil then
		Close();
		return;
	end

	local originCity = Cities.GetCityInPlot(m_selectedUnit:GetX(), m_selectedUnit:GetY());
	if originCity == nil then
		Close();
		return;
	else
		m_originCityOwner = originCity:GetOwner();
		m_originCityID = originCity:GetID();
	end

	RefreshHeader();

	RefreshTopPanel();

	RefreshChooserPanel();
end

-- ===========================================================================
function RefreshHeader()
	local originCity = GetOriginCity();
	if originCity then
		Controls.Header_OriginText:SetText(Locale.Lookup("LOC_ROUTECHOOSER_TO_DESTINATION", Locale.ToUpper(originCity:GetName())));
	end
end

-- ===========================================================================
function RefreshTopPanel()
	local destinationCity = GetDestinationCity();
	local originCity = GetOriginCity();
	if destinationCity ~= nil and originCity ~= nil then
		-- Update City Banner
		Controls.CityName:SetText(Locale.ToUpper(destinationCity:GetName()));

		local backColor:number, frontColor:number  = UI.GetPlayerColors( destinationCity:GetOwner() );

		Controls.BannerBase:SetColor( backColor );
		Controls.CityName:SetColor( frontColor );

		-- Update Trading Post Icon
		if destinationCity:GetTrade():HasActiveTradingPost(originCity:GetOwner()) then
			Controls.TradingPostIcon:SetHide(false);
		else
			Controls.TradingPostIcon:SetHide(true);
		end

		-- Update City-State Quest Icon
		Controls.CityStateQuestIcon:SetHide(true);
		local questsManager	: table = Game.GetQuestsManager();
		local questTooltip	: string = Locale.Lookup("LOC_CITY_STATES_QUESTS");
		if (questsManager ~= nil and Game.GetLocalPlayer() ~= nil) then
			local tradeRouteQuestInfo:table = GameInfo.Quests["QUEST_SEND_TRADE_ROUTE"];
			if (tradeRouteQuestInfo ~= nil) then
				if (questsManager:HasActiveQuestFromPlayer(Game.GetLocalPlayer(), destinationCity:GetOwner(), tradeRouteQuestInfo.Index)) then
					questTooltip = questTooltip .. "[NEWLINE]" .. tradeRouteQuestInfo.IconString .. questsManager:GetActiveQuestName(Game.GetLocalPlayer(), destinationCity:GetOwner(), tradeRouteQuestInfo.Index);
					Controls.CityStateQuestIcon:SetHide(false);
					Controls.CityStateQuestIcon:SetToolTipString(questTooltip);
				end
			end
		end

		-- Update distance to city
		local distanceToDestination:number = Map.GetPlotDistance(originCity:GetX(), originCity:GetY(), destinationCity:GetX(), destinationCity:GetY());
		Controls.DistenceToCity:SetColor( frontColor );
		Controls.DistenceToCity:SetText(distanceToDestination);

		-- Origin ---------------------------------------------

		Controls.OriginResourceList:DestroyAllChildren();

		local originReceivedResources:boolean = false;
		local kOriginRouteInfo:table = GetYieldsForRoute(originCity, destinationCity);

		for yieldIndex=1, #kOriginRouteInfo.kYieldValues, 1 do
			local yieldValue = kOriginRouteInfo.kYieldValues[yieldIndex];
			if (yieldValue ~= 0 ) then
				local yieldInfo = GameInfo.Yields[yieldIndex - 1];
				AddYieldResourceEntry(yieldInfo, yieldValue, Controls.OriginResourceList);
				originReceivedResources = true;
			end
		end

		if kOriginRouteInfo.MajorityReligion > 0 and kOriginRouteInfo.ReligionPressure > 0 then
			AddReligiousPressureResourceEntry(GameInfo.Religions[kOriginRouteInfo.MajorityReligion], kOriginRouteInfo.ReligionPressure, true, Controls.OriginResourceList);
			originReceivedResources = true;
		end

		Controls.OriginResources:SetToolTipString(kOriginRouteInfo.TooltipText);
		Controls.OriginResourceHeader:SetText(Locale.Lookup("LOC_ROUTECHOOSER_RECEIVES_RESOURCE", Locale.Lookup(originCity:GetName())));
		Controls.OriginResources:RegisterSizeChanged( function() ResizeResourceBackgroundColumns(Controls.OriginResources, Controls.OriginResourcesLeftColumn, Controls.OriginResourcesRightColumn); end );

		if originReceivedResources then
			Controls.OriginReceivesNoBenefitsLabel:SetHide(true);
		else
			Controls.OriginReceivesNoBenefitsLabel:SetHide(false);
		end

		-- Destination --------------------------------------------------------------------
		
		Controls.DestinationResourceList:DestroyAllChildren();

		local destinationReceivedResources:boolean = false;
		local kDestRouteInfo:table = GetYieldsForRoute(originCity, destinationCity, true);

		for yieldIndex=1, #kDestRouteInfo.kYieldValues, 1 do
			local yieldValue = kDestRouteInfo.kYieldValues[yieldIndex];
			if (yieldValue ~= 0 ) then
				local yieldInfo = GameInfo.Yields[yieldIndex - 1];
				AddYieldResourceEntry(yieldInfo, yieldValue, Controls.DestinationResourceList);
				destinationReceivedResources = true;
			end
		end

		if kDestRouteInfo.MajorityReligion > 0 and kDestRouteInfo.ReligionPressure > 0 then
			AddReligiousPressureResourceEntry(GameInfo.Religions[kDestRouteInfo.MajorityReligion], kDestRouteInfo.ReligionPressure, false, Controls.DestinationResourceList);
			destinationReceivedResources = true;
		end

		Controls.DestinationResources:SetToolTipString(kDestRouteInfo.TooltipText);
		Controls.DestinationResourceHeader:SetText(Locale.Lookup("LOC_ROUTECHOOSER_RECEIVES_RESOURCE", Locale.Lookup(destinationCity:GetName())));
		Controls.DestinationResources:RegisterSizeChanged( function() ResizeResourceBackgroundColumns(Controls.DestinationResources, Controls.DestinationResourcesLeftColumn, Controls.DestinationResourcesRightColumn); end );

		if destinationReceivedResources then
			Controls.DestinationReceivesNoBenefitsLabel:SetHide(true);
		else
			Controls.DestinationReceivesNoBenefitsLabel:SetHide(false);
		end

		-- Resize CityName so it takes into account the bonus icons
		Controls.RouteBonusIcon:SetHide(not kOriginRouteInfo.HasPathBonus);
		OnBonusIconStackSizeChanged(Controls);

		-- Show Begin Route or Repeat Route if we're rerun the last completed route
		local trade:table = m_selectedUnit:GetTrade();
		local prevOriginComponentID:table = trade:GetLastOriginTradeCityComponentID();
		local prevDestComponentID:table = trade:GetLastDestinationTradeCityComponentID();
		local tradeManager = Game.GetTradeManager();

		HideConfirmGrid(false);

		if	originCity:GetID() == prevOriginComponentID.id and 
			originCity:GetOwner() == prevOriginComponentID.player and
			destinationCity:GetID() == prevDestComponentID.id and
			destinationCity:GetOwner() == prevDestComponentID.player then
			-- Make sure we are able to repeat this trade (not at war, etc)
			if tradeManager:CanStartRoute(originCity:GetOwner(), originCity:GetID(), destinationCity:GetOwner(), destinationCity:GetID()) then
				Controls.BeginRouteLabel:SetText(Locale.Lookup("LOC_ROUTECHOOSER_REPEAT_ROUTE_BUTTON"));
				Controls.BeginRouteAnim:SetToBeginning();
				Controls.BeginRouteAnim:Play();
			else
				HideConfirmGrid(true);
			end
		else
			Controls.BeginRouteLabel:SetText(Locale.Lookup("LOC_ROUTECHOOSER_BEGIN_ROUTE_BUTTON"));
			Controls.BeginRouteAnim:Stop();
			Controls.BeginRouteAnim:SetToBeginning();
		end
	else
		HideConfirmGrid(true);
	end

	Controls.OriginResources:DoAutoSize();
	Controls.CurrentSelectionContainer:DoAutoSize();
	Controls.TopGrid:DoAutoSize();
	OnTopGridSizeChanged();
end

-- ===========================================================================
function OnTopGridSizeChanged()
	Controls.BottomGrid:SetSizeY(Controls.RouteChooser:GetSizeY() - Controls.TopGrid:GetSizeY());
	Controls.BottomGrid:SetOffsetY(Controls.TopGrid:GetSizeY() - 1);
end

-- ===========================================================================
function HideConfirmGrid(shouldHide:boolean)
	-- Show/Hide Panel
	Controls.CurrentSelectionContainer:SetHide(shouldHide);
	Controls.ConfirmGrid:SetHide(shouldHide);

	-- Show/Hide Status Message
	Controls.StatusMessage:SetHide(not shouldHide);

	-- Resize RouteChoiceScrollPanel
	local sizeY:number = shouldHide and DESTINATION_SCROLLPANEL_RELATIVE_Y or DESTINATION_SCROLLPANEL_RELATIVE_Y - Controls.ConfirmGrid:GetSizeY();
	Controls.RouteChoiceScrollPanel:SetParentRelativeSizeY(sizeY);
end

-- ===========================================================================
function RefreshFilters()
	local tradeManager:table = Game.GetTradeManager();

	-- Clear entries
	Controls.DestinationFilterPulldown:ClearEntries();
	m_filterList = {};

	-- Add All Filter
	AddFilter(Locale.Lookup("LOC_ROUTECHOOSER_FILTER_ALL"), nil);

	-- Add Filters by Civ
	for index, entry in ipairs(m_unfilteredDestinations) do
		local pPlayerInfluence:table = Players[entry.owner]:GetInfluence();
		if not pPlayerInfluence:CanReceiveInfluence() then
			-- If the city's owner can receive influence then it is a city state so skip it
			local playerConfig:table = PlayerConfigurations[entry.owner];
			local name = Locale.Lookup(GameInfo.Civilizations[playerConfig:GetCivilizationTypeID()].Name);
			AddFilter(name, function() FilterByCiv(playerConfig:GetCivilizationTypeID()) end);
		end
	end

	-- Add City State Filter
	for index, entry in ipairs(m_unfilteredDestinations) do
		local pPlayerInfluence:table = Players[entry.owner]:GetInfluence();
		if pPlayerInfluence:CanReceiveInfluence() then
			-- If the city's owner can receive influence then it is a city state so add the city state filter
			AddFilter(Locale.Lookup("LOC_ROUTECHOOSER_FILTER_CITYSTATES"), FilterByCityStates);
			break;
		end
	end

	-- Add Filters by Yields
	-- We are *not* going to try to filter the filters by checking to see if there are any routes that have a non-zero
	-- value for each yield, that would be time comsuming when there are lots of cities.
	for yieldInfo in GameInfo.Yields() do
		AddFilter(Locale.Lookup(yieldInfo.Name), function() FilterByResource(yieldInfo.Index) end);
	end

	-- Add filters to pulldown
	for index, filter in ipairs(m_filterList) do
		AddFilterEntry(index);
	end

	-- Different traders have different filters and filter orders
	m_filterSelected = GetFilterIndex(m_filterSelectedName) or 1;
	m_filterSelectedName = m_filterList[m_filterSelected].FilterText;
	Controls.FilterButton:SetText(m_filterSelectedName);

	-- Calculate Internals
	Controls.DestinationFilterPulldown:CalculateInternals();

	UpdateFilterArrow();
end

-- ===========================================================================
function GetFilterIndex(filterName:string)
	for index, filter in ipairs(m_filterList) do
		if filter.FilterText == filterName then
			return index;
		end
	end
end

-- ===========================================================================
function AddFilter(filterName:string, filterFunction)
	-- Make sure we don't add duplicate filters
	if not GetFilterIndex(filterName) then
		table.insert(m_filterList, {FilterText=filterName, FilterFunction=filterFunction});
	end
end

-- ===========================================================================
function AddFilterEntry(filterIndex:number)
	local filterEntry:table = {};
	Controls.DestinationFilterPulldown:BuildEntry( "FilterEntry", filterEntry );
	filterEntry.Button:SetText(m_filterList[filterIndex].FilterText);
	filterEntry.Button:SetVoids(i, filterIndex);
end

-- ===========================================================================
function OnFilterSelected(index:number, filterIndex:number)
	m_filterSelected = filterIndex;
	m_filterSelectedName = m_filterList[m_filterSelected].FilterText;
	Controls.FilterButton:SetText(m_filterSelectedName);

	RefreshStack();
end

-- ===========================================================================
function FilterByCiv(civTypeID:number)
	-- Clear Filter
	m_filteredDestinations = {};

	-- Filter by Civ Type ID
	for index, entry in ipairs(m_unfilteredDestinations) do
		local playerConfig:table = PlayerConfigurations[entry.owner];
		if playerConfig:GetCivilizationTypeID() == civTypeID then
			table.insert(m_filteredDestinations, index);
		end
	end
end

-- ===========================================================================
function FilterByResource(yieldIndex:number)
	-- Clear Filter
	m_filteredDestinations = {};
	local cachedYields:table = {};

	-- Filter by Yield Index
	for index, entry in ipairs(m_unfilteredDestinations) do
		local city = CityManager.GetCity(entry.owner, entry.id);
		if city ~= nil then
			local yieldValue = GetYieldForCity(yieldIndex, city, true);

			if (yieldValue ~= 0 ) then
				cachedYields[index] = yieldValue;
				table.insert(m_filteredDestinations, index);			-- The filtered destinations table contains the index into the unfiltered table.
			end
		end
	end

	table.sort(m_filteredDestinations, function(A, B) return cachedYields[A] > cachedYields[B] end);
end

-- ===========================================================================
function FilterByCityStates()
	-- Clear Filter
	m_filteredDestinations = {};

	-- Filter only cities which aren't full civs meaning they're city-states
	for index, entry in ipairs(m_unfilteredDestinations) do
		local playerConfig:table = PlayerConfigurations[entry.owner];
		if playerConfig:GetCivilizationLevelTypeID() ~= CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV then
			table.insert(m_filteredDestinations, index);
		end
	end
end

-- ===========================================================================
function AddTradeRoutePath(entry : table, color : number)
	-- Add a variation on the destination hex
	local lastElement : number = table.count(entry.pathPlots);
	local kVariations:table = { {"TradeRoute_Destination", entry.pathPlots[lastElement]} };

	local eLocalPlayer = Game.GetLocalPlayer();

	-- Handle mountain tunnels
	-- TODO consider adding variations for entering/exiting portals
	local pPathSegment = { };
	for i,plot in pairs(entry.pathPlots) do
		
		-- Prepend an exit portal if one exists
		local pExit = entry.portalExits[i];
		if (pExit and pExit >= 0) then
			table.insert(pPathSegment, pExit);
		end

		-- Add the next plot to the segment
		table.insert(pPathSegment, plot);
			
		-- Append an entrance portal if one exists
		local pEntrance = entry.portalEntrances[i];
		if (pEntrance and pEntrance >= 0) then
			table.insert(pPathSegment, pEntrance);
			
			-- Submit the segment so far and start a new segment
			UILens.SetLayerHexesPath( m_TradeRoute, eLocalPlayer, pPathSegment, { }, color );
			pPathSegment = { };
		end
	end
	
	-- Submit the final segment
	UILens.SetLayerHexesPath( m_TradeRoute, eLocalPlayer, pPathSegment, kVariations, color );
end

-- ===========================================================================
function RefreshChooserPanel()
	local tradeManager:table = Game.GetTradeManager();
	m_unfilteredDestinations = {};
	m_filteredDestinations = {};
	
	local originCity = GetOriginCity();
	if originCity == nil then
		return;
	end

	-- Gather All Possible Destinations, starting with ourselves
	if (Game.GetLocalPlayer() ~= nil) then
		local localPlayer = Players[Game.GetLocalPlayer()];
		if (localPlayer ~= nil) then
			local players:table = {};
			table.insert(players, localPlayer);
			for i, player in ipairs(Game.GetPlayers()) do
				if (player:GetID() ~= localPlayer:GetID()) then
					table.insert(players, player);
				end
			end
			for i, player in ipairs(players) do
				local cities:table = player:GetCities();
				for j, city in cities:Members() do
					local cityOwner = city:GetOwner();
					local cityID = city:GetID();
					-- Check if a route is allowed. This will not check if there is a valid route, just that if there is one, we can start it.
					if CheckTradeRoute(m_selectedUnit, city) then
						-- We know we can possibly start a route, now see if we can get a route
						local pathPlots:table = {};
						pathPlots, portalEntrances, portalExits = tradeManager:GetTradeRoutePath(m_originCityOwner, m_originCityID, cityOwner, cityID );
						if pathPlots ~= nil and table.count(pathPlots) > 0 then
							local entry:table = {};
							entry.owner = cityOwner;
							entry.id = cityID;
							entry.pathPlots = pathPlots;
							entry.portalEntrances = portalEntrances;
							entry.portalExits = portalExits;

							table.insert(m_unfilteredDestinations, entry);
						end
					end
				end
			end
		end
	end

	-- Update Filters
	RefreshFilters();
	
	-- Update Destination Choice Stack
	RefreshStack();

	-- Make sure the correct lens is active
	if not UILens.IsLensActive( m_TradeRoute ) then
		UILens.SetActive( m_TradeRoute );
	end

	-- Send Trade Route Paths to Engine
	UILens.ClearLayerHexes( m_TradeRoute );

	local DEFAULT_TINT = UI.GetColorValue(1, 1, 1, 1);
	local FADED_TINT = UI.GetColorValue(0.3, 0.3, 0.3, 1);

	-- If a city is selected, fade the other routes
	local kUnselectedColor = DEFAULT_TINT;

	local destinationCity = GetDestinationCity();
	if (destinationCity ~= nil) then kUnselectedColor = FADED_TINT; end

	-- Show all paths that aren't selected
	local pathPlots		: table = {};
	for index, entryIndex in ipairs(m_filteredDestinations) do
		local entry = m_unfilteredDestinations[entryIndex];
		if (entry.owner ~= m_destinationCityOwner or entry.id ~= m_destinationCityID) then
			AddTradeRoutePath( entry, kUnselectedColor );
		end
	end

	-- Show the selected path last if it exists so it's on top
	if destinationCity ~= nil then
		local entry = FindDestinationEntry(m_destinationCityOwner, m_destinationCityID);
		if entry ~= nil then
			AddTradeRoutePath( entry, DEFAULT_TINT );
		end
	end
end

-- ===========================================================================
function RefreshStack()
	local tradeManager:table = Game.GetTradeManager();
	m_filteredDestinations = {};
	
	-- Filter Destinations by active Filter
	if m_filterList[m_filterSelected].FilterFunction ~= nil then
		m_filterList[m_filterSelected].FilterFunction();
	else
		for index, value in ipairs(m_unfilteredDestinations) do
			table.insert(m_filteredDestinations, index);
		end
	end

	-- Add Destinations to Stack
	m_RouteChoiceIM:ResetInstances();

	local numberOfDestinations:number = 0;
	for index, entryIndex in ipairs(m_filteredDestinations) do
		local entry = m_unfilteredDestinations[entryIndex];
		local city = CityManager.GetCity(entry.owner, entry.id);
		if city and entry.pathPlots and table.count(entry.pathPlots) > 0 then
			AddCityToDestinationStack(city);
			numberOfDestinations = numberOfDestinations + 1;
		end
	end

	Controls.RouteChoiceStack:CalculateSize();
	Controls.RouteChoiceScrollPanel:CalculateSize();

	-- Adjust offset to center destination scrollpanel/stack
	if Controls.RouteChoiceScrollPanel:GetScrollBar():IsHidden() then
		Controls.RouteChoiceScrollPanel:SetOffsetX(5);
	else
		Controls.RouteChoiceScrollPanel:SetOffsetX(13);
	end

	-- Show No Available Trade Routes message if nothing to select
	if numberOfDestinations > 0 then
		Controls.StatusMessage:SetText(Locale.Lookup("LOC_ROUTECHOOSER_SELECT_DESTINATION"));
	else
		Controls.StatusMessage:SetText(Locale.Lookup("LOC_ROUTECHOOSER_NO_TRADE_ROUTES"));
	end
end

-- ===========================================================================
function AddCityToDestinationStack(city:table)
	local destinationCity = GetDestinationCity();
	local originCity = GetOriginCity();

	if originCity == nil and destinationCity == nil then
		return;
	end

	local cityEntry:table = m_RouteChoiceIM:GetInstance();

	-- Update Selector Brace
	if destinationCity ~= nil and city:GetName() == destinationCity:GetName() then
		cityEntry.SelectorBrace:SetColor(UI.GetColorValue(1,1,1,1));
		cityEntry.Button:SetSelected(true);
	else
		cityEntry.SelectorBrace:SetColor(UI.GetColorValue(1,1,1,0));
		cityEntry.Button:SetSelected(false);
	end

	-- Setup city banner
	cityEntry.CityName:SetText(Locale.ToUpper(city:GetName()));

	local backColor:number, frontColor:number  = UI.GetPlayerColors( city:GetOwner() );

	cityEntry.BannerBase:SetColor( backColor );
	cityEntry.CityName:SetColor( frontColor );

	cityEntry.TradingPostIcon:SetColor( frontColor );

	-- Update Trading Post Icon
	if city:GetTrade():HasActiveTradingPost(originCity:GetOwner()) then
		cityEntry.TradingPostIcon:SetHide(false);
	else
		cityEntry.TradingPostIcon:SetHide(true);
	end

	-- Update City-State Quest Icon
	cityEntry.CityStateQuestIcon:SetHide(true);
	local questsManager	: table = Game.GetQuestsManager();
	local questTooltip	: string = Locale.Lookup("LOC_CITY_STATES_QUESTS");
	if (questsManager ~= nil and Game.GetLocalPlayer() ~= nil) then
		local tradeRouteQuestInfo:table = GameInfo.Quests["QUEST_SEND_TRADE_ROUTE"];
		if (tradeRouteQuestInfo ~= nil) then
			if (questsManager:HasActiveQuestFromPlayer(Game.GetLocalPlayer(), city:GetOwner(), tradeRouteQuestInfo.Index)) then
				local questTooltip:string = questTooltip .. "[NEWLINE]" .. tradeRouteQuestInfo.IconString .. questsManager:GetActiveQuestName(Game.GetLocalPlayer(), city:GetOwner(), tradeRouteQuestInfo.Index);
				cityEntry.CityStateQuestIcon:SetHide(false);
				cityEntry.CityStateQuestIcon:SetToolTipString(questTooltip);
			end
		end
	end

	-- Update distance to city
	local distanceToDestination:number = Map.GetPlotDistance(originCity:GetX(), originCity:GetY(), city:GetX(), city:GetY());
	cityEntry.DistenceToCity:SetColor( frontColor );
	cityEntry.DistenceToCity:SetText(distanceToDestination);

	-- Setup resources
	cityEntry.ResourceList:DestroyAllChildren();

	local kRouteInfo:table = GetYieldsForRoute(originCity, city);
	for yieldIndex=1, #kRouteInfo.kYieldValues, 1 do
		local yieldValue = kRouteInfo.kYieldValues[yieldIndex];
		if (yieldValue ~= 0 ) then
			local yieldInfo = GameInfo.Yields[yieldIndex - 1];
			AddYieldResourceEntry(yieldInfo, yieldValue, cityEntry.ResourceList);
		end
	end

	if kRouteInfo.MajorityReligion > 0 and kRouteInfo.ReligionPressure > 0 then
		AddReligiousPressureResourceEntry(GameInfo.Religions[kRouteInfo.MajorityReligion], kRouteInfo.ReligionPressure, true, cityEntry.ResourceList);
	end

	cityEntry.Button:SetToolTipString(kRouteInfo.TooltipText);

	-- Resize CityName so it takes into account the bonus icons
	cityEntry.RouteBonusIcon:SetHide(not kRouteInfo.HasPathBonus);
	OnBonusIconStackSizeChanged(cityEntry);

	-- Setup callback
	cityEntry.Button:SetVoids(city:GetOwner(), city:GetID());
	cityEntry.Button:RegisterCallback( Mouse.eLClick, OnTradeRouteSelected );
	cityEntry.BonusIconStack:RegisterSizeChanged( function() OnBonusIconStackSizeChanged(cityEntry); end );

	-- Resize resource background columns to fit parent
	cityEntry.ResourceInfoGrid:RegisterSizeChanged( function() ResizeResourceBackgroundColumns(cityEntry.ResourceInfoGrid, cityEntry.ResourceInfoLeftColumn, cityEntry.ResourceInfoRightColumn); end );
end

-- ===========================================================================
function OnBonusIconStackSizeChanged( pParentControl:table )
	local iIconStackSizeX:number = pParentControl.BonusIconStack:GetSizeX();
	pParentControl.CityName:SetOffsetX(iIconStackSizeX);
	pParentControl.CityName:SetTruncateWidth(pParentControl.NameContainer:GetSizeX() - iIconStackSizeX);
end

-- ===========================================================================
function ResizeResourceBackgroundColumns(parent:table, leftColumn:table, rightColumn:table)
	leftColumn:SetSizeY(parent:GetSizeY());
	rightColumn:SetSizeY(parent:GetSizeY());
end

-- ===========================================================================
function AddYieldResourceEntry(yieldInfo:table, yieldValue:number, stackControl:table)
	local entryInstance:table = {};
	ContextPtr:BuildInstanceForControl( "ResourceEntryInstance", entryInstance, stackControl );
	
	local icon:string, text:string = FormatYieldText(yieldInfo, yieldValue);
	entryInstance.ResourceEntryIcon:SetText(icon);
	entryInstance.ResourceEntryText:SetText(text);
	entryInstance.ResourceEntryStack:CalculateSize();
end

-- ===========================================================================
function AddReligiousPressureResourceEntry(religionInfo:table, pressureValue:number, forOriginCity:boolean, stackControl:table)
	local entryInstance:table = {};
	ContextPtr:BuildInstanceForControl( "ReligionPressureEntryInstance", entryInstance, stackControl );
	
	local religionColor = UI.GetColorValue(religionInfo.Color);
	local religionName = Game.GetReligion():GetName(religionInfo.Index);
	entryInstance.ReligionIcon:SetIcon("ICON_" .. religionInfo.ReligionType);
	entryInstance.ReligionIcon:SetColor(religionColor);
	entryInstance.ReligionIconBacking:SetColor(religionColor);
	entryInstance.ReligionIconBacking:SetToolTipString(religionName);

	local icon:string, text:string = FormatReligiousPressureText(religionInfo, pressureValue, forOriginCity);
	entryInstance.ResourceEntryText:SetText(text);
	entryInstance.ResourceEntryStack:CalculateSize();
end

---------------------------------------
-- Helpers
---------------------------------------
function FormatYieldText(yieldInfo, yieldAmount)
	local text:string = "";

	local iconString = "";
	if (yieldInfo.YieldType == "YIELD_FOOD") then
		iconString = "[ICON_Food]";
	elseif (yieldInfo.YieldType == "YIELD_PRODUCTION") then
		iconString = "[ICON_Production]";
	elseif (yieldInfo.YieldType == "YIELD_GOLD") then
		iconString = "[ICON_Gold]";
	elseif (yieldInfo.YieldType == "YIELD_SCIENCE") then
		iconString = "[ICON_Science]";
	elseif (yieldInfo.YieldType == "YIELD_CULTURE") then
		iconString = "[ICON_Culture]";
	elseif (yieldInfo.YieldType == "YIELD_FAITH") then
		iconString = "[ICON_Faith]";
	end

	if (yieldAmount >= 0) then
		text = text .. "+";
	end

	text = text .. Round(yieldAmount, 1);
	return iconString, text;
end

-- ===========================================================================
function FormatReligiousPressureText(religionInfo, pressureValue, forOriginCity:boolean)
	local text:string = "";

	local iconString = "";
	if (religionInfo ~= nil) then
		if (forOriginCity) then
			iconString = "[ICON_PressureLeft]";
		else
			iconString = "[ICON_PressureRight]";
		end
	end

	if (pressureValue >= 0) then
		text = text .. "+";
	end

	text = text .. pressureValue;
	return iconString, text;
end

-- ===========================================================================
function TradeRouteSelected( cityOwner:number, cityID:number )
	local player:table = Players[cityOwner];
	if player then
		local pCity:table = player:GetCities():FindID(cityID);
		if pCity and FindDestinationEntry(cityOwner, cityID) then
			m_destinationCityOwner = cityOwner;
			m_destinationCityID = cityID;
		else
			m_destinationCityOwner = -1;
			m_destinationCityID = -1;
		end
	end
	
	Refresh();
end

-- ===========================================================================
--	Look at the plot of the destination city.
--	Not always done when selected, as sometimes the TradeOverview will be
--	open and it's going to perform it's own lookat.
-- ===========================================================================
function RealizeLookAtDestinationCity()
	local destinationCity = GetDestinationCity();
	if destinationCity == nil then
		UI.DataError("TradeRouteChooser cannot look at a NIL destination.");
		return;
	end			

	local locX		:number = destinationCity:GetX();
	local locY		:number = destinationCity:GetY();	
	local screenXOff:number = 0.6;
	
	-- Change offset if the TradeOveriew (exists and) is open as well.
	if m_pTradeOverviewContext and (not m_pTradeOverviewContext:IsHidden()) then
		screenXOff = 0.42;
	end

	UI.LookAtPlotScreenPosition( locX, locY, screenXOff, 0.5 );	-- Look at 60% over from left side of screen
end

-- ===========================================================================
--	UI Button Callback
-- ===========================================================================
function OnTradeRouteSelected( cityOwner:number, cityID:number )
	TradeRouteSelected( cityOwner, cityID );
	RealizeLookAtDestinationCity();

	LuaEvents.TradeRouteChooser_RouteConsidered();
end

-- ===========================================================================
function CheckTradeRoute(unit:table, city:table)
	if city and unit then
		local operationParams = {};
		operationParams[UnitOperationTypes.PARAM_X0] = city:GetX();
		operationParams[UnitOperationTypes.PARAM_Y0] = city:GetY();
		operationParams[UnitOperationTypes.PARAM_X1] = unit:GetX();
		operationParams[UnitOperationTypes.PARAM_Y1] = unit:GetY();
		if (UnitManager.CanStartOperation(unit, UnitOperationTypes.MAKE_TRADE_ROUTE, nil, operationParams)) then
			return true;
		end
	end

	return false;
end

-- ===========================================================================
function RequestTradeRoute()
	local destinationCity = GetDestinationCity();
	if destinationCity and m_selectedUnit then
		local operationParams = {};
		operationParams[UnitOperationTypes.PARAM_X0] = destinationCity:GetX();
		operationParams[UnitOperationTypes.PARAM_Y0] = destinationCity:GetY();
		operationParams[UnitOperationTypes.PARAM_X1] = m_selectedUnit:GetX();
		operationParams[UnitOperationTypes.PARAM_Y1] = m_selectedUnit:GetY();
		if (UnitManager.CanStartOperation(m_selectedUnit, UnitOperationTypes.MAKE_TRADE_ROUTE, nil, operationParams)) then
			UnitManager.RequestOperation(m_selectedUnit, UnitOperationTypes.MAKE_TRADE_ROUTE, operationParams);
			UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
            UI.PlaySound("START_TRADE_ROUTE");
		end

		return true;
	end

	return false;
end

-- ===========================================================================
-- Get the yield value as well as the text describing where the yield came from
function GetYieldForCityWithText(yieldIndex:number, city:table, originCity:boolean)
	local tradeManager = Game.GetTradeManager();
	local yieldInfo = GameInfo.Yields[yieldIndex];
	local totalValue = 0;
	local partialValue = 0;
	local sourceText = "";

	if city == nil then
		return 0, "";
	end

	local cityOwner:number = city:GetOwner();
	local cityID:number = city:GetID();

	-- From route
	if (originCity) then
		partialValue = tradeManager:CalculateOriginYieldFromPotentialRoute(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	else
		partialValue = tradeManager:CalculateDestinationYieldFromPotentialRoute(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	end
	totalValue = totalValue + partialValue;
	if (partialValue > 0 and yieldInfo ~= nil) then
		if (sourceText ~= "") then
			sourceText = sourceText .. "[NEWLINE]";
		end
		sourceText = sourceText .. Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_DISTRICTS", partialValue, yieldInfo.IconString, yieldInfo.Name, city:GetName());
	end
	-- From path
	local bFromRouteBonus:boolean = false;
	if (originCity) then
		partialValue = tradeManager:CalculateOriginYieldFromPath(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	else
		partialValue = tradeManager:CalculateDestinationYieldFromPath(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	end
	totalValue = totalValue + partialValue;
	if (partialValue > 0 and yieldInfo ~= nil) then
		bFromRouteBonus = true;
		if (sourceText ~= "") then
			sourceText = sourceText .. "[NEWLINE]";
		end
		sourceText = sourceText .. Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_TRADING_POSTS", partialValue, yieldInfo.IconString, yieldInfo.Name);
	end
	-- From modifiers
	local resourceID = -1;
	if (originCity) then
		partialValue = tradeManager:CalculateOriginYieldFromModifiers(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex, resourceID);
	else
		partialValue = tradeManager:CalculateDestinationYieldFromModifiers(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex, resourceID);
	end
	totalValue = totalValue + partialValue;
	if (partialValue > 0 and yieldInfo ~= nil) then
		if (sourceText ~= "") then
			sourceText = sourceText .. "[NEWLINE]";
		end
		sourceText = sourceText .. Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_BONUSES", partialValue, yieldInfo.IconString, yieldInfo.Name);
	end

	return totalValue, sourceText, bFromRouteBonus;
end

-- ===========================================================================
-- Get just the yield for the city connection
function GetYieldForCity(yieldIndex:number, city:table, originCity:boolean)
	local tradeManager = Game.GetTradeManager();
	local yieldInfo = GameInfo.Yields[yieldIndex];
	local totalValue = 0;
	local partialValue = 0;

	if city == nil then
		return 0;
	end

	local cityOwner:number = city:GetOwner();
	local cityID:number = city:GetID();

	-- From route
	if (originCity) then
		partialValue = tradeManager:CalculateOriginYieldFromPotentialRoute(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	else
		partialValue = tradeManager:CalculateDestinationYieldFromPotentialRoute(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	end
	totalValue = totalValue + partialValue;

	-- From path
	local bFromRouteBonus:boolean = false;
	if (originCity) then
		partialValue = tradeManager:CalculateOriginYieldFromPath(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	else
		partialValue = tradeManager:CalculateDestinationYieldFromPath(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex);
	end
	totalValue = totalValue + partialValue;
	if (partialValue > 0) then
		bFromRouteBonus = true;
	end
	-- From modifiers
	local resourceID = -1;
	if (originCity) then
		partialValue = tradeManager:CalculateOriginYieldFromModifiers(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex, resourceID);
	else
		partialValue = tradeManager:CalculateDestinationYieldFromModifiers(m_originCityOwner, m_originCityID, cityOwner, cityID, yieldIndex, resourceID);
	end
	totalValue = totalValue + partialValue;

	return totalValue, bFromRouteBonus;
end

-- ===========================================================================
function UpdateFilterArrow()
	if Controls.DestinationFilterPulldown:IsOpen() then
		Controls.PulldownOpenedArrow:SetHide(true);
		Controls.PulldownClosedArrow:SetHide(false);
	else
		Controls.PulldownOpenedArrow:SetHide(false);
		Controls.PulldownClosedArrow:SetHide(true);
	end
end

-- ===========================================================================
--	Rise/Hide and refresh Trade UI
-- ===========================================================================
function OnInterfaceModeChanged( oldMode:number, newMode:number )
	if (oldMode == InterfaceModeTypes.MAKE_TRADE_ROUTE) then
		Close();
	end
	if (newMode == InterfaceModeTypes.MAKE_TRADE_ROUTE) then
		Open();
	end
end

-- ===========================================================================
function OnClose()
	Close();

	if UI.GetInterfaceMode() == InterfaceModeTypes.MAKE_TRADE_ROUTE then
		UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
	end
end

-- ===========================================================================
function Close()

	m_originCityOwner = -1;
	m_originCityID = -1;
	m_destinationCityOwner = -1;
	m_destinationCityID = -1;

	LuaEvents.TradeRouteChooser_SetTradeUnitStatus("");

	ContextPtr:SetHide(true);

	LuaEvents.TradeRouteChooser_Close();

	if UILens.IsLensActive(m_TradeRoute) then
		-- Make sure to switch back to default lens
		UILens.SetActive("Default");
	end
end

-- ===========================================================================
function Open()
	LuaEvents.TradeRouteChooser_SetTradeUnitStatus("LOC_HUD_UNIT_PANEL_CHOOSING_TRADE_ROUTE");

	ContextPtr:SetHide(false);
	m_destinationCityOwner = -1;
	m_destinationCityID = -1;

	-- Play Open Animation
	Controls.RouteChooserSlideAnim:SetToBeginning();
	Controls.RouteChooserSlideAnim:Play();

	-- Switch to TradeRoute Lens
	UILens.SetActive(m_TradeRoute);

	if m_postOpenSelectPlayerID ~= -1 then
		TradeRouteSelected( m_postOpenSelectPlayerID, m_postOpenSelectCityID );
		RealizeLookAtDestinationCity();

		-- Reset values
		m_postOpenSelectPlayerID = -1;
		m_postOpenSelectCityID = -1;
	else
		-- Select the previously completed trade route automatically
		m_selectedUnit = UI.GetHeadSelectedUnit();
		if m_selectedUnit then
			local trade:table = m_selectedUnit:GetTrade();
			local prevOriginComponentID:table = trade:GetLastOriginTradeCityComponentID();
			local prevDestComponentID:table = trade:GetLastDestinationTradeCityComponentID();
		
			local originCity:table = Cities.GetCityInPlot(m_selectedUnit:GetX(), m_selectedUnit:GetY());
			if originCity:GetID() == prevOriginComponentID.id and originCity:GetOwner() == prevOriginComponentID.player then
				TradeRouteSelected( prevDestComponentID.player, prevDestComponentID.id );
			end
		end
	end

	LuaEvents.TradeRouteChooser_Open();
	LuaEvents.LaunchBar_CheckPopupsOpen();

	Refresh();	
end

-- ===========================================================================
function ClearSelection()
	m_destinationCityOwner = -1;
	m_destinationCityID = -1;
	Refresh();
end

-- ===========================================================================
function CheckNeedsToOpen()

	-- Make sure we are in-game, i.e. not in the loading screen.
	if UI.IsInGame() then
		local selectedUnit:table = UI.GetHeadSelectedUnit();
		if selectedUnit ~= nil then
			local selectedUnitInfo:table = GameInfo.Units[selectedUnit:GetUnitType()];
			if selectedUnitInfo ~= nil and selectedUnitInfo.MakeTradeRoute == true then
				local activityType:number = UnitManager.GetActivityType(selectedUnit);
				if activityType == ActivityTypes.ACTIVITY_AWAKE and selectedUnit:GetMovesRemaining() > 0 then
					-- If we're open and this is a trade unit then just refresh
					if not ContextPtr:IsHidden() then
						Refresh();
					else
						UI.SetInterfaceMode(InterfaceModeTypes.MAKE_TRADE_ROUTE);
					end

					-- Early out so we don't call Close()
					return;
				end
			end
		end
	end

	-- If we're open and this unit is not a trade unit then close
	if not ContextPtr:IsHidden() then
		Close();
	end
end

-- ===========================================================================
--	UI Event
-- ===========================================================================
function OnInit( isReload:boolean )
	if isReload then		
		LuaEvents.GameDebug_GetValues( "TradeRouteChooser" );	
	end
end

-- ===========================================================================
--	UI EVENT
-- ===========================================================================
function OnShutdown()
	-- Cache values for hotloading...
	LuaEvents.GameDebug_AddValue("TradeRouteChooser", "filterIndex", m_filterSelected );
	LuaEvents.GameDebug_AddValue("TradeRouteChooser", "destinationCityOwner", m_destinationCityOwner );
	LuaEvents.GameDebug_AddValue("TradeRouteChooser", "destinationCityID", m_destinationCityID );
end

-- ===========================================================================
--	LUA Event
--	Set cached values back after a hotload.
-- ===========================================================================s
function OnGameDebugReturn( context:string, contextTable:table )
	if context ~= "TradeRouteChooser" then
		return;
	end

	m_filterSelected = contextTable["filterIndex"];
	m_destinationCityOwner = contextTable["destinationCityOwner"];
	m_destinationCityID = contextTable["destinationCityID"];

	Refresh();
end

-- ===========================================================================
--	GAME Event
--	City was selected so close route chooser
-- ===========================================================================
function OnCitySelectionChanged(owner, ID, i, j, k, bSelected, bEditable)
	if not ContextPtr:IsHidden() and owner == Game.GetLocalPlayer() then
		Close();
	end
end

-- ===========================================================================
--	GAME Event
--	Unit was selected so close route chooser
-- ===========================================================================
function OnUnitSelectionChanged( playerID : number, unitID : number, hexI : number, hexJ : number, hexK : number, bSelected : boolean, bEditable : boolean )
	
	-- Make sure we're the local player and not observing
	if playerID ~= Game.GetLocalPlayer() or playerID == -1 then
		return;
	end

	-- If this is a de-selection event then don't do anything
	if not bSelected then
		return;
	end

	CheckNeedsToOpen();
end

------------------------------------------------------------------------------------------------
function OnLocalPlayerTurnEnd()
	if(GameConfiguration.IsHotseat()) then
		Close();
	end
end

-- ===========================================================================
function OnUnitActivityChanged( playerID :number, unitID :number, eActivityType :number)
	-- Make sure we're the local player and not observing
	if playerID ~= Game.GetLocalPlayer() or playerID == -1 then
		return;
	end

	CheckNeedsToOpen();
end

-- ===========================================================================
function OnPolicyChanged( ePlayer )
	if not ContextPtr:IsHidden() and ePlayer == Game.GetLocalPlayer() then
		Refresh();
	end
end

-- ===========================================================================
--	Input
--	UI Event Handler
-- ===========================================================================
function KeyHandler( key:number )
	if key == Keys.VK_ESCAPE then
		Close();
		return true;
	end

	return false;
end

function OnInputHandler( pInputStruct:table )
	local uiMsg = pInputStruct:GetMessageType();

	if uiMsg == KeyEvents.KeyUp then 
		return KeyHandler( pInputStruct:GetKey() ); 
	end;

	return false;
end

-- ===========================================================================
function OnSelectRouteFromOverview( destinationOwnerID:number, destinationCityID:number )
	if not ContextPtr:IsHidden() then
		-- If we're already open then select the route
		TradeRouteSelected( destinationOwnerID, destinationCityID );
	else
		-- If we're not open then set the route to be selected after we open the panel
		m_postOpenSelectPlayerID = destinationOwnerID;
		m_postOpenSelectCityID = destinationCityID;

		-- Check to see if we need to open
		CheckNeedsToOpen();
	end	
end

-- ===========================================================================
--	Create a trade route from the world input.
-- ===========================================================================
function OnWorldInputMakeTradeRoute( plotId:number )

	local plotX,plotY	= Map.GetPlotLocation( plotId );
	local pCity			:table = Cities.GetCityInPlot( plotX, plotY );
	if pCity then
		UI.PlaySound("Play_UI_Click");
		TradeRouteSelected( pCity:GetOwner(), pCity:GetID() );
	end
end


-- ===========================================================================
--	Setup
-- ===========================================================================
function Initialize()
	-- Context Events
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetShutdown( OnShutdown );
	ContextPtr:SetInputHandler( OnInputHandler, true );

	-- Lua Events
	LuaEvents.GameDebug_Return.Add( OnGameDebugReturn );
	LuaEvents.TradeOverview_SelectRouteFromOverview.Add( OnSelectRouteFromOverview );
	LuaEvents.TradeRouteChooser_CloseIfPopups.Add( OnClose );
	LuaEvents.TradeRouteChooser_ReOpen.Add( Open );
	LuaEvents.WorldInput_MakeTradeRouteDestination.Add( OnWorldInputMakeTradeRoute );	

	-- Game Engine Events	
	Events.InterfaceModeChanged.Add( OnInterfaceModeChanged );
	Events.CitySelectionChanged.Add( OnCitySelectionChanged );
	Events.UnitSelectionChanged.Add( OnUnitSelectionChanged );	
	Events.UnitActivityChanged.Add( OnUnitActivityChanged );
	Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
	Events.GovernmentPolicyChanged.Add( OnPolicyChanged );
	Events.GovernmentPolicyObsoleted.Add( OnPolicyChanged );

	-- Control Events
	Controls.BeginRouteButton:RegisterCallback( Mouse.eLClick, RequestTradeRoute );
	Controls.BeginRouteButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.CancelButton:RegisterCallback( Mouse.eLClick, ClearSelection );
	Controls.FilterButton:RegisterCallback( Mouse.eLClick, UpdateFilterArrow );
	Controls.DestinationFilterPulldown:RegisterSelectionCallback( OnFilterSelected );
	Controls.Header_CloseButton:RegisterCallback( Mouse.eLClick, OnClose );
	Controls.TopGrid:RegisterSizeChanged( OnTopGridSizeChanged );
	Controls.BonusIconStack:RegisterSizeChanged( function() OnBonusIconStackSizeChanged(Controls); end );

	-- Obtain refrence to another context.
	m_pTradeOverviewContext = ContextPtr:LookUpControl("/InGame/TradeOverview");
end
Initialize();