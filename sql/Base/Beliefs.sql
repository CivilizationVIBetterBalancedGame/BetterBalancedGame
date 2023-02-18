--==============================================================================================
--******                PANTHEON                        ******
--==============================================================================================

-- religious settlements more border growth since settler removed
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='RELIGIOUS_SETTLEMENTS_CULTUREBORDER';
-- river goddess +2 HS adj on rivers, -1 housing and -1 amentiy tho
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='RIVER_GODDESS_HOLY_SITE_HOUSING_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='RIVER_GODDESS_HOLY_SITE_AMENITIES_MODIFIER' AND Name='Amount';
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId)
    VALUES ('RIVER_GODDESS_HOLY_SITE_FAITH_BBG' , 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_HAS_PANTHEON_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
    VALUES ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'MODIFIER_PLAYER_CITIES_RIVER_ADJACENCY');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value) VALUES
    ('RIVER_GODDESS_HOLY_SITE_FAITH_BBG', 'ModifierId', 'RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'Amount' , '1'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'DistrictType' , 'DISTRICT_HOLY_SITE'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'YieldType' , 'YIELD_FAITH'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'Description' , 'LOC_DISTRICT_HOLY_SITE_RIVER_FAITH');
INSERT OR IGNORE INTO BeliefModifiers VALUES
    ('BELIEF_RIVER_GODDESS', 'RIVER_GODDESS_HOLY_SITE_FAITH_BBG');
-- city patron buff
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='CITY_PATRON_GODDESS_DISTRICT_PRODUCTION_MODIFIER' AND Name='Amount';
-- Dance of Aurora yields reduced... only work for flat tundra
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='DANCE_OF_THE_AURORA_FAITHTUNDRAHILLSADJACENCY' AND Name='Amount';
-- stone circles -1 faith and +1 prod
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='STONE_CIRCLES_QUARRY_FAITH_MODIFIER' and Name='Amount';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('STONE_CIRCLES_QUARRY_PROD_BBG', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
    ('STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_QUARRY_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('STONE_CIRCLES_QUARRY_PROD_BBG', 'ModifierId', 'STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG'),
    ('STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG', 'YieldType', 'YIELD_PRODUCTION'),
    ('STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG', 'Amount', '1');
INSERT OR IGNORE INTO BeliefModifiers (BeliefType, ModifierID) VALUES
    ('BELIEF_STONE_CIRCLES', 'STONE_CIRCLES_QUARRY_PROD_BBG');
-- religious idols +3 gold
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_BBG', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
    ('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_BBG', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
    ('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_BONUS_MINE_REQUIREMENTS'),
    ('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_LUXURY_MINE_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_BBG', 'ModifierId', 'RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG'),
    ('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG', 'Amount', '3'),
    ('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG', 'YieldType', 'YIELD_GOLD'),
    ('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_BBG', 'ModifierId', 'RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG'),
    ('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG', 'Amount', '3'),
    ('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG', 'YieldType', 'YIELD_GOLD');
INSERT OR IGNORE INTO BeliefModifiers VALUES
    ('BELIEF_RELIGIOUS_IDOLS', 'RELIGIOUS_IDOLS_BONUS_MINE_GOLD_BBG'),
    ('BELIEF_RELIGIOUS_IDOLS', 'RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_BBG');
UPDATE ModifierArguments SET Value='3' WHERE ModifierId IN ('RELIGIOUS_IDOLS_BONUS_MINE_FAITH_MODIFIER', 'RELIGIOUS_IDOLS_LUXURY_MINE_FAITH_MODIFIER') AND Name='Amount';
-- Goddess of the Harvest is +50% faith from chops instead of +100%
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GODDESS_OF_THE_HARVEST_HARVEST_MODIFIER' and Name='Amount';
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GODDESS_OF_THE_HARVEST_REMOVE_FEATURE_MODIFIER' and Name='Amount';
-- Monument to the Gods affects all wonders... not just Ancient and Classical Era
UPDATE ModifierArguments SET Value='ERA_INFORMATION' WHERE ModifierId='MONUMENT_TO_THE_GODS_ANCIENTCLASSICALWONDER_MODIFIER' AND Name='EndEra';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='MONUMENT_TO_THE_GODS_ANCIENTCLASSICALWONDER_MODIFIER' AND Name='Amount';
-- God of War now God of War and Plunder (similar to divine spark)
DELETE FROM BeliefModifiers WHERE BeliefType='BELIEF_GOD_OF_WAR';
INSERT OR IGNORE INTO Modifiers  ( ModifierId , ModifierType , SubjectRequirementSetId )
    VALUES
    ( 'GOD_OF_WAR_AND_PLUNDER_COMHUB' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_HARBOR' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_COMMERCIAL_HUB' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_HARBOR'         ),
    ( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_ENCAMPMENT'     );
INSERT OR IGNORE INTO ModifierArguments ( ModifierId , Name , Type , Value )
    VALUES
    ( 'GOD_OF_WAR_AND_PLUNDER_COMHUB' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_HARBOR' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_MERCHANT' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_ADMIRAL'  ),
    ( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_GENERAL'  ),
    ( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' ),
    ( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' );
INSERT OR IGNORE INTO BeliefModifiers ( BeliefType , ModifierId )
    VALUES
    ( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_COMHUB' ),
    ( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_HARBOR' ),
    ( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' );
-- Fertility Rites gives +1 food for rice and wheat and cattle
INSERT OR IGNORE INTO Tags
    (Tag                                , Vocabulary)
    VALUES 
    ('CLASS_FERTILITY_RITES_FOOD'       , 'RESOURCE_CLASS');
INSERT OR IGNORE INTO TypeTags 
    (Type              , Tag)
    VALUES
    ('RESOURCE_WHEAT'  , 'CLASS_FERTILITY_RITES_FOOD'),
    ('RESOURCE_CATTLE' , 'CLASS_FERTILITY_RITES_FOOD'),
    ('RESOURCE_RICE'   , 'CLASS_FERTILITY_RITES_FOOD');
INSERT OR IGNORE INTO Modifiers 
    (ModifierId                                         , ModifierType                                                , SubjectRequirementSetId)
    VALUES
    ('FERTILITY_RITES_TAG_FOOD'                         , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER'                       , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'      ),
    ('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD'               , 'PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments 
    (ModifierId                                         , Name                       , Value)
    VALUES
    ('FERTILITY_RITES_TAG_FOOD'                         , 'ModifierId'                , 'FERTILITY_RITES_TAG_FOOD_MODIFIER'             ),
    ('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'YieldType'                 , 'YIELD_FOOD'                                    ),
    ('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'Amount'                    , '1'                                             );
INSERT OR IGNORE INTO Requirements 
    (RequirementId                                , RequirementType)
    VALUES 
    ('REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD'       , 'REQUIREMENT_PLOT_RESOURCE_TAG_MATCHES');
INSERT OR IGNORE INTO RequirementArguments 
    (RequirementId                                , Name  , Value)
    VALUES 
    ('REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD'       , 'Tag'         , 'CLASS_FERTILITY_RITES_FOOD');
INSERT OR IGNORE INTO RequirementSets 
    (RequirementSetId                                 , RequirementSetType)
    VALUES 
    ('PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS'       , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements 
    (RequirementSetId                                 , RequirementId)
    VALUES 
    ('PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS'       , 'REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD');
UPDATE BeliefModifiers SET ModifierID='FERTILITY_RITES_TAG_FOOD' WHERE BeliefType='BELIEF_FERTILITY_RITES' AND ModifierID='FERTILITY_RITES_GROWTH';
-- Sacred Path +1 Faith Holy Site adjacency now applies to both Woods and Rainforest
INSERT OR IGNORE INTO BeliefModifiers 
    (BeliefType                   , ModifierId)
    VALUES
    ('BELIEF_SACRED_PATH'         , 'SACRED_PATH_WOODS_FAITH_ADJACENCY');
INSERT OR IGNORE INTO Modifiers 
    (ModifierId                                         , ModifierType                                                , SubjectRequirementSetId)
    VALUES
    ('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'MODIFIER_ALL_CITIES_FEATURE_ADJACENCY'                     , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments 
    (ModifierId                                         , Name                       , Value)
    VALUES
    ('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'DistrictType'              , 'DISTRICT_HOLY_SITE'                            ),
    ('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'FeatureType'               , 'FEATURE_FOREST'                                ),
    ('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'YieldType'                 , 'YIELD_FAITH'                                   ),
    ('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'Amount'                    , '1'                                             ),
    ('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'Description'               , 'LOC_DISTRICT_SACREDPATH_WOODS_FAITH'           );
-- Lady of the Reeds and Marshes now applies pantanal
INSERT OR IGNORE INTO RequirementSetRequirements 
    (RequirementSetId              , RequirementId)
    VALUES 
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_PANTANAL'          );
INSERT OR IGNORE INTO Requirements 
    (RequirementId                          , RequirementType)
    VALUES 
    ('REQUIRES_PLOT_HAS_PANTANAL'           , 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments 
    (RequirementId                          , Name          , Value)
    VALUES 
    ('REQUIRES_PLOT_HAS_PANTANAL'           , 'FeatureType' , 'FEATURE_PANTANAL'             );

--04/10/22 goddess of the hunt nerf from 1p/1f to 1p/2g
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
    ('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_CAMP_REQUIREMENTS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER', 'YieldType', 'YIELD_GOLD'),
    ('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER', 'Amount', '2'),
    ('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD', 'ModifierId', 'BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER');

INSERT INTO BeliefModifiers (BeliefType, ModifierId) VALUES
    ('BELIEF_GODDESS_OF_THE_HUNT', 'BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD');

DELETE FROM BeliefModifiers WHERE ModifierId='GODDESS_OF_THE_HUNT_CAMP_PRODUCTION';

-- Earth Godess +1 faith on appeal
UPDATE Modifiers SET SubjectRequirementSetId='PLOT_CHARMING_APPEAL' WHERE ModifierId='EARTH_GODDESS_APPEAL_FAITH_MODIFIER';

-- Fire Goddess +3
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GODDESS_OF_FIRE_FEATURES_FAITH_MODIFIER' AND Name='Amount';

-- Dance of aurora only on flat tile
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='DANCE_OF_THE_AURORA_FAITHTUNDRAHILLSADJACENCY' AND Name='Amount';

-- Divine spark on District instead of building
UPDATE Modifiers SET ModifierType='MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', SubjectRequirementSetId='DISTRICT_IS_CAMPUS' WHERE ModifierId='DIVINE_SPARK_SCIENTIST_MODIFIER';
-- UPDATE Modifiers SET ModifierType='MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', SubjectRequirementSetId='DISTRICT_IS_THEATER' WHERE ModifierId='DIVINE_SPARK_WRITER_MODIFIER';
-- Divine spark +1 engineer:
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_DIVINE_SPARK_ENGINEER', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
    ('BBG_DIVINE_SPARK_ENGINEER_MODIFIER', 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 'DISTRICT_IS_INDUSTRIAL_ZONE');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_DIVINE_SPARK_ENGINEER', 'ModifierId', 'BBG_DIVINE_SPARK_ENGINEER_MODIFIER'),
    ('BBG_DIVINE_SPARK_ENGINEER_MODIFIER', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER'),
    ('BBG_DIVINE_SPARK_ENGINEER_MODIFIER', 'Amount', '1');
INSERT INTO BeliefModifiers(BeliefType, ModifierID) VALUES
    ('BELIEF_DIVINE_SPARK', 'BBG_DIVINE_SPARK_ENGINEER');

-- Religious settlement: +20% production towards settler and 3 free tiles
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_RELIGIOUS_SETTLEMENT_SETTLER_PROD', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
    ('BBG_RELIGIOUS_SETTLEMENT_SETTLER_PROD_MODIFIER', 'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION', NULL),
    ('BBG_RELIGIOUS_SETTLEMENT_TILE_GRAB', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
    ('BBG_RELIGIOUS_SETTLEMENT_TILE_GRAB_MODIFIER', 'MODIFIER_PLAYER_ADJUST_CITY_TILES', NULL);
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_RELIGIOUS_SETTLEMENT_SETTLER_PROD', 'ModifierId', 'BBG_RELIGIOUS_SETTLEMENT_SETTLER_PROD_MODIFIER'),
    ('BBG_RELIGIOUS_SETTLEMENT_TILE_GRAB', 'ModifierId', 'BBG_RELIGIOUS_SETTLEMENT_TILE_GRAB_MODIFIER'),
    ('BBG_RELIGIOUS_SETTLEMENT_SETTLER_PROD_MODIFIER', 'UnitType', 'UNIT_SETTLER'),
    ('BBG_RELIGIOUS_SETTLEMENT_SETTLER_PROD_MODIFIER', 'Amount', '20'),
    ('BBG_RELIGIOUS_SETTLEMENT_TILE_GRAB_MODIFIER', 'Amount', '2');
INSERT INTO BeliefModifiers(BeliefType, ModifierID) VALUES
    ('BELIEF_RELIGIOUS_SETTLEMENTS', 'BBG_RELIGIOUS_SETTLEMENT_SETTLER_PROD'),
    ('BELIEF_RELIGIOUS_SETTLEMENTS', 'BBG_RELIGIOUS_SETTLEMENT_TILE_GRAB');

-- Initiation Rites gives 30% faith for each military land unit produced
INSERT INTO Modifiers(ModifierId, ModifierType, RunOnce, Permanent, SubjectRequirementSetId) VALUES
    ('INITIATION_RITES_FAITH_YIELD_CPL_MOD', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 0, 0, 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
    ('INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD', 'MODIFIER_SINGLE_CITY_GRANT_YIELD_PER_UNIT_COST', 0, 0, NULL),
    ('BBG_INITIATION_RITES_FREE_WARRIOR', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
    ('BBG_INITIATION_RITES_FREE_WARRIOR_MODIFIER', 'MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL', 1, 1, 'PLAYER_HAS_AT_LEAST_ONE_CITY_REQUIREMENTS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('INITIATION_RITES_FAITH_YIELD_CPL_MOD' , 'ModifierId', 'INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD'),
    ('INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD', 'YieldType', 'YIELD_FAITH'),
    ('INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD', 'UnitProductionPercent', '35'),
    ('BBG_INITIATION_RITES_FREE_WARRIOR', 'ModifierId', 'BBG_INITIATION_RITES_FREE_WARRIOR_MODIFIER'),
    ('BBG_INITIATION_RITES_FREE_WARRIOR_MODIFIER', 'UnitType', 'UNIT_WARRIOR'),
    ('BBG_INITIATION_RITES_FREE_WARRIOR_MODIFIER', 'Amount', '1'),
    ('BBG_INITIATION_RITES_FREE_WARRIOR_MODIFIER', 'AllowUniqueOverride', '1');
DELETE FROM BeliefModifiers WHERE BeliefType='BELIEF_INITIATION_RITES';
INSERT INTO BeliefModifiers(BeliefType, ModifierID) VALUES
    ('BELIEF_INITIATION_RITES', 'INITIATION_RITES_FAITH_YIELD_CPL_MOD'),
    ('BELIEF_INITIATION_RITES', 'BBG_INITIATION_RITES_FREE_WARRIOR');

-- God of forge: 25 => 30%
UPDATE ModifierArguments SET Value='30' WHERE ModifierId='GOD_OF_THE_FORGE_UNIT_ANCIENT_CLASSICAL_PRODUCTION_MODIFIER' AND Name='Amount';


--==============================================================================================
--******                RELIGION                        ******
--==============================================================================================

-- DOF nerf
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='DEFENDER_OF_FAITH_COMBAT_BONUS_MODIFIER' AND Name='Amount';
-- Crusade nerf to +5
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='JUST_WAR_COMBAT_BONUS_MODIFIER' AND Name='Amount';

-- Stewardship to +2/+2
UPDATE ModifierArguments SET Value='2' WHERE Name='Amount' AND ModifierId IN ('STEWARDSHIP_SCIENCE_DISTRICTS_MODIFIER', 'STEWARDSHIP_GOLD_DISTRICTS_MODIFIER');

-- Synagogue to 7 Faith:
UPDATE Building_YieldChanges SET YieldChange=7 WHERE BuildingType='BUILDING_SYNAGOGUE' AND YieldType='YIELD_FAITH';

-- Jesuit Education give 15% discount on campus and theater purchase.
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
    SELECT 'BBG_GIVER_PURCHASE_CHEAPER_' || Buildings.BuildingType, 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_RELIGION_REQUIREMENTS'
    FROM Buildings WHERE PrereqDistrict IN ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'BBG_GIVER_PURCHASE_CHEAPER_' || Buildings.BuildingType, 'ModifierId', 'BBG_PURCHASE_CHEAPER_' || Buildings.BuildingType
    FROM Buildings WHERE PrereqDistrict IN ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');
INSERT INTO Types(Type, Kind) VALUES
    ('BBG_MODIFIER_CITY_ADJUST_BUILDING_PURCHASE_COST', 'KIND_MODIFIER');
INSERT INTO DynamicModifiers(ModifierType, CollectionType, EffectType) VALUES
    ('BBG_MODIFIER_CITY_ADJUST_BUILDING_PURCHASE_COST', 'COLLECTION_OWNER', 'EFFECT_ADJUST_BUILDING_PURCHASE_COST');
INSERT INTO Modifiers(ModifierId, ModifierType)
    SELECT 'BBG_PURCHASE_CHEAPER_' || Buildings.BuildingType, 'BBG_MODIFIER_CITY_ADJUST_BUILDING_PURCHASE_COST'
    FROM Buildings WHERE PrereqDistrict IN ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'BBG_PURCHASE_CHEAPER_' || Buildings.BuildingType, 'BuildingType', BuildingType
    FROM Buildings WHERE PrereqDistrict IN ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'BBG_PURCHASE_CHEAPER_' || Buildings.BuildingType, 'Amount', '15'
    FROM Buildings WHERE PrereqDistrict IN ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');
INSERT INTO BeliefModifiers(BeliefType, ModifierID)
    SELECT 'BELIEF_JESUIT_EDUCATION', 'BBG_GIVER_PURCHASE_CHEAPER_' || Buildings.BuildingType
    FROM Buildings WHERE PrereqDistrict IN ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

-- Monks: Base Game BugFixes
-- Monks: Added: Work with Rams/SeigeTowers, Removed: Wall Breaker 
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_ENABLE_WALL_ATTACK_MONK', 'MODIFIER_PLAYER_UNIT_ADJUST_ENABLE_WALL_ATTACK_PROMOTION_CLASS'),
    ('BBG_BYPASS_WALLS_MONK','MODIFIER_PLAYER_UNIT_ADJUST_BYPASS_WALLS_PROMOTION_CLASS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_ENABLE_WALL_ATTACK_MONK', 'PromotionClass', 'PROMOTION_CLASS_MONK'),
    ('BBG_BYPASS_WALLS_MONK', 'PromotionClass', 'PROMOTION_CLASS_MONK');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS','BBG_ENABLE_WALL_ATTACK_MONK'),
    ('ABILITY_BYPASS_WALLS_PROMOTION_CLASS','BBG_BYPASS_WALLS_MONK');
-- Monks: Added Great General +5 CS/ +1 MS
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_MONK', 'REQUIREMENT_UNIT_TAG_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name , Value) VALUES
    ('BBG_REQUIRES_MONK', 'Tag', 'CLASS_WARRIOR_MONK');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('AOE_CLASSICAL_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
    ('AOE_MEDIEVAL_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
    ('AOE_RENAISSANCE_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
    ('AOE_INDUSTRIAL_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
    ('AOE_MODERN_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
    ('AOE_ATOMIC_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
    ('AOE_INFORMATION_REQUIREMENTS', 'BBG_REQUIRES_MONK');

-- Monks: Added Abilities from General Retire
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_GEORGY_ZHUKOV_FLANKING_BONUS', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_VIJAYA_WIMALARATNE_BONUS_EXPERIENCE', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_JOHN_MONASH_BONUS_EXPERIENCE','CLASS_WARRIOR_MONK'),
    ('ABILITY_TIMUR_BONUS_EXPERIENCE', 'CLASS_WARRIOR_MONK');

--Monks: All civs CS/MS interractions:
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_BARRACKS_TRAINED_UNIT_XP','CLASS_WARRIOR_MONK'),
    ('ABILITY_ARMORY_TRAINED_UNIT_XP', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_MILITARY_ACADEMY_TRAINED_UNIT_XP','CLASS_WARRIOR_MONK'),
    ('ABILITY_GREAT_LIGHTHOUSE_EMBARKED_MOVEMENT', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_COMMUNISM_DEFENSE_BUFF', 'CLASS_WARRIOR_MONK');

-- Monks: Affected by Battlecry
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_OPPONENT_IS_MONK','REQUIREMENT_OPPONENT_UNIT_PROMOTION_CLASS_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_OPPONENT_IS_MONK','UnitPromotionClass','PROMOTION_CLASS_MONK');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES 
    ('BATTLECRY_OPPONENT_REQUIREMENTS', 'BBG_OPPONENT_IS_MONK');

-- Monks: Civ Combat Bonus Interractions
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_HOJO_TOKIMUNE_COASTAL_COMBAT_BONUS', 'CLASS_WARRIOR_MONK'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_PHILIP_II_COMBAT_BONUS_OTHER_RELIGION', 'CLASS_WARRIOR_MONK');

-- Monks: Rework
--Changes the way monk binds. This way it is the same mechanism as other follower beliefs and not a one time exception by Firaxis
--Necessary for Kotoku
UPDATE Modifiers SET ModifierType = 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', SubjectRequirementSetId = 'CITY_FOLLOWS_RELIGION_REQUIREMENTS' WHERE ModifierId = 'ALLOW_WARRIOR_MONKS';

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_PLAYER_ALLOW_MONKS_IN_CITY', 'MODIFIER_CITY_ENABLE_UNIT_FAITH_PURCHASE');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_PLAYER_ALLOW_MONKS_IN_CITY', 'Tag', 'CLASS_WARRIOR_MONK');

UPDATE ModifierArguments SET Name = 'ModifierId', Value = 'BBG_PLAYER_ALLOW_MONKS_IN_CITY' WHERE ModifierId = 'ALLOW_WARRIOR_MONKS';

-- Monks: Defines Scaling Combat Strength with Civics, Capped at the End of Industrial Civis
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_IS_MONK_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_IS_MONK_REQUIREMENTS', 'BBG_REQUIRES_MONK');

INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'BBG_PLAYER_HAS_' || Civics.CivicType || '_REQUIREMENT' , 'REQUIREMENT_PLAYER_HAS_CIVIC'
    FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'BBG_PLAYER_HAS_' || Civics.CivicType || '_REQUIREMENT', 'CivicType', Civics.CivicType
    FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'BBG_PLAYER_HAS_' || Civics.CivicType || '_REQSET', 'REQUIREMENTSET_TEST_ALL'
    FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'BBG_PLAYER_HAS_' || Civics.CivicType || '_REQSET', 'BBG_PLAYER_HAS_' || Civics.CivicType || '_REQUIREMENT'
    FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
    SELECT 'BBG_MODIFIER_MONKS_CS_' || Civics.CivicType , 'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH', 'BBG_PLAYER_HAS_' || Civics.CivicType || '_REQSET'
    FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'BBG_MODIFIER_MONKS_CS_'|| Civics.CivicType , 'Amount', '1'
    FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

--DELETE UNIQUE TEMPLES requirements
DELETE FROM Unit_BuildingPrereqs
    WHERE Unit = 'UNIT_WARRIOR_MONK' AND PrereqBuilding = 'BUILDING_STAVE_CHURCH';

--Relax Requirement to SHRINE
UPDATE Unit_BuildingPrereqs SET PrereqBuilding = 'BUILDING_SHRINE' WHERE Unit = 'UNIT_WARRIOR_MONK' AND PrereqBuilding = 'BUILDING_TEMPLE';

--Reduce Base Cost and Strength, SET Scaling Cost to match closely non-unique units
--with the same CS across eras up to Industrial, Monk then stops scaling and Cost doesn't justify the str.
--Becomes Obsolete in Modern due to str/price. Still should kick ass in Industrial esp with tier II promo.
--Around Shrines Religion Timing should be around sword in strength
UPDATE Units SET Combat = '28' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET Cost = '60' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET CostProgressionModel = 'COST_PROGRESSION_GAME_PROGRESS' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET CostProgressionParam1 = '1000' WHERE UnitType = 'UNIT_WARRIOR_MONK';

--Next line makes monk purchase with kotoku possible to be unlocked if kotoku has a correct modifier
UPDATE Units SET PurchaseYield = NULL, MustPurchase = '1', EnabledByReligion ='0' WHERE UnitType = 'UNIT_WARRIOR_MONK';

--Disables Monk +10 congress interraction. Allows Kotoku city to receive 4 monks and recruit monks, even if city doesn't have a religion
UPDATE Units SET TrackReligion = '0' WHERE UnitType = 'UNIT_WARRIOR_MONK';
--Nerf Tier 2 promo Exploding Palms from +10 down to +5 to stay more in line with mele units
UPDATE ModifierArguments SET Value = '5' WHERE ModifierId = 'EXPLODING_PALMS_INCREASED_COMBAT_STRENGTH';
--Nerf Tier 4 promo Cobra Strike +15 down to +7 to be more in line with other promos
UPDATE ModifierArguments SET Value = '7' WHERE ModifierId = 'COBRA_STRIKE_INCREASED_COMBAT_STRENGTH';
--Deleting Monk Spread from sql (doesn't work since disabling TrackReligion), adding Basil-like spread in Lua
DELETE FROM UnitPromotionModifiers WHERE UnitPromotionType = 'PROMOTION_MONK_DISCIPLES';

--Add Unique Ability Icon and description to Monk's Scaling Ability in Unit Preview
--Modifiers Themself are added through civic tree as monk is not unique to a given player.
INSERT INTO Types(Type, Kind) VALUES
    ('BBG_ABILITY_MONK_SCALING', 'KIND_ABILITY');
    
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_ABILITY_MONK_SCALING', 'CLASS_WARRIOR_MONK');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_MONK_SCALING', 'LOC_BBG_ABILITY_MONK_SCALING_NAME', 'LOC_BBG_ABILITY_MONK_SCALING_DESCRIPTION');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId)
    SELECT 'BBG_ABILITY_MONK_SCALING', 'BBG_MODIFIER_MONKS_CS_'|| Civics.CivicType
    FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

-- Nerf Inquisitors
-- UPDATE Units SET ReligionEvictPercent=50, SpreadCharges=2 WHERE UnitType='UNIT_INQUISITOR';
-- Religious spread from trade routes increased
UPDATE GlobalParameters SET Value='2.0' WHERE Name='RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_DESTINATION';
UPDATE GlobalParameters SET Value='1.0' WHERE Name='RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_ORIGIN'     ;
-- Divine Inspiration yield increased
UPDATE ModifierArguments SET Value='6' WHERE ModifierId='DIVINE_INSPIRATION_WONDER_FAITH_MODIFIER' AND Name='Amount';
-- Lay Ministry now +2 Culture and +2 Faith per Theater and Holy Site
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='LAY_MINISTRY_CULTURE_DISTRICTS_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='LAY_MINISTRY_FAITH_DISTRICTS_MODIFIER' AND Name='Amount';
-- Itinerant Preachers now causes a Religion to spread 40% father away instead of only 30%
-- UPDATE ModifierArguments SET Value='4' WHERE ModifierId='ITINERANT_PREACHERS_SPREAD_DISTANCE';
-- Cross-Cultural Dialogue is now +1 Science for every 3 foreign followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='CROSS_CULTURAL_DIALOGUE_SCIENCE_FOREIGN_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- Tithe is now +1 Gold for every 3 followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TITHE_GOLD_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- World Church is now +1 Culture for every 3 foreign followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='WORLD_CHURCH_CULTURE_FOREIGN_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- Zen Meditation now only requires 1 District to get the +1 Amentity
UPDATE RequirementArguments SET Value='1' WHERE RequirementId='REQUIRES_CITY_HAS_2_SPECIALTY_DISTRICTS' AND Name='Amount';

-- Religious Communities now gives +1 Housing to Holy Sites, like it does for Shines and Temples
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
    VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
    VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER' , 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_HOUSING');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING' , 'ModifierId' , 'RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO BeliefModifiers (BeliefType , ModifierId)
    VALUES ('BELIEF_RELIGIOUS_COMMUNITY' , 'RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIRES_CITY_FOLLOWS_RELIGION');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIRES_CITY_HAS_HOLY_SITE');

-- Warrior Monks +5 Combat Strength
-- 23/04/2021: Implemented by Firaxis
-- UPDATE Units SET Combat=40 WHERE UnitType='UNIT_WARRIOR_MONK';
-- Work Ethic now provides production equal to base yield for Shrine and Temple
DELETE From BeliefModifiers WHERE ModifierId='WORK_ETHIC_FOLLOWER_PRODUCTION';
INSERT OR IGNORE INTO Modifiers 
    (ModifierId                              , ModifierType                          , SubjectRequirementSetId)
    VALUES 
    ('WORK_ETHIC_SHRINE_PRODUCTION'          , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_SHRINE'),
    ('WORK_ETHIC_TEMPLE_PRODUCTION'          , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_TEMPLE'),
    ('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'MODIFIER_BUILDING_YIELD_CHANGE'      , null                              ),
    ('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'MODIFIER_BUILDING_YIELD_CHANGE'      , null                              );
INSERT OR IGNORE INTO ModifierArguments 
    (ModifierId                              , Name           , Value)
    VALUES 
    ('WORK_ETHIC_SHRINE_PRODUCTION'          , 'ModifierId'   , 'WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER'),
    ('WORK_ETHIC_TEMPLE_PRODUCTION'          , 'ModifierId'   , 'WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER'),
    ('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'BuildingType' , 'BUILDING_SHRINE'                      ),
    ('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'YieldType'    , 'YIELD_PRODUCTION'                     ),
    ('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'Amount'       , '2'                                    ),
    ('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'BuildingType' , 'BUILDING_TEMPLE'                      ),
    ('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'YieldType'    , 'YIELD_PRODUCTION'                     ),
    ('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'Amount'       , '4'                                    );
INSERT OR IGNORE INTO BeliefModifiers 
    (BeliefType          , ModifierId)
    VALUES 
    ('BELIEF_WORK_ETHIC' , 'WORK_ETHIC_TEMPLE_PRODUCTION'),
    ('BELIEF_WORK_ETHIC' , 'WORK_ETHIC_SHRINE_PRODUCTION');
-- Dar E Mehr provides +2 culture instead of faith from eras
DELETE FROM Building_YieldsPerEra WHERE BuildingType='BUILDING_DAR_E_MEHR';
INSERT OR IGNORE INTO Building_YieldChanges 
    (BuildingType          , YieldType       , YieldChange)
    VALUES 
    ('BUILDING_DAR_E_MEHR' , 'YIELD_CULTURE' , '2');
-- All worship building production costs reduced    

--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_CATHEDRAL'    ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_GURDWARA'     ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_MEETING_HOUSE';
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_MOSQUE'       ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_PAGODA'       ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_SYNAGOGUE'    ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_WAT'          ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_STUPA'        ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_DAR_E_MEHR'   ;
