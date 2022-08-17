include "bbg_stateutils"
print("BBG Custom Unit Commands")
--[[ =======================================================================

	BBG Custom Unit Commands - Logic

	Receivers for custom unit command events are defined here. They handle
	EXECUTE_SCRIPT commands triggered in the replacement Unit Panel UI script.
	
	EXECUTE_SCRIPT would call it using the .EventName as reference for
	the function name. Script has arg1 the playerID and arg2 the unitID 
	
	They the function is added as a GameEvents
-- =========================================================================]]

--	Initial State Data for units that use these commands

-- ===========================================================================
--	Constants
-- ===========================================================================
local iCondemn_BaseDmg = 100;
local iCondemn_LoyaltyRng = 6;
local iCondemn_LoyaltyPenalty = -15;

local iCondemn_MartyrRng = 9;
local iCondemn_MartyrPressure = 0;
local iCondemn_MartyrChance = 0;

local iRemoveHeresy_LoyaltyPenalty = -20;
local iRemoveHeresy_PopPenalty_Minor = 0;
local iRemoveHeresy_PopPenalty_Moderate = 0;
local iRemoveHeresy_PopPenalty_Major = 0;



-- ===========================================================================
--	Function
-- ===========================================================================
-- PURGE is called on REMOVE_HERESY
function BBGCommand_Purge(eOwner : number, iUnitID : number)
	local pPlayer = Players[eOwner];
	if (pPlayer == nil) then
		return;
	end

	local pUnit = pPlayer:GetUnits():FindID(iUnitID);
	if (pUnit == nil) then
		return;
	end
	
	local pCity : object = CityManager.GetCityAt(pUnit:GetX(), pUnit:GetY());
	if (pCity == nil) then
		for direction = 0, 6, 1 do
			local adjacentPlot = Map.GetAdjacentPlot(pUnit:GetX(), pUnit:GetY(), direction);
			if (adjacentPlot ~= nil) then
				if(adjacentPlot:IsCity() == true) then
					pCity = CityManager.GetCityAt(adjacentPlot:GetX(), adjacentPlot:GetY());
					break
				end
			end
		end
		if (pCity == nil) then
			return
		end
	end
	local cityReligion = pCity:GetReligion()
	if cityReligion == nil then
		return
	end
	local religionType = cityReligion:GetMajorityReligion()
	local message = "-20 Loyalty"
	local string_msg = ""
	string_msg = "[COLOR_RED]"..iRemoveHeresy_LoyaltyPenalty.." "..Locale.Lookup("LOC_REPORTS_LOYALTY")
	-- small purge, loyality only
	local unitReligion = pUnit:GetReligion()
	if unitReligion == nil then
		return
	end
	local u_religionType = unitReligion:GetReligionType()
	if religionType == u_religionType then
		pCity:ChangeLoyalty(iRemoveHeresy_LoyaltyPenalty)
		-- large purge, loyality + population drop
		else
		pCity:ChangeLoyalty(iRemoveHeresy_LoyaltyPenalty)
		if pCity:GetPopulation() > 1 and pCity:GetPopulation() < 8 then
			pCity:ChangePopulation(iRemoveHeresy_PopPenalty_Minor);
			string_msg = string_msg.." "..iRemoveHeresy_PopPenalty_Minor.." "..Locale.Lookup("LOC_CIVINFO_POPULATION")
			elseif pCity:GetPopulation() > 7 and pCity:GetPopulation() < 15 then
			pCity:ChangePopulation(iRemoveHeresy_PopPenalty_Moderate);
			string_msg = string_msg.." "..iRemoveHeresy_PopPenalty_Moderate.." "..Locale.Lookup("LOC_CIVINFO_POPULATION")
			else
			pCity:ChangePopulation(iRemoveHeresy_PopPenalty_Major);
			string_msg = string_msg.." "..iRemoveHeresy_PopPenalty_Major.." "..Locale.Lookup("LOC_CIVINFO_POPULATION")
		end
	end
	
	Game.AddWorldViewText(0, string_msg, pUnit:GetX(), pUnit:GetY());

	-- Report to the application side that we did something.  This helps with visualization
	UnitManager.ReportActivation(pUnit, "PURGE");	
end

GameEvents.BBGCommand_Purge.Add(BBGCommand_Purge)

