--==============================================================================================
--******				GOVERNMENT						   ******
--==============================================================================================

--5.2.5 buff autocracy (extend bonus to plaza/diplo quarter district AND diplo quarter buildings)
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_AUTOCRACY', 'AUTOCRACY_PLAZA_DISTRICT'),
    ('GOVERNMENT_AUTOCRACY', 'AUTOCRACY_DIPLOMATIC_DISTRICT');

INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
    ('POLICY_GOV_AUTOCRACY', 'AUTOCRACY_PLAZA_DISTRICT'),
    ('POLICY_GOV_AUTOCRACY', 'AUTOCRACY_DIPLOMATIC_DISTRICT');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('AUTOCRACY_PLAZA_DISTRICT', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_ALL_YIELDS_CHANGE', 'PLAYER_HAS_GOVERNMENT_DISTRICT_REQUIREMENTS'),
    ('AUTOCRACY_DIPLOMATIC_DISTRICT', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_ALL_YIELDS_CHANGE', 'PLAYER_HAS_DIPLOMATIC_DISTRICT_REQUIREMENTS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('AUTOCRACY_PLAZA_DISTRICT', 'Amount', '1'),
    ('AUTOCRACY_DIPLOMATIC_DISTRICT', 'Amount', '1');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('PLAYER_HAS_DIPLOMATIC_DISTRICT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('PLAYER_HAS_DIPLOMATIC_DISTRICT_REQUIREMENTS', 'PLAYER_HAS_DIPLOMATIC_DISTRICT_REQUIREMENT');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('PLAYER_HAS_DIPLOMATIC_DISTRICT_REQUIREMENT', 'REQUIREMENT_PLAYER_HAS_DISTRICT');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('PLAYER_HAS_DIPLOMATIC_DISTRICT_REQUIREMENT', 'DistrictType', 'DISTRICT_DIPLOMATIC_QUARTER');
