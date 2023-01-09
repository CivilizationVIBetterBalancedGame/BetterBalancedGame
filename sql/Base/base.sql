--==============================================================
--******			  G O V E R N M E N T S				  ******
--==============================================================
-- fascism attack bonus works on defense now too
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_ATTACK_BUFF';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_LEGACY_ATTACK_BUFF';



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
INSERT OR IGNORE INTO Resource_ValidTerrains (ResourceType, TerrainType)
	VALUES ('RESOURCE_OIL', 'TERRAIN_PLAINS');
-- incense +1 food
-- mercury +1 food
-- spice -1 food +1 gold
INSERT OR IGNORE INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES
	('RESOURCE_INCENSE', 'YIELD_FOOD', 1),
	('RESOURCE_MERCURY', 'YIELD_FOOD', 1),
	('RESOURCE_SPICES', 'YIELD_GOLD', 1);
UPDATE Resource_YieldChanges SET YieldChange=1 WHERE ResourceType='RESOURCE_SPICES' AND YieldType='YIELD_FOOD';

-- add 1 production to fishing boat improvement
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_FISHING_BOATS' AND YieldType='YIELD_PRODUCTION';

-- Citizen specialists give +1 main yield
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' 		AND DistrictType='DISTRICT_ACROPOLIS';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' 		AND DistrictType='DISTRICT_CAMPUS';
UPDATE District_CitizenYieldChanges SET YieldChange=4 WHERE YieldType='YIELD_GOLD' 			AND DistrictType='DISTRICT_COMMERCIAL_HUB';
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType='DISTRICT_ENCAMPMENT';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType='DISTRICT_HANSA';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' 			AND DistrictType='DISTRICT_HARBOR';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' 		AND DistrictType='DISTRICT_HOLY_SITE';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType='DISTRICT_INDUSTRIAL_ZONE';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' 		AND DistrictType='DISTRICT_LAVRA';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' 			AND DistrictType='DISTRICT_ROYAL_NAVY_DOCKYARD';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' 		AND DistrictType='DISTRICT_THEATER';

-- Free amenity on new city
UPDATE GlobalParameters SET Value=1 WHERE Name='CITY_AMENITIES_FOR_FREE';
UPDATE Buildings SET Entertainment=1 WHERE BuildingType='BUILDING_PALACE';

-- Seaside Ressort buildable on hills
INSERT INTO Improvement_ValidTerrains(ImprovementType, TerrainType) VALUES
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_GRASS_HILLS'),
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_PLAINS_HILLS'),
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_DESERT_HILLS');

--****		REQUIREMENTS		****--
INSERT OR IGNORE INTO Requirements
	(RequirementId , RequirementType)
	VALUES
	('PLAYER_HAS_MEDIEVAL_FAIRES_CPLMOD', 	'REQUIREMENT_PLAYER_HAS_CIVIC'),
	('PLAYER_HAS_URBANIZATION_CPLMOD', 		'REQUIREMENT_PLAYER_HAS_CIVIC'),
	('PLAYER_HAS_BANKING_CPLMOD'   , 		'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
	('PLAYER_HAS_ECONOMICS_CPLMOD' , 		'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT OR IGNORE INTO RequirementArguments
	(RequirementId , Name , Value)
	VALUES
	('PLAYER_HAS_MEDIEVAL_FAIRES_CPLMOD',	'CivicType', 		'CIVIC_MEDIEVAL_FAIRES'  ),
	('PLAYER_HAS_URBANIZATION_CPLMOD', 	 	'CivicType', 		'CIVIC_URBANIZATION'),
	('PLAYER_HAS_BANKING_CPLMOD'   , 		'TechnologyType', 	'TECH_BANKING'  ),
	('PLAYER_HAS_ECONOMICS_CPLMOD' , 		'TechnologyType', 	'TECH_ECONOMICS');

-- 2022-06-04 -- Add Scientific Theory as Prereq for Steam Power
INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
	VALUES ('TECH_STEAM_POWER', 'TECH_SCIENTIFIC_THEORY');

-- This is simply a visual change which makes the tech paths slighly more understandable (the dotted lines)
-- UPDATE Technologies SET UITreeRow=-3 WHERE TechnologyType='TECH_INDUSTRIALIZATION';


--==========Terrain==========--
--adding campus adjacency to mountain wonders

INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentFeature)
	SELECT 
       'Mountain_Science'||(SELECT COUNT(*)+5
        FROM (SELECT WonderType AS t2 FROM WonderTerrainFeature_BBG  WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN')
        WHERE t2<= t1.WonderType), 'Placeholder', 'YIELD_SCIENCE', 1, 1, t1.WonderType
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