-- BURN is called on CONDEMN_HERETIC
function BBGCommand_Burn(eOwner : number, iUnitID : number)
	local pPlayer = Players[eOwner];
	if (pPlayer == nil) then
		return;
	end

	local pUnit = pPlayer:GetUnits():FindID(iUnitID);
	if (pUnit == nil) then
		return;
	end
	
	local religiousLayerID = 3;
	local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
	if(pPlot:GetUnitCount() > 0) then
		for loop, unit in ipairs(Units.GetUnitsInPlotLayerID(pPlot, religiousLayerID)) do
			if(unit ~= nil) then
				if(unit:GetOwner() ~= eOwner and (unit:GetName() == "LOC_UNIT_MISSIONARY_NAME"
												or unit:GetName() == "LOC_UNIT_INQUISITOR_NAME"
												or unit:GetName() == "LOC_UNIT_APOSTLE_NAME"
												or unit:GetName() == "LOC_UNIT_GURU_NAME")) then
					local religiousForce = unit:GetReligion():GetReligiousStrength()
					local religionType = unit:GetReligion():GetReligionType()
					if religiousForce == nil then
						religiousForce = 100
					end
					local dmgModifier = 100/religiousForce
					local victimDmg = unit:GetDamage()
					if victimDmg == nil then
						victimDmg = 0
					end
					local dmgBase = iCondemn_BaseDmg 
					if (victimDmg - dmgBase * dmgModifier ) < 5  then
						-- Kill the unit
						local pUnitExp = unit:GetExperience()
						local requiredPromotion = GameInfo.UnitPromotions["PROMOTION_MARTYR"];
						if pUnitExp:HasPromotion(requiredPromotion.Index) == true then
							local iRandom = TerrainBuilder.GetRandomNumber(100, "Random Martyr")
							if iRandom < iCondemn_MartyrRng then
								ApplyReligiousBurst(pPlot, unit:GetOwner(), religionType, iCondemn_MartyrRng, iCondemn_MartyrPressure)
							end	
						end
						UnitManager.Kill(unit)
						ApplyLoyaltyReligiousDebuff(pPlot,eOwner,religionType)
						else
						-- Damage the unit
						unit:SetDamage(dmgBase * dmgModifier + victimDmg)
						ApplyLoyaltyReligiousDebuff(pPlot,eOwner,religionType)
					end
				end
			end
		end
		else
		return
	end
	
	-- Report to the application side that we did something.  This helps with visualization
	UnitManager.ReportActivation(pUnit, "BURN");	
	UnitManager.FinishMoves(pUnit);
end

GameEvents.BBGCommand_Burn.Add(BBGCommand_Burn)

function ApplyLoyaltyReligiousDebuff(plot,eOwner,religionType)
	-- Apply a Loyalty Debuff to city with same religion within a certain range
	if plot == nil or eOwner == nil or religionType == nil then
		return
	end

	local pPlayer = Players[eOwner];
	if (pPlayer == nil) then
		return;
	end

	for dx = -iCondemn_LoyaltyRng, iCondemn_LoyaltyRng do
        for dy = -iCondemn_LoyaltyRng, iCondemn_LoyaltyRng do
            local otherPlot = Map.GetPlotXYWithRangeCheck(plot:GetX(), plot:GetY(), dx, dy, iCondemn_LoyaltyRng);
            if(otherPlot) then
                if(otherPlot:IsCity()) then
					local pCity : object = CityManager.GetCityAt(otherPlot:GetX(), otherPlot:GetY());
					if pCity:GetOwner() == eOwner then
						local cityReligion = pCity:GetReligion()
						if cityReligion ~= nil then
							local cityReligionType = cityReligion:GetMajorityReligion()
							if cityReligionType == religionType then
								pCity:ChangeLoyalty(iCondemn_LoyaltyPenalty)
								local string_msg = ""
								string_msg = "[COLOR_RED]"..iCondemn_LoyaltyPenalty.." "..Locale.Lookup("LOC_REPORTS_LOYALTY")
								Game.AddWorldViewText(0, string_msg, otherPlot:GetX(), otherPlot:GetY());
							end
						end
					end
                end
            end
        end
    end
end

function ApplyReligiousBurst(plot, unitOwner, religionType, range, pressure)
	-- Apply a Religious Pressure Burst to cities within a within a certain range
	if plot == nil or religionType == nil or range == nil or pressure == nil or unitOwner == nil then
		return
	end


	for dx = -range, range do
        for dy = -range, range do
            local otherPlot = Map.GetPlotXYWithRangeCheck(plot:GetX(), plot:GetY(), dx, dy, range);
            if(otherPlot) then
                if(otherPlot:IsCity()) then
					local pCity : object = CityManager.GetCityAt(otherPlot:GetX(), otherPlot:GetY());
						pCity:GetReligion():AddReligiousPressure(unitOwner, religionType, pressure, -1);
						local string_msg = ""
						string_msg = "[COLOR_RED] +"..pressure.." Religious Pressure"
						Game.AddWorldViewText(0, string_msg, otherPlot:GetX(), otherPlot:GetY());
                end
            end
        end
    end
end