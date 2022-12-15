--==================
-- Colombia
--==================
-- sight instead of movement
--15/12/22 reverted to base game
-- UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_ADJUST_SIGHT' WHERE ModifierId='EJERCITO_PATRIOTA_EXTRA_MOVEMENT';
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
-- Nihang: General
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_NIHANG', 'REQUIREMENT_UNIT_TAG_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name , Value) VALUES
    ('BBG_REQUIRES_NIHANG', 'Tag', 'CLASS_LAHORE_NIHANG');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('AOE_CLASSICAL_REQUIREMENTS', 'BBG_REQUIRES_NIHANG'),
    ('AOE_MEDIEVAL_REQUIREMENTS', 'BBG_REQUIRES_NIHANG'),
    ('AOE_RENAISSANCE_REQUIREMENTS', 'BBG_REQUIRES_NIHANG'),
    ('AOE_INDUSTRIAL_REQUIREMENTS', 'BBG_REQUIRES_NIHANG'),
    ('AOE_MODERN_REQUIREMENTS', 'BBG_REQUIRES_NIHANG'),
    ('AOE_ATOMIC_REQUIREMENTS', 'BBG_REQUIRES_NIHANG'),
    ('AOE_INFORMATION_REQUIREMENTS', 'BBG_REQUIRES_NIHANG');

-- Nihang: Ram/Tower
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_ENABLE_WALL_ATTACK_NIHANG', 'MODIFIER_PLAYER_UNIT_ADJUST_ENABLE_WALL_ATTACK_PROMOTION_CLASS'),
    ('BBG_BYPASS_WALLS_NIHANG','MODIFIER_PLAYER_UNIT_ADJUST_BYPASS_WALLS_PROMOTION_CLASS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_ENABLE_WALL_ATTACK_NIHANG', 'PromotionClass', 'PROMOTION_CLASS_NIHANG'),
    ('BBG_BYPASS_WALLS_NIHANG', 'PromotionClass', 'PROMOTION_CLASS_NIHANG');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS', 'BBG_ENABLE_WALL_ATTACK_NIHANG'),
    ('ABILITY_BYPASS_WALLS_PROMOTION_CLASS', 'BBG_BYPASS_WALLS_NIHANG');

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

--==============================================================
--******                RELIGION                          ******
--==============================================================
-- Monks: Maya CS
INSERT INTO TypeTags(Type, Tag) Values
    ('ABILITY_MUTAL_COMBAT_STRENGTH_NEAR_CAPITAL', 'CLASS_WARRIOR_MONK');

-- Monk: Comandante +4
INSERT INTO TypeTags(Type, Tag) Values
    ('ABILITY_COMMANDANTE_MELEE_ANTICAV_BUFF','CLASS_WARRIOR_MONK');
