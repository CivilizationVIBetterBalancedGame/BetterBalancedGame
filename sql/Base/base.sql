
UPDATE GlobalParameters SET Value=2 WHERE Name='FORTIFY_BONUS_PER_TURN';

-- 02/07/24 Cost of tech ahead of actual game era are now +30% instead of +20%
UPDATE GlobalParameters SET Value=30 WHERE Name='TECH_COST_PERCENT_CHANGE_AFTER_GAME_ERA';

--==============================================================
--******				S  C  O  R  E				  	  ******
--==============================================================
-- more points for techs and civics
UPDATE ScoringLineItems SET Multiplier=4 WHERE LineItemType='LINE_ITEM_CIVICS';
UPDATE ScoringLineItems SET Multiplier=3 WHERE LineItemType='LINE_ITEM_TECHS';
-- less points for wide, more for tall
UPDATE ScoringLineItems SET Multiplier=2 WHERE LineItemType='LINE_ITEM_CITIES';
UPDATE ScoringLineItems SET Multiplier=2 WHERE LineItemType='LINE_ITEM_POPULATION';
-- Wonders Provide +4 score instead of +15
UPDATE ScoringLineItems SET Multiplier=4 WHERE LineItemType='LINE_ITEM_WONDERS';
-- Great People worth only 3 instead of 5
UPDATE ScoringLineItems SET Multiplier=3 WHERE LineItemType='LINE_ITEM_GREAT_PEOPLE';
-- converting foreign populations reduced from 2 to 1
UPDATE ScoringLineItems SET Multiplier=1 WHERE LineItemType='LINE_ITEM_ERA_CONVERTED';



--==============================================================
--******				START BIASES					  ******
--==============================================================
-- Update Start Bias
UPDATE StartBiasRivers SET Tier=3 WHERE CivilizationType='CIVILIZATION_GERMANY';

-- t1 take up essential coastal spots first
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_ENGLAND' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_NORWAY' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_JAPAN' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_RUSSIA' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_RUSSIA' AND TerrainType='TERRAIN_TUNDRA';
-- t2 must haves
UPDATE StartBiasFeatures SET Tier=2 WHERE CivilizationType='CIVILIZATION_BRAZIL' AND FeatureType='FEATURE_JUNGLE';
-- t3 identities
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_SCYTHIA' AND ResourceType='RESOURCE_HORSES';
-- t4 river mechanics
--UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_SUMERIA';
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_FRANCE';
-- t4 feature mechanics
UPDATE StartBiasFeatures SET Tier=3 WHERE CivilizationType='CIVILIZATION_KONGO' AND FeatureType='FEATURE_JUNGLE';
-- t4 terrain mechanics
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_GRASS_HILLS';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_PLAINS_HILLS';
-- t4 resource mechanics
INSERT OR IGNORE INTO StartBiasResources (CivilizationType , ResourceType , Tier) VALUES
	('CIVILIZATION_SCYTHIA' , 'RESOURCE_SHEEP'  , 4),
	('CIVILIZATION_SCYTHIA' , 'RESOURCE_CATTLE' , 4);
-- t5 last resorts
UPDATE StartBiasFeatures SET Tier=5 WHERE CivilizationType='CIVILIZATION_KONGO' AND FeatureType='FEATURE_FOREST';
UPDATE StartBiasFeatures SET Tier=5 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS';
-- Delete bad bias
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType IN ('TERRAIN_TUNDRA_HILLS', 'TERRAIN_DESERT_HILLS');


--==============================================================
--******				    O T H E R					  ******
--==============================================================
-- oil can be found on flat plains
INSERT OR IGNORE INTO Resource_ValidTerrains (ResourceType, TerrainType) VALUES
    ('RESOURCE_OIL', 'TERRAIN_PLAINS');
-- incense +1 food
-- mercury +1 food
-- spice -1 food +1 gold
INSERT OR IGNORE INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES
	('RESOURCE_INCENSE', 'YIELD_FOOD', 1),
	('RESOURCE_MERCURY', 'YIELD_FOOD', 1),
	('RESOURCE_SPICES', 'YIELD_GOLD', 1),
    ('RESOURCE_TEA', 'YIELD_FOOD', 1),
    ('RESOURCE_PEARLS', 'YIELD_PRODUCTION', 1);
UPDATE Resource_YieldChanges SET YieldChange=1 WHERE ResourceType='RESOURCE_SPICES' AND YieldType='YIELD_FOOD';

-- add 1 production to fishing boat improvement
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_FISHING_BOATS' AND YieldType='YIELD_PRODUCTION';

--09/03/2024 +1 housing to fishery
UPDATE Improvements SET Housing=2 WHERE ImprovementType='IMPROVEMENT_FISHERY';

