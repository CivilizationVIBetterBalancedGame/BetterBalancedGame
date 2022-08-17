include "bbg_stateutils"

--[[ =======================================================================

	BBG Custom Unit Commands - Definitions

		Data and callbacks for enabling custom unit commands to appear and 
		work in the Unit Panel UI. These definitions mimic what appears in 
		data for common unit commands, and are used in the replacement 
		UnitPanel script.

-- =========================================================================]]

m_BBGCustomUnitCommands = {};

-- =========================================================================


--[[ =======================================================================
	PURGE

	Invisible UnitCommand triggered when UnitOpperation.REMOVE_HERESY is used
-- =========================================================================]]
m_BBGCustomUnitCommands.PURGE = {};

m_BBGCustomUnitCommands.PURGE.Properties = {};
m_BBGCustomUnitCommands.PURGE.EventName		= "BBGCommand_Purge";
m_BBGCustomUnitCommands.PURGE.CategoryInUI	= "SPECIFIC";
m_BBGCustomUnitCommands.PURGE.Icon			= "ICON_UNITOPERATION_SPREAD_RELIGION";
m_BBGCustomUnitCommands.PURGE.ToolTipString	= Locale.Lookup("LOC_UNITOPERATION_REMOVE_HERESY_DESCRIPTION").."[NEWLINE] BBG Custom Command";
m_BBGCustomUnitCommands.PURGE.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_DEFAULT_DISABLED_TT");
m_BBGCustomUnitCommands.PURGE.VisibleInUI	= false;

-- ===========================================================================
function m_BBGCustomUnitCommands.PURGE.CanUse(pUnit : object)
	if (pUnit == nil) then
		return false;
	end

	return GameInfo.Units[pUnit:GetType()].UnitType == "UNIT_INQUISITOR";
end

-- ===========================================================================
function m_BBGCustomUnitCommands.PURGE.IsVisible(pUnit : object)
	return false;
end

-- ===========================================================================
function m_BBGCustomUnitCommands.PURGE.IsDisabled(pUnit : object)
	-- Unsure if the EXECUTE_SCRIPT recheck parameters so made a second test just in case
	if (pUnit == nil or pUnit:GetMovesRemaining() == 0) then
		return true;
	end
	
	local iPlotId : number = pUnit:GetPlotId();
	local pPlot : object = Map.GetPlotByIndex(iPlotId);
	if (pPlot == nil) then
		return true;
	end

	local bAdjToOwnCity = false
	local pCity
	for direction = 0, 6, 1 do
		local adjacentPlot
		if direction < 6 then
			adjacentPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), direction);
			else
			adjacentPlot = pPlot
		end
		if (adjacentPlot ~= nil) then
			if(adjacentPlot:IsCity() == true) then
				pCity = CityManager.GetCityAt(adjacentPlot:GetX(), adjacentPlot:GetY());
				if (pCity ~= nil) then
					local CityOwner = pCity:GetOwner()
					local UnitOwner = pUnit:GetOwner()
					if CityOwner == UnitOwner then
						bAdjToOwnCity = true
					end
				end
			end
		end
	end
	
	if (bAdjToOwnCity == false) then
		return true;
	end
	
	local religionType = pUnit:GetReligionType()
	
	if (religionType == nil) then
		return true;
	end	
	local pCityReligion		:table = pCity:GetReligion();
	if (pCityReligion == nil) then
		return true;
	end
	
	local pReligionsInCity:table = pCityReligion:GetReligionsInCity();
	if (pReligionsInCity == nil) then
		return true;
	end	
	
	local bHasHeretics = false
	for _, cityReligion in pairs(pReligionsInCity) do
		local religion:number = cityReligion.Religion;
		if(religion >= 0) then
			local followers:number = cityReligion.Followers;
			if followers > 0 and religion ~= religionType then
				bHasHeretics = true
			end
		end
	end
	if (bHasHeretics == false) then
		return true;
	end
	
	return false;
end


--[[ =======================================================================
	BURN

	Replacement for CODEMN_HERETIC unit command
-- =========================================================================]]
m_BBGCustomUnitCommands.BURN = {};
m_BBGCustomUnitCommands.BURN.Properties = {};
m_BBGCustomUnitCommands.BURN.EventName		= "BBGCommand_Burn";
m_BBGCustomUnitCommands.BURN.CategoryInUI	= "SPECIFIC";
m_BBGCustomUnitCommands.BURN.Icon			= "ICON_UNITCOMMAND_CONDEMN_HERETIC";
m_BBGCustomUnitCommands.BURN.ToolTipString	= Locale.Lookup("LOC_UNITCOMMAND_CONDEMN_HERETIC_DESCRIPTION").."[NEWLINE] BBG Custom Command";
m_BBGCustomUnitCommands.BURN.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_DEFAULT_DISABLED_TT");
m_BBGCustomUnitCommands.BURN.VisibleInUI	= false;

-- ===========================================================================
function m_BBGCustomUnitCommands.BURN.CanUse(pUnit : object)
	-- for testing the magic in on the script side
	if (pUnit == nil) then
		return false;
	end

	return GameInfo.Units[pUnit:GetType()].UnitType == "UNIT_WARRIOR";
end

-- ===========================================================================
function m_BBGCustomUnitCommands.BURN.IsVisible(pUnit : object)
	-- for testing the magic in on the script side
	return false;
end

-- ===========================================================================
function m_BBGCustomUnitCommands.BURN.IsDisabled(pUnit : object)
	-- for testing the magic in on the script side
	return false;
end

