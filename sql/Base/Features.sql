--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- great barrier reef gives +2 science adj
-- INSERT OR IGNORE INTO District_Adjacencies VALUES
--	('DISTRICT_CAMPUS', 'BarrierReef_Science');
--INSERT OR IGNORE INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentFeature) VALUES
--	('BarrierReef_Science', 'LOC_DISTRICT_REEF_SCIENCE', 'YIELD_SCIENCE', 2, 1, 'FEATURE_BARRIER_REEF');
-- Several lack-luster wonders improved
UPDATE Features SET Settlement=1 WHERE FeatureType='FEATURE_CLIFFS_DOVER';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CLIFFS_DOVER', 'YIELD_FOOD', 2);

INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_PANTANAL', 'YIELD_SCIENCE', 2);

INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_DEAD_SEA', 'YIELD_FOOD', 2);

INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CRATER_LAKE', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_CRATER_LAKE' AND YieldType='YIELD_SCIENCE'; 

INSERT OR IGNORE INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_GALAPAGOS', 'YIELD_FOOD', 1);

--Causeway +3 down from +5
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='SPEAR_OF_FIONN_ADJUST_COMBAT_STRENGTH' AND Name='Amount';
UPDATE Modifiers SET SubjectRequirementSetId='ATTACKING_REQUIREMENT_SET' WHERE ModifierId='SPEAR_OF_FIONN_ADJUST_COMBAT_STRENGTH';

-- Tsingy
INSERT INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange) VALUES
    ('FEATURE_TSINGY', 'YIELD_FOOD', 1);

-- Pantanal
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange) VALUES
    ('FEATURE_PANTANAL', 'YIELD_PRODUCTION', 1);

-- Everest
UPDATE Feature_AdjacentYields SET YieldChange=3 WHERE FeatureType='FEATURE_EVEREST';

-- Barrier Reef
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange) VALUES
    ('FEATURE_BARRIER_REEF', 'YIELD_PRODUCTION', 1);

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

