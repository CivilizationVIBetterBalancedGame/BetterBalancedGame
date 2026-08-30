-- -- Create requirements for each district (needed partially for Eleanor)
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType)
    SELECT 'BBG_CITY_HAS_' || DistrictType, 'REQUIREMENTSET_TEST_ALL' FROM Districts;
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'BBG_CITY_HAS_' || DistrictType, 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT' FROM Districts;
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT', 'REQUIREMENT_CITY_HAS_DISTRICT' FROM Districts;
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT', 'DistrictType', DistrictType FROM Districts;


-- Create requirements for each building 
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'BBG_UTILS_CITY_HAS_' || BuildingType || '_REQUIREMENT', 'REQUIREMENT_CITY_HAS_BUILDING' FROM Buildings;
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType)
    SELECT 'BBG_UTILS_CITY_HAS_' || BuildingType, 'REQUIREMENTSET_TEST_ALL' FROM Buildings;
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'BBG_UTILS_CITY_HAS_' || BuildingType, 'BBG_UTILS_CITY_HAS_' || BuildingType || '_REQUIREMENT' FROM Buildings;
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'BBG_UTILS_CITY_HAS_' || BuildingType || '_REQUIREMENT', 'BuildingType', BuildingType FROM Buildings;




INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_IS_SPECIALTY_DISTRICT', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    SELECT 'BBG_IS_SPECIALTY_DISTRICT', 'BBG_DISTRICT_IS_' || DistrictType || '_REQUIREMENT' FROM Districts WHERE RequiresPopulation=1;

-- -- Create requirements for each district (needed for digital democracy)
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType)
    SELECT 'BBG_DISTRICT_IS_' || DistrictType || '_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Districts;
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'BBG_DISTRICT_IS_' || DistrictType || '_REQSET', 'BBG_DISTRICT_IS_' || DistrictType || '_REQUIREMENT' FROM Districts;
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'BBG_DISTRICT_IS_' || DistrictType || '_REQUIREMENT', 'REQUIREMENT_DISTRICT_TYPE_MATCHES' FROM Districts;
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'BBG_DISTRICT_IS_' || DistrictType || '_REQUIREMENT', 'DistrictType', DistrictType FROM Districts;

-- Create requirements for each technology
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || TechnologyType, 'REQUIREMENTSET_TEST_ALL' FROM Technologies;
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || TechnologyType || '_REQUIREMENT', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY' FROM Technologies;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || TechnologyType || '_REQUIREMENT', 'TechnologyType', TechnologyType FROM Technologies;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || TechnologyType, 'BBG_UTILS_PLAYER_HAS_' || TechnologyType || '_REQUIREMENT' FROM Technologies;

-- Create requirements for each civic
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || CivicType || '_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Civics;
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || CivicType || '_REQUIREMENT', 'REQUIREMENT_PLAYER_HAS_CIVIC' FROM Civics;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || CivicType || '_REQUIREMENT', 'CivicType', CivicType FROM Civics;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_UTILS_PLAYER_HAS_' || CivicType || '_REQSET', 'BBG_UTILS_PLAYER_HAS_' || CivicType || '_REQUIREMENT' FROM Civics;


-- Create requiremnt for each leader
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_PLAYER_IS_' || LeaderType || '_REQSET', 'REQUIREMENTSET_TEST_ANY' FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'BBG_PLAYER_IS_' || LeaderType || '_REQSET', 'BBG_PLAYER_IS_' || LeaderType || '_REQUIREMENT' FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'BBG_PLAYER_IS_' || LeaderType || '_REQUIREMENT' , 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES' FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'BBG_PLAYER_IS_' || LeaderType || '_REQUIREMENT' , 'LeaderType', LeaderType FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';


