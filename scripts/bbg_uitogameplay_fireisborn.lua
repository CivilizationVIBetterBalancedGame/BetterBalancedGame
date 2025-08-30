------------------------------------------------------------------------------
--	FILE:	 bbg_uitogameplay_fireisborn.lua
--	AUTHOR:  Calcifer
--	PURPOSE: Add Fire is born governor functionality
------------------------------------------------------------------------------

print("BBG UI to Gameplay Script for Fire is Born started")
--FireIsBorn
function OnGovernorAssigned(iCityOwnerID, iCityID, iGovernorOwnerID, iGovernorType)
	if iGovernorType ~= 8 then -- not fire is born
		return
	end
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iCityOwnerID, iCityID)
	if pTargetCity == nil then
		return
	end
	--above all mandatory checks that FireIsBorn is assigned
	--set player property
	local tFireIsBorn = {}
	tFireIsBorn["iCityID"] = iCityID
	tFireIsBorn["iMinorID"] = iCityOwnerID
	tFireIsBorn["Status"] = 0 
	--0: establishing, 1: established, -1 not assigned
	local kParameters = {}
	kParameters.OnStart = "GameplaySetFireIsBornProperty"
	kParameters["iGovernorOwnerID"] = iGovernorOwnerID
	kParameters["tFireIsBorn"] = tFireIsBorn
	UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function GetAppointedGovernor(playerID:number, governorTypeIndex:number)
	-- Make sure we're looking for a valid governor
	if playerID < 0 or governorTypeIndex < 0 then
		return nil;
	end

	-- Get the player governor list
	local pGovernorDef = GameInfo.Governors[governorTypeIndex];
	local pPlayer:table = Players[playerID];
	local pPlayerGovernors:table = pPlayer:GetGovernors();
	local bHasGovernors, tGovernorList = pPlayerGovernors:GetGovernorList();

	-- Find and return the governor from the governor list
	if pPlayerGovernors:HasGovernor(pGovernorDef.Hash) then
		for i,governor in ipairs(tGovernorList) do
			if governor:GetType() == governorTypeIndex then
				return governor;
			end
		end
	end

	-- Return nil if this player has not appointed that governor
	return nil;
end

function OnGovernorChanged(iGovernorOwnerID, iGovernorID)
	print("OnGovernorChanged")
	print(iGovernorOwnerID, iGovernorID)
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer==nil then
		return
	end
	if iGovernorID ~= 8 then --not fire is born
		return
	end
	local tFireIsBorn = pPlayer:GetProperty("FIREISBORN")
	if tFireIsBorn == nil then
		return
	end
	local pPlayerGovernors = pPlayer:GetGovernors()
	local pPlayerGovernor = GetAppointedGovernor(iGovernorOwnerID, iGovernorID)
	local kParameters = {}
	kParameters.OnStart = "GameplaySetFireIsBornProperty"
	kParameters["iGovernorOwnerID"] = iGovernorOwnerID
	if pPlayerGovernor:IsEstablished(1) and tFireIsBorn~=nil then
		print("Fire is born Established")
		local pCity = CityManager.GetCity(tFireIsBorn.iMinorID, tFireIsBorn.iCityID)
		if pPlayerGovernor:GetAssignedCity() == pCity then
			print("fire is born established -> recalculate fire is born yields and plot properties")
			tFireIsBorn.Status = 1
			kParameters["tFireIsBorn"] = tFireIsBorn
			UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		end
	elseif pPlayerGovernor:IsEstablished(1) == false and tFireIsBorn.iCityID ~= nil then
		print("fire is born removed -> recalculate fire is born yields and plot properties, player properties as well")
		tFireIsBorn.Status = -1
		kParameters["tFireIsBorn"] = tFireIsBorn
		UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	end
end


function OnTradeRouteActivityChanged(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	print("OnTradeRouteActivityChanged", iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	print(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	local pOriginPlayer = Players[iOriginPlayerID]
	if pOriginPlayer == nil then
		return
	end
	local pTargetPlayer = Players[iTargetPlayerID]
	if pTargetPlayer == nil then
		return
	end
	local pOriginCity = CityManager.GetCity(iOriginPlayerID, iOriginCityID)
	if pOriginCity == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iTargetPlayerID, iTargetCityID)
	if pTargetCity == nil then
		return
	end
	--above mandatory checks
	if pTargetPlayer:IsMajor() then -- script only works for CS
		return
	end
	--recalculate trade plot properties
	
	print("Recalculating plot properties")
	--local tAmani = pOriginPlayer:GetProperty("AMANI")
	--local tOCityTraders = pOriginCity:GetProperty("CS_TRADERS")
	--local iMyTargetPlayerID = -1
	--for i, iCSCityOwnerID in ipairs(tOCityTraders) do
		--if tAmani["iMinorID"] == iCSCityOwnerID then
			--iMyTargetPlayerID = tAmani["iMinorID"]
		--end
	--end
	local pCityOutTrade = pOriginCity:GetTrade():GetOutgoingRoutes()
	local bControl = false
	--print("Checking for Amani Trader property iMyTargetPlayerID", iMyTargetPlayerID)
	--if iMyTargetPlayerID ~= -1 then
		print("Amani Trader Property Found => Is Trader to Amani Active Checks")
		if pCityOutTrade ~= nil then
			for _, route in ipairs(pCityOutTrade) do
				if route.DestinationCityPlayer == iTargetPlayerID then
					bControl = true
				end
				print("City Owner", iTargetPlayerID, "bControl", bControl)
			end
		end
	--end
	print("bControl Final", bControl)
	local kParameters = {}
	kParameters.OnStart = "GameplaySetCSTrader"
	kParameters["iOriginPlayerID"] = iOriginPlayerID
	kParameters["iOriginCityID"] = iOriginCityID
	if bControl == true then
		print("Sending Add trader req")
		kParameters["iTargetPlayerID"] = iTargetPlayerID
		UI.RequestPlayerOperation(iOriginPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, iTargetPlayerID)
	else
		kParameters["iTargetPlayerID"] = 0 - iTargetPlayerID
		print("Sending Remove trader req")
		if not pOriginPlayer:CanUnreadyTurn() then

			--UI.IsTurnTimerElapsed(Game.GetLocalPlayer()) then
			print("Player Turn Ended => Adding to buffer")
			table.insert(tBufferedParams["CSBufferedParams"], kParameters)
		else
			print("PlayerTurnActive")
			tBufferedParams["CSBufferedParams"] = {}	
			UI.RequestPlayerOperation(iOriginPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, 0-iTargetPlayerID)
		end
	end
end

function Initialize()
	Events.GovernorAssigned.Add(OnGovernorAssigned)
	Events.GovernorChanged.Add(OnGovernorChanged)
	Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged)
end

--====Activation====--
Initialize()