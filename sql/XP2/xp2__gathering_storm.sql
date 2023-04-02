/*
--==============================================================
--******                  DIPLOMACY                       ******
--==============================================================
UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_DIPLOVICTORY';
UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_WORLD_IDEOLOGY';
UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_MIGRATION_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_GLOBAL_ENERGY_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_ESPIONAGE_PACT';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_HERITAGE_ORG';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_PUBLIC_WORKS';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_DEFORESTATION_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_MODERN' WHERE ResolutionType='WC_RES_ARMS_CONTROL';
DELETE FROM Resolutions WHERE ResolutionType='WC_RES_PUBLIC_RELATIONS';
*/  



--==============================================================
--******                  PANTHEONS                       ******
--==============================================================
-- no settler
DELETE FROM BeliefModifiers WHERE ModifierId='RELIGIOUS_SETTLEMENTS_SETTLER';
-- reeds and marshes works with all floodplains (see egypt for ReqArgs) and remains only 1 prod
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='LADY_OF_THE_REEDS_PRODUCTION2_MODIFIER' AND Name='Amount';
INSERT OR IGNORE INTO RequirementSetRequirements 
    (RequirementSetId, RequirementId)
    VALUES
    ('PLOT_HAS_REEDS_REQUIREMENTS', 'REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND'),
    ('PLOT_HAS_REEDS_REQUIREMENTS', 'REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS');

--==============================================================
--******                 RELIGIOUS                        ******
--==============================================================
--delete their new work ethic
DELETE From BeliefModifiers WHERE ModifierId='WORK_ETHIC_ADJACENCY_PRODUCTION_2';
-- nerf tithe
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TITHE_GOLD_CITY_MODIFIER' AND Name='Amount';
-- feed the world housing reduced
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='FEED_THE_WORLD_SHRINE_HOUSING_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='FEED_THE_WORLD_TEMPLE_HOUSING_MODIFIER' AND Name='Amount';
/*
--revert feed the world to pre-GS version
DELETE FROM BeliefModifiers WHERE BeliefType='BELIEF_FEED_THE_WORLD' AND ModifierID='FEED_THE_WORLD_SHRINE_HOUSING';
DELETE FROM BeliefModifiers WHERE BeliefType='BELIEF_FEED_THE_WORLD' AND ModifierID='FEED_THE_WORLD_TEMPLE_HOUSING';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='FEED_THE_WORLD_SHRINE_FOOD3' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='FEED_THE_WORLD_TEMPLE_FOOD3' AND Name='Amount';
UPDATE Beliefs SET Description='LOC_BELIEF_FEED_THE_WORLD_DESCRIPTION' WHERE BeliefType='BELIEF_FEED_THE_WORLD';
*/
-- revert work ethic back to ours
DELETE From BeliefModifiers WHERE ModifierId='WORK_ETHIC_ADJACENCY_PRODUCTION';
INSERT OR IGNORE INTO BeliefModifiers (BeliefType, ModifierId) VALUES
    ('BELIEF_WORK_ETHIC', 'WORK_ETHIC_TEMPLE_PRODUCTION'),
    ('BELIEF_WORK_ETHIC', 'WORK_ETHIC_SHRINE_PRODUCTION');
UPDATE Beliefs SET Description='LOC_BELIEF_WORK_ETHIC_DESCRIPTION' WHERE BeliefType='BELIEF_WORK_ETHIC';
-- Cross-Cultural Dialogue reverted
UPDATE BeliefModifiers SET ModifierID='CROSS_CULTURAL_DIALOGUE_SCIENCE_FOREIGN_FOLLOWER' WHERE BeliefType='BELIEF_CROSS_CULTURAL_DIALOGUE';
-- World Church reverted
UPDATE BeliefModifiers SET ModifierID='WORLD_CHURCH_CULTURE_FOREIGN_FOLLOWER' WHERE BeliefType='BELIEF_WORLD_CHURCH';
-- revert descriptions back to ours
UPDATE Beliefs SET Description='LOC_BELIEF_CROSS_CULTURAL_DIALOGUE_DESCRIPTION' WHERE BeliefType='BELIEF_CROSS_CULTURAL_DIALOGUE';
UPDATE Beliefs SET Description='LOC_BELIEF_WORLD_CHURCH_DESCRIPTION' WHERE BeliefType='BELIEF_WORLD_CHURCH';
UPDATE Beliefs SET Description='LOC_BELIEF_LAY_MINISTRY_DESCRIPTION' WHERE BeliefType='BELIEF_LAY_MINISTRY';

