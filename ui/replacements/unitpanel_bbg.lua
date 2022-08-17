-- ===========================================================================
--	Unit Panel Replacement/Extension
--	BBG
-- ===========================================================================

include "UnitPanel_Expansion2"
include "bbg_stateutils" -- allows to save game state
include "bbg_unitcommanddefs" -- define m_BBGCustomUnitCommands
print("Unitpanel Replacement for BBG")
-- ===========================================================================
--	CONSTANT
-- ===========================================================================
REMOVE_HERESY_HASH_ID = -498124375

-- ===========================================================================
--	CACHE BASE FUNCTIONS
-- ===========================================================================
BASE_GetUnitOperationTooltip = GetUnitOperationTooltip;

-- ===========================================================================
--	OVERRIDE BASE FUNCTIONS
-- ===========================================================================

function GetUnitActionsTable(pUnit : object)
	-- We have to repick the base function to insert the specific call for Remove Heresy 
	-- Remove Heresy is now a dual aciton with both UnitOperation and UnitCommand EXECUTE_SCRIPT outcomes
	-- Condemn is no longer a UnitCommand.Condemn but an UnitCommand EXECUTE_SCRIPT calling BURN
	local actionsTable	= {
		ATTACK			= {},
		BUILD			= {},
		GAMEMODIFY		= {},
		MOVE			= {},
		OFFENSIVESPY	= {},
		INPLACE			= {},
		SECONDARY		= {},
		SPECIFIC		= {},
		displayOrder = {
			primaryArea = {"ATTACK","OFFENSIVESPY","SPECIFIC","MOVE","INPLACE","GAMEMODIFY"},	-- How they appear in the UI
			secondaryArea = {"SECONDARY"}
		}		
	};

	local bestValidImprovement:number  = -1;	-- To recommend to player.
  
	if pUnit == nil then
		UI.DataError("NIL unit when attempting to get action table.");
		return;
	end

	local unitType :string = GameInfo.Units[pUnit:GetUnitType()].UnitType;

	for commandRow in GameInfo.UnitCommands() do
		if ( commandRow.VisibleInUI ) then
			local actionHash	:number		= commandRow.Hash;
			local isDisabled	:boolean	= IsDisabledByTutorial(unitType, actionHash ); 

			if (actionHash == UnitCommandTypes.MOVE_JUMP) then
				local foo = 0;
			end

			if (actionHash == UnitCommandTypes.ENTER_FORMATION) then
				--Check if there are any units in the same tile that this unit can create a formation with
				--Call CanStartCommand asking for results
				local bCanStart, tResults = UnitManager.CanStartCommand( pUnit, actionHash, nil, true);
				if (bCanStart and tResults) then
					if (tResults[UnitCommandResults.UNITS] ~= nil and #tResults[UnitCommandResults.UNITS] ~= 0) then
						local tUnits = tResults[UnitCommandResults.UNITS];
						for i, unit in ipairs(tUnits) do
							local pUnitInstance = Players[unit.player]:GetUnits():FindID(unit.id);
							if (pUnitInstance ~= nil) then

								local toolTipString :string		= Locale.Lookup(commandRow.Description, GameInfo.Units[pUnitInstance:GetUnitType()].Name);
								local callback		:ifunction	= function() OnUnitActionClicked_EnterFormation(pUnitInstance) end								

								AddActionToTable( actionsTable, commandRow, isDisabled, toolTipString, actionHash, callback );
							end
						end
					end
				end
			elseif (actionHash == UnitCommandTypes.PROMOTE) then
				--Call CanStartCommand asking for a list of possible promotions for that unit
				local bCanStart, tResults = UnitManager.CanStartCommand( pUnit, actionHash, true, true);
				if (bCanStart and tResults) then
					if (tResults[UnitCommandResults.PROMOTIONS] ~= nil and #tResults[UnitCommandResults.PROMOTIONS] ~= 0) then
						local tPromotions		= tResults[UnitCommandResults.PROMOTIONS];						
						local toolTipString		= Locale.Lookup(commandRow.Description);
						local callback			= function() ShowPromotionsList(tPromotions); end

						AddActionToTable( actionsTable, commandRow, isDisabled, toolTipString, actionHash, callback );
					end
				end
			elseif (actionHash == UnitCommandTypes.NAME_UNIT) then
				local bCanStart = UnitManager.CanStartCommand( pUnit, UnitCommandTypes.NAME_UNIT, true) and GameCapabilities.HasCapability("CAPABILITY_RENAME");
				if (bCanStart) then			
					local toolTipString = Locale.Lookup(commandRow.Description);
					AddActionToTable( actionsTable, commandRow, isDisabled, toolTipString, actionHash, OnNameUnit );
				end
			elseif (actionHash == UnitCommandTypes.DELETE) then				
				local bCanStart = UnitManager.CanStartCommand( pUnit, UnitCommandTypes.DELETE, true);
				if (bCanStart) then
					local toolTipString	= Locale.Lookup(commandRow.Description);
					AddActionToTable( actionsTable, commandRow, isDisabled, toolTipString, actionHash, OnPromptToDeleteUnit );
				end
			elseif (actionHash == UnitCommandTypes.CANCEL and GameInfo.Units[unitType].Spy) then
				-- Route the cancel action for spies to the espionage popup for cancelling a mission
				local bCanStart = UnitManager.CanStartCommand( pUnit, actionHash, true);
				if (bCanStart) then
					local bCanStartNow, tResults = UnitManager.CanStartCommand( pUnit, actionHash, false, true);
					AddActionToTable( actionsTable, commandRow, isDisabled, Locale.Lookup("LOC_UNITPANEL_ESPIONAGE_CANCEL_MISSION"), actionHash, OnUnitActionClicked_CancelSpyMission, UnitCommandTypes.TYPE, actionHash  );
				end	
			elseif (actionHash == UnitCommandTypes.CONDEMN_HERETIC) then
				-- The UI check of an operation is a loose check where it only fails if the unit could never do the command.
				local bCanStart = UnitManager.CanStartCommand( pUnit, actionHash, true);
				if (bCanStart) then
					-- Check again if the operation can occur, this time for real.
					local bCanStartNow, tResults = UnitManager.CanStartCommand( pUnit, actionHash, false, true);
					local bDisabled = not bCanStartNow;
					local toolTipString = Locale.Lookup(commandRow.Description);
					if (tResults ~= nil) then
						if (tResults[UnitOperationResults.ACTION_NAME] ~= nil and tResults[UnitOperationResults.ACTION_NAME] ~= "") then
							toolTipString = Locale.Lookup(tResults[UnitOperationResults.ACTION_NAME]);
						end

						if (tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION] ~= nil) then
							toolTipString = toolTipString .. "[NEWLINE]"; -- Line break before add'l desc block
							for i,v in ipairs(tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION]) do
								toolTipString = toolTipString .. "[NEWLINE]" .. Locale.Lookup(v);
							end
							
							if (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
								if (table.count(tResults[UnitOperationResults.FAILURE_REASONS]) > 0) then
									toolTipString = toolTipString .. "[NEWLINE]"; -- Line break after add'l desc block if there are failure reasons to report
								end
							end
						end

						-- Are there any failure reasons?
						if ( bDisabled ) then
							if (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
								-- Add the reason(s) to the tool tip
								for i,v in ipairs(tResults[UnitOperationResults.FAILURE_REASONS]) do
									toolTipString = toolTipString .. "[NEWLINE]" .. "[COLOR:Red]" .. Locale.Lookup(v) .. "[ENDCOLOR]";
								end
							end
						end
					end
					isDisabled = bDisabled or isDisabled;	-- Mix in tutorial disabledness
					local overrideIcon:string = nil;

					isDisabled, tooltipString, overrideIcon = LateCheckActionBeforeAdd( kActionsTable, actionHash, isDisabled, tooltipString, overrideIcon );
					AddActionToTable( actionsTable, commandRow, isDisabled, toolTipString, actionHash, OnUnitActionClicked_Condemn_Heretic, UnitCommandTypes.TYPE, actionHash, overrideIcon  );
				end
			else
				-- The UI check of an operation is a loose check where it only fails if the unit could never do the command.
				local bCanStart = UnitManager.CanStartCommand( pUnit, actionHash, true);
				if (bCanStart) then
					-- Check again if the operation can occur, this time for real.
					local bCanStartNow, tResults = UnitManager.CanStartCommand( pUnit, actionHash, false, true);
					local bDisabled = not bCanStartNow;
					local toolTipString:string;

					if (actionHash == UnitCommandTypes.UPGRADE) then
						-- if it's a unit upgrade action, add the unit it will upgrade to in the tooltip as well as the upgrade cost
						if (tResults ~= nil) then
							if (tResults[UnitCommandResults.UNIT_TYPE] ~= nil) then
								local upgradeUnitName = GameInfo.Units[tResults[UnitCommandResults.UNIT_TYPE]].Name;
								toolTipString = Locale.Lookup(upgradeUnitName);
								local upgradeCost = pUnit:GetUpgradeCost();
								if (upgradeCost ~= nil) then
									toolTipString = Locale.Lookup("LOC_UNITOPERATION_UPGRADE_INFO", upgradeUnitName, upgradeCost);
								end
								toolTipString = toolTipString .. AddUpgradeResourceCost(pUnit);
							end
						end
					elseif (actionHash == UnitCommandTypes.FORM_CORPS) then
						if (GameInfo.Units[unitType].Domain == "DOMAIN_SEA") then
							toolTipString = Locale.Lookup("LOC_UNITCOMMAND_FORM_FLEET_DESCRIPTION");
						else
							toolTipString = Locale.Lookup(commandRow.Description);
						end
					elseif (actionHash == UnitCommandTypes.FORM_ARMY) then
						if (GameInfo.Units[unitType].Domain == "DOMAIN_SEA") then
							toolTipString = Locale.Lookup("LOC_UNITCOMMAND_FORM_ARMADA_DESCRIPTION");
						else
							toolTipString = Locale.Lookup(commandRow.Description);
						end
					else
						toolTipString = Locale.Lookup(commandRow.Description);
					end
					if (tResults ~= nil) then
						if (tResults[UnitOperationResults.ACTION_NAME] ~= nil and tResults[UnitOperationResults.ACTION_NAME] ~= "") then
							toolTipString = Locale.Lookup(tResults[UnitOperationResults.ACTION_NAME]);
						end

						if (tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION] ~= nil) then
							toolTipString = toolTipString .. "[NEWLINE]"; -- Line break before add'l desc block
							for i,v in ipairs(tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION]) do
								toolTipString = toolTipString .. "[NEWLINE]" .. Locale.Lookup(v);
							end
							
							if (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
								if (table.count(tResults[UnitOperationResults.FAILURE_REASONS]) > 0) then
									toolTipString = toolTipString .. "[NEWLINE]"; -- Line break after add'l desc block if there are failure reasons to report
								end
							end
						end

						-- Are there any failure reasons?
						if ( bDisabled ) then
							if (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
								-- Add the reason(s) to the tool tip
								for i,v in ipairs(tResults[UnitOperationResults.FAILURE_REASONS]) do
									toolTipString = toolTipString .. "[NEWLINE]" .. "[COLOR:Red]" .. Locale.Lookup(v) .. "[ENDCOLOR]";
								end
							end
						end
					end
					isDisabled = bDisabled or isDisabled;	-- Mix in tutorial disabledness
					local overrideIcon:string = nil;

					isDisabled, tooltipString, overrideIcon = LateCheckActionBeforeAdd( kActionsTable, actionHash, isDisabled, tooltipString, overrideIcon );
					AddActionToTable( actionsTable, commandRow, isDisabled, toolTipString, actionHash, OnUnitActionClicked, UnitCommandTypes.TYPE, actionHash, overrideIcon  );
				end
			end
		end
	end


	-- Loop over the UnitOperations (like commands but may take 1 to N turns to complete)
	
	-- Only show the operations if the unit has moves left.
    local isHasMovesLeft = pUnit:GetMovesRemaining() > 0;
	if isHasMovesLeft then
		
		for operationRow in GameInfo.UnitOperations() do

			local actionHash	:number = operationRow.Hash;
			local isDisabled	:boolean= IsDisabledByTutorial( unitType, actionHash ); 

			-- if unit can build an improvement, show all the buildable improvements for that tile
			if IsBuildingImprovement(actionHash) then
				local tParameters = GetBuildImprovementParameters(actionHash, pUnit);

				--Call CanStartOperation asking for results
				local bCanStart, tResults = UnitManager.CanStartOperation( pUnit, actionHash, nil, tParameters, true);

				if (bCanStart and tResults ~= nil) then
					if (tResults[UnitOperationResults.IMPROVEMENTS] ~= nil and #tResults[UnitOperationResults.IMPROVEMENTS] ~= 0) then
						
						bestValidImprovement = tResults[UnitOperationResults.BEST_IMPROVEMENT];
						
						local tImprovements = tResults[UnitOperationResults.IMPROVEMENTS];
						for i, eImprovement in ipairs(tImprovements) do
							
							tParameters[UnitOperationTypes.PARAM_IMPROVEMENT_TYPE] = eImprovement;
							
							local improvement		= GameInfo.Improvements[eImprovement];

							bCanStart, tResults = UnitManager.CanStartOperation(pUnit, actionHash, nil, tParameters, true);
							local isDisabled		= not bCanStart;
							local toolTipString		= Locale.Lookup(operationRow.Description) .. ": " .. Locale.Lookup(improvement.Name);

							if tResults ~= nil then

								if (tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION] ~= nil) then
									for i,v in ipairs(tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION]) do
										toolTipString = toolTipString .. "[NEWLINE]" .. Locale.Lookup(v);
									end
								end

								-- Are there any failure reasons?
								if isDisabled then
									if (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
										-- Add the reason(s) to the tool tip
										for i,v in ipairs(tResults[UnitOperationResults.FAILURE_REASONS]) do
											toolTipString = toolTipString .. "[NEWLINE]" .. "[COLOR:Red]" .. Locale.Lookup(v) .. "[ENDCOLOR]";
										end
									end
								end
							end

							-- If this improvement is the same enum as what the game marked as "the best" for this plot, set this flag for the UI to use.
							if ( bestValidImprovement ~= nil and bestValidImprovement ~= -1 and bestValidImprovement == eImprovement ) then
								improvement["IsBestImprovement"] = true;
							else
								improvement["IsBestImprovement"] = false;
							end

							improvement["CategoryInUI"] = "BUILD";	-- TODO: Force improvement to be a type of "BUILD", this can be removed if CategoryInUI is added to "Improvements" in the database schema. ??TRON
							local callbackFn, isDisabled = GetBuildImprovementCallback( actionHash, isDisabled );
							AddActionToTable( actionsTable, improvement, isDisabled, toolTipString, actionHash, callbackFn, improvement.Hash );
						end
					end
				end
			elseif (actionHash == UnitOperationTypes.MOVE_TO) then
				local bCanStart		:boolean= UnitManager.CanStartOperation( pUnit,  UnitOperationTypes.MOVE_TO, nil, false, false);	-- No exclusion test, no results
				if (bCanStart) then
					local toolTipString	:string	= Locale.Lookup(operationRow.Description);
					AddActionToTable( actionsTable, operationRow, isDisabled, toolTipString, actionHash, OnUnitActionClicked_MoveTo );
				end
			elseif (operationRow.CategoryInUI == "OFFENSIVESPY") then
				local bCanStart		:boolean= UnitManager.CanStartOperation( pUnit, actionHash, nil, false, false);	-- No exclusion test, no result
				if (bCanStart) then
					---- We only want a single offensive spy action which opens the EspionageChooser side panel
					if actionsTable[operationRow.CategoryInUI] ~= nil and table.count(actionsTable[operationRow.CategoryInUI]) == 0 then
						local toolTipString	:string	= Locale.Lookup("LOC_UNITPANEL_ESPIONAGE_CHOOSE_MISSION");
						AddActionToTable( actionsTable, operationRow, isDisabled, toolTipString, actionHash, OnUnitActionClicked, UnitOperationTypes.TYPE, actionHash, "ICON_UNITOPERATION_SPY_MISSIONCHOOSER");
					end
				end
			elseif (actionHash == UnitOperationTypes.SPY_COUNTERSPY) then
				local bCanStart, tResults = UnitManager.CanStartOperation( pUnit, actionHash, nil, true );
				if (bCanStart) then
					local toolTipString	= Locale.Lookup(operationRow.Description);
					AddActionToTable( actionsTable, operationRow, isDisabled, toolTipString, actionHash, OnUnitActionClicked, UnitOperationTypes.TYPE, actionHash, "ICON_UNITOPERATION_SPY_COUNTERSPY_ACTION");
				end
			elseif (actionHash == UnitOperationTypes.FOUND_CITY) then
				local bCanStart, tResults = UnitManager.CanStartOperation( pUnit,  UnitOperationTypes.FOUND_CITY, nil, false, OperationResultsTypes.ALL);	-- No exclusion test
				if (bCanStart) then
					local toolTipString	:string	= Locale.Lookup(operationRow.Description);
					AddActionToTable( actionsTable, operationRow, isDisabled, toolTipString, actionHash, function() OnUnitActionClicked_FoundCity(tResults); end);
				end
			elseif (actionHash == UnitOperationTypes.WMD_STRIKE) then
				-- if unit can deploy a WMD, create a unit action for each type
				-- first check if the unit is capable of deploying a WMD
				local bCanStart = UnitManager.CanStartOperation( pUnit, UnitOperationTypes.WMD_STRIKE, nil, true);
				if (bCanStart) then
					for entry in GameInfo.WMDs() do
						local tParameters = {};
						tParameters[UnitOperationTypes.PARAM_WMD_TYPE] = entry.Index;
						bCanStart, tResults = UnitManager.CanStartOperation(pUnit, actionHash, nil, tParameters, true);
						local isWMDTypeDisabled:boolean = (not bCanStart) or isDisabled;
						local toolTipString	:string	= Locale.Lookup(operationRow.Description);
						local wmd = entry.Index;
						toolTipString = toolTipString .. "[NEWLINE]" .. Locale.Lookup(entry.Name);
						local callBack = 
							function(void1,void2,mode) 
								OnUnitActionClicked_WMDStrike(wmd,mode); 
							end
						-- Are there any failure reasons?
						if ( not bCanStart ) then
							if tResults ~= nil and (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
								-- Add the reason(s) to the tool tip
								for i,v in ipairs(tResults[UnitOperationResults.FAILURE_REASONS]) do
									toolTipString = toolTipString .. "[NEWLINE]" .. "[COLOR:Red]" .. Locale.Lookup(v) .. "[ENDCOLOR]";
								end
							end
							if(not IsActionLimited(entry.WeaponType))then
								AddActionToTable( actionsTable, operationRow, isWMDTypeDisabled, toolTipString, actionHash, callBack ); 	
							end
						else
							AddActionToTable( actionsTable, operationRow, isWMDTypeDisabled, toolTipString, actionHash, callBack ); 
						end
											
					end
				end
			elseif (actionHash == REMOVE_HERESY_HASH_ID) then
				-- Is this operation visible in the UI?
				-- The UI check of an operation is a loose check where it only fails if the unit could never do the operation.
				if ( operationRow.VisibleInUI ) then
					local bCanStart:boolean, tResults:table = UnitManager.CanStartOperation( pUnit, actionHash, nil, true );

					if (bCanStart) then
						-- Check again if the operation can occur, this time for real.
						bCanStart, tResults = UnitManager.CanStartOperation(pUnit, actionHash, nil, false, OperationResultsTypes.NO_TARGETS);		-- Hint that we don't require possibly expensive target results.
						local bDisabled:boolean = not bCanStart;
						local toolTipString:string = GetUnitOperationTooltip(operationRow);

						if (tResults ~= nil) then
							if (tResults[UnitOperationResults.ACTION_NAME] ~= nil and tResults[UnitOperationResults.ACTION_NAME] ~= "") then
								toolTipString = Locale.Lookup(tResults[UnitOperationResults.ACTION_NAME]);
							end

							if (tResults[UnitOperationResults.FEATURE_TYPE] ~= nil) then
								local featureName = GameInfo.Features[tResults[UnitOperationResults.FEATURE_TYPE]].Name;
								toolTipString = toolTipString .. ": " .. Locale.Lookup(featureName);
							end

							if (tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION] ~= nil) then
								for i,v in ipairs(tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION]) do
									toolTipString = toolTipString .. "[NEWLINE]" .. Locale.Lookup(v);
								end
							end

							-- Are there any failure reasons?
							if ( bDisabled ) then
								if (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
									-- Add the reason(s) to the tool tip
									for i,v in ipairs(tResults[UnitOperationResults.FAILURE_REASONS]) do
										toolTipString = toolTipString .. "[NEWLINE]" .. "[COLOR:Red]" .. Locale.Lookup(v) .. "[ENDCOLOR]";
									end
								end
							end
						end
						isDisabled = bDisabled or isDisabled;

						if(not IsActionLimited(operationRow.PrimaryKey, pUnit))then
							local overrideIcon:string = nil;

							isDisabled, toolTipString, overrideIcon = LateCheckOperationBeforeAdd( tResults, actionsTable, actionHash, isDisabled, toolTipString, overrideIcon );
							AddActionToTable( actionsTable, operationRow, isDisabled, toolTipString, actionHash, OnUnitActionClicked_RemoveHeresy, UnitOperationTypes.TYPE, actionHash, overrideIcon  );
						end
					end
				end
				
			else
				-- Is this operation visible in the UI?
				-- The UI check of an operation is a loose check where it only fails if the unit could never do the operation.
				if ( operationRow.VisibleInUI ) then
					local bCanStart:boolean, tResults:table = UnitManager.CanStartOperation( pUnit, actionHash, nil, true );

					if (bCanStart) then
						-- Check again if the operation can occur, this time for real.
						bCanStart, tResults = UnitManager.CanStartOperation(pUnit, actionHash, nil, false, OperationResultsTypes.NO_TARGETS);		-- Hint that we don't require possibly expensive target results.
						local bDisabled:boolean = not bCanStart;
						local toolTipString:string = GetUnitOperationTooltip(operationRow);

						if (tResults ~= nil) then
							if (tResults[UnitOperationResults.ACTION_NAME] ~= nil and tResults[UnitOperationResults.ACTION_NAME] ~= "") then
								toolTipString = Locale.Lookup(tResults[UnitOperationResults.ACTION_NAME]);
							end

							if (tResults[UnitOperationResults.FEATURE_TYPE] ~= nil) then
								local featureName = GameInfo.Features[tResults[UnitOperationResults.FEATURE_TYPE]].Name;
								toolTipString = toolTipString .. ": " .. Locale.Lookup(featureName);
							end

							if (tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION] ~= nil) then
								for i,v in ipairs(tResults[UnitOperationResults.ADDITIONAL_DESCRIPTION]) do
									toolTipString = toolTipString .. "[NEWLINE]" .. Locale.Lookup(v);
								end
							end

							-- Are there any failure reasons?
							if ( bDisabled ) then
								if (tResults[UnitOperationResults.FAILURE_REASONS] ~= nil) then
									-- Add the reason(s) to the tool tip
									for i,v in ipairs(tResults[UnitOperationResults.FAILURE_REASONS]) do
										toolTipString = toolTipString .. "[NEWLINE]" .. "[COLOR:Red]" .. Locale.Lookup(v) .. "[ENDCOLOR]";
									end
								end
							end
						end
						isDisabled = bDisabled or isDisabled;

						if(not IsActionLimited(operationRow.PrimaryKey, pUnit))then
							local overrideIcon:string = nil;

							isDisabled, toolTipString, overrideIcon = LateCheckOperationBeforeAdd( tResults, actionsTable, actionHash, isDisabled, toolTipString, overrideIcon );
							AddActionToTable( actionsTable, operationRow, isDisabled, toolTipString, actionHash, OnUnitActionClicked, UnitOperationTypes.TYPE, actionHash, overrideIcon  );
						end
					end
				end
			end
		end
	end
	-- Scenario Unit Commands
	--	Test all custom commands in table defined in "BlackDeathScenario_UnitCommands" to add
	--	to the selected unit's table.
	for sCommandKey, pCommandTable in pairs(m_BBGCustomUnitCommands) do
		
		--if UnitManager.CanStartCommand(pUnit, UnitCommandTypes.EXECUTE_SCRIPT) then
			local bVisible : boolean = true;
			if (pCommandTable.IsVisible ~= nil) then
				bVisible = pCommandTable.IsVisible(pUnit);
			end
			if (bVisible) then

				if (pCommandTable.CanUse ~= nil and pCommandTable.CanUse(pUnit) == true) then

					local bIsDisabled : boolean = false;
					if (pCommandTable.IsDisabled ~= nil) then
						bIsDisabled = pCommandTable.IsDisabled(pUnit);
					end
			
					local sToolTipString : string = pCommandTable.ToolTipString or "Undefined Unit Command";

					local pCallback : ifunction = function()
						local pSelectedUnit = UI.GetHeadSelectedUnit();
						if (pSelectedUnit == nil) then
							return;
						end

						local tParameters = {};
						tParameters[UnitCommandTypes.PARAM_NAME] = pCommandTable.EventName or "";
						UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);
					end

					if (bIsDisabled and pCommandTable.DisabledToolTipString ~= nil) then
						sToolTipString = sToolTipString .. "[NEWLINE][NEWLINE]" .. pCommandTable.DisabledToolTipString;
					end

					AddActionToTable(actionsTable, pCommandTable, bIsDisabled, sToolTipString, UnitCommandTypes.EXECUTE_SCRIPT, pCallback);
				end
			end
	end


	return actionsTable;
