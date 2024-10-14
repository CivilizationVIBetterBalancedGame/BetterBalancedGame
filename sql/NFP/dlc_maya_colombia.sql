--==================
-- Maya
--==================

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
--These abilities depend on XP2, recreate
INSERT OR IGNORE INTO Types(Type, Kind) VALUES
    ('ABILITY_BYPASS_WALLS_PROMOTION_CLASS', 'KIND_ABILITY'),
    ('ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS', 'KIND_ABILITY'); 
INSERT OR IGNORE INTO UnitAbilities(UnitAbilityType, Name, Description, Permanent) VALUES
    ('ABILITY_BYPASS_WALLS_PROMOTION_CLASS', 'LOC_ABILITY_BYPASS_WALLS_NAME','LOC_ABILITY_BYPASS_WALLS_PROMOTION_CLASS_DESCRIPTION', 1),
    ('ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS', 'LOC_ABILITY_ENABLE_WALL_ATTACK_NAME', 'LOC_ABILITY_ENABLE_WALL_PROMOTION_CLASS_ATTACK_DESCRIPTION', 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS', 'BBG_ENABLE_WALL_ATTACK_NIHANG'),
    ('ABILITY_BYPASS_WALLS_PROMOTION_CLASS', 'BBG_BYPASS_WALLS_NIHANG');

-- 13/03/24 Buff Nihang +3 (25->28)
UPDATE Units SET Combat=28 WHERE UnitType='UNIT_LAHORE_NIHANG';
--30/09/24 reduce scaling from +15 to +12
UPDATE ModifierArguments SET Value=12 WHERE Name='Amount' AND ModifierId LIKE 'NIHANG%STRENGTH';

--13/03/24 Medic movement also work on Nihang
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQUIREMENT_UNIT_IS_NIHANG', 'REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIREMENT_UNIT_IS_NIHANG', 'UnitPromotionClass', 'PROMOTION_CLASS_NIHANG');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_MEDIC_MOVEMENT_NIHANG_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_MEDIC_MOVEMENT_NIHANG_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_NIHANG_REQSET', 'REQUIREMENT_UNIT_IS_NIHANG');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MEDIC_NIHANG_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_NIHANG_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MEDIC_NIHANG_MOVEMENT', 'Amount', 1);
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_NIHANG_MOVEMENT');

--08/03/24 Singapour works on every trader
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL' WHERE ModifierId='MINOR_CIV_SINGAPORE_PRODUCTION_PER_MAJOR_TRADE_PARTNER';

--09/03/24 Batey buff 
--+1 prod for each strat
--+1 food for each luxe
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_BATEY', 'YIELD_PRODUCTION', 0),
    ('IMPROVEMENT_BATEY', 'YIELD_GOLD', 0);

INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_BATEY', 'BBG_Batey_gold_Luxe'),
    ('IMPROVEMENT_BATEY', 'BBG_Batey_Prod_Strat');

INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentResourceClass) VALUES
    ('BBG_Batey_gold_Luxe', 'Placeholder', 'YIELD_GOLD', 1, 1, 'RESOURCECLASS_LUXURY'),
    ('BBG_Batey_Prod_Strat', 'Placeholder', 'YIELD_PRODUCTION', 1, 1,'RESOURCECLASS_STRATEGIC');

-- Batey buildable on hills
INSERT INTO Improvement_ValidTerrains(ImprovementType, TerrainType) VALUES
    ('IMPROVEMENT_BATEY', 'TERRAIN_GRASS_HILLS'),
    ('IMPROVEMENT_BATEY', 'TERRAIN_PLAINS_HILLS'),
    ('IMPROVEMENT_BATEY', 'TERRAIN_DESERT_HILLS'),
    ('IMPROVEMENT_BATEY', 'TERRAIN_TUNDRA_HILLS'),
    ('IMPROVEMENT_BATEY', 'TERRAIN_SNOW_HILLS');
    
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

-- Monk: Comandante +4
INSERT INTO TypeTags(Type, Tag) Values
    ('ABILITY_COMMANDANTE_MELEE_ANTICAV_BUFF','CLASS_WARRIOR_MONK');
