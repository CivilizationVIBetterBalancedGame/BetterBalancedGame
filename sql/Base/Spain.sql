-- Author: iElden
-- Making this is like spain but s is silent

-- Early Fleets moved to Mercenaries
UPDATE ModifierArguments SET Value='CIVIC_MERCENARIES' WHERE Name='CivicType' AND ModifierId='TRAIT_NAVAL_CORPS_EARLY';
-- 30% discount on missionaries
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_EL_ESCORIAL', 'HOLY_ORDER_MISSIONARY_DISCOUNT_MODIFIER');
-- 15/05/2021: Delete free builder on foreign continent
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_TREASURE_FLEET' AND ModifierId='TRAIT_INTERCONTINENTAL_BUILDER';
-- 15/05/2021: Conquistador to +5 (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='CONQUISTADOR_SPECIFIC_UNIT_COMBAT' AND Name='Amount';

-- Spain got coastal bias again
INSERT INTO StartBiasTerrains(CivilizationType, TerrainType, Tier) VALUES
    ('CIVILIZATION_SPAIN', 'TERRAIN_COAST', 1);

-- Give x2 yield instead of x3
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRAIT_INTERCONTINENTAL_INTERNATIONAL_FAITH' AND Name='Amount';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TRAIT_INTERCONTINENTAL_INTERNATIONAL_GOLD' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_INTERCONTINENTAL_INTERNATIONAL_PRODUCTION' AND Name='Amount';
--15/06/23 Remove double yields for internal
-- UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRAIT_INTERCONTINENTAL_DOMESTIC_FAITH' AND Name='Amount';
-- UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TRAIT_INTERCONTINENTAL_DOMESTIC_GOLD' AND Name='Amount';
-- UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_INTERCONTINENTAL_DOMESTIC_PRODUCTION' AND Name='Amount';
DELETE FROM Modifiers WHERE ModifierId IN ('TRAIT_INTERCONTINENTAL_DOMESTIC_FAITH', 'TRAIT_INTERCONTINENTAL_DOMESTIC_GOLD', 'TRAIT_INTERCONTINENTAL_DOMESTIC_PRODUCTION');

-- ==== MISSIONS ====
-- missions get +1 housing on home continent
--INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
--    ('BBG_REQUIRES_PLOT_IS_OWNER_CAPITAL_CONTINENT', 'REQUIREMENT_PLOT_IS_OWNER_CAPITAL_CONTINENT');
--INSERT OR IGNORE INTO RequirementSets VALUES
--    ('BBG_PLOT_CAPITAL_CONTINENT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
--INSERT OR IGNORE INTO RequirementSetRequirements VALUES
--    ('BBG_PLOT_CAPITAL_CONTINENT_REQUIREMENTS', 'BBG_REQUIRES_PLOT_IS_OWNER_CAPITAL_CONTINENT');
--INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
--    VALUES ('BBG_MISSION_HOMECONTINENT_HOUSING' , 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING', 'BBG_PLOT_CAPITAL_CONTINENT_REQUIREMENTS');
--INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
--    VALUES ('BBG_MISSION_HOMECONTINENT_HOUSING' , 'Amount' , 1);
--INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
--    VALUES ('IMPROVEMENT_MISSION' , 'BBG_MISSION_HOMECONTINENT_HOUSING');
--29/08/22 Missions gain housing if less than 8 tiles from cap
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MISSION_DISTANCE_HOUSING', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING', 'BBG_IS_PLOT_WITHIN_8_TILES_FROM_CAPITAL_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MISSION_DISTANCE_HOUSING', 'Amount', '1');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_IS_PLOT_WITHIN_8_TILES_FROM_CAPITAL_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_IS_PLOT_WITHIN_8_TILES_FROM_CAPITAL_REQUIREMENTS', 'BBG_REQUIRES_OBJECT_WITHIN_8_TILES_FROM_CAPITAL');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_OBJECT_WITHIN_8_TILES_FROM_CAPITAL', 'REQUIREMENT_PLOT_NEAR_CAPITAL');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_OBJECT_WITHIN_8_TILES_FROM_CAPITAL', 'MinDistance', '1'),
    ('BBG_REQUIRES_OBJECT_WITHIN_8_TILES_FROM_CAPITAL', 'MaxDistance', '7');
INSERT INTO ImprovementModifiers (ImprovementType, ModifierID) VALUES
    ('IMPROVEMENT_MISSION', 'BBG_MISSION_DISTANCE_HOUSING');
-- Missions cannot be placed next to each other
UPDATE Improvements SET SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_MISSION';
-- Missions moved to Theology
UPDATE Improvements SET PrereqTech=NULL, PrereqCivic='CIVIC_THEOLOGY' WHERE ImprovementType='IMPROVEMENT_MISSION';
-- Missions get bonus science at Enlightenment instead of cultural heritage
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_THE_ENLIGHTENMENT' WHERE Id='17';
--23/08/22 Missions remove bonus on split
DELETE FROM Modifiers WHERE ModifierId='MISSION_NEWCONTINENT_FOOD';
DELETE FROM Modifiers WHERE ModifierId='MISSION_NEWCONTINENT_PRODUCTION';
DELETE FROM Modifiers WHERE ModifierId='MISSION_NEWCONTINENT_FAITH';
DELETE FROM ImprovementModifiers WHERE ModifierId='MISSION_NEWCONTINENT_FOOD' AND ModifierId='IMPROVEMENT_MISSION';
DELETE FROM ImprovementModifiers WHERE ModifierId='MISSION_NEWCONTINENT_PRODUCTION' AND ModifierId='IMPROVEMENT_MISSION';
DELETE FROM ImprovementModifiers WHERE ModifierId='MISSION_NEWCONTINENT_FAITH' AND ModifierId='IMPROVEMENT_MISSION';
--23/08/22 Missions requirement 8+ tiles from capital 
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_OBJECT_8_TILES_OR_MORE_FROM_CAPITAL', 'REQUIREMENT_PLOT_NEAR_CAPITAL');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_OBJECT_8_TILES_OR_MORE_FROM_CAPITAL', 'MinDistance', '8');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_IS_PLOT_8_TILES_OR_MORE_FROM_CAPITAL_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_IS_PLOT_8_TILES_OR_MORE_FROM_CAPITAL_REQUIREMENTS', 'BBG_REQUIRES_OBJECT_8_TILES_OR_MORE_FROM_CAPITAL');
--23/08/22 Missions give prod and faith when 8+ tiles from cap
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MISSION_DISTANCE_PRODUCTION', 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'BBG_IS_PLOT_8_TILES_OR_MORE_FROM_CAPITAL_REQUIREMENTS'),
    ('BBG_MISSION_DISTANCE_FAITH', 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'BBG_IS_PLOT_8_TILES_OR_MORE_FROM_CAPITAL_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MISSION_DISTANCE_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_MISSION_DISTANCE_PRODUCTION', 'Amount', '1'),
    ('BBG_MISSION_DISTANCE_FAITH', 'YieldType', 'YIELD_FAITH'),
    ('BBG_MISSION_DISTANCE_FAITH', 'Amount', '1');
