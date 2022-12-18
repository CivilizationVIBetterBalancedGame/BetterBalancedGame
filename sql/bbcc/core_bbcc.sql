CREATE TABLE BBCC(
    ResourceType TEXT,
    ResourceClassType TEXT,
    TerrainType TEXT,
    FeatureType TEXT,
    Food INT DEFAULT 0 NOT NULL,
    Prod INT DEFAULT 0 NOT NULL,
    Gold INT DEFAULT 0 NOT NULL,
    Faith INT DEFAULT 0 NOT NULL,
    Cult INT DEFAULT 0 NOT NULL,
    Sci INT DEFAULT 0 NOT NULL
);

INSERT INTO BBCC(ResourceType, ResourceClassType, TerrainType)
	SELECT Resources.ResourceType, Resources.ResourceClassType, Resource_ValidTerrains.TerrainType
	FROM Resources INNER JOIN Resource_ValidTerrains
	ON Resources.ResourceType = Resource_ValidTerrains.ResourceType
	WHERE Resources.ResourceClassType<>'RESOURCECLASS_ARTIFACT' AND Resource_ValidTerrains.TerrainType NOT IN ('TERRAIN_COAST', 'TERRAIN_OCEAN');

INSERT INTO BBCC(ResourceType, ResourceClassType, TerrainType, FeatureType)
	SELECT Resources.ResourceType, Resources.ResourceClassType, tt, ft
	FROM Resources 
	INNER JOIN
		(SELECT Resource_ValidFeatures.ResourceType as rt, Feature_ValidTerrains.TerrainType as tt, Feature_ValidTerrains.FeatureType as ft 
		FROM Resource_ValidFeatures 
		INNER JOIN Feature_ValidTerrains
		ON Resource_ValidFeatures.FeatureType = Feature_ValidTerrains.FeatureType
		WHERE Feature_ValidTerrains.TerrainType NOT IN ('TERRAIN_COAST', 'TERRAIN_OCEAN'))
	ON Resources.ResourceType = rt
	WHERE (Resources.ResourceClassType<>'RESOURCECLASS_ARTIFACT');

INSERT INTO BBCC(TerrainType)
	SELECT Terrains.TerrainType 
	FROM Terrains 
	WHERE TerrainType NOT LIKE '%MOUNTAIN'
		AND TerrainType NOT IN ('TERRAIN_COAST', 'TERRAIN_OCEAN');

INSERT INTO BBCC(FeatureType, TerrainType)
	SELECT DISTINCT Features.FeatureType, Feature_ValidTerrains.TerrainType
	FROM Features
		INNER JOIN Feature_ValidTerrains ON Features.FeatureType = Feature_ValidTerrains.FeatureType
		INNER JOIN Feature_YieldChanges ON Features.FeatureType = Feature_YieldChanges.FeatureType
	WHERE Feature_ValidTerrains.TerrainType IN ('TERRAIN_GRASS', 'TERRAIN_GRASS_HILLS', 'TERRAIN_PLAINS', 'TERRAIN_PLAINS_HILLS', 'TERRAIN_DESERT', 'TERRAIN_DESERT_HILLS', 'TERRAIN_TUNDRA', 'TERRAIN_TUNDRA_HILLS', 'TERRAIN_SNOW', 'TERRAIN_SNOW_HILLS')
		AND Features.Removable = 0 
		AND Features.Settlement = 1;
--Flatten Nat Wonder Tiles
UPDATE BBCC SET TerrainType = REPLACE(TerrainType, '_HILLS','') 
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE NaturalWonder = 1);
--terrain Yields
UPDATE OR IGNORE BBCC SET Food = (SELECT BBCC.Food + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE BBCC.TerrainType = Terrain_YieldChanges.TerrainType 
		AND YieldType = 'YIELD_FOOD');
