
-- 08/03/24 Granada's Alcazar buff
-- +1 culture per adjacent Ikanda
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_ALCAZAR_CULTURE_IKANDA', 'LOC_BBG_ALCAZAR_CULTURE_ENCAMPMENT', 'YIELD_CULTURE', 1, 1, 'DISTRICT_IKANDA');
INSERT INTO Improvement_Adjacencies(ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_ALCAZAR', 'BBG_ALCAZAR_CULTURE_IKANDA');