end

-- ===========================================================================
function OnUnitActionClicked_RemoveHeresy( actionType:number, actionHash:number, currentMode:number )
	if g_isOkayToProcess then
		local pSelectedUnit :table= UI.GetHeadSelectedUnit();
			if (actionType == UnitOperationTypes.TYPE and actionHash == REMOVE_HERESY_HASH_ID) then
				local tParameters = {};
				tParameters[UnitCommandTypes.PARAM_NAME] = "BBGCommand_Purge";
				UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);	
				UnitManager.RequestOperation( pSelectedUnit, actionHash );
			end

	else
		UI.DataError("OnUnitActionClicked_RemoveHeresy() but it's currently not okay to process. (Which is fine; unless it's the player's turn.)");
	end
end

function OnUnitActionClicked_Condemn_Heretic( actionType:number, actionHash:number, currentMode:number )
	if g_isOkayToProcess then
		local pSelectedUnit :table= UI.GetHeadSelectedUnit();
			if (actionHash == UnitCommandTypes.CONDEMN_HERETIC) then
				local tParameters = {};
				tParameters[UnitCommandTypes.PARAM_NAME] = "BBGCommand_Burn";
				UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);
				UI.PlaySound("Unit_CondemnHeretic_2D")		
			end

	else
		UI.DataError("OnUnitActionClicked_Condemn_Heretic() but it's currently not okay to process. (Which is fine; unless it's the player's turn.)");
	end
end

