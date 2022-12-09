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
UPDATE BBCC SET Food = BBCC.Food + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_FOOD' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType;
UPDATE BBCC SET Prod = BBCC.Prod + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType;
UPDATE BBCC SET Gold = BBCC.Gold + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType;
UPDATE BBCC SET Prod = BBCC.Faith + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType;
UPDATE BBCC SET Cult = BBCC.Cult + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType;
UPDATE BBCC SET Sci = BBCC.Sci + Terrain_YieldChanges.YieldChange
	FROM Terrain_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.TerrainType = Terrain_YieldChanges.TerrainType;
--Irremovable Feature Yields (Non-Nat Wonders)
UPDATE BBCC SET Food = BBCC.Food + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FOOD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0);
UPDATE BBCC SET Prod = BBCC.Prod + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0);
UPDATE BBCC SET Gold = BBCC.Gold + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0);
UPDATE BBCC SET Faith = BBCC.Faith + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0);
UPDATE BBCC SET Cult = BBCC.Cult + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0);
UPDATE BBCC SET Sci = BBCC.Sci + Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 0);
--Irremovable Feature Yields (NatWonder)
UPDATE BBCC SET Food = Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FOOD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1);
UPDATE BBCC SET Prod = Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1);
UPDATE BBCC SET Gold = Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1);
UPDATE BBCC SET Faith = Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1);
UPDATE BBCC SET Cult = Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1);
UPDATE BBCC SET Sci = Feature_YieldChanges.YieldChange
	FROM Feature_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.FeatureType = Feature_YieldChanges.FeatureType 
		AND Feature_YieldChanges.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable = 0 AND NaturalWonder = 1);
--Resource Yields
UPDATE BBCC SET Food = BBCC.Food + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_FOOD' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCC SET Prod = BBCC.Prod + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_PRODUCTION' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCC SET Gold = BBCC.Gold + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_GOLD' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCC SET Faith = BBCC.Faith + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_FAITH' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCC SET Cult = BBCC.Cult + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_CULTURE' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCC SET Sci = BBCC.Sci + Resource_YieldChanges.YieldChange
	FROM Resource_YieldChanges 
	WHERE YieldType = 'YIELD_SCIENCE' 
		AND BBCC.ResourceType = Resource_YieldChanges.ResourceType;

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

INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'REQ_PLOT_HAS_'||Terrains.TerrainType||'_BBCC', 'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES'
	FROM Terrains
	WHERE TerrainType NOT LIKE '%COAST' AND TerrainType NOT LIKE '%OCEAN' AND TerrainType NOT LIKE '%MOUNTAIN';
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_PLOT_HAS_'||Terrains.TerrainType||'_BBCC', 'TerrainType', Terrains.TerrainType
	FROM Terrains
	WHERE TerrainType NOT LIKE '%COAST' AND TerrainType NOT LIKE '%OCEAN' AND TerrainType NOT LIKE '%MOUNTAIN';

