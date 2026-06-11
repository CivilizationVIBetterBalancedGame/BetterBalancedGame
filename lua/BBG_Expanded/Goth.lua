-- ========================================================================
-- =                              GOTHS                                  =
-- ========================================================================
-- base hook is canceled because the city is already migrated

-- from SeelingCat's Goth
function C15_GetValidTraitPlayers(sTrait)
    local tValid = {}
    for k, v in ipairs(PlayerManager.GetWasEverAliveIDs()) do
        local civType = PlayerConfigurations[v]:GetCivilizationTypeName()
        for trait in GameInfo.CivilizationTraits() do
            if trait.CivilizationType == civType and trait.TraitType == sTrait then 
                tValid[v] = true 
            end
        end
    end
    return tValid
end

local sTrait = "TRAIT_CIVILIZATION_MER_GOTHIC_MIGRATION"
local tTraitPlayers = C15_GetValidTraitPlayers(sTrait)

function BBG_Gothic_Pop(playerID, cityID)
    if tTraitPlayers[playerID] then

        local iRadius = 6
        local sGothPop = "LOC_GOTHIC_MIGRATION_POP_GAIN"
        
        -- print ("BBG_Gothic_Pop working!")
        local pPlayer = Players[playerID]
        local pPlayerCities = pPlayer:GetCities()
        local pCity = pPlayerCities:FindID(cityID)
        local oX = pCity:GetX()
        local oY = pCity:GetY()

        if oX > -1 then
            local CityCheck = Game:GetProperty(playerID .. oX .. "_" .. oY)

            if CityCheck ~= nil then
                -- print ("already migrated from this city")
            else
                if Players[playerID]:GetCulture():HasCivic(GameInfo.Civics["CIVIC_EARLY_EMPIRE"].Index) then
                    for i, otherCity in pPlayerCities:Members() do
                        if otherCity == pCity then
                            -- we don't need to test the city against itself
                        else
                            local nX = otherCity:GetX()
                            local nY = otherCity:GetY()

                            if nX > -1 then

                                local iDistance = Map.GetPlotDistance(oX, oY, nX, nY)

                                if iDistance <= iRadius then
                                    local pGrowth = otherCity:GetGrowth()
                                    if pGrowth and pGrowth:GetHousing() > otherCity:GetPopulation()+1 then
                                        otherCity:ChangePopulation(1)
                                        if pPlayer:IsHuman() then
                                            Game.AddWorldViewText(playerID, Locale.Lookup(sGothPop, 1), nX, nY, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                Game:SetProperty(playerID .. oX .. "_" .. oY, 1)
            end
        end
    end
end

Events.CityInitialized.Add(BBG_Gothic_Pop)
