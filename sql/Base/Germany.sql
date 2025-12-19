-- Extra district comes at Guilds
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('PLAYER_HAS_GUILDS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLAYER_HAS_GUILDS' , 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_PLAYER_HAS_GUILDS' , 'CivicType' , 'CIVIC_GUILDS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('PLAYER_HAS_GUILDS_REQUIREMENTS' , 'REQUIRES_PLAYER_HAS_GUILDS');
UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_GUILDS_REQUIREMENTS' WHERE ModifierId='TRAIT_EXTRA_DISTRICT_EACH_CITY';

-- 19/12/25 Barbarossa excluded from hansa chub adjacency, only Ludwig gets it
INSERT INTO ExcludedAdjacencies (TraitType, YieldChangeId) VALUES
    ('TRAIT_LEADER_HOLY_ROMAN_EMPEROR', 'Commerical_Hub_Production');

INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_BARBAROSSA_HANSA_ENCAMPMENT_PROD', 'LOC_BBG_BARBAROSSA_HANSA_ENCAMPMENT_PROD_DESC', 'YIELD_PRODUCTION', 2, 1, 'DISTRICT_ENCAMPMENT');
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_HANSA', 'BBG_BARBAROSSA_HANSA_ENCAMPMENT_PROD');
