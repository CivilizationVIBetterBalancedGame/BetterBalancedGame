-- Maple Plantation plainesprairecollines/plaines/prairies 1 gold 1 food
-- Opal Mine desertplainestundracollines/plaines 3 gold
-- Papyrus Plantation Marais/inondables 1 science
-- Penguins Camp plainesprairiestundracollines/plaines/prairies/tundra 1 science
-- Plums Plantation plainesprairies/prairiescollines 1 food 1 culture
-- Pomegranates plantations Plaines/plainescollines/inondablesplainesprairies/prairies 1 food 1 faith


INSERT INTO Resource_ValidTerrains (ResourceType, TerrainType) VALUES
    ('RESOURCE_P0K_PENGUINS', 'TERRAIN_SNOW_HILLS'),
    ('RESOURCE_P0K_PENGUINS', 'TERRAIN_SNOW'),
    ('RESOURCE_P0K_PENGUINS', 'TERRAIN_DESERT'),
    ('RESOURCE_P0K_PENGUINS', 'TERRAIN_DESERT_HILLS'),
    ('RESOURCE_P0K_PENGUINS', 'TERRAIN_COAST');
INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES
    ('RESOURCE_P0K_PENGUINS', 'YIELD_FOOD', 1);

-- There is a custom spawn for Penguins in BBM, thanks to BaNiPouZ
UPDATE Resources SET AdjacentToLand=1, SeaFrequency=1 WHERE ResourceType='RESOURCE_P0K_PENGUINS';

INSERT INTO Improvement_ValidResources (ImprovementType, ResourceType, MustRemoveFeature) VALUES
    ('IMPROVEMENT_FISHING_BOATS', 'RESOURCE_P0K_PENGUINS', 1);

INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES
    ('RESOURCE_P0K_PAPYRUS', 'YIELD_PRODUCTION', 1);