-- Create requirements for each ressources
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_PLAYER_CAN_SEE_' || ResourceType || '_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'BBG_PLAYER_CAN_SEE_' || ResourceType || '_REQSET', 'BBG_PLAYER_CAN_SEE_' || ResourceType || '_REQUIREMENT' FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'BBG_PLAYER_CAN_SEE_' || ResourceType || '_REQUIREMENT' , 'REQUIREMENT_PLAYER_HAS_RESOURCE_VISIBILITY' FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'BBG_PLAYER_CAN_SEE_' || ResourceType || '_REQUIREMENT' , 'ResourceType', ResourceType FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';

    
-- INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
-- 	('BBG_PLAYER_CAN_SEE_HORSES', 'REQUIREMENTSET_TEST_ALL'),
-- 	('BBG_PLAYER_CAN_SEE_IRON', 'REQUIREMENTSET_TEST_ALL'),
-- 	('BBG_PLAYER_CAN_SEE_NITER', 'REQUIREMENTSET_TEST_ALL'),
-- 	('BBG_PLAYER_CAN_SEE_COAL', 'REQUIREMENTSET_TEST_ALL'),
-- 	('BBG_PLAYER_CAN_SEE_ALUMINUM', 'REQUIREMENTSET_TEST_ALL'),
-- 	('BBG_PLAYER_CAN_SEE_OIL', 'REQUIREMENTSET_TEST_ALL'),
-- 	('BBG_PLAYER_CAN_SEE_URANIUM', 'REQUIREMENTSET_TEST_ALL');
-- INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
-- 	('BBG_PLAYER_CAN_SEE_HORSES', 'REQUIRES_PLAYER_CAN_SEE_HORSES'),
-- 	('BBG_PLAYER_CAN_SEE_IRON', 'REQUIRES_PLAYER_CAN_SEE_IRON'),
-- 	('BBG_PLAYER_CAN_SEE_NITER', 'REQUIRES_PLAYER_CAN_SEE_NITER'),
-- 	('BBG_PLAYER_CAN_SEE_COAL', 'REQUIRES_PLAYER_CAN_SEE_COAL'),
-- 	('BBG_PLAYER_CAN_SEE_ALUMINUM', 'REQUIRES_PLAYER_CAN_SEE_ALUMINUM'),
-- 	('BBG_PLAYER_CAN_SEE_OIL', 'REQUIRES_PLAYER_CAN_SEE_OIL'),
-- 	('BBG_PLAYER_CAN_SEE_URANIUM', 'REQUIRES_PLAYER_CAN_SEE_URANIUM');

-- requirements game era (for portugal)
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'BBG_GAME_IS_IN_' || EraType || '_REQUIREMENT', 'REQUIREMENT_GAME_ERA_IS'
    FROM Eras;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'BBG_GAME_IS_IN_' || EraType || '_REQUIREMENT', 'EraType', EraType
    FROM Eras;
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_GAME_IS_IN_' || EraType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
    FROM Eras;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_GAME_IS_IN_' || EraType || '_REQUIREMENTS', 'BBG_GAME_IS_IN_' || EraType || '_REQUIREMENT'
    FROM Eras;

-- requirements player game era (for teddy)
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'BBG_PLAYER_IS_IN_' || EraType || '_REQUIREMENT', 'REQUIREMENT_PLAYER_ERA_AT_LEAST'
    FROM Eras;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'BBG_PLAYER_IS_IN_' || EraType || '_REQUIREMENT', 'EraType', EraType
    FROM Eras;
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_PLAYER_IS_IN_' || EraType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
    FROM Eras;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_PLAYER_IS_IN_' || EraType || '_REQUIREMENTS', 'BBG_PLAYER_IS_IN_' || EraType || '_REQUIREMENT'
    FROM Eras;


-- requirement player is not erea
INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
    SELECT 'BBG_PLAYER_IS_NOT_IN_' || EraType || '_REQUIREMENT', 'REQUIREMENT_PLAYER_ERA_AT_LEAST', 1
    FROM Eras;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'BBG_PLAYER_IS_NOT_IN_' || EraType || '_REQUIREMENT', 'EraType', EraType
    FROM Eras;
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_PLAYER_IS_NOT_IN_' || EraType || '_REQSET', 'REQUIREMENTSET_TEST_ALL'
    FROM Eras;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_PLAYER_IS_NOT_IN_' || EraType || '_REQSET', 'BBG_PLAYER_IS_NOT_IN_' || EraType || '_REQUIREMENT'
    FROM Eras;


INSERT OR IGNORE INTO RequirementSets VALUES
    ('BBG_UNIT_ON_HILL_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements VALUES
    ('BBG_UNIT_ON_HILL_REQUIREMENTS', 'PLOT_IS_HILLS_REQUIREMENT');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_HAS_IMPROVED_BONUS', 'REQUIREMENT_PLOT_IMPROVED_RESOURCE_CLASS_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_HAS_IMPROVED_BONUS', 'ResourceClassType', 'RESOURCECLASS_BONUS');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_HAS_IMPROVED_LUXURY', 'REQUIREMENT_PLOT_IMPROVED_RESOURCE_CLASS_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_HAS_IMPROVED_LUXURY', 'ResourceClassType', 'RESOURCECLASS_LUXURY');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_TILE_HAS_ANY_IMPROVEMENT', 'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT');