/*
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('REQSET_PLOT_IS_PLAINS_HILLS_CITY_BBCC', 'REQUIREMENTSET_TEST_ALL'),
	('REQSET_PLOT_IS_TUNDRA_CITY_BBCC', 'REQUIREMENTSET_TEST_ALL'),
	('REQSET_PLOT_IS_TUNDRA_HILLS_CITY_BBCC', 'REQUIREMENTSET_TEST_ALL'),
	('REQSET_PLOT_IS_DESERT_CITY_BBCC', 'REQUIREMENTSET_TEST_ALL'),
	('REQSET_PLOT_IS_DESERT_HILLS_CITY_BBCC', 'REQUIREMENTSET_TEST_ALL'),
	('REQSET_PLOT_IS_SNOW_CITY_BBCC', 'REQUIREMENTSET_TEST_ALL'),
	('REQSET_PLOT_IS_SNOW_HILLS_CITY_BBCC', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('REQSET_PLOT_IS_PLAINS_HILLS_CITY_BBCC', 'PLOT_IS_PLAINS_HILLS_TERRAIN_REQUIREMENT'),
	('REQSET_PLOT_IS_PLAINS_HILLS_CITY_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC'),
	('REQSET_PLOT_IS_TUNDRA_CITY_BBCC', 'REQUIRES_PLOT_HAS_TUNDRA'),
	('REQSET_PLOT_IS_TUNDRA_CITY_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC'),
	('REQSET_PLOT_IS_TUNDRA_HILLS_CITY_BBCC', 'PLOT_IS_TUNDRA_HILLS_TERRAIN_REQUIREMENT'),
	('REQSET_PLOT_IS_TUNDRA_HILLS_CITY_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC'),
	('REQSET_PLOT_IS_DESERT_CITY_BBCC', 'REQUIRES_PLOT_HAS_DESERT'),
	('REQSET_PLOT_IS_DESERT_CITY_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC'),
	('REQSET_PLOT_IS_DESERT_HILLS_CITY_BBCC', 'PLOT_IS_DESERT_HILLS_TERRAIN_REQUIREMENT'),
	('REQSET_PLOT_IS_DESERT_HILLS_CITY_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC'),
	('REQSET_PLOT_IS_SNOW_CITY_BBCC', 'REQUIRES_PLOT_HAS_SNOW'),
	('REQSET_PLOT_IS_SNOW_CITY_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC'),
	('REQSET_PLOT_IS_SNOW_HILLS_CITY_BBCC', 'PLOT_IS_SNOW_HILLS_TERRAIN_REQUIREMENT'),
	('REQSET_PLOT_IS_SNOW_HILLS_CITY_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC');

--Adding To Requirements for Missing Food to Flats When Appropriate
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT DISTINCT 'REQSET_PLOT_IS_'||REPLACE(BBCC.TerrainType, 'TERRAIN_','')||'_CITY_BBCC',
		CASE 
			WHEN 
				(BBCC.FeatureType IS NULL 
				OR BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=1))
				AND (BBCC.ResourceClassType<>'RESOURCECLASS_STRATEGIC' AND BBCC.ResourceType IS NOT NULL)
			THEN
				'REQ_HAS_NO_'||BBCC.ResourceType||'_BBCC'
			WHEN
				(BBCC.FeatureType IS NULL 
				OR BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=1))
				AND BBCC.ResourceClassType='RESOURCECLASS_STRATEGIC'
			THEN
				'REQ_HAS_NO_OR_SEES_NO_'||BBCC.ResourceType||'_BBCC'
			WHEN
				BBCC.FeatureType IS NOT NULL 
				AND BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0)
			THEN
				'REQ_HAS_NO_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC'
			ELSE
				'REQ_HAS_NO_'||BBCC.FeatureType||'_BBCC'
		END
	FROM BBCC
	WHERE Food>2 AND TerrainType NOT LIKE '%HILLS';

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT DISTINCT 'REQSET_PLOT_IS_'||REPLACE(BBCC.TerrainType, 'TERRAIN_','')||'_CITY_BBCC',
		CASE 
			WHEN 
				(BBCC.FeatureType IS NULL 
				OR BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=1))
				AND (BBCC.ResourceClassType<>'RESOURCECLASS_STRATEGIC' AND BBCC.ResourceType IS NOT NULL)
			THEN
				'REQ_HAS_NO_'||BBCC.ResourceType||'_BBCC'
			WHEN
				(BBCC.FeatureType IS NULL 
				OR BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=1))
				AND BBCC.ResourceClassType='RESOURCECLASS_STRATEGIC'
			THEN
				'REQ_HAS_NO_OR_SEES_NO_'||BBCC.ResourceType||'_BBCC'
			WHEN
				BBCC.FeatureType IS NOT NULL 
				AND BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0)
			THEN
				'REQ_HAS_NO_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC'
			ELSE
				'REQ_HAS_NO_'||BBCC.FeatureType||'_BBCC'
		END
	FROM BBCC
	WHERE Prod>=2 AND TerrainType LIKE '%HILLS' AND TerrainType<>'TERRAIN_PLAINS_HILLS';
*/
--============Adding Missing Yields:=============-----
--food
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(3-BBCC.Food AS varchar)||'_FOOD_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Food<3 
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_ADD_'||CAST(1 AS varchar)||'_FOOD_BBCC', 'YieldType', 'YIELD_FOOD'
	FROM BBCC
	WHERE Food<3 
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_ADD_'||CAST(1 AS varchar)||'_FOOD_BBCC', 'Amount', 1
	FROM BBCC
	WHERE Food<3 
		AND TerrainType NOT LIKE '%HILLS';
