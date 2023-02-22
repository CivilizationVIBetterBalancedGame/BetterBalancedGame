--==============================================================
--******            C I V I L I Z A T I O N S             ******
--==============================================================
--==================
-- America
--==================
-- Reduce combat strength of mustangs to match Fighter due to them already having many extra combat bonuses over biplanes
UPDATE Units SET Combat=95, RangedCombat=95 WHERE UnitType='UNIT_AMERICAN_P51';
-- rough rider is a cav replacement, so should cost horses
INSERT OR IGNORE INTO Units_XP2 (UnitType, ResourceCost)
    VALUES ('UNIT_AMERICAN_ROUGH_RIDER', 10);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_AMERICAN_ROUGH_RIDER';

DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_AMERICA' AND TerrainType IN ('TERRAIN_DESERT_MOUNTAIN', 'TERRAIN_TUNDRA_MOUNTAIN');
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_AMERICA' AND TerrainType IN ('TERRAIN_GRASS_MOUNTAIN', 'TERRAIN_PLAINS_MOUNTAIN');

--==================
-- Arabia
--==================
-- Implemented by Firaxis
-- UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CUIRASSIER' WHERE Unit='UNIT_ARABIAN_MAMLUK';


--==================
-- Canada
--==================
-- INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
--  VALUES
--  ('TRAIT_LEADER_LAST_BEST_WEST', 'TUNDRA_EXTRA_FOOD_CPLMOD'           ),
--  ('TRAIT_LEADER_LAST_BEST_WEST', 'TUNDRA_HILLS_EXTRA_FOOD_CPLMOD'     ),
--  ('TRAIT_LEADER_LAST_BEST_WEST', 'NATIONAL_PARK_FOOD_YIELDS_CPLMOD'   ),
--  ('TRAIT_LEADER_LAST_BEST_WEST', 'NATIONAL_PARK_PROD_YIELDS_CPLMOD'   );
--INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, OwnerRequirementSetId)
--  VALUES
--  ('TUNDRA_EXTRA_FOOD_CPLMOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_TUNDRA_REQUIREMENTS', NULL),
--  ('TUNDRA_HILLS_EXTRA_FOOD_CPLMOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_TUNDRA_HILLS_REQUIREMENTS', NULL),
--  ('NATIONAL_PARK_FOOD_YIELDS_CPLMOD', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'CITY_HAS_NATIONAL_PARK_REQUREMENTS', NULL),
--  ('NATIONAL_PARK_PROD_YIELDS_CPLMOD', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'CITY_HAS_NATIONAL_PARK_REQUREMENTS', NULL);
--INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
--  VALUES
--  ('TUNDRA_EXTRA_FOOD_CPLMOD', 'YieldType', 'YIELD_FOOD'      ),
--  ('TUNDRA_EXTRA_FOOD_CPLMOD', 'Amount', '1'               ),
--  ('TUNDRA_HILLS_EXTRA_FOOD_CPLMOD', 'YieldType', 'YIELD_FOOD'      ),
--  ('TUNDRA_HILLS_EXTRA_FOOD_CPLMOD', 'Amount', '1'               ),
--  ('NATIONAL_PARK_FOOD_YIELDS_CPLMOD', 'YieldType', 'YIELD_FOOD'      ),
--  ('NATIONAL_PARK_FOOD_YIELDS_CPLMOD', 'Amount', '4'               ),
--  ('NATIONAL_PARK_PROD_YIELDS_CPLMOD', 'YieldType', 'YIELD_PRODUCTION'),
--  ('NATIONAL_PARK_PROD_YIELDS_CPLMOD', 'Amount', '4'               );
-- 15/05/2021 : Canada +1 food per city center
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_TOUNDRA_CITY_EXTRA_FOOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_IS_TUNDRA_CITY_REQUIREMENTS'),
    ('BBG_TOUNDRA_HILLS_CITY_EXTRA_FOOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_IS_TUNDRA_HILL_CITY_REQUIREMENTS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_TOUNDRA_CITY_EXTRA_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('BBG_TOUNDRA_CITY_EXTRA_FOOD', 'Amount', '1'),
    ('BBG_TOUNDRA_HILLS_CITY_EXTRA_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('BBG_TOUNDRA_HILLS_CITY_EXTRA_FOOD', 'Amount', '1');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('PLOT_IS_TUNDRA_CITY_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'),
    ('PLOT_IS_TUNDRA_HILL_CITY_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('PLOT_IS_TUNDRA_CITY_REQUIREMENTS', 'REQUIRES_PLOT_HAS_TUNDRA'),
    ('PLOT_IS_TUNDRA_CITY_REQUIREMENTS', 'BBG_REQUIRES_PLOT_IS_CITY_CENTER'),
    ('PLOT_IS_TUNDRA_HILL_CITY_REQUIREMENTS', 'REQUIRES_PLOT_HAS_TUNDRA_HILLS'),
    ('PLOT_IS_TUNDRA_HILL_CITY_REQUIREMENTS', 'BBG_REQUIRES_PLOT_IS_CITY_CENTER');
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_IS_CITY_CENTER', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_IS_CITY_CENTER', 'DistrictType', 'DISTRICT_CITY_CENTER');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_LAST_BEST_WEST', 'BBG_TOUNDRA_CITY_EXTRA_FOOD'),
    ('TRAIT_LEADER_LAST_BEST_WEST', 'BBG_TOUNDRA_HILLS_CITY_EXTRA_FOOD');

-- Hockey rink at Civil Service
UPDATE Improvements SET PrereqCivic='CIVIC_DIPLOMATIC_SERVICE' WHERE ImprovementType='IMPROVEMENT_ICE_HOCKEY_RINK';
-- Mounties get a base combat buff and combat buff from nearby parks radius increased
UPDATE Units SET Combat=70, Cost=360 WHERE UnitType='UNIT_CANADA_MOUNTIE';
UPDATE RequirementArguments SET Value='4' WHERE RequirementId='UNIT_PARK_REQUIREMENT'       AND Name='MaxDistance';
UPDATE RequirementArguments SET Value='4' WHERE RequirementId='UNIT_OWNER_PARK_REQUIREMENT' AND Name='MaxDistance';



--==========
-- EGYPT
--==========
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
    VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND', 'FeatureType', 'FEATURE_FLOODPLAINS_GRASSLAND');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
    VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS', 'FeatureType', 'FEATURE_FLOODPLAINS_PLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS');



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

--==========
-- FRANCE
--==========
UPDATE Units_XP2 SET ResourceCost=10 WHERE UnitType='UNIT_FRENCH_GARDE_IMPERIALE';



--==================
-- Kongo
--==================
UPDATE Units_XP2 SET ResourceCost=10 WHERE UnitType='UNIT_KONGO_SHIELD_BEARER';



--==================
-- Ottoman
--==================



--==================
-- Persia
--==================
--14/07/2022: Reverted
--03/10/2022: to 15
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_PERSIAN_IMMORTAL';



--==================
-- Rome
--==================
--14/07/2022: Reverted
--03/10/2022: to 15
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_ROMAN_LEGION';


--==================
-- Scythia
--==================
-- Scythian horse cost 5 online speed
INSERT INTO Units_XP2(UnitType, ResourceCost) VALUES
    ('UNIT_SCYTHIAN_HORSE_ARCHER', 10);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_SCYTHIAN_HORSE_ARCHER';

--==================
-- Sweden
--==================
-- open air museum moved to diplo service
UPDATE Improvements SET PrereqCivic='CIVIC_DIPLOMATIC_SERVICE' WHERE ImprovementType='IMPROVEMENT_OPEN_AIR_MUSEUM';
-- +50% prod towards libraries, universities, workshops, and factories
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_NOBEL_PRIZE', 'NOBEL_PRIZE_UNIVERISTY_BOOST'),
    ('TRAIT_CIVILIZATION_NOBEL_PRIZE', 'NOBEL_PRIZE_LIBRARY_BOOST'),
    ('TRAIT_CIVILIZATION_NOBEL_PRIZE', 'NOBEL_PRIZE_WORKSHOP_BOOST'),
    ('TRAIT_CIVILIZATION_NOBEL_PRIZE', 'NOBEL_PRIZE_FACTORY_BOOST');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('NOBEL_PRIZE_LIBRARY_BOOST', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION'),
    ('NOBEL_PRIZE_UNIVERISTY_BOOST', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION'),
    ('NOBEL_PRIZE_WORKSHOP_BOOST', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION'),
    ('NOBEL_PRIZE_FACTORY_BOOST', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES 
    ('NOBEL_PRIZE_LIBRARY_BOOST', 'BuildingType', 'BUILDING_LIBRARY'),
    ('NOBEL_PRIZE_LIBRARY_BOOST', 'Amount', '50'),
    ('NOBEL_PRIZE_UNIVERISTY_BOOST', 'BuildingType', 'BUILDING_UNIVERSITY'),
    ('NOBEL_PRIZE_UNIVERISTY_BOOST', 'Amount', '50'),
    ('NOBEL_PRIZE_WORKSHOP_BOOST', 'BuildingType', 'BUILDING_WORKSHOP'),
    ('NOBEL_PRIZE_WORKSHOP_BOOST', 'Amount', '50'),
    ('NOBEL_PRIZE_FACTORY_BOOST', 'BuildingType', 'BUILDING_FACTORY'),
    ('NOBEL_PRIZE_FACTORY_BOOST', 'Amount', '50');

-- Queens Bibliotheque can be build with other t2 gouv
DELETE FROM MutuallyExclusiveBuildings WHERE Building='BUILDING_QUEENS_BIBLIOTHEQUE' OR MutuallyExclusiveBuilding='BUILDING_QUEENS_BIBLIOTHEQUE';

-- 29/08/2021: +50% Production toward Gov plaza buildings
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_SWEDEN_GOV_BUILDINGS_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_SWEDEN_GOV_BUILDINGS_PRODUCTION', 'DistrictType', 'DISTRICT_GOVERNMENT'),
    ('BBG_SWEDEN_GOV_BUILDINGS_PRODUCTION', 'Amount', '50');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_NOBEL_PRIZE', 'BBG_SWEDEN_GOV_BUILDINGS_PRODUCTION');

--==============================================================
--******                  BUILDINGS                       ******
--==============================================================
-- flood barriers unlocked at steam power
UPDATE Buildings SET PrereqTech='TECH_STEAM_POWER' WHERE BuildingType='BUILDING_FLOOD_BARRIER';
-- +1 niter from armories
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_ARMORY', 'NITER_FROM_ARMORY_BBG');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('NITER_FROM_ARMORY_BBG', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_NITER_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('NITER_FROM_ARMORY_BBG', 'ResourceType', 'RESOURCE_NITER'),
    ('NITER_FROM_ARMORY_BBG', 'Amount', '1');
-- +2 oil from mil acadamies
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_MILITARY_ACADEMY', 'OIL_FROM_MIL_ACAD_BBG');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('OIL_FROM_MIL_ACAD_BBG', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_OIL_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('OIL_FROM_MIL_ACAD_BBG', 'ResourceType', 'RESOURCE_OIL'),
    ('OIL_FROM_MIL_ACAD_BBG', 'Amount', '2');
-- +1 coal from shipyard
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_SHIPYARD', 'COAL_FROM_SHIPYARD_BBG');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('COAL_FROM_SHIPYARD_BBG', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_COAL_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('COAL_FROM_SHIPYARD_BBG', 'ResourceType', 'RESOURCE_COAL'),
    ('COAL_FROM_SHIPYARD_BBG', 'Amount', '1');
-- +2 alum from airports
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_AIRPORT', 'ALUM_FROM_AIRPORT_BBG');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('ALUM_FROM_AIRPORT_BBG', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_ALUMINUM_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('ALUM_FROM_AIRPORT_BBG', 'ResourceType', 'RESOURCE_ALUMINUM'),
    ('ALUM_FROM_AIRPORT_BBG', 'Amount', '2');
UPDATE Building_YieldChanges SET YieldChange=6 WHERE BuildingType='BUILDING_FOSSIL_FUEL_POWER_PLANT' AND YieldType='YIELD_PRODUCTION';
UPDATE Building_YieldChanges SET YieldChange=8 WHERE BuildingType='BUILDING_POWER_PLANT' AND YieldType='YIELD_PRODUCTION';
UPDATE Building_YieldChanges SET YieldChange=6 WHERE BuildingType='BUILDING_POWER_PLANT' AND YieldType='YIELD_SCIENCE';

--==============================================================
--*****                  WONDERS(Built)                   ******
--==============================================================
-- Golden Gate Bridge: Fixed Bug, where one side of the Bridge is impassible
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'BuildingType', 'BUILDING_GOLDEN_GATE_BRIDGE'),
    ('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'MinRange', '0'),
    ('BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE', 'MaxRange', '1');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_GOLDENGATE_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_GOLDENGATE_REQSET', 'BBG_REQUIRES_PLOT_IS_ADJACENT_TO_GOLDENGATE'),
    ('BBG_GOLDENGATE_REQSET', 'AOE_REQUIRES_LAND_DOMAIN');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_GOLDENGATE_IGNORE_CLIFF', 'MODIFIER_ALL_UNITS_ATTACH_MODIFIER', 'BBG_GOLDENGATE_REQSET');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GOLDENGATE_IGNORE_CLIFF', 'ModifierId', 'COMMANDO_BONUS_IGNORE_CLIFF_WALLS');

INSERT INTO GameModifiers(ModifierId) VALUES ('BBG_GOLDENGATE_IGNORE_CLIFF');

INSERT INTO CustomPlacement(ObjectType, Hash, PlacementFunction)
    SELECT Types.Type, Types.Hash, 'BBG_PANAMA_CANAL_CUSTOM_PLACEMENT'
    FROM Types WHERE Type = 'BUILDING_PANAMA_CANAL';

--==============================================================
--******                 CITY_STATES                      ******
--==============================================================
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='MINOR_CIV_FEZ_INITIATION_SCIENCE_POPULATION' AND Name='Amount';


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

-- Monks: Cards/Governments
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_GLOBAL_COALITION_FRIENDLY_TERRITORY', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_DIGITAL_DEMOCRACY_DEBUFF', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_FINEST_HOUR_FRIENDLY_TERRITORY', 'CLASS_WARRIOR_MONK');
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
--******            W O N D E R S  (NATURAL)              ******
--==============================================================
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_SCIENCE';
UPDATE Features Set Description='LOC_FEATURE_EYE_OF_THE_SAHARA_DESCRIPTION' WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA';
UPDATE Feature_YieldChanges SET YieldChange='4' WHERE FeatureType='FEATURE_GOBUSTAN'       AND YieldType='YIELD_CULTURE'   ;
UPDATE Feature_YieldChanges SET YieldChange='4' WHERE FeatureType='FEATURE_GOBUSTAN'       AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange='2' WHERE FeatureType='FEATURE_WHITEDESERT'    AND YieldType='YIELD_CULTURE'   ;
UPDATE Feature_YieldChanges SET YieldChange='2' WHERE FeatureType='FEATURE_WHITEDESERT'    AND YieldType='YIELD_SCIENCE'   ;
UPDATE Feature_YieldChanges SET YieldChange='6' WHERE FeatureType='FEATURE_WHITEDESERT'    AND YieldType='YIELD_GOLD'      ;
UPDATE Feature_YieldChanges SET YieldChange='3' WHERE FeatureType='FEATURE_CHOCOLATEHILLS' AND YieldType='YIELD_FOOD'      ;
UPDATE Feature_YieldChanges SET YieldChange='3' WHERE FeatureType='FEATURE_CHOCOLATEHILLS' AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange='1' WHERE FeatureType='FEATURE_CHOCOLATEHILLS' AND YieldType='YIELD_SCIENCE'   ;
UPDATE Feature_AdjacentYields SET YieldChange='2' WHERE FeatureType='FEATURE_DEVILSTOWER' AND YieldType='YIELD_FAITH';

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
-- fascism attack bonus working for GDR
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES ('ABILITY_FASCISM_ATTACK_BUFF', 'CLASS_GIANT_DEATH_ROBOT');
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES ('ABILITY_FASCISM_LEGACY_ATTACK_BUFF', 'CLASS_GIANT_DEATH_ROBOT');
-- statue of liberty text fix
UPDATE Buildings SET Description='LOC_BUILDING_STATUE_LIBERTY_EXPANSION2_DESCRIPTION' WHERE BuildingType='BUILDING_STATUE_LIBERTY';
-- oil available on all floodplains
INSERT OR IGNORE INTO Resource_ValidFeatures (ResourceType, FeatureType)
    VALUES
    ('RESOURCE_OIL', 'FEATURE_FLOODPLAINS_GRASSLAND'),
    ('RESOURCE_OIL', 'FEATURE_FLOODPLAINS_PLAINS');
-- retinues policy card is 50% of resource cost for produced and upgrade units
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
    VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_MODIFIER_CPLMOD', 'MODIFIER_CITY_ADJUST_STRATEGIC_RESOURCE_REQUIREMENT_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_MODIFIER_CPLMOD', 'Amount', '50');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
    VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD', 'ModifierId', 'PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_MODIFIER_CPLMOD');
INSERT OR IGNORE INTO PolicyModifiers (PolicyType, ModifierId)
    VALUES
    ('POLICY_RETINUES', 'PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD'),
    ('POLICY_FORCE_MODERNIZATION', 'PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD');
-- get +1 resource when revealed (niter and above only)
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

-- citizen yields
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' AND DistrictType='DISTRICT_COTHON';
UPDATE District_CitizenYieldChanges SET YieldChange=4 WHERE YieldType='YIELD_GOLD' AND DistrictType='DISTRICT_SUGUBA';

-- GATHERING STORM WAR GOSSIP --
DELETE FROM Gossips WHERE GossipType='GOSSIP_MAKE_DOW';

-- Offshore Oil can be improved at Refining
UPDATE Improvements SET PrereqTech='TECH_REFINING' WHERE ImprovementType='IMPROVEMENT_OFFSHORE_OIL_RIG';


--==============================================================
--******                C O N G R E S S                   ******
--==============================================================
DELETE FROM ModifierArguments WHERE ModifierId='APPLY_RES_UNIT_COMBAT_DEBUFF';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('APPLY_RES_UNIT_COMBAT_DEBUFF','ModifierId', 'WC_RES_UNIT_COMBAT_DEBUFF');

--==============================================================
--******                G O V E R N O R S                 ******
--==============================================================
--5.1.4 add free starting promo on monks, 2nd promo bugged in 5.1.3
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_UNIT_TYPE_IS_MONK', 'REQUIREMENT_UNIT_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_UNIT_TYPE_IS_MONK', 'UnitType', 'UNIT_WARRIOR_MONK');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_TYPE_IS_MONK_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_TYPE_IS_MONK_REQSET', 'BBG_REQUIRES_UNIT_TYPE_IS_MONK');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('MOKSHA_MONK_FREE_PROMO', 'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE', 'BBG_UNIT_TYPE_IS_MONK_REQSET');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('MOKSHA_MONK_FREE_PROMO', 'Amount', '-1');
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierID) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT', 'MOKSHA_MONK_FREE_PROMO');
-- delete moksha's scrapped abilities
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
-- 15% culture moved to moksha
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_BISHOP' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN' AND ModifierId='LIBRARIAN_CULTURE_YIELD_BONUS';
-- nerf bishop to +50% outgoing pressure
--UPDATE ModifierArguments SET Value='50' WHERE ModifierId='CARDINAL_BISHOP_PRESSURE' AND Name='Amount';
-- move Moksha's abilities
UPDATE GovernorPromotions SET Level=2, 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT';
UPDATE GovernorPromotions SET Level=1, 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
UPDATE GovernorPromotions SET Level=2, 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP');
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
-- Curator moved to last moksha ability
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT'),
        ('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT');
-- Move +1 Culture to Moksha
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP');
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT' AND PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';

-- 2020/12/21 - Moved Moska Citadel fix from new_bbg_nfp_babylon.sql here (was 25)
-- Related to https://github.com/iElden/BetterBalancedGame/issues/48
UPDATE ModifierArguments SET Value=24 WHERE ModifierId='CARDINAL_CITADEL_OF_GOD_FAITH_FINISH_BUILDINGS' AND Name='BuildingProductionPercent';


-- move Pingala's 100% GPP to first on left ability
UPDATE GovernorPromotions SET Level=1, 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS', 'GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN');
-- create Pingala's science from trade routes ability and apply to middle right ability
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
    VALUES
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'Domestic', '1'),
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'Amount', '3'),
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'YieldType', 'YIELD_SCIENCE');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion)
    VALUES
        ('GOVERNOR_THE_EDUCATOR', 'GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column', BaseAbility)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_DESCRIPTION', 2, 2, 0);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG');
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER'),
        ('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG');