-- modifier types
INSERT INTO Types(Type, Kind) VALUES
    ('MODIFIER_SINGLE_PLAYER_ATTACH_MODIFIER', 'KIND_MODIFIER'),
    ('MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER', 'KIND_MODIFIER');
INSERT INTO DynamicModifiers(ModifierType, CollectionType, EffectType) VALUES
    ('MODIFIER_SINGLE_PLAYER_ATTACH_MODIFIER', 'COLLECTION_OWNER', 'EFFECT_ATTACH_MODIFIER'),
    ('MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER', 'COLLECTION_PLAYER_DISTRICTS', 'EFFECT_ATTACH_MODIFIER');  


CREATE TABLE WonderTerrainFeature_BBG(
    WonderType TEXT NOT NULL,
    TerrainClassType TEXT,
    FeatureType TEXT,
    Other TEXT,
    PRIMARY KEY(WonderType)
);

CREATE TABLE AbstractModifiers(
    ParentObjectID TEXT NOT NULL,
    ModifierAId TEXT,
    ModifierAType TEXT,
    ModifierAName TEXT,
    ModifierAValue TEXT,
    ModifierBId TEXT,
    SubjectRequirementSetId TEXT,
    RequirementSetType TEXT,
    RequirementId TEXT,
    RequirementType TEXT,
    Inverse BOOL,
    Name TEXT,
    Value TEXT 
    );

CREATE TABLE CustomPlacement(
    ObjectType TEXT NOT NULL,
    Hash INTEGER NOT NULL,
    PlacementFunction TEXT NOT NULL,
    OverridePlacement BOOLEAN NOT NULL CHECK(OverridePlacement IN (0,1)) DEFAULT 0,
    PRIMARY KEY(ObjectType),
    FOREIGN KEY(Hash) REFERENCES Types(Hash) ON DELETE CASCADE ON UPDATE CASCADE
    );


-- For Hungary and Varangian
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'BBG_PLAYER_IS_SUZERAIN_OF_' || LeaderType, 'REQUIREMENT_PLAYER_IS_SUZERAIN_OF_X'
    FROM Leaders
    WHERE InheritFrom IN
        ('LEADER_MINOR_CIV_CULTURAL', 'LEADER_MINOR_CIV_INDUSTRIAL', 'LEADER_MINOR_CIV_MILITARISTIC',
        'LEADER_MINOR_CIV_RELIGIOUS', 'LEADER_MINOR_CIV_SCIENTIFIC', 'LEADER_MINOR_CIV_TRADE');

INSERT INTO RequirementArguments(RequirementId, Name, Type, Value)
    SELECT 'BBG_PLAYER_IS_SUZERAIN_OF_' || LeaderType, 'LeaderType', 'ARGTYPE_IDENTITY', LeaderType
    FROM Leaders
    WHERE InheritFrom IN
        ('LEADER_MINOR_CIV_CULTURAL', 'LEADER_MINOR_CIV_INDUSTRIAL', 'LEADER_MINOR_CIV_MILITARISTIC',
        'LEADER_MINOR_CIV_RELIGIOUS', 'LEADER_MINOR_CIV_SCIENTIFIC', 'LEADER_MINOR_CIV_TRADE');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_PLAYER_IS_SUZERAIN_OF_' || LeaderType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
    FROM Leaders
    WHERE InheritFrom IN
        ('LEADER_MINOR_CIV_CULTURAL', 'LEADER_MINOR_CIV_INDUSTRIAL', 'LEADER_MINOR_CIV_MILITARISTIC',
        'LEADER_MINOR_CIV_RELIGIOUS', 'LEADER_MINOR_CIV_SCIENTIFIC', 'LEADER_MINOR_CIV_TRADE');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_PLAYER_IS_SUZERAIN_OF_' || LeaderType || '_REQUIREMENTS', 'BBG_PLAYER_IS_SUZERAIN_OF_' || LeaderType
    FROM Leaders
    WHERE InheritFrom IN
        ('LEADER_MINOR_CIV_CULTURAL', 'LEADER_MINOR_CIV_INDUSTRIAL', 'LEADER_MINOR_CIV_MILITARISTIC',
        'LEADER_MINOR_CIV_RELIGIOUS', 'LEADER_MINOR_CIV_SCIENTIFIC', 'LEADER_MINOR_CIV_TRADE');

