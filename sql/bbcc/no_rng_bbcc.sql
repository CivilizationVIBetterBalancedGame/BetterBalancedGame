UPDATE BBCCRes SET Food=2 WHERE TerrainType IN ('TERRAIN_GRASS','TERRAIN_GRASS_HILLS');
UPDATE BBCCRes SET Food=2 WHERE TerrainType = 'TERRAIN_DESERT' AND FeatureType='FEATURE_FLOODPLAINS';
UPDATE BBCCRes SET Food=1 WHERE TerrainType IN ('TERRAIN_PLAINS', 'TERRAIN_PLAINS_HILLS', 'TERRAIN_TUNDRA', 'TERRAIN_TUNDRA_HILLS');
UPDATE BBCCRes SET Prod=1 WHERE TerrainType IN ('TERRAIN_PLAINS','TERRAIN_GRASS_HILLS', 'TERRAIN_DESERT_HILLS', 'TERRAIN_TUNDRA_HILLS', 'TERRAIN_DESERT_HILLS');
UPDATE BBCCRes SET Prod=2 WHERE TerrainType = 'TERRAIN_PLAINS_HILLS'; 
UPDATE BBCCRes SET Food = BBCCRes.Food + Resource_YieldChanges.YieldChange
FROM Resource_YieldChanges WHERE YieldType = 'YIELD_FOOD' AND BBCCRes.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCCRes SET Prod = BBCCRes.Prod + Resource_YieldChanges.YieldChange
FROM Resource_YieldChanges WHERE YieldType = 'YIELD_PRODUCTION' AND BBCCRes.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCCRes SET Gold = BBCCRes.Gold + Resource_YieldChanges.YieldChange
FROM Resource_YieldChanges WHERE YieldType = 'YIELD_GOLD' AND BBCCRes.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCCRes SET Faith = BBCCRes.Faith + Resource_YieldChanges.YieldChange
FROM Resource_YieldChanges WHERE YieldType = 'YIELD_FAITH' AND BBCCRes.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCCRes SET Cult = BBCCRes.Cult + Resource_YieldChanges.YieldChange
FROM Resource_YieldChanges WHERE YieldType = 'YIELD_CULTURE' AND BBCCRes.ResourceType = Resource_YieldChanges.ResourceType;
UPDATE BBCCRes SET Sci = BBCCRes.Sci + Resource_YieldChanges.YieldChange
FROM Resource_YieldChanges WHERE YieldType = 'YIELD_SCIENCE' AND BBCCRes.ResourceType = Resource_YieldChanges.ResourceType;

INSERT INTO Requirements(RequirementId, RequirementType, Inverse) VALUES
	('REQ_PLOT_HAS_NO_FEATURE_FLOODPLAINS_BBCC', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES', '1'),
	('REQ_PLOT_HAS_NO_FEATURE_FLOODPLAINS_PLAINS_BBCC', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES', '1'),
	('REQ_PLOT_HAS_NO_FEATURE_FLOODPLAINS_GRASSLAND', '')