----------- HOLY WATER --------------
-- holy waters affects mili units instead of religious, and works in all converted city tiles
-- 2020-12-03 was previously affecting all districts

--5.1 Changed holly waters inconsistency so it follows the same logic as Defender/Crusade
UPDATE Modifiers SET ModifierType='MODIFIER_ALL_UNITS_ATTACH_MODIFIER' WHERE ModifierId='HOLY_WATERS_HEALING';
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_ADJUST_HEAL_PER_TURN' WHERE ModifierId='HOLY_WATERS_HEALING_MODIFIER';
--Cleaning UP Firaxis code
DELETE FROM RequirementSetRequirements WHERE RequirementSetId='HOLY_WATERS_HEALING_REQUIREMENTS';
DELETE FROM RequirementSetRequirements WHERE RequirementSetId='HOLY_WATERS_HEALING_MODIFIER_REQUIREMENTS';
UPDATE RequirementSets SET RequirementSetType='REQUIREMENTSET_TEST_ANY' WHERE RequirementSetId='HOLY_WATERS_HEALING_MODIFIER_REQUIREMENTS';
INSERT OR IGNORE INTO RequirementSetRequirements VALUES
    ('HOLY_WATERS_HEALING_REQUIREMENTS', 'BBG_REQUIRES_PLAYER_FOUNDED_RELIGION_OR_MVEMBA'),
    ('HOLY_WATERS_HEALING_REQUIREMENTS', 'BBG_REQUIRES_ANY_CITY_FOLLOWS_RELIGION'),
    ('HOLY_WATERS_HEALING_MODIFIER_REQUIREMENTS', 'REQUIRES_UNIT_NEAR_FRIENDLY_RELIGIOUS_CITY'),
    ('HOLY_WATERS_HEALING_MODIFIER_REQUIREMENTS', 'REQUIRES_UNIT_NEAR_ENEMY_RELIGIOUS_CITY');
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_ANY_CITY_FOLLOWS_RELIGION', 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_ANY_CITY_FOLLOWS_RELIGION', 'RequirementSetId', 'HOLY_WATERS_HEALING_MODIFIER_REQUIREMENTS');
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='HOLY_WATERS_HEALING_MODIFIER' AND Name='Amount';
UPDATE Modifiers Set SubjectRequirementSetId = NULL WHERE ModifierId = 'HOLY_WATERS_HEALING_MODIFIER';

--==============================================================
--******                START BIASES                      ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_PHOENICIA' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_MALI' AND TerrainType='TERRAIN_DESERT_HILLS';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_MALI' AND TerrainType='TERRAIN_DESERT';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_CANADA' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_CANADA' AND TerrainType='TERRAIN_TUNDRA';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_CANADA' AND TerrainType IN ('TERRAIN_SNOW_HILLS', 'TERRAIN_SNOW');
UPDATE StartBiasFeatures SET Tier=2 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS_PLAINS';
UPDATE StartBiasFeatures SET Tier=2 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS_GRASSLAND';
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_HUNGARY';
UPDATE StartBiasTerrains SET Tier=3 WHERE CivilizationType='CIVILIZATION_INCA' AND TerrainType='TERRAIN_GRASS_MOUNTAIN';
UPDATE StartBiasTerrains SET Tier=3 WHERE CivilizationType='CIVILIZATION_INCA' AND TerrainType='TERRAIN_PLAINS_MOUNTAIN';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_INCA' AND TerrainType IN ('TERRAIN_DESERT_MOUNTAIN', 'TERRAIN_TUNDRA_MOUNTAIN', 'TERRAIN_SNOW_MOUNTAIN');


--==============================================================
--******            D I S A S T E R S                     ******
--==============================================================

-- Revert exceptions
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_DUST_STORM_HABOOB';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_BLIZZARD_CRIPPLING';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_BLIZZARD_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_DUST_STORM_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_CATASTROPHIC';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_MEGACOLOSSAL';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_FLOOD_1000_YEAR';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_FLOOD_MAJOR';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_FLOOD_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_FOREST_FIRE';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_FOREST_FIRE_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_HURRICANE_CAT_5';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_JUNGLE_FIRE';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_JUNGLE_FIRE_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_KILIMANJARO_CATASTROPHIC';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_KILIMANJARO_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_TORNADO_OUTBREAK';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_VESUVIUS_MEGACOLOSSAL';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_VESUVIUS_TRIGGERED';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_VOLCANO_CATASTROPHIC';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_VOLCANO_MEGACOLOSSAL';
UPDATE RandomEvent_Damages Set Percentage=0 WHERE DamageType='UNIT_KILLED_CIVILIAN' AND RandomEventType='RANDOM_EVENT_VOLCANO_TRIGGERED';



