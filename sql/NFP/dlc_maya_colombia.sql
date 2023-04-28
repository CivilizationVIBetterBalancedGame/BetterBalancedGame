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
