--==================
-- America
--==================
-- rough rider is a cav replacement, so should cost horses
INSERT OR IGNORE INTO Units_XP2 (UnitType, ResourceCost)
    VALUES ('UNIT_AMERICAN_ROUGH_RIDER', 10);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_AMERICAN_ROUGH_RIDER';

DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_AMERICA' AND TerrainType IN ('TERRAIN_DESERT_MOUNTAIN', 'TERRAIN_TUNDRA_MOUNTAIN');
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_AMERICA' AND TerrainType IN ('TERRAIN_GRASS_MOUNTAIN', 'TERRAIN_PLAINS_MOUNTAIN');