-- Pingala's double adajacency Promo
-- 11/12/22 from x2 to x3
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'Amount', '200'),
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'YieldType', 'YIELD_SCIENCE');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES
        ('GOVERNOR_THE_EDUCATOR', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column', BaseAbility)
    VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_DESCRIPTION', 2, 0, 0);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'GOVERNOR_PROMOTION_EDUCATOR_GRANTS'),
        ('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG');

-- Amani's changed 1st right ability
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES
    ('HORSES_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_HORSES_CPLMOD'),
    ('IRON_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_IRON_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
    ('HORSES_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_HORSES'),
    ('HORSES_BASE_AMOUNT_MODIFIER', 'Amount', '1'),
    ('IRON_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_IRON'),
    ('IRON_BASE_AMOUNT_MODIFIER', 'Amount', '1');
INSERT OR IGNORE INTO GovernorPromotionModifiers VALUES
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'HORSES_BASE_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'IRON_BASE_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'NITER_BASE_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'COAL_BASE_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'ALUMINUM_BASE_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'OIL_BASE_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'URANIUM_BASE_AMOUNT_MODIFIER');
-- new 1st on left promo for Amani
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_AMBASSADOR', 'GOVERNOR_PROMOTION_NEGOTIATOR_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column')
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_NAME', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_DESCRIPTION', 1, 0);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH'),
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENSE_LOGISTICS_SIEGE_PROTECTION');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER');
-- move Amani's Emissary to 2nd on left
UPDATE GovernorPromotions SET Level=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER' WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_NEGOTIATOR_BBG' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
        ('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY', 'PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES');
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='EMISSARY_IDENTITY_PRESSURE_TO_FOREIGN_CITIES' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES' AND Name='Amount';
-- Delete Amani's Foreign Investor
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
-- Correct Amani's Spies promo
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
        ('GOVERNOR_PROMOTION_LOCAL_INFORMANTS', 'GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE');
