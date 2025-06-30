-- reduce combat bonus to 3 from 5
-- 16/04/23 Remove combat bonus
-- 02/07/24 revert 16/04/23 cs change
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='MUTAL_NEAR_CAPITAL_COMBAT' AND Name='Amount';
-- DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_LEADER_NEARBY_CITIES_GAIN_ABILITY';
-- set citizen yields to same as other campuses
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' AND DistrictType='DISTRICT_OBSERVATORY';
-- start biases --
-- after coastals and tundra and desert; delete non-plantation lux biases; add banana bias; make flat land bias last priority
INSERT OR REPLACE INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_MAYA', 'RESOURCE_CITRUS', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_COFFEE', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_COCOA', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_COTTON', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_DYES', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_SILK', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_SPICES', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_SUGAR', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_TEA', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_TOBACCO', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_WINE', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_INCENSE', 3),
    -- ('CIVILIZATION_MAYA', 'RESOURCE_OLIVES', 3), other dlc
    ('CIVILIZATION_MAYA', 'RESOURCE_BANANAS', 4);

DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_GYPSUM';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_JADE';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_MARBLE';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_MERCURY';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_SALT';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_IVORY';

-- Delete StartBiasTerrain
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_MAYA';

-- 15/05/2021: Delete free builder
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_MUTAL' AND ModifierId='TRAIT_LEADER_NEARBY_CITIES_GAIN_BUILDER';

-- 24/04/23 Reduced bonus/malus to cities
UPDATE ModifierArguments SET Value='5, 5, 5, 5, 5, 5' WHERE ModifierId='TRAIT_LEADER_NEARBY_CITIES_GAIN_YIELDS' AND Name='Amount';
UPDATE ModifierArguments SET Value='-10, -10, -10, -10, -10, -10' WHERE ModifierId='TRAIT_LEADER_NEARBY_CITIES_LOSE_YIELDS' AND Name='Amount';

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_MAYA_CAPITAL_HOUSING', 'MODIFIER_PLAYER_CAPITAL_CITY_ADJUST_BUILDING_HOUSING');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MAYA_CAPITAL_HOUSING', 'Amount', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_MAYAB', 'BBG_MAYA_CAPITAL_HOUSING');

-- Monks: Maya CS
INSERT INTO TypeTags(Type, Tag) Values
    ('ABILITY_MUTAL_COMBAT_STRENGTH_NEAR_CAPITAL', 'CLASS_WARRIOR_MONK');

-- 14/10 discount reduced to 35% (20 for diplo quarter) and unique district to 55%
UPDATE Districts SET CostProgressionParam1=35 WHERE DistrictType='DISTRICT_OBSERVATORY';
UPDATE Districts SET Cost=30 WHERE DistrictType='DISTRICT_OBSERVATORY';

-- 19/12/23 Observatory adjacency from plantations reduced to +1 but plantations gain 2 science at education
INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_PLANTATION', 'BBG_Plantation_Science_Observatory_Education');
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech) VALUES
    ('BBG_Plantation_Science_Observatory_Education', 'Placeholder', 'YIELD_SCIENCE', 1, 1, 'DISTRICT_OBSERVATORY', 'TECH_EDUCATION');
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_PLANTATION', 'YIELD_SCIENCE', '0');
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='Plantation_Science';

-- 19/12/23 Observatory adjacency from plantations reduced to +1 but plantations gain 2 science at education
INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_PLANTATION', 'BBG_Plantation_Science_Observatory');
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_Plantation_Science_Observatory', 'Placeholder', 'YIELD_SCIENCE', 1, 1, 'DISTRICT_OBSERVATORY');

-- INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
--     ('BBG_TRAIT_PLANTATIONS_SCIENCE_OBSERVATORY', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_PLOT_ADJACENT_TO_OBSERVATORIES_PLANTATIONS_AT_EDUCATION_REQSET');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--     ('BBG_TRAIT_PLANTATIONS_SCIENCE_OBSERVATORY', 'YieldType', 'YIELD_SCIENCE'),
--     ('BBG_TRAIT_PLANTATIONS_SCIENCE_OBSERVATORY', 'Amount', 2);
-- INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
--     ('BBG_PLOT_ADJACENT_TO_OBSERVATORIES_PLANTATIONS_AT_EDUCATION_REQSET', 'REQUIREMENTSET_TEST_ALL');
-- INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
--     ('BBG_PLOT_ADJACENT_TO_OBSERVATORIES_PLANTATIONS_AT_EDUCATION_REQSET', 'REQUIRES_PLOT_HAS_PLANTATION'),
--     ('BBG_PLOT_ADJACENT_TO_OBSERVATORIES_PLANTATIONS_AT_EDUCATION_REQSET', 'REQUIRES_PLOT_ADJACENT_TO_OBSERVATORY'),
--     ('BBG_PLOT_ADJACENT_TO_OBSERVATORIES_PLANTATIONS_AT_EDUCATION_REQSET', 'BBG_UTILS_PLAYER_HAS_TECH_EDUCATION_REQUIREMENT');
-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
--     ('TRAIT_LEADER_MUTAL', 'BBG_TRAIT_PLANTATIONS_SCIENCE_OBSERVATORY');

-- 16/12/24 Observatories give +1 housing
UPDATE Districts SET Housing=1 WHERE DistrictType='DISTRICT_OBSERVATORY';

-- 08/01/25 Observatories gets +2 from geothermal
INSERT INTO District_Adjacencies (DistrictType , YieldChangeId) VALUES
    ('DISTRICT_OBSERVATORY', 'Geothermal_Science');

-- 30/11/24 Ancient unit gets -5 agaisnt city center, see Base/Units.sql
INSERT INTO TypeTags (Type, Tag) VALUES
    ('UNIT_MAYAN_HULCHE', 'CLASS_MALUS_CITY_CENTER');