UPDATE OR IGNORE BBCC SET Prod = (SELECT BBCC.Prod + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType);
UPDATE OR IGNORE BBCC SET Gold = (SELECT BBCC.Gold + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType);
UPDATE OR IGNORE BBCC SET Faith = (SELECT BBCC.Faith + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType);
UPDATE OR IGNORE BBCC SET Cult = (SELECT BBCC.Cult + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType);
UPDATE OR IGNORE BBCC SET Sci = (SELECT BBCC.Sci + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType);
--Irremovable Feature Yields (Non-Nat Wonders)
UPDATE OR IGNORE BBCC SET Food = (SELECT BBCC.Food + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FOOD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0));
UPDATE OR IGNORE BBCC SET Prod = (SELECT BBCC.Prod + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0));
UPDATE OR IGNORE BBCC SET Gold = (SELECT BBCC.Gold + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0));
UPDATE OR IGNORE BBCC SET Faith = (SELECT BBCC.Faith + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0));
UPDATE OR IGNORE BBCC SET Cult = (SELECT BBCC.Cult + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0));
UPDATE OR IGNORE BBCC SET Sci = (SELECT BBCC.Sci + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0));
--Irremovable Feature Yields (NatWonder)
UPDATE OR IGNORE BBCC SET Food = (SELECT Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FOOD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1));
UPDATE OR IGNORE BBCC SET Prod = (SELECT Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1));
UPDATE OR IGNORE BBCC SET Gold = (SELECT Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1));
UPDATE OR IGNORE BBCC SET Faith = (SELECT Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1));
UPDATE OR IGNORE BBCC SET Cult = (SELECT Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1));
UPDATE OR IGNORE BBCC SET Sci = (SELECT Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1));
--Resource Yields
UPDATE OR IGNORE BBCC SET Food = (SELECT BBCC.Food + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_FOOD' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType);
UPDATE OR IGNORE BBCC SET Prod = (SELECT BBCC.Prod + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType);
UPDATE OR IGNORE BBCC SET Gold = (SELECT BBCC.Gold + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType);
UPDATE OR IGNORE BBCC SET Faith = (SELECT BBCC.Faith + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType);
UPDATE OR IGNORE BBCC SET Cult = (SELECT BBCC.Cult + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType);
UPDATE OR IGNORE BBCC SET Sci = (SELECT BBCC.Sci + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType);

CREATE TABLE tmp
AS 
SELECT DISTINCT 
	BBCC.ResourceType, 
	BBCC.ResourceClassType, 
	BBCC.TerrainType,
	CASE
		WHEN BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0)
		THEN BBCC.FeatureType
		ELSE NULL
	END,
	BBCC.Food,
	BBCC.Prod,
	BBCC.Gold,
	BBCC.Faith,
	BBCC.Cult,
	BBCC.Sci
FROM BBCC;

DELETE FROM BBCC;
INSERT INTO BBCC SELECT * FROM tmp;
DROP TABLE tmp;

--strategic requirements
INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
	SELECT DISTINCT 'REQ_HAS_NO_'||BBCC.ResourceType||'_BBCC', 'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES', '1'
	FROM BBCC WHERE ResourceType IS NOT NULL;

INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT 'REQ_HAS_NO_'||BBCC.ResourceType||'_BBCC', 'ResourceType', BBCC.ResourceType
	FROM BBCC WHERE ResourceType IS NOT NULL;

INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
	SELECT 'REQ_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQUIREMENT_PLAYER_HAS_RESOURCE_VISIBILITY', '1'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';

INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_SEES_NO_'||Resources.ResourceType||'_BBCC', 'ResourceType', Resources.ResourceType
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT 'REQSET_HAS_NO_OR_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQUIREMENTSET_TEST_ANY'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'REQSET_HAS_NO_OR_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQ_HAS_NO_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'REQSET_HAS_NO_OR_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQ_SEES_NO_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';

INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'REQ_HAS_NO_OR_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';

INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_HAS_NO_OR_SEES_NO_'||Resources.ResourceType||'_BBCC', 'RequirementSetId', 'REQSET_HAS_NO_OR_SEES_NO_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
--Create Positive Requirements
--res
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT 'REQ_HAS_'||BBCC.ResourceType||'_BBCC', 'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'
	FROM BBCC WHERE ResourceType NOT NULL;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT 'REQ_HAS_'||BBCC.ResourceType||'_BBCC', 'ResourceType', BBCC.ResourceType
	FROM BBCC WHERE ResourceType NOT NULL;
--features
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT 'REQ_HAS_'||BBCC.FeatureType||'_BBCC', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES'
	FROM BBCC WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0);
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT 'REQ_HAS_'||BBCC.FeatureType||'_BBCC', 'FeatureType', BBCC.FeatureType
	FROM BBCC WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0);
INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
	SELECT DISTINCT 'REQ_HAS_NO_'||BBCC.FeatureType||'_BBCC', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES', '1'
	FROM BBCC WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0);
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT 'REQ_HAS_NO_'||BBCC.FeatureType||'_BBCC', 'FeatureType', BBCC.FeatureType
	FROM BBCC WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0);
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'REQ_SEES_'||Resources.ResourceType||'_BBCC', 'REQUIREMENT_PLAYER_HAS_RESOURCE_VISIBILITY'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_SEES_'||Resources.ResourceType||'_BBCC', 'ResourceType', Resources.ResourceType
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT 'REQSET_HAS_AND_SEES_'||Resources.ResourceType||'_BBCC', 'REQUIREMENTSET_TEST_ALL'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'REQSET_HAS_AND_SEES_'||Resources.ResourceType||'_BBCC', 'REQ_HAS_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';	
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'REQSET_HAS_AND_SEES_'||Resources.ResourceType||'_BBCC', 'REQ_SEES_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'REQ_HAS_AND_SEES_'||Resources.ResourceType||'_BBCC', 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_HAS_AND_SEES_'||Resources.ResourceType||'_BBCC', 'RequirementSetId', 'REQSET_HAS_AND_SEES_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';	
--ReqSets For Pairs
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT DISTINCT 'REQSET_HAS_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC', 'REQUIREMENTSET_TEST_ALL'
	FROM BBCC 
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0) 
		AND ResourceType NOT NULL;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT DISTINCT 'REQSET_HAS_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC', 
		CASE
			WHEN BBCC.ResourceClassType<>'RESOURCECLASS_STRATEGIC' 
			THEN 'REQ_HAS_'||BBCC.ResourceType||'_BBCC'
			WHEN BBCC.ResourceClassType='RESOURCECLASS_STRATEGIC'
			THEN 'REQ_HAS_AND_SEES_'||BBCC.ResourceType||'_BBCC'
		END
	FROM BBCC 
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0) 
		AND ResourceType NOT NULL;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT DISTINCT 'REQSET_HAS_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC', 'REQ_HAS_'||BBCC.FeatureType||'_BBCC'
	FROM BBCC 
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0) 
		AND ResourceType NOT NULL;
--paired
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT 'REQ_HAS_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC', 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	FROM BBCC 
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0) 
		AND ResourceType NOT NULL;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT 'REQ_HAS_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC', 'RequirementSetId', 'REQSET_HAS_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC'
	FROM BBCC
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0) 
		AND ResourceType NOT NULL;
--paired negation
INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
	SELECT DISTINCT 'REQ_HAS_NO_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC', 'REQUIREMENT_REQUIREMENTSET_IS_MET', '1'
	FROM BBCC 
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0) 
		AND ResourceType NOT NULL;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT 'REQ_HAS_NO_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC', 'RequirementSetId', 'REQSET_HAS_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC'
	FROM BBCC
	WHERE FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0) 
		AND ResourceType NOT NULL;
--terrain
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'REQ_PLOT_HAS_'||Terrains.TerrainType||'_BBCC', 'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES'
	FROM Terrains
	WHERE TerrainType NOT LIKE '%COAST' AND TerrainType NOT LIKE '%OCEAN' AND TerrainType NOT LIKE '%MOUNTAIN';
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_PLOT_HAS_'||Terrains.TerrainType||'_BBCC', 'TerrainType', Terrains.TerrainType
	FROM Terrains
	WHERE TerrainType NOT LIKE '%COAST' AND TerrainType NOT LIKE '%OCEAN' AND TerrainType NOT LIKE '%MOUNTAIN';

INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
	SELECT 'REQ_PLOT_HAS_NO_'||Terrains.TerrainType||'_BBCC', 'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES', '1'
	FROM Terrains
	WHERE TerrainType NOT LIKE '%COAST' AND TerrainType NOT LIKE '%OCEAN' AND TerrainType NOT LIKE '%MOUNTAIN';
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_PLOT_HAS_NO_'||Terrains.TerrainType||'_BBCC', 'TerrainType', Terrains.TerrainType
	FROM Terrains
	WHERE TerrainType NOT LIKE '%COAST' AND TerrainType NOT LIKE '%OCEAN' AND TerrainType NOT LIKE '%MOUNTAIN';
--city center
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQ_PLOT_IS_CITY_CENTER_BBCC' , 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQ_PLOT_IS_CITY_CENTER_BBCC' , 'DistrictType', 'DISTRICT_CITY_CENTER');
INSERT INTO Requirements(RequirementId, RequirementType, Inverse) VALUES
    ('REQ_PLOT_IS_NO_CITY_CENTER_BBCC' , 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', '1');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQ_PLOT_IS_NO_CITY_CENTER_BBCC' , 'DistrictType', 'DISTRICT_CITY_CENTER');
--Has no resource at all
INSERT INTO Requirements(RequirementId, RequirementType, Inverse) VALUES
	('REQ_HAS_NO_RESOURCE_BBCC', 'REQUIREMENT_PLOT_HAS_ANY_RESOURCE', 1);

CREATE TABLE BBCC_Modifiers(
	ModifierId TEXT NOT NULL,
	YieldType TEXT NOT NULL,
	Amount TEXT NOT NULL,
	SubjectRequirementSetId TEXT,
	InnerReqSet TEXT,
	TerrainType TEXT,
	ResourceType TEXT,
	ResourceClassType TEXT,
	FeatureType TEXT,
	ReqSet_TFR TEXT
);