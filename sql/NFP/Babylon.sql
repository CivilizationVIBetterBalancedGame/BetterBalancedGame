--==============================================================
--******            C I V I L I Z A T I O N S             ******
--==============================================================

-- Remove free envoy on first district without free building.
DELETE FROM TraitModifiers WHERE ModifierId IN ('TRAIT_FREE_ENVOY_WHEN_DISTRICT_MADE', 'TRAIT_FREE_ENVOY_WHEN_DISTRICT_MADE_SPECIFIC') AND TraitType='TRAIT_LEADER_HAMMURABI';

-- Eureka to 65% (from 100%)
-- INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
--     ('BBG_TRAIT_BABYLON_EUREKA', 'MODIFIER_PLAYER_ADJUST_TECHNOLOGY_BOOST');
-- INSERT INTO ModifierArguments(ModifierId, Name, Value, Extra) VALUES
--     ('BBG_TRAIT_BABYLON_EUREKA', 'Amount', '25', '-1');
-- DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_BABYLON' AND ModifierID='TRAIT_EUREKA_INCREASE';
-- INSERT INTO TraitModifiers(TraitType, ModifierID) VALUES
--     ('TRAIT_CIVILIZATION_BABYLON', 'BBG_TRAIT_BABYLON_EUREKA');
-- -- Science +1% per technology unlocked.
-- INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId)
--     SELECT 'BBG_BABYLON_SCIENCE_' || TechnologyType, 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER', 'BBG_UTILS_PLAYER_HAS_' || TechnologyType
--     FROM Technologies;
-- INSERT INTO ModifierArguments(ModifierId, Name, Value)
--     SELECT 'BBG_BABYLON_SCIENCE_' || TechnologyType, 'YieldType', 'YIELD_SCIENCE'
--     FROM Technologies;
-- INSERT INTO ModifierArguments(ModifierId, Name, Value)
--     SELECT 'BBG_BABYLON_SCIENCE_' || TechnologyType, 'Amount', '1'
--     FROM Technologies;
-- INSERT INTO TraitModifiers(TraitType, ModifierId)
--     SELECT 'TRAIT_CIVILIZATION_BABYLON', 'BBG_BABYLON_SCIENCE_' || TechnologyType
--     FROM Technologies;
-- -- Babylon don't get Eureka boost from Free Inquiry
-- INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
--     ('PLAYER_HAS_GOLDEN_AGE_AND_NOT_BABYLON', 'REQUIREMENTSET_TEST_ALL');
-- --5.1 Fixed the free inq bug
-- INSERT INTO Requirements(RequirementId, RequirementType) VALUES
--     ('PLAYER_IS_NOT_BABYLON', 'REQUIREMENT_PLAYER_TYPE_MATCHES');
-- INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
--     ('PLAYER_IS_NOT_BABYLON', 'CivilizationType', 'CIVILIZATION_BABYLON_STK');
-- UPDATE Requirements SET Inverse = '1' WHERE RequirementId = 'PLAYER_IS_NOT_BABYLON';
-- INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
--     ('PLAYER_HAS_GOLDEN_AGE_AND_NOT_BABYLON', 'PLAYER_IS_NOT_BABYLON'),
--     ('PLAYER_HAS_GOLDEN_AGE_AND_NOT_BABYLON', 'REQUIRES_PLAYER_HAS_GOLDEN_AGE');
-- UPDATE Modifiers SET OwnerRequirementSetId='PLAYER_HAS_GOLDEN_AGE_AND_NOT_BABYLON' WHERE ModifierId='COMMEMORATION_SCIENTIFIC_GA_BOOSTS';

--24/11/22 Babylon get free eureka when building a library
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_BABYLON' AND ModifierID='TRAIT_SCIENCE_DECREASE';
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_BABYLON' AND ModifierID='TRAIT_EUREKA_INCREASE';
--18/12/22 writed it properly :komik:
--BUILDING_IS_LIBRARY doesn't exist in base, recreate
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQUIRES_CITY_HAS_LIBRARY', 'REQUIREMENT_CITY_HAS_BUILDING');
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQUIRES_CITY_HAS_LIBRARY', 'BuildingType', 'BUILDING_LIBRARY');
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BUILDING_IS_LIBRARY', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BUILDING_IS_LIBRARY', 'REQUIRES_CITY_HAS_LIBRARY');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_BABYLON_FREE_EUREKA_LIBRARY', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'BUILDING_IS_LIBRARY'),
    ('BBG_BABYLON_FREE_EUREKA_LIBRARY_MODIFIER', 'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_GOODY_HUT', null);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_BABYLON_FREE_EUREKA_LIBRARY', 'ModifierId', 'BBG_BABYLON_FREE_EUREKA_LIBRARY_MODIFIER'),
    ('BBG_BABYLON_FREE_EUREKA_LIBRARY_MODIFIER', 'Amount', 1);
INSERT INTO TraitModifiers VALUES
    ('TRAIT_CIVILIZATION_BABYLON', 'BBG_BABYLON_FREE_EUREKA_LIBRARY');

-- 17/04/23 Palgum requires freshwater and improved tiles but...
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
    ('BBG_TILE_HAS_ANY_IMPROVEMENT', 'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT', 0),
    ('BBG_REQUIRES_TILE_IS_NOT_FARM', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES', 1);
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_TILE_IS_NOT_FARM', 'ImprovementType', 'IMPROVEMENT_FARM');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_TILE_HAS_ANY_IMPROVEMENT_BUT_FARM_AND_IS_FRESH_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_TILE_HAS_ANY_IMPROVEMENT_BUT_FARM_AND_IS_FRESH_REQSET', 'BBG_TILE_HAS_ANY_IMPROVEMENT'),
    ('BBG_TILE_HAS_ANY_IMPROVEMENT_BUT_FARM_AND_IS_FRESH_REQSET', 'BBG_REQUIRES_TILE_IS_NOT_FARM'),
    ('BBG_TILE_HAS_ANY_IMPROVEMENT_BUT_FARM_AND_IS_FRESH_REQSET', 'REQUIRES_PLOT_IS_FRESH_WATER');
UPDATE Modifiers SET SubjectRequirementSetId='BBG_TILE_HAS_ANY_IMPROVEMENT_BUT_FARM_AND_IS_FRESH_REQSET' WHERE ModifierId='PALGUM_ADDFOOD';
-- ... also gives prod to farm like watermill
INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_PALGUM', 'BBG_WATERMILL_PRODUCTION_FARM');