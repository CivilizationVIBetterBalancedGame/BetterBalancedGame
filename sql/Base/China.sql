-- great wall gets +1 prod, no initial gold, lowered gold and lowered culture per adj after castles
INSERT INTO Improvement_YieldChanges VALUES ('IMPROVEMENT_GREAT_WALL', 'YIELD_PRODUCTION', 1);
UPDATE Improvement_YieldChanges SET YieldChange=0 WHERE ImprovementType='IMPROVEMENT_GREAT_WALL' AND YieldType='YIELD_GOLD';
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='GreatWall_Culture';
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='GreatWall_Gold';
-- 02/07/24 wall +1 culture at military science
-- 30/06/25 Removed
-- INSERT INTO Improvement_BonusYieldChanges (ImprovementType, YieldType, BonusYieldChange, PrereqTech) VALUES
--     ('IMPROVEMENT_GREAT_WALL', 'YIELD_CULTURE', 1, 'TECH_MILITARY_SCIENCE');

-- 02/07/24 Eureka/Inspi boost nerfed to +5% (from +10)
UPDATE ModifierArguments SET Value=5 WHERE ModifierId IN ('TRAIT_CIVIC_BOOST', 'TRAIT_TECHNOLOGY_BOOST');

-- 02/07/24 China bonus of eureka/inspi when finishing wonders moved to Qin Shi Mandate
UPDATE TraitModifiers SET TraitType='FIRST_EMPEROR_TRAIT' WHERE ModifierId IN ('TRAIT_CIVIC_BOOST_WONDER_ERA', 'TRAIT_TECHNOLOGY_BOOST_WONDER_ERA');


-- Crouching Tiger now a crossbowman replacement that gets +7 when adjacent to an enemy unit
INSERT INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
    VALUES ('UNIT_CHINESE_CROUCHING_TIGER', 'UNIT_CROSSBOWMAN');
-- 02/07/24 Reduced to 170 prod
UPDATE Units SET Cost=170 , RangedCombat=40 , Range=2 WHERE UnitType='UNIT_CHINESE_CROUCHING_TIGER';

INSERT INTO Tags (Tag , Vocabulary)
    VALUES ('CLASS_CROUCHING_TIGER', 'ABILITY_CLASS');
INSERT INTO TypeTags (Type , Tag)
    VALUES ('UNIT_CHINESE_CROUCHING_TIGER', 'CLASS_CROUCHING_TIGER');
