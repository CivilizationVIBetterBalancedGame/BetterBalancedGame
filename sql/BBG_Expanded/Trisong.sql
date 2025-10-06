-- ========================================================================
-- =                              TIBET                                   =
-- ========================================================================

-- Citizen may work mountain tiles that receives yields from districts within 2 tiles 
-- 		- Campus 1 Science, IZ 1 Prod, Theater 1 Culture, Hub & Harbor 1 Gold, HS Faith, City Center 2 Food
-- May purchase buildings with faith in specialty districts next to mountains.
-- Cities with an established governor receive +5% faith for each promotion that governor has.

-- Start bias
-- All mountains to 3
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_SUK_TIBET' AND TerrainType IN ('TERRAIN_DESERT_MOUNTAIN', 'TERRAIN_SNOW_MOUNTAIN', 'TERRAIN_TUNDRA_MOUNTAIN');
UPDATE StartBiasTerrains SET Tier=3 WHERE CivilizationType='CIVILIZATION_SUK_TIBET';

-- 30/09/25: Can no longer purchase buildings on govplaza with faith
DELETE FROM TraitModifiers WHERE ModifierId='SUK_DHARMA_KINGS_DISTRICT_GOVERNMENT_FAITH_PURCHASE_MODIFIER';

-- ==========================================================
-- =                         DZONG                          =
-- ==========================================================

UPDATE ModifierArguments SET Value=5 WHERE ModifierId='SUK_DZONG_DEFENSE_STRENGTH';
UPDATE Districts SET Cost=30 WHERE DistrictType='DISTRICT_SUK_DZONG';
DELETE FROM District_ValidTerrains WHERE DistrictType='DISTRICT_SUK_DZONG';
UPDATE Districts SET Appeal=1 WHERE DistrictType='DISTRICT_SUK_DZONG';

-- 30/09/25: Dzong buildings now only have 10% discount with faith/gold (instead of 20%)
UPDATE ModifierArguments SET Value=10 WHERE Name='Amount' AND ModifierId LIKE 'SUK_DZONG_BUILDING_%';

-- ==========================================================
-- =                        RTA PA                          =
-- ==========================================================

-- Tibetan unique Renaissance era ranged cavalry, has a range of 1 but can move after attacking, no movement penalty in hill terrain. Unlock with Astronomy.
-- 17/08/25: -5/-5 nerf to combat and ranged strength
UPDATE Units SET Combat=50, RangedCombat=53, BaseMoves=4 WHERE UnitType='UNIT_SUK_TIBET_RTA_PA';

-- 30/09/25: Rta Pa no longer ignores hills
DELETE FROM UnitAbilityModifiers WHERE ModifierId='SUK_RTA_PA_IGNORE_HILLS';

-- ========================================================================
-- =                             TRISONG                                  =
-- ========================================================================

DELETE FROM TraitModifiers WHERE ModifierId='SUK_CAPTURE_OF_CHANGAN_GREAT_GENERAL_POINTS';

-- Land combat units in cities with a temple and an encampment get a free promotion (from worship building)
-- 17/08/25: free promotion is only granted if the city has a worship building
-- INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
-- 	('BBG_CITY_HAS_TEMPLE_AND_ENCAMPMENT_REQSET', 'REQUIREMENTSET_TEST_ALL');
-- INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
-- 	('BBG_CITY_HAS_TEMPLE_AND_ENCAMPMENT_REQSET', 'SUK_CAPTURE_OF_CHANGAN_HAS_DZONG'),
-- 	('BBG_CITY_HAS_TEMPLE_AND_ENCAMPMENT_REQSET', 'REQUIRES_CITY_HAS_ENCAMPMENT'),
-- 	('BBG_CITY_HAS_TEMPLE_AND_ENCAMPMENT_REQSET', 'REQUIRES_CITY_HAS_TEMPLE');
-- UPDATE Modifiers SET SubjectRequirementSetId='BBG_CITY_HAS_TEMPLE_AND_ENCAMPMENT_REQSET' WHERE ModifierId='SUK_CAPTURE_OF_CHANGAN_FREE_PROMOTION';

-- Get 1 governor title  when funding a religion
-- 17/08/25: no longer grants a free governor title upon founding a religion
-- INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
-- 	('BBG_TRISONG_GOVERNOR_RELIGION', 'MODIFIER_PLAYER_ADJUST_GOVERNOR_POINTS', 'BBG_PLAYER_FOUNDED_RELIGION_REQSET');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
-- 	('BBG_TRISONG_GOVERNOR_RELIGION', 'Delta', 1);
-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
-- 	('TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN', 'BBG_TRISONG_GOVERNOR_RELIGION');