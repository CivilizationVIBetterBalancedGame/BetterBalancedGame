-- Stepwell Unique Improvement gets +1 base Faith and +1 Food moved from Professional Sports to Feudalism
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_STEPWELL' AND YieldType='YIELD_FAITH'; 
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_FEUDALISM' WHERE Id='20';
-- Stepwells get +1 food per adajacent farm
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement) VALUES
    ('BBG_STEPWELL_FOOD', 'Placeholder', 'YIELD_FOOD', 1, 1, 'IMPROVEMENT_FARM');
INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_STEPWELL', 'BBG_STEPWELL_FOOD');
DELETE FROM ImprovementModifiers WHERE ModifierId='STEPWELL_FARMADJACENCY_FOOD';

-- 25/06/25 Amenity per different religion changed to 1 amenity if city following India's religion
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_AMENITIES_FOR_MIN_FOLLOWERS';
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_INDIA_AMENITY_RELIGION', 'MODIFIER_PLAYER_CITIES_ADJUST_AMENITIES_FROM_RELIGION', 'CITY_FOLLOWS_RELIGION_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_INDIA_AMENITY_RELIGION', 'Amount', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_DHARMA', 'BBG_INDIA_AMENITY_RELIGION');
INSERT INTO Types (Type, Kind) VALUES
    ('MODIFIER_PLAYER_CITIES_ADJUST_AMENITIES_FROM_RELIGION', 'KIND_MODIFIER');
INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES
    ('MODIFIER_PLAYER_CITIES_ADJUST_AMENITIES_FROM_RELIGION', 'COLLECTION_PLAYER_CITIES', 'EFFECT_ADJUST_CITY_AMENITIES_FROM_RELIGION');


-- ==================
-- India (Gandhi)
-- ==================
-- Extra belief when founding a Religion
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('EXTRA_BELIEF_MODIFIER', 'MODIFIER_PLAYER_ADD_BELIEF', 'HAS_A_RELIGION_BBG');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_SATYAGRAHA', 'EXTRA_BELIEF_MODIFIER');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('HAS_A_RELIGION_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('HAS_A_RELIGION_BBG', 'REQUIRES_FOUNDED_RELIGION_BBG');
INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
    ('REQUIRES_FOUNDED_RELIGION_BBG', 'REQUIREMENT_FOUNDED_NO_RELIGION', 1);


-- +1 movement to builders
-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
--     ('TRAIT_LEADER_SATYAGRAHA', 'GANDHI_FAST_BUILDERS');
-- INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
--     ('GANDHI_FAST_BUILDERS', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'UNIT_IS_BUILDER');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--     ('GANDHI_FAST_BUILDERS', 'Amount', '1');
-- -- -- +1 movement to settlers
-- -- -- 04/07/24 Cities need to have HS
-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
--     ('TRAIT_LEADER_SATYAGRAHA', 'BBG_GANDHI_FAST_SETTLERS_GIVER');
-- INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
--     ('BBG_GANDHI_FAST_SETTLERS_GIVER', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'UNIT_IS_SETTLER');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--     ('BBG_GANDHI_FAST_SETTLERS_GIVER', 'Amount', '1');
-- INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
--     ('UNIT_IS_SETTLER', 'REQUIREMENT_UNIT_IS_SETTLER');
-- INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
--     ('UNIT_IS_SETTLER', 'REQUIREMENTSET_TEST_ALL');
-- INSERT INTO Requirements (RequirementId, RequirementType) VALUES
--     ('REQUIREMENT_UNIT_IS_SETTLER', 'REQUIREMENT_UNIT_TYPE_MATCHES');
-- INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
--     ('REQUIREMENT_UNIT_IS_SETTLER', 'UnitType', 'UNIT_SETTLER');

-- 05/07/24 Gandhi movement settler/builder delayed to cities with hs
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
    ('BBG_PLAYER_IS_GANDHI', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
    ('BBG_PLAYER_IS_GANDHI', 'BBG_PLAYER_IS_GANDHI_REQUIREMENT');
INSERT INTO Requirements(RequirementId , RequirementType) VALUES
    ('BBG_PLAYER_IS_GANDHI_REQUIREMENT' , 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
    ('BBG_PLAYER_IS_GANDHI_REQUIREMENT' , 'LeaderType', 'LEADER_GANDHI');

INSERT INTO Types (Type, Kind) VALUES
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT', 'CLASS_BUILDER'),
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT', 'CLASS_SETTLER');
INSERT INTO UnitAbilities (UnitAbilityType, Name, Description, Inactive) VALUES
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT', 'LOC_BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_NAME', 'LOC_BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_DESC', 1);
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT', 'BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_MODIFIER');
INSERT INTO Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) VALUES
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_GIVER', 'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS', 0, 'BBG_PLAYER_IS_GANDHI'),
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 1, NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_GIVER', 'AbilityType', 'BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT'),
    ('BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_MODIFIER', 'Amount', 1);
INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES
    ('DISTRICT_HOLY_SITE', 'BBG_ABILITY_GANDHI_SETTLER_BUILDER_MOVEMENT_GIVER');


-- 15/12/22 Gandhi faith per city following religion
-- 02/11/23 Removed
-- INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
--  ('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'MODIFIER_PLAYER_RELIGION_ADD_PLAYER_BELIEF_YIELD');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--  ('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'BeliefYieldType', 'BELIEF_YIELD_PER_CITY'),
--  ('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'YieldType', 'YIELD_FAITH'),
--  ('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'Amount', '1'),
--  ('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'PerXItems', '1');
-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
--  ('TRAIT_LEADER_SATYAGRAHA', 'BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION');

-- 10/03/2024 nerf gandhi war weariness to 50%
UPDATE ModifierArguments SET Value=50 WHERE ModifierId='TRAIT_INCREASE_ENEMY_WAR_WEARINESS' AND Name='Amount'; 

-- 19/12/23 Varus cost 5 horse
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_INDIAN_VARU';
INSERT INTO Units_XP2 (UnitType, ResourceCost) VALUES
    ('UNIT_INDIAN_VARU', 10);