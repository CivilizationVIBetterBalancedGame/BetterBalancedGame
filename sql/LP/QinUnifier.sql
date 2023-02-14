

-- 5.2.5 Yongle nerf Pop require remain the same but reduce science/culture from 1 per pop to +0.5/+0.3 (double the inner science/culture per pop) and reduce gold from 2 to 1
UPDATE ModifierArguments SET Value='0.5' WHERE ModifierId='YONGLE_SCIENCE_POPULATION' AND Name='Amount';
UPDATE ModifierArguments SET Value='0.3' WHERE ModifierId='YONGLE_CULTURE_POPULATION' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='YONGLE_GOLD_POPULATION' AND Name='Amount';

-- 5.2.5 Qin unifier general gains 1 charge
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_QIN', 'BBG_LEADER_QIN_ALT_GENERAL_CHARGES');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_LEADER_QIN_ALT_GENERAL_CHARGES', 'MODIFIER_PLAYER_UNITS_ADJUST_GREAT_PERSON_CHARGES', 'UNIT_IS_GENERAL');

INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
    ('BBG_LEADER_QIN_ALT_GENERAL_CHARGES', 'Amount', '1');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('UNIT_IS_GENERAL', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('UNIT_IS_GENERAL', 'REQUIREMENT_UNIT_IS_GENERAL');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQUIREMENT_UNIT_IS_GENERAL', 'REQUIREMENT_GREAT_PERSON_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIREMENT_UNIT_IS_GENERAL', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_GENERAL');


