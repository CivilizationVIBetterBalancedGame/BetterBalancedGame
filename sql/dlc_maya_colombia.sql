--==================
-- Colombia
--==================
-- site instead of movement
--DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_EJERCITO_PATRIOTA_EXTRA_MOVEMENT';
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_ADJUST_SIGHT' WHERE ModifierId='EJERCITO_PATRIOTA_EXTRA_MOVEMENT';
-- cannot produce great generals
INSERT OR IGNORE INTO ExcludedGreatPersonClasses (GreatPersonClassType, TraitType) VALUES
    ( 'GREAT_PERSON_CLASS_GENERAL', 'TRAIT_LEADER_CAMPANA_ADMIRABLE' );
-- llanero support nerf
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='LLANERO_ADJACENCY_STRENGTH' AND Name='Amount';
-- hacienda comes sooner, but can only be built on flat tiles
UPDATE Improvements SET PrereqCivic='CIVIC_MEDIEVAL_FAIRES' WHERE ImprovementType='IMPROVEMENT_HACIENDA';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_HACIENDA' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_HACIENDA' AND TerrainType='TERRAIN_GRASS_HILLS';




--==================
-- Maya
--==================
-- reduce combat bonus to 3 from 5
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='MUTAL_NEAR_CAPITAL_COMBAT' AND Name='Amount';
-- set citizen yields to same as other campuses
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' AND DistrictType='DISTRICT_OBSERVATORY';
--- start biases ---
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
    ('CIVILIZATION_MAYA', 'RESOURCE_OLIVES', 3),
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

--==================
-- City-States
--==================
-- UPDATE Units SET CostProgressionModel='COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1=10 WHERE UnitType='UNIT_LAHORE_NIHANG';


--==================
-- Other
--==================
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES
	('RESOURCE_MAIZE'  , 'CLASS_FERTILITY_RITES_FOOD');


--==================
-- Wonders
--==================
UPDATE Feature_AdjacentYields SET YieldChange=1 WHERE FeatureType='FEATURE_PAITITI' AND YieldType='YIELD_GOLD';
UPDATE Feature_AdjacentYields SET YieldChange=1 WHERE FeatureType='FEATURE_PAITITI' AND YieldType='YIELD_CULTURE';
DELETE FROM Feature_AdjacentYields WHERE FeatureType='FEATURE_BERMUDA_TRIANGLE';
