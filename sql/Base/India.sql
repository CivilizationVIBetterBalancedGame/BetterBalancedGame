-- Stepwell Unique Improvement gets +1 base Faith and +1 Food moved from Professional Sports to Feudalism
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_STEPWELL' AND YieldType='YIELD_FAITH'; 
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_FEUDALISM' WHERE Id='20';
-- Stepwells get +1 food per adajacent farm
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement)
	VALUES ('BBG_STEPWELL_FOOD', 'Placeholder', 'YIELD_FOOD', 1, 1, 'IMPROVEMENT_FARM');
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType, YieldChangeId)
	VALUES ('IMPROVEMENT_STEPWELL', 'BBG_STEPWELL_FOOD');
DELETE FROM ImprovementModifiers WHERE ModifierId='STEPWELL_FARMADJACENCY_FOOD';


--==================
-- India (Gandhi)
--==================
-- Extra belief when founding a Religion
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES ('EXTRA_BELIEF_MODIFIER', 'MODIFIER_PLAYER_ADD_BELIEF', 'HAS_A_RELIGION_BBG');
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
    VALUES ('TRAIT_LEADER_SATYAGRAHA', 'EXTRA_BELIEF_MODIFIER');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('HAS_A_RELIGION_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('HAS_A_RELIGION_BBG', 'REQUIRES_FOUNDED_RELIGION_BBG');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType, Inverse)
	VALUES ('REQUIRES_FOUNDED_RELIGION_BBG', 'REQUIREMENT_FOUNDED_NO_RELIGION', 1);
-- +1 movement to builders
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_SATYAGRAHA' , 'GANDHI_FAST_BUILDERS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GANDHI_FAST_BUILDERS' , 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT' , 'UNIT_IS_BUILDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GANDHI_FAST_BUILDERS' , 'Amount' , '1');
-- +1 movement to settlers
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_SATYAGRAHA' , 'GANDHI_FAST_SETTLERS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GANDHI_FAST_SETTLERS' , 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT' , 'UNIT_IS_SETTLER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GANDHI_FAST_SETTLERS' , 'Amount' , '1');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('UNIT_IS_SETTLER' , 'REQUIREMENT_UNIT_IS_SETTLER');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('UNIT_IS_SETTLER' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIREMENT_UNIT_IS_SETTLER' , 'REQUIREMENT_UNIT_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIREMENT_UNIT_IS_SETTLER' , 'UnitType' , 'UNIT_SETTLER');


--15/12/22 Gandhi faith per city following religion
--02/11/23 Removed
-- INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
-- 	('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'MODIFIER_PLAYER_RELIGION_ADD_PLAYER_BELIEF_YIELD');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
-- 	('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'BeliefYieldType', 'BELIEF_YIELD_PER_CITY'),
-- 	('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'YieldType', 'YIELD_FAITH'),
-- 	('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'Amount', '1'),
-- 	('BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION', 'PerXItems', '1');
-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
-- 	('TRAIT_LEADER_SATYAGRAHA', 'BBG_TRAIT_FAITH_PER_CITY_FOLLOWING_RELIGION');

--19/12/23 Varus cost 5 horse
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_INDIAN_VARU';
INSERT INTO Units_XP2 (UnitType, ResourceCost) VALUES
	('UNIT_INDIAN_VARU', 10);