INSERT INTO ImprovementModifiers (ImprovementType, ModifierId) VALUES
    ('IMPROVEMENT_MISSION', 'BBG_MISSION_DISTANCE_PRODUCTION'),
    ('IMPROVEMENT_MISSION', 'BBG_MISSION_DISTANCE_FAITH');

--23/08/22 Districts prod now boosted if 8+ tiles from capital instead of continent split
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_TREASURE_FLEET' AND ModifierId='TRAIT_INTERCONTINENTAL_DISTRICT_PRODUCTION';
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_TRAIT_DISTANCE_DISTRICT_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_ALL_DISTRICTS_PRODUCTION','BBG_IS_PLOT_8_TILES_OR_MORE_FROM_CAPITAL_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_DISTANCE_DISTRICT_PRODUCTION', 'Amount', 25);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_TREASURE_FLEET', 'BBG_TRAIT_DISTANCE_DISTRICT_PRODUCTION');

-- Can make fleet with shipyard.
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId) VALUES
    ('BBG_SPAIN_FLEET_DISCOUNT', 'MODIFIER_CITY_CORPS_ARMY_ADJUST_DISCOUNT', 'BBG_PLAYER_IS_SPAIN');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_SPAIN_FLEET_DISCOUNT', 'UnitDomain', 'DOMAIN_SEA'),
    ('BBG_SPAIN_FLEET_DISCOUNT', 'Amount', '25');

INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_SHIPYARD', 'BBG_SPAIN_FLEET_DISCOUNT');

-- Leader is Phillipe Requirement.
INSERT OR IGNORE INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
    ('BBG_PLAYER_IS_SPAIN', 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
    ('BBG_PLAYER_IS_SPAIN', 'BBG_PLAYER_IS_SPAIN_REQUIREMENT');
INSERT OR IGNORE INTO Requirements(RequirementId , RequirementType) VALUES
    ('BBG_PLAYER_IS_SPAIN_REQUIREMENT' , 'REQUIREMENT_PLAYER_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments(RequirementId , Name, Value) VALUES
    ('BBG_PLAYER_IS_SPAIN_REQUIREMENT' , 'CivilizationType', 'CIVILIZATION_SPAIN');

-- 16/04/23 Reduces bonus combat vs other religion from 5 to 3
-- 15/06/23 Reverted
-- 08/07/24 come back
UPDATE ModifierArguments SET Value=3 WHERE ModifierId='PHILIP_II_COMBAT_BONUS_OTHER_RELIGION' AND Name='Amount';