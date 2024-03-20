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
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER');

-- Modifier to actually check if the improvement is built, only done once
INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, RunOnce, Permanent) VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD', 'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY', 'PLAYER_HAS_MAHAVIHARA', 1, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA', 'ModifierId', 'ARGTYPE_IDENTITY', 'MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD'),
    ('MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD', 'Amount', 'ARGTYPE_IDENTITY', 1);

-- Modifier which triggers and attaches to all players when game is created 
INSERT INTO GameModifiers (ModifierId) VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA');


-- 2020/12/16 - Ayutthaya Culture bug fix
-- https://github.com/iElden/BetterBalancedGame/issues/48

-- THESE ARE THE VALUE FIRAXIS INTENDED
-- 10%
-- UPDATE ModifierArguments SET Value=60 WHERE ModifierId='MINOR_CIV_AYUTTHAYA_CULTURE_COMPLETE_BUILDING' AND Name='BuildingProductionPercent';

-- 2020/12/20 - Ayutthaya Culture buff (10% => 20%) IT WAS FIXED BY FIRAXIS <==================================================================
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


-- 08/03/24 Samarkand dome also gives production
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_IS_SUZERAIN'),
    ('BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_PER_IMPROVEMENT_AT_LOCATION_BABYLON', NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION',  'ModifierId', 'BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION_MODIFIER'),
    ('BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION_MODIFIER', 'Amount', 1),
    ('BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION_MODIFIER', 'ImprovementType', 'IMPROVEMENT_TRADING_DOME'),
    ('BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION_MODIFIER', 'YieldType', 'YIELD_PRODUCTION');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('MINOR_CIV_SAMARKAND_TRAIT', 'BBG_MINOR_CIV_SAMARKAND_TRADE_PRODUCTION');