-- Only attack for both Varangian and Olympia
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_PLAYER_ATTACKING_IS_SUZERAIN_OF_' || LeaderType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
    FROM Leaders
    WHERE InheritFrom IN
        ('LEADER_MINOR_CIV_CULTURAL', 'LEADER_MINOR_CIV_INDUSTRIAL', 'LEADER_MINOR_CIV_MILITARISTIC',
        'LEADER_MINOR_CIV_RELIGIOUS', 'LEADER_MINOR_CIV_SCIENTIFIC', 'LEADER_MINOR_CIV_TRADE');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_PLAYER_ATTACKING_IS_SUZERAIN_OF_' || LeaderType || '_REQUIREMENTS', 'BBG_PLAYER_IS_SUZERAIN_OF_' || LeaderType
    FROM Leaders
    WHERE InheritFrom IN
        ('LEADER_MINOR_CIV_CULTURAL', 'LEADER_MINOR_CIV_INDUSTRIAL', 'LEADER_MINOR_CIV_MILITARISTIC',
        'LEADER_MINOR_CIV_RELIGIOUS', 'LEADER_MINOR_CIV_SCIENTIFIC', 'LEADER_MINOR_CIV_TRADE');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_PLAYER_ATTACKING_IS_SUZERAIN_OF_' || LeaderType || '_REQUIREMENTS', 'PLAYER_IS_ATTACKER_REQUIREMENTS'
    FROM Leaders
    WHERE InheritFrom IN
        ('LEADER_MINOR_CIV_CULTURAL', 'LEADER_MINOR_CIV_INDUSTRIAL', 'LEADER_MINOR_CIV_MILITARISTIC',
        'LEADER_MINOR_CIV_RELIGIOUS', 'LEADER_MINOR_CIV_SCIENTIFIC', 'LEADER_MINOR_CIV_TRADE');



-- For Victoria AoE and Elizabeth
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_OBJECT_10_OR_MORE_TILES_FROM_CAPITAL_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_OBJECT_10_OR_MORE_TILES_FROM_CAPITAL_REQSET', 'BBG_REQUIRES_OBJECT_10_OR_MORE_TILES_FROM_CAPITAL');
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_OBJECT_10_OR_MORE_TILES_FROM_CAPITAL','REQUIREMENT_PLOT_NEAR_CAPITAL');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_OBJECT_10_OR_MORE_TILES_FROM_CAPITAL', 'MinDistance', '10');


-- Every resources requirement
INSERT INTO Requirements (RequirementId, RequirementType) SELECT
    'BBG_CITY_HAS_IMPROVED_' || Resources.ResourceType || '_REQ', 'REQUIREMENT_CITY_HAS_RESOURCE_TYPE_IMPROVED' FROM Resources WHERE NOT Resources.ResourceType='BBG_DUMMY_RESOURCE_MACEDON';
INSERT INTO RequirementArguments (RequirementId, Name, Value) SELECT
    'BBG_CITY_HAS_IMPROVED_' || Resources.ResourceType || '_REQ', 'ResourceType', Resources.ResourceType FROM Resources WHERE NOT Resources.ResourceType='BBG_DUMMY_RESOURCE_MACEDON';
    
-- city has improved strategic
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'BBG_CITY_HAS_IMPROVED_' || Resources.ResourceType || '_REQ' FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
-- city has improved bonus
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_HAS_IMPROVED_BONUS_REQSET', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_CITY_HAS_IMPROVED_BONUS_REQSET', 'BBG_CITY_HAS_IMPROVED_' || Resources.ResourceType || '_REQ' FROM Resources WHERE ResourceClassType='RESOURCECLASS_BONUS';
-- city has improved lux
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_HAS_IMPROVED_LUX_REQSET', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_CITY_HAS_IMPROVED_LUX_REQSET', 'BBG_CITY_HAS_IMPROVED_' || Resources.ResourceType || '_REQ' FROM Resources WHERE ResourceClassType='RESOURCECLASS_LUXURY';

