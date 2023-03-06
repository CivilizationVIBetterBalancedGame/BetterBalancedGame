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

-- Palgum requires improved tile for bonus food yield (5.2.5 reverted and greyed)
--INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
    --('REQUIRES_PLOT_HAS_ANY_IMPROVEMENT', 'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT', 0);
--INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    --('PLOT_IS_FRESH', 'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT');
--UPDATE RequirementSets SET RequirementSetType = 'REQUIREMENTSET_TEST_ALL' WHERE RequirementSetId = 'PLOT_IS_FRESH';


--==============================================================
--******                     CITY-STATES                  ******
--==============================================================

-- Babylon - Nalanda infinite technology re-suze fix.
-- Remove the trait modifier from the Nalanda Minor
--  This was the initial cause of the problem.  
--   The context was destroyed when suzerain was lost, and recreated when suzerain was gained.  
--   Moving the context to the Game instance solves this problem.
DELETE FROM TraitModifiers WHERE ModifierId='MINOR_CIV_NALANDA_FREE_TECHNOLOGY';

-- We don't care about these modifiers anymore, they are connected to the TraitModifier
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_NALANDA_FREE_TECHNOLOGY_MODIFIER';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_NALANDA_FREE_TECHNOLOGY';

-- Attach the modifier to check for improvement to each player
INSERT INTO Modifiers 
    (ModifierId, ModifierType)
    VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER');

-- Modifier to actually check if the improvement is built, only done once
INSERT INTO Modifiers 
    (ModifierId, ModifierType, OwnerRequirementSetId, RunOnce, Permanent)
    VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD', 'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY', 'PLAYER_HAS_MAHAVIHARA', 1, 1);

INSERT INTO ModifierArguments
    (ModifierId, Name, Type, Value)
    VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA', 'ModifierId', 'ARGTYPE_IDENTITY', 'MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD'),
    ('MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD', 'Amount', 'ARGTYPE_IDENTITY', 1);

-- Modifier which triggers and attaches to all players when game is created 
INSERT INTO GameModifiers
    (ModifierId)
    VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA');


-- 2020/12/16 - Ayutthaya Culture bug fix
-- https://github.com/iElden/BetterBalancedGame/issues/48

-- THESE ARE THE VALUE FIRAXIS INTENDED
-- 10%
-- UPDATE ModifierArguments SET Value=60 WHERE ModifierId='MINOR_CIV_AYUTTHAYA_CULTURE_COMPLETE_BUILDING' AND Name='BuildingProductionPercent';

-- 2020/12/20 - Ayutthaya Culture buff (10% => 20%)
-- 20%
UPDATE ModifierArguments SET Value=20 WHERE ModifierId='MINOR_CIV_AYUTTHAYA_CULTURE_COMPLETE_BUILDING' AND Name='BuildingProductionPercent';

-- Scenario: Building momument on Online speed with 30 production code
-- BuildingProductionPercent    Faith   Percentage
-- 0                            0       0%
-- 1                            180     600%
-- 6                            30      100%
-- 10                           18      60% -- Current Ayutthaya 
-- 17.5                         10.5    35%
-- 24                           7.5     25% -- Correct Moksha
-- 25                           7.2     24% -- Current Moksha 
-- 50                           3.6     12%
-- 60                           3       10% -- Correct Ayutthaya
-- 6 * ProductionCost / BuildingProductionPercent = Yield
-- Therefore =>  
-- USE THIS FORMULA TO CALCULATE THE DESIRED ((BuildingProductionPercent)) FIELD
-- BuildingProductionPercent =  ProductionCost * 6 / Yield

-- 2020/12/19 - Add Mahavihara faith adjacencies for Lavra as well as Holy Site
-- https://github.com/iElden/BetterBalancedGame/issues/51
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict)
    VALUES ('BBG_Mahavihara_Lavra_Faith', 'Placeholder','YIELD_FAITH', 1, 1, 'DISTRICT_LAVRA');

INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId)
    VALUES ('IMPROVEMENT_MAHAVIHARA','BBG_Mahavihara_Lavra_Faith');