-- Citizen specialists give +1 main yield
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' AND DistrictType='DISTRICT_ACROPOLIS';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' AND DistrictType='DISTRICT_CAMPUS';
UPDATE District_CitizenYieldChanges SET YieldChange=4 WHERE YieldType='YIELD_GOLD' AND DistrictType='DISTRICT_COMMERCIAL_HUB';
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' AND DistrictType='DISTRICT_ENCAMPMENT';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' AND DistrictType='DISTRICT_HANSA';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' AND DistrictType='DISTRICT_HARBOR';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' AND DistrictType='DISTRICT_HOLY_SITE';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' AND DistrictType='DISTRICT_INDUSTRIAL_ZONE';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' AND DistrictType='DISTRICT_LAVRA';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' AND DistrictType='DISTRICT_ROYAL_NAVY_DOCKYARD';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' AND DistrictType='DISTRICT_THEATER';

-- Free amenity on new city
UPDATE GlobalParameters SET Value=1 WHERE Name='CITY_AMENITIES_FOR_FREE';
UPDATE Buildings SET Entertainment=1 WHERE BuildingType='BUILDING_PALACE';

-- Seaside Ressort buildable on hills
INSERT INTO Improvement_ValidTerrains(ImprovementType, TerrainType) VALUES
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_GRASS_HILLS'),
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_PLAINS_HILLS'),
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_DESERT_HILLS');
-- 12/06/23 Beach Resort can be built on appealling tiles
UPDATE Improvements SET MinimumAppeal=2 WHERE ImprovementType='IMPROVEMENT_BEACH_RESORT';
--15/06/23 Beach resort get gold double the appeal and tourism based on that
UPDATE Improvement_Tourism SET TourismSource='TOURISMSOURCE_GOLD' WHERE ImprovementType='IMPROVEMENT_BEACH_RESORT';
UPDATE Improvements SET YieldFromAppealPercent=200 WHERE ImprovementType='IMPROVEMENT_BEACH_RESORT';


-- 12/06/23 Fix tourism at flight on some improvement
INSERT OR IGNORE INTO Improvement_Tourism(ImprovementType, TourismSource, PrereqTech)
    SELECT Improvements.ImprovementType, 'TOURISMSOURCE_CULTURE', 'TECH_FLIGHT' From Improvements WHERE ImprovementType IN ('IMPROVEMENT_FARM', 'IMPROVEMENT_QUARRY', 'IMPROVEMENT_CAMP', 'IMPROVEMENT_FISHING_BOATS', 'IMPROVEMENT_LUMBER_MILL', 'IMPROVEMENT_OIL_WELL', 'IMPROVEMENT_OFFSHORE_OIL_RIG');

-- 14/10/23 Lumber mill yield changes come earlier (steel to balistics and cybernetics to synthetics material)
UPDATE Improvement_BonusYieldChanges SET PrereqTech='TECH_BALLISTICS' WHERE Id=5;
UPDATE Technologies SET Description='BBG_LOC_TECH_BALLISTICS_DESCRIPTION' WHERE TechnologyType='TECH_BALLISTICS';
UPDATE Improvement_BonusYieldChanges SET PrereqTech='TECH_SYNTHETIC_MATERIALS' WHERE Id=227;

-- 14/10/23 Quarry yield changes come earlier (predictive systems to rocketry, so +2 rocketery, and gunpowder to military engineering)
UPDATE Improvement_BonusYieldChanges SET PrereqTech='TECH_MILITARY_ENGINEERING' WHERE Id=230;
UPDATE Technologies SET Description='BBG_LOC_TECH_MILITARY_ENGINEERING_DESCRIPTION' WHERE TechnologyType='TECH_MILITARY_ENGINEERING';
UPDATE Improvement_BonusYieldChanges SET BonusYieldChange=2 WHERE Id=13;
DELETE FROM Improvement_BonusYieldChanges WHERE Id=231;
UPDATE Technologies SET Description=NULL WHERE TechnologyType='TECH_PREDICTIVE_SYSTEMS';