-- needed for players without nfp
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQUIRES_PLOT_HAS_GRASS_FLOODPLAINS', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES'),
    ('REQUIRES_PLOT_HAS_PLAINS_FLOODPLAINS', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIRES_PLOT_HAS_GRASS_FLOODPLAINS', 'FeatureType', 'FEATURE_FLOODPLAINS_GRASSLAND'),
    ('REQUIRES_PLOT_HAS_PLAINS_FLOODPLAINS', 'FeatureType', 'FEATURE_FLOODPLAINS_PLAINS');
    



-- == PLAYER HAS FINISHED RELIGION ==
-- Checks Requirement Set for each belief type
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('REQUIRES_PLAYER_COMPLETED_RELIGION_RELIC_CPLMOD' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('REQUIRES_PLAYER_COMPLETED_RELIGION_RELIC_CPLMOD' , 'RELIGION_HAS_FOUNDER_BELIEF_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('REQUIRES_PLAYER_COMPLETED_RELIGION_RELIC_CPLMOD' , 'RELIGION_HAS_WORSHIP_BELIEF_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('REQUIRES_PLAYER_COMPLETED_RELIGION_RELIC_CPLMOD' , 'RELIGION_HAS_ENHANCER_BELIEF_CPLMOD');
-- Creates Belief Requirement Sets
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIREMENTSET_TEST_ANY');
-- Attaches Requirement Sets
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_CPLMOD' , 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_CPLMOD' , 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_CPLMOD' , 'REQUIREMENT_REQUIREMENTSET_IS_MET');
-- RequirementSet For FOUNDER Belief
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_CHURCH_PROPERTY_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_LAY_MINISTRY_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_PAPAL_PRIMACY_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_PILGRIMAGE_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_STEWARDSHIP_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_TITHE_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_WORLD_CHURCH_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_CROSS_CULTURAL_DIALOGUE_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_RELIGIOUS_UNITY_CPLMOD');
--RequirementSet For WORSHIP Belief
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_CATHEDRAL_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_GURDWARA_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_MEETING_HOUSE_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_MOSQUE_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_PAGODA_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_SYNAGOGUE_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_WAT_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_STUPA_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_DAR_E_MEHR_CPLMOD');
--RequirementSet For ENHANCER Belief
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_DEFENDER_OF_FAITH_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_HOLY_ORDER_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_ITINERANT_PREACHERS_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_JUST_WAR_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_MISSIONARY_ZEAL_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_MONASTIC_ISOLATION_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_SCRIPTURE_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_BURIAL_GROUNDS_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_RELIGIOUS_COLONIZATION_CPLMOD');
--Checks for FOUNDER Belief
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_CHURCH_PROPERTY_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_LAY_MINISTRY_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_PAPAL_PRIMACY_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_PILGRIMAGE_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_STEWARDSHIP_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_TITHE_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_WORLD_CHURCH_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_CROSS_CULTURAL_DIALOGUE_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_RELIGIOUS_UNITY_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
--Checks for WORSHIP Belief
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_CATHEDRAL_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_GURDWARA_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_MEETING_HOUSE_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_MOSQUE_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_PAGODA_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_SYNAGOGUE_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_WAT_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_STUPA_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_DAR_E_MEHR_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
--Checks for ENHANCER Belief
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_DEFENDER_OF_FAITH_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_HOLY_ORDER_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_ITINERANT_PREACHERS_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_JUST_WAR_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_MISSIONARY_ZEAL_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_MONASTIC_ISOLATION_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_SCRIPTURE_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_BURIAL_GROUNDS_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
    VALUES ('REQUIRES_BELIEF_RELIGIOUS_COLONIZATION_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
--RequirementArguments
--Checks RequirementSets
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('RELIGION_HAS_FOUNDER_BELIEF_CPLMOD' , 'RequirementSetId' , 'RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('RELIGION_HAS_WORSHIP_BELIEF_CPLMOD' , 'RequirementSetId' , 'RELIGION_HAS_WORSHIP_BELIEF_REQUIREMENTS_CPLMOD');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('RELIGION_HAS_ENHANCER_BELIEF_CPLMOD' , 'RequirementSetId' , 'RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD');
--FOUNDER   
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_CHURCH_PROPERTY_CPLMOD' , 'BeliefType' , 'BELIEF_CHURCH_PROPERTY');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_LAY_MINISTRY_CPLMOD' , 'BeliefType' , 'BELIEF_LAY_MINISTRY');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_PAPAL_PRIMACY_CPLMOD' , 'BeliefType' , 'BELIEF_PAPAL_PRIMACY');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_PILGRIMAGE_CPLMOD' , 'BeliefType' , 'BELIEF_PILGRIMAGE');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_STEWARDSHIP_CPLMOD' , 'BeliefType' , 'BELIEF_STEWARDSHIP');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_TITHE_CPLMOD' , 'BeliefType' , 'BELIEF_TITHE');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_WORLD_CHURCH_CPLMOD' , 'BeliefType' , 'BELIEF_WORLD_CHURCH');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_CROSS_CULTURAL_DIALOGUE_CPLMOD' , 'BeliefType' , 'BELIEF_CROSS_CULTURAL_DIALOGUE');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES('REQUIRES_BELIEF_RELIGIOUS_UNITY_CPLMOD' , 'BeliefType' , 'BELIEF_RELIGIOUS_UNITY');
--WORSHIP   
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_CATHEDRAL_CPLMOD' , 'BeliefType' , 'BELIEF_CATHEDRAL');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_GURDWARA_CPLMOD' , 'BeliefType' , 'BELIEF_GURDWARA');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_MEETING_HOUSE_CPLMOD' , 'BeliefType' , 'BELIEF_MEETING_HOUSE');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_MOSQUE_CPLMOD' , 'BeliefType' , 'BELIEF_MOSQUE');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_PAGODA_CPLMOD' , 'BeliefType' , 'BELIEF_PAGODA');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_SYNAGOGUE_CPLMOD' , 'BeliefType' , 'BELIEF_SYNAGOGUE');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_WAT_CPLMOD' , 'BeliefType' , 'BELIEF_WAT');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_STUPA_CPLMOD' , 'BeliefType' , 'BELIEF_STUPA');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_DAR_E_MEHR_CPLMOD' , 'BeliefType' , 'BELIEF_DAR_E_MEHR');
--ENHANCER
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_DEFENDER_OF_FAITH_CPLMOD' , 'BeliefType' , 'BELIEF_DEFENDER_OF_FAITH');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_HOLY_ORDER_CPLMOD' , 'BeliefType' , 'BELIEF_HOLY_ORDER');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_ITINERANT_PREACHERS_CPLMOD' , 'BeliefType' , 'BELIEF_ITINERANT_PREACHERS');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_JUST_WAR_CPLMOD' , 'BeliefType' , 'BELIEF_JUST_WAR');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_MISSIONARY_ZEAL_CPLMOD' , 'BeliefType' , 'BELIEF_MISSIONARY_ZEAL');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_MONASTIC_ISOLATION_CPLMOD' , 'BeliefType' , 'BELIEF_MONASTIC_ISOLATION');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_SCRIPTURE_CPLMOD' , 'BeliefType' , 'BELIEF_SCRIPTURE');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_BURIAL_GROUNDS_CPLMOD' , 'BeliefType' , 'BELIEF_BURIAL_GROUNDS');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_BELIEF_RELIGIOUS_COLONIZATION_CPLMOD' , 'BeliefType' , 'BELIEF_RELIGIOUS_COLONIZATION');