--==============================================================
--******                    O T H E R                     ******
--==============================================================
UPDATE GlobalParameters SET Value='-2' WHERE Name='FAVOR_PER_OWNED_ORIGINAL_CAPITAL';
-- oil available on all floodplains
INSERT OR IGNORE INTO Resource_ValidFeatures (ResourceType, FeatureType)
    VALUES
    ('RESOURCE_OIL', 'FEATURE_FLOODPLAINS_GRASSLAND'),
    ('RESOURCE_OIL', 'FEATURE_FLOODPLAINS_PLAINS');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES
    ('NITER_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_NITER_CPLMOD'),
    ('COAL_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_COAL_CPLMOD'),
    ('ALUMINUM_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_ALUMINUM_CPLMOD'),
    ('OIL_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_OIL_CPLMOD'),
    ('URANIUM_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_URANIUM_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
    ('NITER_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_NITER'),
    ('NITER_BASE_AMOUNT_MODIFIER', 'Amount', '1'),
    ('COAL_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_COAL'),
    ('COAL_BASE_AMOUNT_MODIFIER', 'Amount', '1'),
    ('ALUMINUM_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_ALUMINUM'),
    ('ALUMINUM_BASE_AMOUNT_MODIFIER', 'Amount', '1'),
    ('OIL_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_OIL'),
    ('OIL_BASE_AMOUNT_MODIFIER', 'Amount', '1'),
    ('URANIUM_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_URANIUM'),
    ('URANIUM_BASE_AMOUNT_MODIFIER', 'Amount', '1');
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
    VALUES
    ('TRAIT_LEADER_MAJOR_CIV', 'NITER_BASE_AMOUNT_MODIFIER'),
    ('TRAIT_LEADER_MAJOR_CIV', 'COAL_BASE_AMOUNT_MODIFIER'),
    ('TRAIT_LEADER_MAJOR_CIV', 'ALUMINUM_BASE_AMOUNT_MODIFIER'),
    ('TRAIT_LEADER_MAJOR_CIV', 'OIL_BASE_AMOUNT_MODIFIER'),
    ('TRAIT_LEADER_MAJOR_CIV', 'URANIUM_BASE_AMOUNT_MODIFIER');
--can't go minus favor from grievances
UPDATE GlobalParameters SET Value='0' WHERE Name='FAVOR_GRIEVANCES_MINIMUM';
-- additional niter spawn locations
INSERT OR IGNORE INTO Resource_ValidFeatures (ResourceType, FeatureType)
    VALUES ('RESOURCE_NITER', 'FEATURE_FLOODPLAINS');

-- GATHERING STORM WAR GOSSIP --
DELETE FROM Gossips WHERE GossipType='GOSSIP_MAKE_DOW';

-- Offshore Oil can be improved at Refining
UPDATE Improvements SET PrereqTech='TECH_REFINING' WHERE ImprovementType='IMPROVEMENT_OFFSHORE_OIL_RIG';


--==============================================================
--******                   N U K E S                      ******
--==============================================================

-- 14/07/2022 Nuke +50% production cost. uranium cost x1.5
UPDATE Projects SET Cost=1500 WHERE ProjectType='PROJECT_MANHATTAN_PROJECT';
UPDATE Projects SET Cost=1500 WHERE ProjectType='PROJECT_OPERATION_IVY';
UPDATE Projects SET Cost=1200 WHERE ProjectType='PROJECT_BUILD_NUCLEAR_DEVICE';
UPDATE Projects SET Cost=1500 WHERE ProjectType='PROJECT_BUILD_THERMONUCLEAR_DEVICE';
UPDATE Project_ResourceCosts SET StartProductionCost=15 WHERE ProjectType='PROJECT_BUILD_NUCLEAR_DEVICE';
UPDATE Project_ResourceCosts SET StartProductionCost=30 WHERE ProjectType='PROJECT_BUILD_THERMONUCLEAR_DEVICE';

--=======================================================================
--******               Wonder+Terrain/Feature                      ******
--=======================================================================
--geothermal wonder amenity interraction with bath and aqueduct:
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType)
    SELECT 'REQ_PLOT_ADJACENT_TO_'||WonderTerrainFeature_BBG.WonderType||'_BBG', 'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES'
    FROM WonderTerrainFeature_BBG WHERE FeatureType ='FEATURE_GEOTHERMAL_FISSURE';
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_PLOT_ADJACENT_TO_'||WonderTerrainFeature_BBG.WonderType||'_BBG', 'FeatureType', WonderTerrainFeature_BBG.WonderType
    FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_GEOTHERMAL_FISSURE';
