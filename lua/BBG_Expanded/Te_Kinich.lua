-- Port Lime - Te Kinich - Functions
-- Author: Lime
-- DateCreated: 5/31/2024 4:38:43 PM
--------------------------------------------------------------
--	Damaging enemy cities provides a burst of Science equal to twice the damage the city
--	received, and conquering a capital grants you a random Eureka. Discovering a 
--	Technology while at war instantly heals all your military units by 50 and grants 
--	them +5 XP. 

function C15_GetValidTraitPlayersNew(sTrait)
    local tValid = {}
    for k, v in ipairs(PlayerManager.GetWasEverAliveIDs()) do
        local leaderType = PlayerConfigurations[v]:GetLeaderTypeName()
        for trait in GameInfo.LeaderTraits() do
            if trait.LeaderType == leaderType and trait.TraitType == sTrait then 
                tValid[v] = true 
            end;
        end
        if not tValid[v] then
            local civType = PlayerConfigurations[v]:GetCivilizationTypeName()
            for trait in GameInfo.CivilizationTraits() do
                if trait.CivilizationType == civType and trait.TraitType == sTrait then 
                    tValid[v] = true 
                end;
            end
        end
    end
    return tValid
end

--=============================================================================================================

local iTrait	= "TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS"
local tValidPlayers = C15_GetValidTraitPlayersNew(iTrait)

function LimeTeKinich_GrantScienceOnDamage(m_combatData)
	-- find out if the attacker is Te' K'inich
	local attacker = m_combatData[CombatResultParameters.ATTACKER]
	local tAttackerID = attacker[CombatResultParameters.ID].player
	if not tValidPlayers[tAttackerID] then return end 
--	print("TK has damaged a something")

	-- find out if the defender is a city
--	print(m_combatData[CombatResultParameters.DEFENDER])
	local defender = m_combatData[CombatResultParameters.DEFENDER]
	--print(defender[CombatResultParameters.ID].type)
	if not (defender[CombatResultParameters.ID].type == 3) then return end
--	print("TK was attacking a city!")

	-- adjust the amount of damage
	local iAmountScience = defender[CombatResultParameters.DAMAGE_TO]
	--print("I think the city took this much damage! "..iAmountScience)
	local pPlayer = Players[tAttackerID]
	pPlayer:GetTechs():ChangeCurrentResearchProgress(iAmountScience)

	-- send up a flag
	if pPlayer == Players[Game.GetLocalPlayer()] then
		local tAttackerX = attacker[CombatResultParameters.LOCATION].x
		local tAttackerY = attacker[CombatResultParameters.LOCATION].y
		Game.AddWorldViewText(tAttackerID, Locale.Lookup("LOC_LIME_MAYA_TE_KINICH_SCIENCE", iAmountScience), tAttackerX, tAttackerY, 0)
	end
end
-- Events.Combat.Add(LimeTeKinich_GrantScienceOnDamage)

--===============================================================================================================

local sCapital = "TRAIT_TE_KINICH_originalcapital"

function LimeTeKinich_PlayerSettledCity(playerID, cityID, x, y)
--	print("a city was settled!")
	local pPlayer = Players[playerID]
--	if not pPlayer:IsMajor() then return end

--	print("it was a major civ!")
	if pPlayer:GetCities():GetCapitalCity():GetID() == cityID then
--		print("it was a capital!")
		if not pPlayer:GetProperty(sCapital) then
--			print("this is the first time this player gets their capital messed with") -- it's not gonna work fully right with Phoenicia but edge case I guess I'm too dumb
			local pPlot = Map.GetPlotXY(x,y)
			pPlot:SetProperty(sCapital,true)
			pPlayer:SetProperty(sCapital,true)
--			print("plot setting done")
		end
	end
end
-- Events.CityAddedToMap.Add(LimeTeKinich_PlayerSettledCity)

function LimeTeKinich_GrantEurekaOnConquest(newPlayerID, oldPlayerID, newCityID, cityX, cityY)
	if not tValidPlayers[newPlayerID] then return end 
--	print("te kinich conquered a city")

	if Map.GetPlotXY(cityX, cityY):GetProperty(sCapital) then
--		print("te kinich conquered a capital")
		Players[newPlayerID]:AttachModifierByID("MOD_LIME_TE_KINICH_GRANT_EUREKA")
--		print("eureka granted")
	end
end
-- GameEvents.CityConquered.Add(LimeTeKinich_GrantEurekaOnConquest)

--==================================================================================================================

--local iHealAmount	= 50 -- in case I want to change it)
--local iXPAmount		= 5 -- well only if I end up luaing the whole thing

-- function LimeTeKinich_IsAtWar(pPlayer)
-- 	local pDiplo = pPlayer:GetDiplomacy()
	
-- 	for k, v in ipairs(PlayerManager.GetAliveIDs()) do 
-- --		print("target has met this one!")
-- 		if pDiplo:IsAtWarWith(v) then
-- 			return true
-- 		else
-- 				--iNumAtPeace = iNumAtPeace + 1
-- --			print("this one was at peace!")
-- 		end
-- --		print("next!")
-- 	end
-- 	return false
-- end

function LimeTeKinich_HealSoldiersOnTech(playerID, technologyIndex)
	if not tValidPlayers[playerID] then return end 
--	print("Te' K'kinich has completed a technology!")

	local pPlayer = Players[playerID]

	for i, pUnit in pPlayer:GetUnits():Members() do
		pUnit:ChangeDamage(-5)
		pUnit:GetExperience():ChangeExperience(2)
--		print("this unit done! hope the float text happens!")
	end

--	print("all units healed and granted!")									-- is that how it works?
end
Events.TechBoostTriggered.Add(LimeTeKinich_HealSoldiersOnTech)

print("Loaded")