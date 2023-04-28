
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
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
		VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_PRODUCTION';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_SCIENCE', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_SCIENCE';
-- lake retba
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_LAKE_RETBA', 'YIELD_FOOD', 2);

UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_FOOD';