--prod
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(1 AS varchar)||'_PRODUCTION_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Prod<2 
		AND TerrainType LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_ADD_'||CAST(1 AS varchar)||'_PRODUCTION_BBCC', 'YieldType', 'YIELD_PRODUCTION'
	FROM BBCC
	WHERE Prod<2 
		AND TerrainType LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_ADD_'||CAST(1 AS varchar)||'_PRODUCTION_BBCC', 'Amount', 1
	FROM BBCC
	WHERE Prod<2 
		AND TerrainType LIKE '%HILLS';
--============Removing Excess Yields:============-----
--creating modifiers
--food
--flat
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Food-3 AS varchar)||'_FOOD_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Food>3 
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Food-3 AS varchar)||'_FOOD_BBCC', 'YieldType', 'YIELD_FOOD'
	FROM BBCC
	WHERE Food>3 
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Food-3 AS varchar)||'_FOOD_BBCC', 'Amount', 3-BBCC.Food
	FROM BBCC
	WHERE Food>3 
		AND TerrainType NOT LIKE '%HILLS';
--hill
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Food-2 AS varchar)||'_FOOD_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Food>2 
		AND TerrainType LIKE '%HILLS';
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Food-2 AS varchar)||'_FOOD_BBCC', 'YieldType', 'YIELD_FOOD'
	FROM BBCC
	WHERE Food>2
		AND TerrainType LIKE '%HILLS';
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Food-2 AS varchar)||'_FOOD_BBCC', 'Amount', 2-BBCC.Food
	FROM BBCC
	WHERE Food>2 
		AND TerrainType LIKE '%HILLS';
--prod
--hill
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Prod-2 AS varchar)||'_PRODUCTION_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Prod>2 
		AND TerrainType LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Prod-2 AS varchar)||'_PRODUCTION_BBCC', 'YieldType', 'YIELD_PRODUCTION'
	FROM BBCC
	WHERE Prod>2 
		AND TerrainType LIKE '%HILLS';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Prod-2 AS varchar)||'_PRODUCTION_BBCC', 'Amount', 2-BBCC.Prod
	FROM BBCC
	WHERE Prod>2 
		AND TerrainType LIKE '%HILLS';
--flat
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Prod-1 AS varchar)||'_PRODUCTION_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Prod>1 
		AND TerrainType NOT LIKE '%HILLS';
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Prod-1 AS varchar)||'_PRODUCTION_BBCC', 'YieldType', 'YIELD_PRODUCTION'
	FROM BBCC
	WHERE Prod>1 
		AND TerrainType NOT LIKE '%HILLS';
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Prod-1 AS varchar)||'_PRODUCTION_BBCC', 'Amount', 1-BBCC.Prod
	FROM BBCC
	WHERE Prod>1 
		AND TerrainType NOT LIKE '%HILLS';
--gold
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Gold AS varchar)||'_GOLD_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Gold>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Gold AS varchar)||'_GOLD_BBCC', 'YieldType', 'YIELD_GOLD'
	FROM BBCC
	WHERE Gold>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Gold AS varchar)||'_GOLD_BBCC', 'Amount', 0-BBCC.Gold
	FROM BBCC
	WHERE Gold>0;