UPDATE GovernorPromotions SET 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_LOCAL_INFORMANTS';


-- Reyna's new 3rd level right ability
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('MANAGER_BUILDING_GOLD_DISCOUNT_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_ALL_BUILDINGS_PURCHASE_COST'),
    ('MANAGER_DISTRICT_GOLD_DISCOUNT_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_ALL_DISTRICTS_PURCHASE_COST');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('MANAGER_BUILDING_GOLD_DISCOUNT_BBG', 'Amount', '50'),
    ('MANAGER_DISTRICT_GOLD_DISCOUNT_BBG', 'Amount', '50');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_MANAGER_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_MERCHANT', 'GOVERNOR_PROMOTION_MANAGER_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column')
    VALUES
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_NAME', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_DESCRIPTION', 3, 2);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'MANAGER_BUILDING_GOLD_DISCOUNT_BBG'),
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'MANAGER_DISTRICT_GOLD_DISCOUNT_BBG');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR');
-- Delete Reyna's old one
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
-- bump gold from base ability
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='FOREIGN_EXCHANGE_GOLD_FROM_FOREIGN_TRADE_PASSING_THROUGH' AND Name='Amount';
-- add +2 gold per breathtaking
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_BBG', 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_BBG', 'RequirementSetId', 'PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS');
INSERT OR IGNORE INTO RequirementSets VALUES
    ('PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG', 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements VALUES
    ('PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG', 'REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_BBG'),
    ('PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG', 'REQUIRES_PLOT_BREATHTAKING_APPEAL');
UPDATE Modifiers SET SubjectRequirementSetId='PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG' WHERE ModifierId='FORESTRY_MANAGEMENT_FEATURE_NO_IMPROVEMENT_GOLD';
-- +1 trade route
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TAX_COLLECTOR_ADJUST_TRADE_CAPACITY_BBG', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TAX_COLLECTOR_ADJUST_TRADE_CAPACITY_BBG', 'Amount', '1');
INSERT OR IGNORE INTO GovernorPromotionModifiers VALUES
    ('GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR', 'TAX_COLLECTOR_ADJUST_TRADE_CAPACITY_BBG');


