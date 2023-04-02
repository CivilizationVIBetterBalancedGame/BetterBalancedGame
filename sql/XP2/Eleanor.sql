--==========
-- ELEANOR
--==========
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_ELEANOR_LOYALTY', 'THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, OwnerRequirementSetId) VALUES
    ('THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION', NULL, NULL);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD', 'DistrictType', 'DISTRICT_THEATER'),
    ('THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD', 'Amount', '100');

CREATE TABLE TmpEldenEleonore(DistrictType PRIMARY KEY NOT NULL, YieldType NOT NULL);
INSERT INTO TmpEldenEleonore(DistrictType, YieldType) VALUES
    ('DISTRICT_NEIGHBORHOOD', 'YIELD_FOOD'),
    ('DISTRICT_INDUSTRIAL_ZONE', 'YIELD_PRODUCTION'),
    ('DISTRICT_COMMERCIAL_HUB', 'YIELD_GOLD'),
    ('DISTRICT_HARBOR', 'YIELD_GOLD'),
    ('DISTRICT_CAMPUS', 'YIELD_SCIENCE'),
    ('DISTRICT_THEATER', 'YIELD_CULTURE'),
    ('DISTRICT_HOLY_SITE', 'YIELD_FAITH');

-- Create and attach modifier to Eleanor
INSERT INTO TraitModifiers(TraitType, ModifierId)
    SELECT 'TRAIT_LEADER_ELEANOR_LOYALTY', 'BBG_ELEONORE_' || GreatWorkObjectTypes.GreatWorkObjectType || '_' || DistrictType || '_MODIFIER'
    FROM TmpEldenEleonore CROSS JOIN GreatWorkObjectTypes;
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId, Permanent)
    SELECT 'BBG_ELEONORE_' || GreatWorkObjectTypes.GreatWorkObjectType || '_' || DistrictType || '_MODIFIER', 'MODIFIER_PLAYER_CITIES_ADJUST_GREATWORK_YIELD', 'BBG_CITY_HAS_' || DistrictType, 1
    FROM TmpEldenEleonore CROSS JOIN GreatWorkObjectTypes;

-- Create District Requirements
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType)
    SELECT 'BBG_CITY_HAS_' || DistrictType, 'REQUIREMENTSET_TEST_ALL'
    FROM TmpEldenEleonore;
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'BBG_CITY_HAS_' || DistrictType, 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT'
    FROM TmpEldenEleonore;
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT', 'REQUIREMENT_CITY_HAS_DISTRICT'
    FROM TmpEldenEleonore;
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT', 'DistrictType', DistrictType
    FROM TmpEldenEleonore;

-- Set Modifiers Arguments to correct value
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'BBG_ELEONORE_' || GreatWorkObjectTypes.GreatWorkObjectType || '_' || DistrictType || '_MODIFIER', 'GreatWorkObjectType', GreatWorkObjectType
    FROM TmpEldenEleonore CROSS JOIN GreatWorkObjectTypes;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'BBG_ELEONORE_' || GreatWorkObjectTypes.GreatWorkObjectType || '_' || DistrictType || '_MODIFIER', 'YieldType', YieldType
    FROM TmpEldenEleonore CROSS JOIN GreatWorkObjectTypes;
--4/10/22 Eleanor bonus reduced to 1
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'BBG_ELEONORE_' || GreatWorkObjectTypes.GreatWorkObjectType || '_' || DistrictType || '_MODIFIER', 'YieldChange', '1'
    FROM TmpEldenEleonore CROSS JOIN GreatWorkObjectTypes;

-- Fix Anshan bug with Eleanor
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
    ('BBG_PLAYER_IS_NOT_ELEANOR', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
    ('BBG_PLAYER_IS_NOT_ELEANOR', 'BBG_PLAYER_IS_NOT_ELEANOR_ENGLAND_REQUIREMENT'),
    ('BBG_PLAYER_IS_NOT_ELEANOR', 'BBG_PLAYER_IS_NOT_ELEANOR_FRANCE_REQUIREMENT');
INSERT INTO Requirements(RequirementId , RequirementType, Inverse) VALUES
    ('BBG_PLAYER_IS_NOT_ELEANOR_ENGLAND_REQUIREMENT', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES', 1),
    ('BBG_PLAYER_IS_NOT_ELEANOR_FRANCE_REQUIREMENT', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES', 1);
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
    ('BBG_PLAYER_IS_NOT_ELEANOR_ENGLAND_REQUIREMENT', 'LeaderType', 'LEADER_ELEANOR_ENGLAND'),
    ('BBG_PLAYER_IS_NOT_ELEANOR_FRANCE_REQUIREMENT', 'LeaderType', 'LEADER_ELEANOR_FRANCE');

UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_IS_NOT_ELEANOR' WHERE ModifierId IN
    ('MINOR_CIV_BABYLON_GREAT_WORK_WRITING_SCIENCE', 'MINOR_CIV_BABYLON_GREAT_WORK_RELIC_SCIENCE', 'MINOR_CIV_BABYLON_GREAT_WORK_ARTIFACT_SCIENCE');

DROP TABLE TmpEldenEleonore;