
-- 08/03/24 Granada's Alcazar buff
-- +1 culture per adjacent encampment/Ikanda/Than
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_ALCAZAR_CULTURE_THANH', 'LOC_BBG_ALCAZAR_CULTURE_ENCAMPMENT', 'YIELD_CULTURE', 1, 1, 'DISTRICT_THANH');
INSERT INTO Improvement_Adjacencies(ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_ALCAZAR', 'BBG_ALCAZAR_CULTURE_IKANDA'),
    ('IMPROVEMENT_ALCAZAR', 'BBG_ALCAZAR_CULTURE_THANH');