-- Requirements to test if unit is in an era or earlier BBG_UNIT_IS_UP_TO_RENAISSANCE_ERA


INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) SELECT
    'BBG_UNIT_IS_' || EraType, 'REQUIREMENT_UNIT_ERA_TYPE_MATCHES' FROM Eras;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) SELECT
    'BBG_UNIT_IS_' || EraType, 'EraType', EraType FROM Eras;
    

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) SELECT
    'BBG_UNIT_IS_UP_TO_' || EraType, 'REQUIREMENT_REQUIREMENTSET_IS_MET' FROM Eras;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) SELECT
    'BBG_UNIT_IS_UP_TO_' || EraType, 'RequirementSetId', 'BBG_UNIT_IS_UP_TO_' || EraType || '_REQSET' FROM Eras;
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType) SELECT
    'BBG_UNIT_IS_UP_TO_' || EraType || '_REQSET', 'REQUIREMENTSET_TEST_ANY' FROM Eras;

-- ex : medieval = ancient, classical + medieval --> use ChronologyIndex to get the era order
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT
    'BBG_UNIT_IS_UP_TO_' || current.EraType || '_REQSET',
    'BBG_UNIT_IS_' || prior.EraType
FROM Eras AS current
JOIN Eras AS prior
    ON prior.ChronologyIndex <= current.ChronologyIndex;

-- to check if unit is melee, ranged, anti cav, light cav, siege, cavalry etc
INSERT INTO Requirements (RequirementId, RequirementType) 
SELECT 'BBG_UNIT_IS_' || PromotionClassType, 'REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES' FROM UnitPromotionClasses;

