CREATE TABLE BBCCRes(
	ResourceType TEXT NOT NULL,
	ResourceClassType TEXT NOT NULL,
	TerrainType TEXT,
	FeatureType TEXT,
	Food INT DEFAULT 0,
	Prod INT DEFAULT 0,
	Gold INT DEFAULT 0,
	Cult INT DEFAULT 0,
	Faith INT DEFAULT 0,
	Sci INT DEFAULT 0
);

INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
	SELECT 'REQ_HAS_NO_'||Resources.ResourceType||'_BBCC', 'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES', '1'
	FROM Resources WHERE (ResourceClassType<>'RESOURCECLASS_ARTIFACT' AND SeaFrequency=0) OR ResourceType='RESOURCE_OIL' OR ResourceType='RESOURCE_AMBER';

INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_HAS_NO_'||Resources.ResourceType||'_BBCC', 'ResourceType', Resources.ResourceType
	FROM Resources WHERE (ResourceClassType<>'RESOURCECLASS_ARTIFACT' AND SeaFrequency=0) OR ResourceType='RESOURCE_OIL' OR ResourceType='RESOURCE_AMBER';

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

INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQ_PLOT_IS_CITY_CENTER_BBCC' , 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES'),
    ('REQ_PLOT_HAS_GRASS_BBCC','REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES'),
    ('REQ_PLOT_HAS_PLAINS_BBCC','REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQ_PLOT_IS_CITY_CENTER_BBCC' , 'DistrictType', 'DISTRICT_CITY_CENTER'),
    ('REQ_PLOT_HAS_GRASS_BBCC','TerrainType','TERRAIN_GRASS'),
    ('REQ_PLOT_HAS_PLAINS_BBCC','TerrainType','TERRAIN_PLAINS');

INSERT INTO BBCCRes(ResourceType, ResourceClassType, TerrainType)
	SELECT Resources.ResourceType, Resources.ResourceClassType, Resource_ValidTerrains.TerrainType
	FROM Resources INNER JOIN Resource_ValidTerrains
	ON Resources.ResourceType = Resource_ValidTerrains.ResourceType
	WHERE ((Resources.ResourceClassType<>'RESOURCECLASS_ARTIFACT' AND Resources.SeaFrequency=0) OR Resources.ResourceType='RESOURCE_OIL' OR Resources.ResourceType='RESOURCE_AMBER') AND Resource_ValidTerrains.TerrainType<>'TERRAIN_COAST';

INSERT INTO BBCCRes(ResourceType, ResourceClassType, TerrainType, FeatureType)
	SELECT Resources.ResourceType, Resources.ResourceClassType, tt, ft
	FROM Resources INNER JOIN
		(SELECT Resource_ValidFeatures.ResourceType as rt, Feature_ValidTerrains.TerrainType as tt, Feature_ValidTerrains.FeatureType as ft 
		FROM Resource_ValidFeatures INNER JOIN Feature_ValidTerrains
		ON Resource_ValidFeatures.FeatureType = Feature_ValidTerrains.FeatureType)
	ON Resources.ResourceType = rt
	WHERE (Resources.ResourceClassType<>'RESOURCECLASS_ARTIFACT' AND Resources.SeaFrequency=0) OR Resources.ResourceType='RESOURCE_OIL' OR Resources.ResourceType='RESOURCE_AMBER';

--DELETE FROM BBCCRes WHERE FeatureType='FEATURE_JUNGLE' AND TerrainType IN ('TERRAIN_GRASS', 'TERRAIN_GRASS_HILLS');
