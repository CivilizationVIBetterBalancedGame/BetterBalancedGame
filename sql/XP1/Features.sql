
-- Delicate Arch
UPDATE Feature_AdjacentYields SET YieldChange=3 WHERE FeatureType='FEATURE_DELICATE_ARCH' AND YieldType='YIELD_GOLD';

--Matterhorn +2 down from +3
-- UPDATE ModifierArguments SET Value='0' WHERE ModifierId='ALPINE_TRAINING_COMBAT_HILLS' AND Name='Amount';
--23/08/22 no more combat bonus
DELETE FROM UnitAbilityModifiers WHERE ModifierId='ALPINE_TRAINING_COMBAT_HILLS';
DELETE FROM Modifiers WHERE ModifierId='ALPINE_TRAINING_COMBAT_HILLS';
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES ('ABILITY_ALPINE_TRAINING', 'CLASS_WAR_CART');
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES ('ABILITY_ALPINE_TRAINING', 'CLASS_LIGHT_CHARIOT');
-- Monks: Matternhorn
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_ALPINE_TRAINING', 'CLASS_WARRIOR_MONK');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_TIMUR_BONUS_EXPERIENCE', 'CLASS_WARRIOR_MONK');

-- Eye of the Sahara gets 2 Food, 2 Production, and 2 Science
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_PRODUCTION_ATOMIC' AND Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_SCIENCE_ATOMIC' AND Name='Amount';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange) VALUES
	('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_PRODUCTION';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange) VALUES
	('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_SCIENCE', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_SCIENCE';
-- lake retba
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange) VALUES
	('FEATURE_LAKE_RETBA', 'YIELD_FOOD', 2);

UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_FOOD';


-- 30/09/25: Zhangye Danxia give 1 point per era (instead of 2 all the time)
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) SELECT
    'BBG_PLAYER_HAS_ZHANGYE_DANXIA_' || EraType, 'REQUIREMENTSET_TEST_ALL' FROM Eras;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_PLAYER_HAS_ZHANGYE_DANXIA_' || EraType, 'PLAYER_HAS_ZHANGYE_DANXIA' FROM Eras;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_PLAYER_HAS_ZHANGYE_DANXIA_' || EraType, 'BBG_GAME_IS_IN_' || EraType || '_REQUIREMENT' FROM Eras;

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_MERCHANT_' || EraType, 'MODIFIER_ALL_PLAYERS_ADJUST_GREAT_PERSON_POINTS', 'BBG_PLAYER_HAS_ZHANGYE_DANXIA_' || EraType FROM Eras;
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_MERCHANT_' || EraType, 'GreatPersonClassType', 'GREAT_PERSON_CLASS_MERCHANT' FROM Eras;
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_MERCHANT_' || EraType, 'Amount', 1 FROM Eras;
INSERT INTO GameModifiers (ModifierId) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_MERCHANT_' || EraType FROM Eras;

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_GENERAL_' || EraType, 'MODIFIER_ALL_PLAYERS_ADJUST_GREAT_PERSON_POINTS', 'BBG_PLAYER_HAS_ZHANGYE_DANXIA_' || EraType FROM Eras;
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_GENERAL_' || EraType, 'GreatPersonClassType', 'GREAT_PERSON_CLASS_GENERAL' FROM Eras;
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_GENERAL_' || EraType, 'Amount', 1 FROM Eras;
INSERT INTO GameModifiers (ModifierId) SELECT
    'BBG_ZHANGYE_DANXIA_GREAT_GENERAL_' || EraType FROM Eras;

DELETE FROM GameModifiers WHERE ModifierId IN ('GREAT_GENERAL_ZHANGYE', 'GREAT_MERCHANT_ZHANGYE')

