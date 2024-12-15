-- -- Create requirements for each district (needed partially for Eleanor)
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType)
    SELECT 'BBG_CITY_HAS_' || DistrictType, 'REQUIREMENTSET_TEST_ALL' FROM Districts;
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'BBG_CITY_HAS_' || DistrictType, 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT' FROM Districts;
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT', 'REQUIREMENT_CITY_HAS_DISTRICT' FROM Districts;
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'BBG_CITY_HAS_' || DistrictType || '_REQUIREMENT', 'DistrictType', DistrictType FROM Districts;

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

-- Create requirements for each ressources
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
	('BBG_PLAYER_CAN_SEE_HORSES', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_PLAYER_CAN_SEE_IRON', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_PLAYER_CAN_SEE_NITER', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_PLAYER_CAN_SEE_COAL', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_PLAYER_CAN_SEE_ALUMINUM', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_PLAYER_CAN_SEE_OIL', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_PLAYER_CAN_SEE_URANIUM', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('BBG_PLAYER_CAN_SEE_HORSES', 'REQUIRES_PLAYER_CAN_SEE_HORSES'),
	('BBG_PLAYER_CAN_SEE_IRON', 'REQUIRES_PLAYER_CAN_SEE_IRON'),
	('BBG_PLAYER_CAN_SEE_NITER', 'REQUIRES_PLAYER_CAN_SEE_NITER'),
	('BBG_PLAYER_CAN_SEE_COAL', 'REQUIRES_PLAYER_CAN_SEE_COAL'),
	('BBG_PLAYER_CAN_SEE_ALUMINUM', 'REQUIRES_PLAYER_CAN_SEE_ALUMINUM'),
	('BBG_PLAYER_CAN_SEE_OIL', 'REQUIRES_PLAYER_CAN_SEE_OIL'),
	('BBG_PLAYER_CAN_SEE_URANIUM', 'REQUIRES_PLAYER_CAN_SEE_URANIUM');

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

--modifier types
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
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIRES_CITY_HAS_IMPROVED_ALUMINUM'),
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIRES_CITY_HAS_IMPROVED_COAL'),
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIRES_CITY_HAS_IMPROVED_HORSES'),
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIRES_CITY_HAS_IMPROVED_IRON'),
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIRES_CITY_HAS_IMPROVED_NITER'),
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIRES_CITY_HAS_IMPROVED_OIL'),
    ('BBG_CITY_HAS_IMPROVED_STRAT_REQSET', 'REQUIRES_CITY_HAS_IMPROVED_URANIUM');

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