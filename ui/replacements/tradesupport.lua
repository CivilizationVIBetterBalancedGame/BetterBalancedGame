print("TradeSupport BBG overide loaded")


-- Get idle Trade Units by Player ID
function GetIdleTradeUnits( playerID:number )
	local idleTradeUnits:table = {};

	-- Loop through the Players units
	local localPlayerUnits:table = Players[playerID]:GetUnits();
	for i,unit in localPlayerUnits:Members() do

		-- Find any trade units
		local unitInfo:table = GameInfo.Units[unit:GetUnitType()];
		if unitInfo.MakeTradeRoute then
			local doestradeUnitHasRoute:boolean = false;

			-- Determine if those trade units are busy by checking outgoing routes from the players cities
			local localPlayerCities:table = Players[playerID]:GetCities();
			for i,city in localPlayerCities:Members() do
				local routes = city:GetTrade():GetOutgoingRoutes();
				for i,route in ipairs(routes) do
					if route.TraderUnitID == unit:GetID() then
						doestradeUnitHasRoute = true;
					end
				end
			end

			-- If this trade unit isn't attached to an outgoing route then they are idle
			if not doestradeUnitHasRoute then
				table.insert(idleTradeUnits, unit);
			end
		end
	end

	return idleTradeUnits;
end

-- ===========================================================================
function GetYieldsForRoute(pOriginCity:table, pDestinationCity:table, bReturnDestiationYields:boolean)
	local kRouteInfo:table = {
		kYieldValues = {},
		TooltipText = "",
		HasPathBonus = false,
		MajorityReligion = -1,
		ReligionPressure = -1
	}

	if pOriginCity == nil or pDestinationCity == nil then
		return kRouteInfo;
	end

	local pTradeManager = Game.GetTradeManager();

	-- Default to origin yields
	if bReturnDestiationYields == nil then
		bReturnDestiationYields = false;
	end

	local originOwnerID:number = pOriginCity:GetOwner();
	local originCityID:number = pOriginCity:GetID();

	local destOwnerID:number = pDestinationCity:GetOwner();
	local destCityID:number = pDestinationCity:GetID();

	-- From route
	local kRouteYields:table = {};
	if not bReturnDestiationYields then
		kRouteYields = pTradeManager:CalculateOriginYieldsFromPotentialRoute(originOwnerID, originCityID, destOwnerID, destCityID);
	else
		kRouteYields = pTradeManager:CalculateDestinationYieldsFromPotentialRoute(originOwnerID, originCityID, destOwnerID, destCityID);
	end

	-- From path
	local kPathYields:table = {};
	if not bReturnDestiationYields then
		kPathYields = pTradeManager:CalculateOriginYieldsFromPath(originOwnerID, originCityID, destOwnerID, destCityID);
	else
		kPathYields = pTradeManager:CalculateDestinationYieldsFromPath(originOwnerID, originCityID, destOwnerID, destCityID);
	end

	-- From modifiers
	local kModifierYields:table = {};
	if not bReturnDestiationYields then
		kModifierYields = pTradeManager:CalculateOriginYieldsFromModifiers(originOwnerID, originCityID, destOwnerID, destCityID);
	else
		kModifierYields = pTradeManager:CalculateDestinationYieldsFromModifiers(originOwnerID, originCityID, destOwnerID, destCityID);
	end

	-- Overall modifiers / multipliers
	local kYieldMultipliers:table = {};
	for yieldIndex=1, #kRouteYields, 1 do
		kYieldMultipliers[yieldIndex] = 1;
		if originOwnerID ~= destOwnerID then
			if not bReturnDestiationYields then
				local pPlayerTrade:table = Players[originOwnerID]:GetTrade();
				kYieldMultipliers[yieldIndex] = pPlayerTrade:GetInternationalYieldModifier(yieldIndex-1);
			else
				local pPlayerTrade:table = Players[destOwnerID]:GetTrade();
				kYieldMultipliers[yieldIndex] = pPlayerTrade:GetInternationalYieldModifier(yieldIndex-1);
			end
		end
	end

	-- BBG Corrects Amani owner only trade route bonuses to show on Trader Unit Panel

    local isCityState:boolean = false;
    local governorsAssignedToCity = pDestinationCity:GetAllAssignedGovernors();
    -- print(#governorsAssignedToCity);
    local playerId = Game.GetLocalPlayer();
    -- print('PlayerId:');
    -- print(playerID);
    for i, j in ipairs(governorsAssignedToCity) do
        if j:GetOwner() == playerId then
            -- print('CS Amani Governor belongs to player');
            -- check its a city state
            for i, pCityState in ipairs(PlayerManager.GetAliveMinors()) do
		        if pCityState:GetID() == destOwnerID then
			        isCityState = true;
			        break;
		        end
	        end
	        -- need this check to make sure its not Ibrahim (Ottoman governor)
            if j:GetName() == 'LOC_GOVERNOR_THE_AMBASSADOR_NAME' and j:IsEstablished() and isCityState then
                -- print('Amani fully established, adding Messenger promo yields.')
                kRouteYields[1] = kRouteYields[1] + 2;
                kRouteYields[2] = kRouteYields[2] + 2;
                --[[if j:HasPromotion(DB.MakeHash('GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR')) then
                	kRouteYields[1] = kRouteYields[1] + 1;
                    kRouteYields[2] = kRouteYields[2] + 1;
                    kRouteYields[3] = kRouteYields[1] + 3;
                    -- print('Amani Promotion recognised, added Foreign Investor yields to display');
                end --]]
            end
        end
    end

	-- Add the yields together and return the result
	for yieldIndex=1, #kRouteYields, 1 do

		local kYieldInfo:table = GameInfo.Yields[yieldIndex - 1];
		if kYieldInfo ~= nil then
			local routeValue:number = kRouteYields[yieldIndex];
			if routeValue > 0 then
				if kRouteInfo.TooltipText ~= "" then
					kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
				end
				kRouteInfo.TooltipText = kRouteInfo.TooltipText .. Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_DISTRICTS", routeValue, kYieldInfo.IconString, kYieldInfo.Name, pDestinationCity:GetName());
			end

			local pathValue:number = kPathYields[yieldIndex];
			if pathValue > 0 then
				kRouteInfo.HasPathBonus = true;
				if kRouteInfo.TooltipText ~= "" then
					kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
				end
				kRouteInfo.TooltipText = kRouteInfo.TooltipText .. Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_TRADING_POSTS", pathValue, kYieldInfo.IconString, kYieldInfo.Name);
			end

			local modifierValue:number = kModifierYields[yieldIndex];
			if modifierValue > 0 then
				if kRouteInfo.TooltipText ~= "" then
					kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
				end
				kRouteInfo.TooltipText = kRouteInfo.TooltipText .. Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_BONUSES", modifierValue, kYieldInfo.IconString, kYieldInfo.Name);
			end

			local totalBeforeMultiplier:number = routeValue + pathValue + modifierValue;
			local total:number = totalBeforeMultiplier;
			local multiplier:number = kYieldMultipliers[yieldIndex];
			if total > 0 and multiplier ~= 1 then
				total = totalBeforeMultiplier * multiplier;
				local valueFromMultiplier:number = total - totalBeforeMultiplier;
				local multiplierAsPercent:number = (multiplier * 100) - 100;

				if kRouteInfo.TooltipText ~= "" then
					kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
				end
				kRouteInfo.TooltipText = kRouteInfo.TooltipText .. Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_MULTIPLIERS", valueFromMultiplier, kYieldInfo.IconString, kYieldInfo.Name, multiplierAsPercent);
			end

			-- Put the total into routeYields
			kRouteInfo.kYieldValues[yieldIndex] = total;
		end
	end

	kRouteInfo.MajorityReligion = pOriginCity:GetReligion():GetMajorityReligion();
	if (kRouteInfo.MajorityReligion > 0) then
		local pressureValue, sourceText = GetReligiousPressureForCity(kRouteInfo.MajorityReligion, pOriginCity, pDestinationCity, not bReturnDestiationYields);
		if (pressureValue ~= 0) then
			if (kRouteInfo.TooltipText ~= "") then
				kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
			end
			kRouteInfo.TooltipText = kRouteInfo.TooltipText .. sourceText;
			kRouteInfo.ReligionPressure = pressureValue;
		end
	end

	return kRouteInfo;
end

-- ===========================================================================
function GetReligiousPressureForCity(religionIndex:number, originCity:table, destinationCity:table, forOriginCity:boolean)
	local pressureValue = 0;
	local pressureIconString = "";
	local cityName = "";
	local tradeManager = Game.GetTradeManager();

	if originCity == nil or destinationCity == nil then
		return 0, "";
	end

	if (forOriginCity) then
		pressureValue = tradeManager:CalculateOriginReligiousPressureFromPotentialRoute(originCity:GetOwner(), originCity:GetID(), destinationCity:GetOwner(), destinationCity:GetID(), religionIndex);
		pressureIconString = "[ICON_PressureLeft]";
		cityName = destinationCity:GetName();
	else
		pressureValue = tradeManager:CalculateDestinationReligiousPressureFromPotentialRoute(originCity:GetOwner(), originCity:GetID(), destinationCity:GetOwner(), destinationCity:GetID(), religionIndex);
		pressureIconString = "[ICON_PressureRight]";
		cityName = originCity:GetName();
	end
	local sourceText = Locale.Lookup("LOC_ROUTECHOOSER_RELIGIOUS_PRESSURE_SOURCE_MAJORITY_RELIGION", pressureValue, pressureIconString, Game.GetReligion():GetName(religionIndex), cityName);
	return pressureValue, sourceText;
end
