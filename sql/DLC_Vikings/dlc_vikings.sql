-- 15/12/22 Lysjefjord +2MP

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_MODIFIER', 'Amount', '2');

INSERT INTO Types(Type, Kind) VALUES
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY', 'CLASS_NAVAL_CARRIER'),
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY', 'CLASS_NAVAL_MELEE'),
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY', 'CLASS_NAVAL_RANGED'),
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY', 'CLASS_NAVAL_RAIDER');
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive, ShowFloatTextWhenEarned) VALUES
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY', 'LOC_BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY_NAME', 'LOC_BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY_DESC', 1, 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY', 'BBG_LYSEFJORD_GRANT_MOVEMENT_MODIFIER');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
	('BBG_LYSEFJORD_GRANT_MOVEMENT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('BBG_LYSEFJORD_GRANT_MOVEMENT_REQUIREMENTS', 'PLOT_ADJACENT_TO_LYSEFJORDEN_REQUIREMENT'),
	('BBG_LYSEFJORD_GRANT_MOVEMENT_REQUIREMENTS', 'UNIT_IS_NAVAL_REQUIREMENT');

INSERT INTO Modifiers (ModifierId, ModifierType, Permanent, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
	('BBG_LYSEFJORD_GRANT_MOVEMENT', 'MODIFIER_ALL_UNITS_GRANT_ABILITY', 1, 'LYSEFJORDEN_REQUIREMENTS', 'BBG_LYSEFJORD_GRANT_MOVEMENT_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_LYSEFJORD_GRANT_MOVEMENT', 'AbilityType', 'BBG_LYSEFJORD_GRANT_MOVEMENT_ABILITY');

INSERT INTO GameModifiers (ModifierId) VALUES
	('BBG_LYSEFJORD_GRANT_MOVEMENT');

DELETE FROM Modifiers WHERE ModifierId='LYSEFJORDEN_GRANT_NAVAL_UNIT_EXPERIENCE';
DELETE FROM ModifierArguments WHERE ModifierId='LYSEFJORDEN_GRANT_NAVAL_UNIT_EXPERIENCE';
DELETE FROM RequirementSetRequirements WHERE RequirementSetId='LYSEFJORDEN_GRANT_EXPERIENCE_REQUIREMENTS';
DELETE FROM RequirementSets WHERE RequirementSetId='LYSEFJORDEN_GRANT_EXPERIENCE_REQUIREMENTS';

--Causeway +3 down from +5
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='SPEAR_OF_FIONN_ADJUST_COMBAT_STRENGTH' AND Name='Amount';
--ATTACKING_REQUIREMENT_SET depends on Persia Macedon, recreated
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType) VALUES
	('ATTACKING_REQUIREMENT_SET', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId) VALUES
	('ATTACKING_REQUIREMENT_SET', 'PLAYER_IS_ATTACKER_REQUIREMENTS');
UPDATE Modifiers SET SubjectRequirementSetId='ATTACKING_REQUIREMENT_SET' WHERE ModifierId='SPEAR_OF_FIONN_ADJUST_COMBAT_STRENGTH';

-- 12/06/23 Fix tourism at flight on some improvement
INSERT OR IGNORE INTO Improvement_Tourism(ImprovementType, TourismSource, PrereqTech) VALUES
    ('IMPROVEMENT_MONASTERY', 'TOURISMSOURCE_FAITH', 'TECH_FLIGHT');

--=======================================================================
--******                       CITY STATE                          ******
--=======================================================================

--10/03/2024 Alcazar Improvement grants +1 sigth
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_ALCAZAR_IN_PLOT'
WHERE EXISTS (SELECT * FROM Improvements WHERE ImprovementType = 'IMPROVEMENT_ALCAZAR');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
    ('REQUIRES_ALCAZAR_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIRES_ALCAZAR_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_ALCAZAR');

-- 08/03/24 Granada's Alcazar buff
-- +1 base prod
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_ALCAZAR', 'YIELD_PRODUCTION', 1);
-- +1 culture per adjacent Encampment
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_ALCAZAR_CULTURE_ENCAMPMENT', 'LOC_BBG_ALCAZAR_CULTURE_ENCAMPMENT', 'YIELD_CULTURE', 1, 1, 'DISTRICT_ENCAMPMENT');
INSERT INTO Improvement_Adjacencies(ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_ALCAZAR', 'BBG_ALCAZAR_CULTURE_ENCAMPMENT');

-- 08/03/24 Auckland nerf : only work on improved tiles
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER_AND_INDUSTRIAL', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER', 'REQUIRES_PLOT_HAS_SHALLOW_WATER'),
    ('BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER', 'BBG_TILE_HAS_ANY_IMPROVEMENT'),
    ('BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER_AND_INDUSTRIAL', 'REQUIRES_PLOT_HAS_SHALLOW_WATER'),
    ('BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER_AND_INDUSTRIAL', 'BBG_TILE_HAS_ANY_IMPROVEMENT'),
    ('BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER_AND_INDUSTRIAL', 'REQUIRES_PLAYER_IS_INDUSTRIAL_ERA');
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER' WHERE ModifierId='MINOR_CIV_AUCKLAND_SHALLOW_WATER_PRODUCTION_BONUS_BASE';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLOT_IS_IMPROVED_IN_SHALLOW_WATER_AND_INDUSTRIAL' WHERE ModifierId='MINOR_CIV_AUCKLAND_SHALLOW_WATER_PRODUCTION_BONUS_INDUSTRIAL';
    
-- 09/03/2024 Monastery +1 food, +1faith per adjacent district at reformed church (instead of 2)
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_MONASTERY', 'YIELD_FOOD', 1);
UPDATE Improvement_YieldChanges SET YieldChange=3 WHERE ImprovementType='IMPROVEMENT_MONASTERY' AND YieldType='YIELD_FAITH';
UPDATE Adjacency_YieldChanges SET ObsoleteCivic='CIVIC_REFORMED_CHURCH' WHERE ID='Monastery_DistrictAdjacency';
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, OtherDistrictAdjacent, PrereqCivic) VALUES
    ('Monastery_DistrictAdjacency_ReformedChurch', 'Placeholder', 'YIELD_FAITH', 1, 1, 1, 'CIVIC_REFORMED_CHURCH');
INSERT INTO Improvement_Adjacencies VALUES
    ('IMPROVEMENT_MONASTERY', 'Monastery_DistrictAdjacency_ReformedChurch');