INSERT INTO Types (Type , Kind)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD', 'KIND_ABILITY');
INSERT INTO TypeTags (Type , Tag)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD', 'CLASS_CROUCHING_TIGER');
INSERT INTO UnitAbilities (UnitAbilityType , Name , Description)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD', 'LOC_ABILITY_TIGER_ADJACENCY_NAME', 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');
INSERT INTO UnitAbilityModifiers (UnitAbilityType , ModifierId)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD', 'TIGER_ADJACENCY_DAMAGE');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
    VALUES ('TIGER_ADJACENCY_DAMAGE', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'TIGER_ADJACENCY_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TIGER_ADJACENCY_DAMAGE', 'Amount', '7'); 
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('TIGER_ADJACENCY_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('TIGER_ADJACENCY_REQUIREMENTS', 'PLAYER_IS_ATTACKER_REQUIREMENTS');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('TIGER_ADJACENCY_REQUIREMENTS', 'ADJACENT_UNIT_REQUIREMENT');
INSERT INTO ModifierStrings (ModifierId , Context , Text)
    VALUES ('TIGER_ADJACENCY_DAMAGE', 'Preview', 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');

-- Move builder charge from Qin-Shi to China
-- DELETE FROM TraitModifiers WHERE TraitType='FIRST_EMPEROR_TRAIT' AND ModifierId='TRAIT_ADJUST_BUILDER_CHARGES';
-- INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
--    ('TRAIT_CIVILIZATION_DYNASTIC_CYCLE', 'TRAIT_ADJUST_BUILDER_CHARGES');
-- Remove 10% eureka/inspiration (return to QinShi leader only)
-- DELETE FROM TraitModifiers WHERE ModifierId in ('TRAIT_CIVIC_BOOST', 'TRAIT_TECHNOLOGY_BOOST');

-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
--	('FIRST_EMPEROR_TRAIT', 'TRAIT_CIVIC_BOOST'),
--	('FIRST_EMPEROR_TRAIT', 'TRAIT_TECHNOLOGY_BOOST');

-- UPDATE 10/01/2023 Give back eureka to all China and move back builder to Qin-Shin only

-- 10/03/24 QinShi +1 food per wonder
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_TRAIT_WONDER_FOOD', 'MODIFIER_SINGLE_CITY_ADJUST_WONDER_YIELD_CHANGE'),
    ('BBG_TRAIT_ATTACH_WONDER_FOOD', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_ATTACH_WONDER_FOOD', 'ModifierId', 'BBG_TRAIT_WONDER_FOOD'),
    ('BBG_TRAIT_WONDER_FOOD', 'Amount', '1'),
    ('BBG_TRAIT_WONDER_FOOD', 'YieldType', 'YIELD_FOOD');
INSERT INTO TraitModifiers VALUES
    ('FIRST_EMPEROR_TRAIT', 'BBG_TRAIT_ATTACH_WONDER_FOOD');


-- 02/07/24 Qin Shi builder charge for wonder upgraded to +20% (from +15%)
-- 24/07/24 No
-- UPDATE ModifierArguments SET Value=20 WHERE ModifierId='TRAIT_BUILDER_WONDER_PERCENT' AND Name='Amount';

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_ADJACENT_TO_WALL', 'REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_ADJACENT_TO_WALL', 'ImprovementType', 'IMPROVEMENT_GREAT_WALL');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_PLOT_IS_WALL_NEXT_TO_WALL_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_PLOT_IS_WALL_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_PLOT_IS_WALL_NEXT_TO_WALL_REQSET', 'REQUIRES_GREATWALL_IN_PLOT'),
    ('BBG_PLOT_IS_WALL_NEXT_TO_WALL_REQSET', 'BBG_REQUIRES_PLOT_ADJACENT_TO_WALL'),
    ('BBG_PLOT_IS_WALL_REQSET', 'REQUIRES_GREATWALL_IN_PLOT');


-- 30/06/25 China leaders get different wall buffs
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_QINSHI_WALL_GOLD_ADJACENT', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_PLOT_IS_WALL_NEXT_TO_WALL_REQSET'),
    ('BBG_QINSHI_WALL_FAITH_ADJACENT', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_PLOT_IS_WALL_NEXT_TO_WALL_REQSET'),
    ('BBG_QINSHI_WALL_GOLD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_PLOT_IS_WALL_REQSET'),
    ('BBG_QINSHI_WALL_FAITH', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_PLOT_IS_WALL_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_QINSHI_WALL_GOLD_ADJACENT', 'YieldType', 'YIELD_GOLD'),
    ('BBG_QINSHI_WALL_GOLD_ADJACENT', 'Amount', 1),
    ('BBG_QINSHI_WALL_FAITH_ADJACENT', 'YieldType', 'YIELD_FAITH'),
    ('BBG_QINSHI_WALL_FAITH_ADJACENT', 'Amount', 1),
    ('BBG_QINSHI_WALL_GOLD', 'YieldType', 'YIELD_GOLD'),
    ('BBG_QINSHI_WALL_GOLD', 'Amount', 1),
    ('BBG_QINSHI_WALL_FAITH', 'YieldType', 'YIELD_FAITH'),
    ('BBG_QINSHI_WALL_FAITH', 'Amount', 1);
INSERT INTO TraitModifiers VALUES
    ('FIRST_EMPEROR_TRAIT', 'BBG_QINSHI_WALL_GOLD_ADJACENT'),
    ('FIRST_EMPEROR_TRAIT', 'BBG_QINSHI_WALL_FAITH_ADJACENT');