--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Poland
--==================
-- 19/05/2021, 05/09/2021: Poland's Winged Hussar
UPDATE Units SET Combat=64, PrereqCivic='CIVIC_REFORMED_CHURCH' WHERE UnitType='UNIT_POLISH_HUSSAR';

-- Poland gets a relic when founding and completeing a religion
--Grants Relic Upon Founding Religion
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId , RunOnce , Permanent)
	VALUES ('TRAIT_LITHUANIANUNION_FOUND_RELIGION_RELIC_CPLMOD' , 'MODIFIER_PLAYER_GRANT_RELIC' , 'BBG_PLAYER_FOUNDED_RELIGION_REQSET' , 1 , 1);	
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_LITHUANIANUNION_FOUND_RELIGION_RELIC_CPLMOD' , 'Amount' , '1');
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_LITHUANIAN_UNION' , 'TRAIT_LITHUANIANUNION_FOUND_RELIGION_RELIC_CPLMOD');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('BBG_PLAYER_FOUNDED_RELIGION_REQSET' , 'REQUIREMENTSET_TEST_ALL');	
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('BBG_PLAYER_FOUNDED_RELIGION_REQSET' , 'REQUIRES_FOUNDED_RELIGION_BBG');
-- Grants Relic Upon completing Religion
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId , RunOnce , Permanent)
	VALUES ('TRAIT_LITHUANIANUNION_COMPLETE_RELIGION_RELIC_CPLMOD' , 'MODIFIER_PLAYER_GRANT_RELIC' , 'REQUIRES_PLAYER_COMPLETED_RELIGION_RELIC_CPLMOD' , 1 , 1);
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_LITHUANIANUNION_COMPLETE_RELIGION_RELIC_CPLMOD' , 'Amount' , '1');
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_LITHUANIAN_UNION' , 'TRAIT_LITHUANIANUNION_COMPLETE_RELIGION_RELIC_CPLMOD');