INSERT INTO RequirementSets VALUES
    ('REQSET_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements 
    SELECT 'REQSET_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG', 'REQ_PLOT_ADJACENT_TO_'||WonderTerrainFeature_BBG.WonderType||'_BBG'
    FROM WonderTerrainFeature_BBG WHERE FeatureType ='FEATURE_GEOTHERMAL_FISSURE';
INSERT INTO RequirementSetRequirements VALUES
    ('REQSET_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG', 'PLOT_ADJACENT_TO_GEOTHERMAL_FISSURE_REQUIREMENT');
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQ_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG', 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQ_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG', 'RequirementSetId', 'REQSET_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG');
UPDATE RequirementSetRequirements SET RequirementId = 'REQ_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG' 
    WHERE RequirementId = 'PLOT_ADJACENT_TO_GEOTHERMAL_FISSURE_REQUIREMENT' AND RequirementSetId<>'REQSET_PLOT_ADJACENT_TO_GEOTHERMAL_FEATURE_TYPE_BBG';
--geothermal wonder hungary bath amenity interraction
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'REQ_CITY_HAS_1_OR_MORE_'||WonderTerrainFeature_BBG.WonderType||'_BBG', 'REQUIREMENT_CITY_HAS_X_FEATURE_TYPE'
    FROM WonderTerrainFeature_BBG WHERE FeatureType ='FEATURE_GEOTHERMAL_FISSURE';
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_CITY_HAS_1_OR_MORE_'||WonderTerrainFeature_BBG.WonderType||'_BBG', 'FeatureType', WonderTerrainFeature_BBG.WonderType
    FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_GEOTHERMAL_FISSURE';
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_CITY_HAS_1_OR_MORE_'||WonderTerrainFeature_BBG.WonderType||'_BBG', 'Amount', 1
    FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_GEOTHERMAL_FISSURE';
UPDATE RequirementSets SET RequirementSetType = 'REQUIREMENTSET_TEST_ANY' WHERE RequirementSetId = 'CITY_HAS_1_OR_MORE_GEOTHERMALFISSURE_REQUIREMENTS';
INSERT INTO RequirementSetRequirements
    SELECT 'CITY_HAS_1_OR_MORE_GEOTHERMALFISSURE_REQUIREMENTS','REQ_CITY_HAS_1_OR_MORE_'||WonderTerrainFeature_BBG.WonderType||'_BBG'
    FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_GEOTHERMAL_FISSURE';
--Etemenanki Marsh Wonder
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType)
    SELECT 'REQ_'||WonderTerrainFeature_BBG.WonderType||'_BBG', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES'
    FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_MARSH';
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_'||WonderTerrainFeature_BBG.WonderType||'_BBG', 'FeatureType', WonderTerrainFeature_BBG.WonderType
    FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_MARSH';