--****		REQUIREMENTS		****--
INSERT OR IGNORE INTO Requirements
	(RequirementId , RequirementType)
	VALUES
	('PLAYER_HAS_MEDIEVAL_FAIRES_CPLMOD', 'REQUIREMENT_PLAYER_HAS_CIVIC'),
	('PLAYER_HAS_URBANIZATION_CPLMOD', 'REQUIREMENT_PLAYER_HAS_CIVIC'),
	('PLAYER_HAS_BANKING_CPLMOD', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
	('PLAYER_HAS_ECONOMICS_CPLMOD', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT OR IGNORE INTO RequirementArguments
	(RequirementId , Name , Value)
	VALUES
	('PLAYER_HAS_MEDIEVAL_FAIRES_CPLMOD', 'CivicType', 'CIVIC_MEDIEVAL_FAIRES'  ),
	('PLAYER_HAS_URBANIZATION_CPLMOD', 'CivicType', 'CIVIC_URBANIZATION'),
	('PLAYER_HAS_BANKING_CPLMOD', 'TechnologyType', 'TECH_BANKING'  ),
	('PLAYER_HAS_ECONOMICS_CPLMOD', 'TechnologyType', 'TECH_ECONOMICS');

-- 2022-06-04 -- Add Scientific Theory as Prereq for Steam Power
INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
	VALUES ('TECH_STEAM_POWER', 'TECH_SCIENTIFIC_THEORY');

-- This is simply a visual change which makes the tech paths slighly more understandable (the dotted lines)
-- UPDATE Technologies SET UITreeRow=-3 WHERE TechnologyType='TECH_INDUSTRIALIZATION';


--Removing any Extra Yields Mechanism
/*
CREATE TABLE Numbers(Number INT NOT NULL);
INSERT INTO Numbers VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15);

INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'REQ_PLOT_HAS_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
    FROM Numbers LEFT JOIN Yields;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_PLOT_HAS_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'PropertyName', 'EXTRA_'||Yields.YieldType
    FROM Numbers LEFT JOIN Yields;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_PLOT_HAS_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'PropertyMinimum', Numbers.Number
    FROM Numbers LEFT JOIN Yields;
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'REQSET_PLOT_HAS_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'REQUIREMENTSET_TEST_ALL'
    FROM Numbers LEFT JOIN Yields;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'REQSET_PLOT_HAS_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'REQ_PLOT_HAS_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG'
    FROM Numbers LEFT JOIN Yields;
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
    SELECT 'MODIFIER_CITY_REMOVE_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_HAS_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG'
    FROM Numbers LEFT JOIN Yields;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'MODIFIER_CITY_REMOVE_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'YieldType', Yields.YieldType
    FROM Numbers LEFT JOIN Yields;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'MODIFIER_CITY_REMOVE_'||Numbers.Number||'_EXTRA_'||Yields.YieldType||'_BBG', 'Amount', -1
    FROM Numbers LEFT JOIN Yields;
INSERT INTO Modifiers(ModifierId, ModifierType)
    SELECT 'MODIFIER_CIV_CITIES_REMOVE_EXTRA_'||Numbers.Number||'_'||Yields.YieldType||'_BBG', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER'
    FROM Numbers LEFT JOIN Yields;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
    SELECT 'MODIFIER_CIV_CITIES_REMOVE_EXTRA_'||Numbers.Number||'_'||Yields.YieldType||'_BBG', 'ModifierId', 'MODIFIER_CITY_REMOVE_EXTRA_'||Numbers.Number||'_'||Yields.YieldType||'_BBG'
    FROM Numbers LEFT JOIN Yields;

INSERT INTO TraitModifiers(TraitType, ModifierId)
    SELECT 'TRAIT_LEADER_MAJOR_CIV', 'MODIFIER_CIV_CITIES_REMOVE_EXTRA_'||Numbers.Number||'_'||Yields.YieldType||'_BBG'
    FROM Numbers LEFT JOIN Yields;
INSERT INTO TraitModifiers(TraitType, ModifierId)
    SELECT 'MINOR_CIV_DEFAULT_TRAIT', 'MODIFIER_CIV_CITIES_REMOVE_EXTRA_'||Numbers.Number||'_'||Yields.YieldType||'_BBG'
    FROM Numbers LEFT JOIN Yields;
DROP TABLE Numbers;
*/

--=======================================================================
--******                        Spy                                ******
--=======================================================================
--Creating Spy Capacity Modifier (lua attaches it)
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('MODIFIER_CAPTURED_ADD_SPY_CAPACITY_BBG', 'MODIFIER_PLAYER_GRANT_SPY');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('MODIFIER_CAPTURED_ADD_SPY_CAPACITY_BBG', 'Amount', '1');

--=======================================================================
--******               Wonder+Terrain/Feature                      ******
--=======================================================================

INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentFeature)
	SELECT 
       'Mountain_Science'||(SELECT COUNT(*)+5
        FROM (SELECT WonderType AS t2 FROM WonderTerrainFeature_BBG  WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN')
        WHERE t2<= t1.WonderType), 'LOC_CAMPUS_MOUNTAIN_WONDER_ADJACENCY_BBG', 'YIELD_SCIENCE', 1, 1, t1.WonderType
FROM WonderTerrainFeature_BBG AS t1
WHERE t1.TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN'
ORDER BY WonderType;
INSERT OR IGNORE INTO District_Adjacencies
	SELECT 
       'DISTRICT_CAMPUS', 'Mountain_Science'||(SELECT COUNT(*)+5
        FROM (SELECT WonderType AS t2 FROM WonderTerrainFeature_BBG  WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN')
        WHERE t2<= t1.WonderType)
FROM WonderTerrainFeature_BBG AS t1
WHERE t1.TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN'
ORDER BY WonderType;

--lake
UPDATE OR IGNORE Features SET AddsFreshWater = 1, Lake = 1 
	WHERE FeatureType IN (SELECT WonderType FROM WonderTerrainFeature_BBG WHERE Other = 'LAKE');
--oasis
UPDATE OR IGNORE Features SET AddsFreshWater = 1
	WHERE FeatureType IN (SELECT WonderType FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_OASIS');
--Defense Modifier
UPDATE OR IGNORE Features SET MovementChange=1,DefenseModifier = -2
	WHERE FeatureType IN (SELECT WonderType FROM WonderTerrainFeature_BBG WHERE FeatureType = 'FEATURE_MARSH');
UPDATE OR IGNORE Features SET MovementChange=1, SightThroughModifier=1, DefenseModifier = 3
	WHERE FeatureType IN (SELECT WonderType FROM WonderTerrainFeature_BBG WHERE Other = 'HILLS');

--aqueduct/bath custom placements (for wonder terrain/feature)
INSERT INTO CustomPlacement(ObjectType, Hash, PlacementFunction)
    SELECT Types.Type, Types.Hash, 'BBG_AQUEDUCT_CUSTOM_PLACEMENT'
    FROM Types WHERE Type IN ('DISTRICT_AQUEDUCT', 'DISTRICT_BATH');

--=======================================================================
--******                       GOODY HUTS                          ******
--=======================================================================

UPDATE GoodyHutSubTypes SET Turn=30 WHERE ModifierID='GOODY_CULTURE_GRANT_ONE_RELIC';

--=======================================================================
--******                       DISTRICTS                          ******
--=======================================================================

-- 14/10 discount reduced to 35% (20 for diplo quarter/gov) and unique district to 55%
UPDATE Districts SET CostProgressionParam1=20 WHERE DistrictType='DISTRICT_DIPLOMATIC_QUARTER';
UPDATE Districts SET CostProgressionParam1=35 WHERE DistrictType IN ('DISTRICT_THEATER', 'DISTRICT_INDUSTRIAL_ZONE', 'DISTRICT_ENTERTAINMENT_COMPLEX', 'DISTRICT_HOLY_SITE', 'DISTRICT_CAMPUS', 'DISTRICT_ENCAMPMENT', 'DISTRICT_HARBOR', 'DISTRICT_AERODROME', 'DISTRICT_COMMERCIAL_HUB');

UPDATE Districts SET CostProgressionParam1=35 WHERE DistrictType IN ('DISTRICT_ACROPOLIS', 'DISTRICT_STREET_CARNIVAL', 'DISTRICT_ROYAL_NAVY_DOCKYARD', 'DISTRICT_LAVRA', 'DISTRICT_HANSA');
UPDATE Districts SET Cost=20 WHERE DistrictType='DISTRICT_BATH';
UPDATE Districts SET Cost=30 WHERE DistrictType IN ('DISTRICT_MBANZA', 'DISTRICT_ACROPOLIS', 'DISTRICT_STREET_CARNIVAL', 'DISTRICT_ROYAL_NAVY_DOCKYARD', 'DISTRICT_LAVRA', 'DISTRICT_HANSA');

--19/12/23 entertainment complex to 2 amenities (from 1)
UPDATE Districts SET Entertainment=2 WHERE DistrictType='DISTRICT_ENTERTAINMENT_COMPLEX';

--=======================================================================
--******                       TECHS                               ******
--=======================================================================

--18/12/23 advanced ballistics advanced one era
UPDATE Technologies SET EraType="ERA_MODERN" WHERE TechnologyType='TECH_ADVANCED_BALLISTICS';
UPDATE Technologies SET Cost=1370 WHERE TechnologyType='TECH_ADVANCED_BALLISTICS';

--=======================================================================
--******                       AMENITIES                           ******
--=======================================================================

UPDATE Happinesses SET GrowthModifier=8, NonFoodYieldModifier=8 WHERE HappinessType='HAPPINESS_HAPPY';
UPDATE Happinesses SET GrowthModifier=16, NonFoodYieldModifier=16 WHERE HappinessType='HAPPINESS_ECSTATIC';

-- 14/03/24 Nationalism boost is now upgrading a land unit to level 3
UPDATE Boosts SET BoostClass='BOOST_TRIGGER_LAND_UNIT_LEVEL', NumItems=3 WHERE CivicType='CIVIC_NATIONALISM';