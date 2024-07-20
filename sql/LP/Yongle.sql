--==================
-- Yongle
--==================
-- 5.2.5 Yongle nerf Pop require remain the same but reduce science/culture from 1 per pop to +0.5/+0.3 (double the inner science/culture per pop) and reduce gold from 2 to 1
-- 14/10/23 from 0.5/0.3 to 0.7/0.5
UPDATE ModifierArguments SET Value='0.7' WHERE ModifierId='YONGLE_SCIENCE_POPULATION' AND Name='Amount';
UPDATE ModifierArguments SET Value='0.5' WHERE ModifierId='YONGLE_CULTURE_POPULATION' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='YONGLE_GOLD_POPULATION' AND Name='Amount';

-- 14/10/23 doubled project yield
-- 25/10/23 nerf project yield to 60%
-- 03/07/24 project to 70%
UPDATE Project_YieldConversions SET PercentOfProductionRate=70 WHERE ProjectType='PROJECT_LIJIA_FOOD';
UPDATE Project_YieldConversions SET PercentOfProductionRate=70 WHERE ProjectType='PROJECT_LIJIA_FAITH';
UPDATE Project_YieldConversions SET PercentOfProductionRate=150 WHERE ProjectType='PROJECT_LIJIA_GOLD';

-- 03/07/24 Get an eureka when reaching 10 pop & an inspi when reaching 15
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_YONGLE_EUREKA_10_POP_GIVER', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'BBG_CITY_HAS_10_POP_REQSET'),
	('BBG_YONGLE_EUREKA_10_POP_MODIFIER', 'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_GOODY_HUT', NULL),
	('BBG_YONGLE_INSPI_15_POP_GIVER', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'BBG_CITY_HAS_15_POP_REQSET'),
	('BBG_YONGLE_INSPI_15_POP_MODIFIER', 'MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_GOODY_HUT', NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_YONGLE_EUREKA_10_POP_GIVER', 'ModifierId', 'BBG_YONGLE_EUREKA_10_POP_MODIFIER'),
	('BBG_YONGLE_EUREKA_10_POP_MODIFIER', 'Amount', 1),
	('BBG_YONGLE_INSPI_15_POP_GIVER', 'ModifierId', 'BBG_YONGLE_INSPI_15_POP_MODIFIER'),
	('BBG_YONGLE_INSPI_15_POP_MODIFIER', 'Amount', 1);

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_LEADER_YONGLE', 'BBG_YONGLE_EUREKA_10_POP_GIVER'),
	('TRAIT_LEADER_YONGLE', 'BBG_YONGLE_INSPI_15_POP_GIVER');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
	('BBG_CITY_HAS_15_POP', 'REQUIREMENT_CITY_HAS_X_POPULATION'),
	('BBG_CITY_HAS_10_POP', 'REQUIREMENT_CITY_HAS_X_POPULATION');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
	('BBG_CITY_HAS_15_POP', 'Amount', 15),
	('BBG_CITY_HAS_10_POP', 'Amount', 10);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
	('BBG_CITY_HAS_15_POP_REQSET', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_CITY_HAS_10_POP_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('BBG_CITY_HAS_15_POP_REQSET', 'BBG_CITY_HAS_15_POP'),
	('BBG_CITY_HAS_10_POP_REQSET', 'BBG_CITY_HAS_10_POP');