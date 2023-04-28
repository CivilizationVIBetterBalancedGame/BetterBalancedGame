--==============================================================
--******			 	  CITY-STATES		 		  	  ******
--==============================================================
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_UNIQUE_INFLUENCE_ARMORY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_ARMORY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_UNIQUE_INFLUENCE_MILITARY_ACADEMY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_MILITARY_ACADEMY_IDENTITY_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='MINOR_CIV_PRESLAV_BARRACKS_STABLE_IDENTITY_BONUS';
UPDATE ModifierArguments SET Value='40' WHERE ModifierId='MINOR_CIV_PRESLAV_BARRACKS_STABLE_IDENTITY_BONUS' AND Name='Amount';

--==============================================================
--******				PANTHEONS					  ******
--==============================================================
-- Lady of the Reeds and Marshes now applies ubsunur
INSERT OR IGNORE INTO RequirementSetRequirements 
    (RequirementSetId              , RequirementId)
    VALUES 
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'    );
INSERT OR IGNORE INTO Requirements 
    (RequirementId                          , RequirementType)
    VALUES 
    ('REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'     , 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments 
    (RequirementId                          , Name          , Value)
    VALUES 
    ('REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'     , 'FeatureType' , 'FEATURE_UBSUNUR_HOLLOW'       );

--==============================================================
--******                RELIGION                          ******
--==============================================================


--==============================================================
--******				START BIASES					  ******
--==============================================================
-- UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_NETHERLANDS' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_MONGOLIA' AND ResourceType='RESOURCE_HORSES';
-- UPDATE StartBiasRivers SET Tier=3 WHERE CivilizationType='CIVILIZATION_NETHERLANDS';
INSERT INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_GEORGIA', 'RESOURCE_STONE', '4'),
    ('CIVILIZATION_GEORGIA', 'RESOURCE_MARBLE', '4'),
    ('CIVILIZATION_GEORGIA', 'RESOURCE_GYPSUM', '4');
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_GRASS_HILLS';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType IN ('TERRAIN_DESERT_HILLS', 'TERRAIN_TUNDRA_HILLS');
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_PLAINS_MOUNTAIN';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_GRASS_MOUNTAIN';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType IN ('TERRAIN_DESERT_MOUNTAIN', 'TERRAIN_TUNDRA_MOUNTAIN');



--==============================================================
--******			W O N D E R S  (MAN-MADE)			  ******
--==============================================================


--==============================================================
--******				    O T H E R					  ******
--==============================================================








