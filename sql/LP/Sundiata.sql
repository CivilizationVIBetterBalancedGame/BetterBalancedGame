
--===========================================================================
--=                               SUNDIATA                                  =
--===========================================================================

-- Rework 07/07/24
-- Exclusion from Mansa Suguba/HS adjacency
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
    ('TRAIT_LEADER_SUNDIATA_KEITA', 'BBG_SUGUBA_HOLY_SITE_MANSA');

-- Theater give +1 adj to suguba
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_SUGUBA_THEATER_SUNDIATA', 'LOC_BBG_SUGUBA_THEATER_SUNDIATA', 'YIELD_GOLD', 1, 'DISTRICT_THEATER');
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) VALUES
    ('DISTRICT_SUGUBA', 'BBG_SUGUBA_THEATER_SUNDIATA');
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
    ('TRAIT_LEADER_SAHEL_MERCHANTS', 'BBG_SUGUBA_HOLY_SITE_MANSA');

-- and reverse
-- 24/07/24 removed
-- INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
--     ('BBG_THEATER_SUGUBA_SUNDIATA', 'LOC_BBG_THEATER_SUGUBA_SUNDIATA', 'YIELD_CULTURE', 1, 'DISTRICT_SUGUBA');
-- INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) VALUES
--     ('DISTRICT_THEATER', 'BBG_THEATER_SUGUBA_SUNDIATA');
-- INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId)
--    SELECT TraitType, 'BBG_THEATER_SUGUBA_SUNDIATA' FROM CivilizationTraits WHERE CivilizationType != 'CIVILIZATION_MALI' GROUP BY CivilizationType;
-- INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
--     ('TRAIT_LEADER_SAHEL_MERCHANTS', 'BBG_THEATER_SUGUBA_SUNDIATA');


-- +1 Great Writer points per turn in cities with both a Suguba and a Theater Square.
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_HAS_SUGUBA_THEATER_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_HAS_SUGUBA_THEATER_REQSET', 'BBG_CITY_HAS_DISTRICT_THEATER_REQUIREMENT'),
    ('BBG_CITY_HAS_SUGUBA_THEATER_REQSET', 'BBG_CITY_HAS_DISTRICT_SUGUBA_REQUIREMENT');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_SUNDIATA_GREAT_WRITER_POINT_GIVER', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', NULL),
    ('BBG_SUNDIATA_GREAT_WRITER_POINT', 'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT', 'BBG_CITY_HAS_SUGUBA_THEATER_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SUNDIATA_GREAT_WRITER_POINT_GIVER', 'ModifierId', 'BBG_SUNDIATA_GREAT_WRITER_POINT'),
    ('BBG_SUNDIATA_GREAT_WRITER_POINT', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_WRITER'),
    ('BBG_SUNDIATA_GREAT_WRITER_POINT', 'Amount', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_SUNDIATA_KEITA', 'BBG_SUNDIATA_GREAT_WRITER_POINT_GIVER');

-- +4 gold, +2 Culture (from prod) per Great Work of Writing.
UPDATE ModifierArguments SET VALUE='YIELD_CULTURE' WHERE ModifierId='SUNDIATA_KEITA_GREAT_WORK_PRODUCTION_WRITING' AND Name='YieldType';

-- 30% Gold discount on Great People patronage
UPDATE ModifierArguments SET VALUE=30 WHERE ModifierId='SUNDIATA_KEITA_PURCHASE_GREAT_PEOPLE' AND Name='Amount';