INSERT INTO RequirementSets VALUES
    ('REQSET_PLOT_IS_MARSH_OR_MARSH_WONDER_BBG', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements
    SELECT 'REQSET_PLOT_IS_MARSH_OR_MARSH_WONDER_BBG', 'REQ_'||WonderTerrainFeature_BBG.WonderType||'_BBG'
    FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_MARSH';
INSERT INTO RequirementSetRequirements VALUES
    ('REQSET_PLOT_IS_MARSH_OR_MARSH_WONDER_BBG', 'REQUIRES_PLOT_HAS_MARSH');
UPDATE Modifiers SET SubjectRequirementSetId = 'REQSET_PLOT_IS_MARSH_OR_MARSH_WONDER_BBG' 
    WHERE ModifierId IN ('ETEMENANKI_SCIENCE_MARSH', 'ETEMENANKI_PRODUCTION_MARSH') AND SubjectRequirementSetId = 'PLOT_HAS_MARSH_REQUIREMENTS';
--Machu mountain wonder interraction 
CREATE TABLE MachuTemp(
    ModifierId TEXT NOT NULL, 
    FeatureType TEXT NOT NULL, 
    DistrictType TEXT NOT NULL
    );
INSERT INTO MachuTemp
    SELECT DISTINCT 'MACHUPICCU_'||Districts.DistrictType||'_'||WonderTerrainFeature_BBG.WonderType||'_BBG', WonderTerrainFeature_BBG.WonderType, Districts.DistrictType
    FROM WonderTerrainFeature_BBG LEFT JOIN Districts
    WHERE WonderTerrainFeature_BBG.TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN' AND Districts.DistrictType IN ('DISTRICT_COMMERCIAL_HUB', 'DISTRICT_INDUSTRIAL_ZONE', 'DISTRICT_THEATER');
INSERT INTO Modifiers(ModifierId, ModifierType)
    SELECT DISTINCT MachuTemp.ModifierId, 'MODIFIER_PLAYER_CITIES_FEATURE_ADJACENCY'
    FROM MachuTemp;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT DISTINCT MachuTemp.ModifierId, 'DistrictType', MachuTemp.DistrictType
    FROM MachuTemp;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT DISTINCT MachuTemp.ModifierId, 'FeatureType', MachuTemp.FeatureType
    FROM MachuTemp;
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value)
    SELECT DISTINCT MachuTemp.ModifierId, 'YieldType', 
    CASE 
        WHEN MachuTemp.DistrictType = 'DISTRICT_COMMERCIAL_HUB' THEN 'YIELD_GOLD'
        WHEN MachuTemp.DistrictType = 'DISTRICT_INDUSTRIAL_ZONE' THEN 'YIELD_PRODUCTION'
        WHEN MachuTemp.DistrictType = 'DISTRICT_THEATER' THEN 'YIELD_CULTURE'
    END
    FROM MachuTemp;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT DISTINCT MachuTemp.ModifierId, 'Amount', 1
    FROM MachuTemp;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT DISTINCT MachuTemp.ModifierId, 'Description', 
    CASE 
        WHEN MachuTemp.DistrictType = 'DISTRICT_COMMERCIAL_HUB' THEN 'LOC_BUILDING_MACHU_PICCHU_GOLD'
        WHEN MachuTemp.DistrictType = 'DISTRICT_INDUSTRIAL_ZONE' THEN 'LOC_BUILDING_MACHU_PICCHU_PRODUCTION'
        WHEN MachuTemp.DistrictType = 'DISTRICT_THEATER' THEN 'LOC_BUILDING_MACHU_PICCHU_CULTURE'
    END
    FROM MachuTemp;
INSERT INTO BuildingModifiers
    SELECT DISTINCT 'BUILDING_MACHU_PICCHU', MachuTemp.ModifierId
    FROM MachuTemp;
DROP TABLE MachuTemp;

--terrain/feature wonders
--adding campus adjacency to reef wonders
INSERT OR IGNORE INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentFeature)
    SELECT 
       'ReefWonder_Science'||(SELECT COUNT(*)
        FROM (SELECT WonderType AS t2 FROM WonderTerrainFeature_BBG  WHERE TerrainClassType = 'FEATURE_REEF')
        WHERE t2<= t1.WonderType), 'LOC_REEF_WONDER_SCIENCE', 'YIELD_SCIENCE', 2, 1, t1.WonderType
FROM WonderTerrainFeature_BBG AS t1
WHERE t1.FeatureType = 'FEATURE_REEF' AND t1.WonderType<>'FEATURE_BARRIER_REEF'
ORDER BY WonderType;
INSERT OR IGNORE INTO District_Adjacencies
    SELECT 
       'DISTRICT_CAMPUS', 'ReefWonder_Science'||(SELECT COUNT(*)
        FROM (SELECT WonderType AS t2 FROM WonderTerrainFeature_BBG  WHERE TerrainClassType = 'FEATURE_REEF')
        WHERE t2<= t1.WonderType)
FROM WonderTerrainFeature_BBG AS t1
WHERE t1.FeatureType = 'FEATURE_REEF' AND t1.WonderType<>'FEATURE_BARRIER_REEF'
ORDER BY WonderType;
--adding reef wonders defense modifier
UPDATE OR IGNORE Features SET DefenseModifier = 3
    WHERE FeatureType IN (SELECT WonderType FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_REEF');

