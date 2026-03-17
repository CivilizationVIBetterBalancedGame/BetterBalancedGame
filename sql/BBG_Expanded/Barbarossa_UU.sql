
-- Barbarossa tank replacement
-- +3 base
-- +3 when not adjacent to another panzer
DELETE FROM UnitAbilityModifiers WHERE UnitAbilityType='ABILITY_PANZER';

UPDATE Units SET Combat=88, Cost=480 WHERE UnitType='UNIT_GERMAN_PANZER';

INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
    ('BBG_PANZER_IS_NOT_ADJACENT', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TAG_MATCHES', 1);
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_PANZER_IS_NOT_ADJACENT', 'Tag', 'CLASS_GERMAN_PANZER'),
    ('BBG_PANZER_IS_NOT_ADJACENT', 'IncludeCenter', 0);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_PANZER_IS_NOT_ADJACENT_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_PANZER_IS_NOT_ADJACENT_REQSET', 'BBG_PANZER_IS_NOT_ADJACENT');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_PANZER_CS_NOT_ADJACENT_PANZER', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_PANZER_IS_NOT_ADJACENT_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_PANZER_CS_NOT_ADJACENT_PANZER', 'Amount', 3);
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('ABILITY_PANZER', 'BBG_PANZER_CS_NOT_ADJACENT_PANZER');
INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES
    ('BBG_PANZER_CS_NOT_ADJACENT_PANZER', 'Preview', 'LOC_BBG_PANZER_CS_NOT_ADJACENT_PANZER_DESC');