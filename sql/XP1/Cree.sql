-- Created by iElden

-- Add Ressource Bias
INSERT INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_CREE', 'RESOURCE_CATTLE', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_HORSES', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_SHEEP', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_DEER', '4');

-- Delete free trader (keep tradetoute capacity)
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_POTTERY_ADD_TRADER' AND Name='Amount';

-- 17/04/23 Oki loses 5 base str but gain 5 against stronger units
UPDATE Units SET Combat=15 WHERE UnitType='UNIT_CREE_OKIHTCITAW';

INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQUIRES_COMBAT_AGAINST_STRONGER_UNIT','REQUIREMENT_OPPONENT_IS_STRONGER');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('COMBAT_AGAINST_STRONGER_UNIT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('COMBAT_AGAINST_STRONGER_UNIT_REQUIREMENTS', 'REQUIRES_COMBAT_AGAINST_STRONGER_UNIT');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'COMBAT_AGAINST_STRONGER_UNIT_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS', 'Amount', 5);

INSERT INTO Types (Type, Kind) VALUES
	('BBG_ABILITY_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_ABILITY_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS', 'CLASS_CREE_OKIHTCITAW');
INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS', 'LOC_BBG_ABILITY_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS', 'LOC_BBG_ABILITY_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS_DESCRIPTION');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS', 'BBG_OKIHTCITAW_STRONG_AGAINST_STRONGER_UNITS');