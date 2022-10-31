-- free city center building after code of laws
UPDATE Modifiers SET SubjectRequirementSetId='HAS_CODE_OF_LAWS_SET_BBG' WHERE ModifierId='TRAIT_ADJUST_NON_CAPITAL_FREE_CHEAPEST_BUILDING';
INSERT OR IGNORE INTO RequirementSets VALUES ('HAS_CODE_OF_LAWS_SET_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements VALUES ('HAS_CODE_OF_LAWS_SET_BBG', 'HAS_CODE_OF_LAWS_BBG');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
	('HAS_CODE_OF_LAWS_BBG', 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) VALUES
	('HAS_CODE_OF_LAWS_BBG', 'CivicType', 'CIVIC_CODE_OF_LAWS');
-- reverted 04/10/22
-- INSERT OR IGNORE INTO District_Adjacencies (DistrictType , YieldChangeId)
-- 	VALUES ('DISTRICT_BATH' , 'District_Culture');