--faith
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Faith AS varchar)||'_FAITH_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Faith>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Faith AS varchar)||'_FAITH_BBCC', 'YieldType', 'YIELD_FAITH'
	FROM BBCC
	WHERE Faith>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Faith AS varchar)||'_FAITH_BBCC', 'Amount', 0-BBCC.Faith
	FROM BBCC
	WHERE Faith>0;
--Culture
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Cult AS varchar)||'_CULTURE_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Cult>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Cult AS varchar)||'_CULTURE_BBCC', 'YieldType', 'YIELD_CULTURE'
	FROM BBCC
	WHERE Cult>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Cult AS varchar)||'_CULTURE_BBCC', 'Amount', 0-BBCC.Cult
	FROM BBCC
	WHERE Cult>0;
--Science
INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(BBCC.Sci AS varchar)||'_SCIENCE_BBCC', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'
	FROM BBCC
	WHERE Sci>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Sci AS varchar)||'_SCIENCE_BBCC', 'YieldType', 'YIELD_SCIENCE'
	FROM BBCC
	WHERE Sci>0;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT 
		'MODIFIER_REMOVE_'||CAST(BBCC.Sci AS varchar)||'_SCIENCE_BBCC', 'Amount', 0-BBCC.Sci
	FROM BBCC
	WHERE Sci>0;

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

INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount)
	SELECT Modifiers.ModifierId, yt, am
	FROM Modifiers 
	INNER JOIN (SELECT ModifierArguments.ModifierId as yt_mId, ModifierArguments.Value as yt FROM ModifierArguments WHERE ModifierArguments.Name = 'YieldType') 
		ON Modifiers.ModifierId = yt_mId
	INNER JOIN (SELECT ModifierArguments.ModifierId as am_mId, ModifierArguments.Value as am FROM ModifierArguments WHERE ModifierArguments.Name = 'Amount')
		ON Modifiers.ModifierId = am_mId
	WHERE ModifierId LIKE 'MODIFIER_REMOVE_%_BBCC' OR ModifierId LIKE 'MODIFIER_ADD_%_BBCC';

UPDATE BBCC_Modifiers SET SubjectRequirementSetId = REPLACE(ModifierId, 'MODIFIER_','REQSET_');
UPDATE BBCC_Modifiers SET InnerReqSet = REPLACE(ModifierId, 'MODIFIER_','REQSET_VALID_TFR_');

CREATE TABLE tmp(
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

INSERT INTO tmp
	SELECT * 
	FROM BBCC_Modifiers 
	INNER JOIN BBCC ON CASE
		

DROP TABLE dummy;

CREATE TABLE dummy AS
	SELECT DISTINCT 'REQSET_PLOT_IS_'||REPLACE(BBCC.TerrainType, 'TERRAIN_','')||'_CITY_BBCC' as ReqSet,
		CASE 
			WHEN 
				(BBCC.FeatureType IS NULL 
				OR BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=1))
				AND (BBCC.ResourceClassType<>'RESOURCECLASS_STRATEGIC' AND BBCC.ResourceType IS NOT NULL)
			THEN
				'REQ_HAS_NO_'||BBCC.ResourceType||'_BBCC'
			WHEN
				(BBCC.FeatureType IS NULL 
				OR BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=1))
				AND BBCC.ResourceClassType='RESOURCECLASS_STRATEGIC'
			THEN
				'REQ_HAS_NO_OR_SEES_NO_'||BBCC.ResourceType||'_BBCC'
			WHEN
				BBCC.FeatureType IS NOT NULL 
				AND BBCC.FeatureType IN (SELECT FeatureType FROM Features WHERE Removable=0)
			THEN
				'REQ_HAS_NO_'||BBCC.ResourceType||'_AND_'||BBCC.FeatureType||'_BBCC'
			ELSE
				'REQ_HAS_NO_'||BBCC.FeatureType||'_BBCC'
		END as Req, *
	FROM BBCC
		WHERE Prod>=2 AND TerrainType LIKE '%HILLS' AND TerrainType<>'TERRAIN_PLAINS_HILLS';