-- Increase prod and power for Magnus Industrialist promo
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_COAL_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_OIL_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_NUCLEAR_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_RESOURCE_POWER_PROVIDED' AND Name='Amount';
-- Strategics required reduced to zero for Black Marketeer and swapped with Victor's Arms Race
UPDATE ModifierArguments SET Value='100' WHERE ModifierId='BLACK_MARKETEER_STRATEGIC_RESOURCE_COST_DISCOUNT' AND Name='Amount';
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_DEFENDER' WHERE GovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_RESOURCE_MANAGER' WHERE GovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EMBRASURE';
INSERT OR IGNORE INTO GovernorPromotionPrereqs ( GovernorPromotionType, PrereqGovernorPromotion ) VALUES
    ( 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST' ),
    ( 'GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST' ),
    ( 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS' ),
    ( 'GOVERNOR_PROMOTION_EMBRASURE', 'GOVERNOR_PROMOTION_GARRISON_COMMANDER' ),
    ( 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'GOVERNOR_PROMOTION_DEFENSE_LOGISTICS' ),
    ( 'GOVERNOR_PROMOTION_AIR_DEFENSE_INITIATIVE', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER' );
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EMBRASURE';
UPDATE GovernorPromotions SET 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AIR_DEFENSE_INITIATIVE';


-- Liang
-- +1 prod on every resource
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('ZONING_COMMISH_PROD_CITIZEN_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'ZONING_COMMISH_PROD_BBG_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments ( ModifierId, Name, Value ) VALUES
    ( 'ZONING_COMMISH_PROD_CITIZEN_BBG', 'Amount', '1' ),
    ( 'ZONING_COMMISH_PROD_CITIZEN_BBG', 'YieldType', 'YIELD_PRODUCTION' );
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('ZONING_COMMISH_PROD_BBG_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('ZONING_COMMISH_PROD_BBG_REQUIREMENTS', 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
UPDATE GovernorPromotionModifiers SET ModifierId='ZONING_COMMISH_PROD_CITIZEN_BBG' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER' AND ModifierId='ZONING_COMMISSIONER_FASTER_DISTRICT_CONSTRUCTION';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER';
INSERT OR IGNORE INTO GovernorPromotionPrereqs ( GovernorPromotionType, PrereqGovernorPromotion ) VALUES
    ( 'GOVERNOR_PROMOTION_ZONING_COMMISSIONER', 'GOVERNOR_PROMOTION_PARKS_RECREATION' ),
    ( 'GOVERNOR_PROMOTION_ZONING_COMMISSIONER', 'GOVERNOR_PROMOTION_WATER_WORKS' );
UPDATE GovernorPromotions SET Level=3, 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER';

-- +1 food on every resource
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM Types WHERE Type='GOVERNOR_PROMOTION_AQUACULTURE';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('AGRICULTURE_FOOD_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'AGRICULTURE_FOOD_BBG_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AGRICULTURE_FOOD_BBG', 'YieldType', 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AGRICULTURE_FOOD_BBG', 'Amount', '1');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('AGRICULTURE_FOOD_BBG_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('AGRICULTURE_FOOD_BBG_REQUIREMENTS', 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('AGRICULTURE_PROMOTION_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_BUILDER', 'AGRICULTURE_PROMOTION_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column')
    VALUES ('AGRICULTURE_PROMOTION_BBG', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_NAME', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_DESCRIPTION', 1, 2);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES ('AGRICULTURE_PROMOTION_BBG', 'AGRICULTURE_FOOD_BBG');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES ('AGRICULTURE_PROMOTION_BBG', 'GOVERNOR_PROMOTION_BUILDER_GUILDMASTER');

-- +1 housing for districts
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='WATER_WORKS_NEIGHBORHOOD_HOUSING';
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='WATER_WORKS_CANAL_AMENITY';
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='WATER_WORKS_DAM_AMENITY';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='WATER_WORKS_AQUEDUCT_HOUSING';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='WATER_WORKS_AQUEDUCT_HOUSING' AND Name='Amount';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_WATER_WORKS', 'AGRICULTURE_PROMOTION_BBG');
UPDATE GovernorPromotions SET Level=2, 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_WATER_WORKS';

-- better parks
UPDATE Improvement_YieldChanges SET YieldChange=3 WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND YieldType='YIELD_CULTURE';
INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_CITY_PARK', 'YIELD_SCIENCE', 3);
INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_CITY_PARK', 'YIELD_GOLD', 3);
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='CITY_PARK_WATER_AMENITY';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('CITY_PARK_HOUSING_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('CITY_PARK_HOUSING_BBG', 'Amount', '1');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType, ModifierID) VALUES
    ('IMPROVEMENT_CITY_PARK', 'CITY_PARK_HOUSING_BBG');
DELETE FROM ImprovementModifiers WHERE ModifierID='CITY_PARK_GOVERNOR_CULTURE';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_DESERT_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_GRASS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_SNOW_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE Improvements SET OnePerCity=1 WHERE ImprovementType='IMPROVEMENT_CITY_PARK';
-- move parks
UPDATE GovernorPromotions SET Level=2, 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_PARKS_RECREATION';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_PARKS_RECREATION';
INSERT OR IGNORE INTO GovernorPromotionPrereqs ( GovernorPromotionType, PrereqGovernorPromotion ) VALUES
    ( 'GOVERNOR_PROMOTION_PARKS_RECREATION', 'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE' );

-- add fishery to tech tree
UPDATE Improvements SET TraitType=NULL WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM ImprovementModifiers WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM Modifiers WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
DELETE FROM ModifierArguments WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
UPDATE Improvements SET PrereqTech='TECH_CARTOGRAPHY' WHERE ImprovementType='IMPROVEMENT_FISHERY';

-- add prod to reinforced materials
INSERT OR IGNORE INTO RequirementSets ( RequirementSetId, RequirementSetType ) VALUES
    ( 'REQUIRES_PLOT_HAS_VOLCANIC_SOIL_BBG', 'REQUIREMENTSET_TEST_ANY' );
INSERT OR IGNORE INTO RequirementSetRequirements ( RequirementSetId, RequirementId ) VALUES
    ( 'REQUIRES_PLOT_HAS_VOLCANIC_SOIL_BBG', 'PLOT_VOLCANIC_SOIL_REQUIREMENT' );
INSERT OR IGNORE INTO Modifiers ( ModifierId, ModifierType, SubjectRequirementSetId ) VALUES
    ( 'REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQUIRES_PLOT_HAS_FLOODPLAINS_CPL' ),
    ( 'REINFORCED_INFRASTRUCTURE_VOLCANO_PROD_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQUIRES_PLOT_HAS_VOLCANIC_SOIL_BBG' );
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD_BBG', 'YieldType', 'YIELD_PRODUCTION'),
    ('REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD_BBG', 'Amount', '1'),
    ('REINFORCED_INFRASTRUCTURE_VOLCANO_PROD_BBG', 'YieldType', 'YIELD_PRODUCTION'),
    ('REINFORCED_INFRASTRUCTURE_VOLCANO_PROD_BBG', 'Amount', '1');
UPDATE GovernorPromotions SET Level=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE';
INSERT OR IGNORE INTO GovernorPromotionPrereqs ( GovernorPromotionType, PrereqGovernorPromotion ) VALUES
    ( 'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE', 'GOVERNOR_PROMOTION_BUILDER_GUILDMASTER' );
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ( 'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE', 'REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD_BBG' ),
    ( 'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE', 'REINFORCED_INFRASTRUCTURE_VOLCANO_PROD_BBG' );

-- 07/12 Liang 3 turns
UPDATE Governors SET TransitionStrength=150 WHERE GovernorType='GOVERNOR_THE_BUILDER';

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
        WHERE t2<= t1.WonderType), 'Placeholder', 'YIELD_SCIENCE', 2, 1, t1.WonderType
FROM WonderTerrainFeature_BBG AS t1
WHERE t1.FeatureType = 'FEATURE_REEF'
ORDER BY WonderType;
INSERT OR IGNORE INTO District_Adjacencies
    SELECT 
       'DISTRICT_CAMPUS', 'ReefWonder_Science'||(SELECT COUNT(*)
        FROM (SELECT WonderType AS t2 FROM WonderTerrainFeature_BBG  WHERE TerrainClassType = 'FEATURE_REEF')
        WHERE t2<= t1.WonderType)
FROM WonderTerrainFeature_BBG AS t1
WHERE t1.FeatureType = 'FEATURE_REEF'
ORDER BY WonderType;
--adding reef wonders defense modifier
UPDATE OR IGNORE Features SET DefenseModifier = 3
    WHERE FeatureType IN (SELECT WonderType FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_REEF');

