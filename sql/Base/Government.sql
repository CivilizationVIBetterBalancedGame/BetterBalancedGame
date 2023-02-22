--==============================================================================================
--******				GOVERNMENT						   ******
--==============================================================================================
-- fascism attack bonus works on defense now too
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_ATTACK_BUFF';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_LEGACY_ATTACK_BUFF';

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

UPDATE Governments SET OtherGovernmentIntolerance=0 WHERE GovernmentType='GOVERNMENT_DEMOCRACY';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_FASCISM';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_COMMUNISM';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='COLLECTIVIZATION_INTERNAL_TRADE_PRODUCTION' AND Name='Amount';

-- Replace +2 favor on renaissance wall with monarchy to +2 culture
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE' WHERE ModifierId='MONARCHY_STARFORT_FAVOR';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='MONARCHY_STARFORT_FAVOR';

DELETE FROM ModifierArguments WHERE ModifierId='MONARCHY_STARFORT_FAVOR';
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('MONARCHY_STARFORT_FAVOR', 'BuildingType', 'BUILDING_STAR_FORT'),
    ('MONARCHY_STARFORT_FAVOR', 'YieldType', 'YIELD_CULTURE'),
    ('MONARCHY_STARFORT_FAVOR', 'Amount', '2');


-- Government slot
UPDATE Government_SlotCounts SET NumSlots=1 WHERE GovernmentType='GOVERNMENT_MERCHANT_REPUBLIC' AND GovernmentSlotType='SLOT_DIPLOMATIC';
UPDATE Government_SlotCounts SET NumSlots=2 WHERE GovernmentType='GOVERNMENT_MERCHANT_REPUBLIC' AND GovernmentSlotType='SLOT_WILDCARD';

--11/12/22 Communism -1 red card +1 yellow card
UPDATE Government_SlotCounts SET NumSlots=2 WHERE GovernmentType='GOVERNMENT_COMMUNISM' AND GovernmentSlotType='SLOT_MILITARY';
UPDATE Government_SlotCounts SET NumSlots=4 WHERE GovernmentType='GOVERNMENT_COMMUNISM' AND GovernmentSlotType='SLOT_ECONOMIC';

--11/12/22
UPDATE ModifierArguments SET Value=1 WHERE ModifierId='COMMUNISM_PRODUCTIVE_PEOPLE' and Name="Amount";

--11/12/22 Collectivization also give +4 gold per traderoute
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_COLLECTIVIZATION_TRADE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_COLLECTIVIZATION_TRADE_GOLD', 'YieldType', 'YIELD_GOLD'),
    ('BBG_COLLECTIVIZATION_TRADE_GOLD', 'Amount', '4');
INSERT INTO PolicyModifiers(PolicyType, ModifierId) VALUES
    ('POLICY_COLLECTIVIZATION', 'BBG_COLLECTIVIZATION_TRADE_GOLD');