INSERT INTO RequirementArguments (RequirementId, Name, Value) 
SELECT 'BBG_UNIT_IS_' || PromotionClassType, 'UnitPromotionClass', PromotionClassType FROM UnitPromotionClasses;

INSERT INTO Requirements (RequirementId, RequirementType) 
SELECT 'BBG_UNIT_IS_' || FormationClassType, 'REQUIREMENT_UNIT_FORMATION_CLASS_MATCHES' FROM UnitFormationClasses;

INSERT INTO RequirementArguments (RequirementId, Name, Value) 
SELECT 'BBG_UNIT_IS_' || FormationClassType, 'UnitFormationClass', FormationClassType FROM UnitFormationClasses;


-- Test if unit is unit type
INSERT INTO Requirements (RequirementId, RequirementType)
SELECT 'BBG_UTILS_UNIT_IS_' || UnitType, 'REQUIREMENT_UNIT_TYPE_MATCHES' FROM Units;

INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'BBG_UTILS_UNIT_IS_' || UnitType, 'UnitType', UnitType FROM Units;

INSERT INTO Tags (Tag, Vocabulary)
SELECT 'CLASS_UNIQUE_UNIT', 'ABILITY_CLASS';

INSERT INTO TypeTags (Type, Tag)
SELECT UnitType, 'CLASS_UNIQUE_UNIT' FROM Units WHERE TraitType is not null;

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
('BBG_UTILS_UNIT_IS_UNIQUE', 'REQUIREMENT_UNIT_TAG_MATCHES'),
('BBG_UTILS_OPPONENT_UNIT_IS_UNIQUE', 'REQUIREMENT_OPPONENT_UNIT_TAG_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
('BBG_UTILS_UNIT_IS_UNIQUE', 'Tag', 'CLASS_UNIQUE_UNIT'),
('BBG_UTILS_OPPONENT_UNIT_IS_UNIQUE', 'Tag', 'CLASS_UNIQUE_UNIT');



-- allow to test if an unit has a specific promotion
-- promotion give a fake ability, and a requirement check if a unit has the ability
INSERT INTO Requirements (RequirementId, RequirementType) 
    SELECT 'BBG_UNIT_HAS_' || UnitPromotionType || '_ABILITY', 'REQUIREMENT_UNIT_HAS_ABILITY' FROM UnitPromotions;

INSERT INTO RequirementArguments (RequirementId, Name, Value) 
    SELECT 'BBG_UNIT_HAS_' || UnitPromotionType || '_ABILITY', 'UnitAbilityType', 'BBG_FAKE_ABILITY_' || UnitPromotionType FROM UnitPromotions;

INSERT INTO Modifiers (ModifierId, ModifierType) 
    SELECT 'BBG_UNIT_' || UnitPromotionType || '_GIVE_ABILITY', 'MODIFIER_PLAYER_UNIT_GRANT_ABILITY' FROM UnitPromotions;

INSERT INTO Types (Type, Kind)
    SELECT 'BBG_FAKE_ABILITY_' || UnitPromotionType, 'KIND_ABILITY' FROM UnitPromotions;

INSERT INTO UnitAbilities (UnitAbilityType, Name, Description, Inactive)
    SELECT 'BBG_FAKE_ABILITY_' || UnitPromotionType, null, null, 1 FROM UnitPromotions;

INSERT INTO TypeTags (Type, Tag)
    SELECT 'BBG_FAKE_ABILITY_' || UnitPromotionType, 'CLASS_ALL_COMBAT_UNITS' FROM UnitPromotions;

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
    SELECT 'BBG_UNIT_' || UnitPromotionType || '_GIVE_ABILITY', 'AbilityType', 'BBG_FAKE_ABILITY_' || UnitPromotionType FROM UnitPromotions;

INSERT INTO UnitPromotionModifiers (UnitPromotionType, ModifierId) 
    SELECT UnitPromotionType, 'BBG_UNIT_' || UnitPromotionType || '_GIVE_ABILITY' FROM UnitPromotions;

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) 
    SELECT 'BBG_UNIT_' || UnitPromotionType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' FROM UnitPromotions;

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) 
    SELECT 'BBG_UNIT_' || UnitPromotionType || '_REQUIREMENTS', 'BBG_UNIT_HAS_' || UnitPromotionType || '_ABILITY' FROM UnitPromotions;
