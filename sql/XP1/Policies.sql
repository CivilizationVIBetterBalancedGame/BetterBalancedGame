--==============================================================
--******				    POLICIES					  ******
--==============================================================

-- 2020/12/20 Pundit proposal accepted to revert Rationalism requirement to +3 (from +4)
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_CAMPUS_HAS_HIGH_ADJACENCY' AND Name='Amount';
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_HOLY_SITE_HAS_HIGH_ADJACENCY' AND Name='Amount';
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_THEATER_SQUARE_HAS_HIGH_ADJACENCY' AND Name='Amount';

-- 2021/08/24 Rationnalism at 13 population
-- /!\ AFFECT FOLLOWING MODIFIERS :
-- FREEMARKET_BUILDING_YIELDS_HIGH_POP, GRANDOPERA_BUILDING_YIELDS_HIGH_POP
-- RATIONALISM_BUILDING_YIELDS_HIGH_POP, SIMULTANEUM_BUILDING_YIELDS_HIGH_POP
UPDATE RequirementArguments SET Value=13 WHERE RequirementId='REQUIRES_CITY_HAS_HIGH_POPULATION' AND Name='Amount';

--5.2.5 buff autocracy (extend bonus to plaza/diplo quarter district AND diplo quarter buildings) -- moved from base
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_AUTOCRACY', 'AUTOCRACY_PLAZA_DISTRICT'),
    ('GOVERNMENT_AUTOCRACY', 'AUTOCRACY_DIPLOMATIC_DISTRICT');

INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
    ('POLICY_GOV_AUTOCRACY', 'AUTOCRACY_PLAZA_DISTRICT'),
    ('POLICY_GOV_AUTOCRACY', 'AUTOCRACY_DIPLOMATIC_DISTRICT');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('AUTOCRACY_PLAZA_DISTRICT', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_ALL_YIELDS_CHANGE', 'CITY_HAS_GOV_DISTRICT_BBG_REQSET'),
    ('AUTOCRACY_DIPLOMATIC_DISTRICT', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_ALL_YIELDS_CHANGE', 'CITY_HAS_DIPLOMATIC_DISTRICT_BBG_REQSET');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('AUTOCRACY_PLAZA_DISTRICT', 'Amount', '1'),
    ('AUTOCRACY_DIPLOMATIC_DISTRICT', 'Amount', '1');
 
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('CITY_HAS_DIPLOMATIC_DISTRICT_BBG_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('CITY_HAS_GOV_DISTRICT_BBG_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('CITY_HAS_DIPLOMATIC_DISTRICT_BBG_REQSET', 'CITY_HAS_DIPLOMATIC_DISTRICT_BBG_REQ'),
    ('CITY_HAS_GOV_DISTRICT_BBG_REQSET', 'CITY_HAS_GOV_DISTRICT_BBG_REQ');
 
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('CITY_HAS_DIPLOMATIC_DISTRICT_BBG_REQ', 'REQUIREMENT_CITY_HAS_DISTRICT'),
    ('CITY_HAS_GOV_DISTRICT_BBG_REQ', 'REQUIREMENT_CITY_HAS_DISTRICT');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('CITY_HAS_DIPLOMATIC_DISTRICT_BBG_REQ', 'DistrictType', 'DISTRICT_DIPLOMATIC_QUARTER'),
    ('CITY_HAS_GOV_DISTRICT_BBG_REQ', 'DistrictType', 'DISTRICT_GOVERNMENT');

/*
--5.2.5 Communism -- moved from base
INSERT INTO PolicyModifiers(PolicyType, ModifierId)
    SELECT 'POLICY_GOV_COMMUNISM', Modifiers.ModifierId
    FROM Modifiers WHERE ModifierId LIKE 'COMMUNISM%MODIFIER_BBG';
*/