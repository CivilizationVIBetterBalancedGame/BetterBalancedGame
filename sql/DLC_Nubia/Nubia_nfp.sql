
-- 13/01/25 diplo quarter give 1 culture/2 gold to pyramids
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_PYRAMID_DIPLO_CULTURE', 'Placeholder', 'YIELD_CULTURE', 1, 1, 'DISTRICT_DIPLOMATIC_QUARTER'),
    ('BBG_PYRAMID_DIPLO_GOLD', 'Placeholder', 'YIELD_GOLD', 2, 1, 'DISTRICT_DIPLOMATIC_QUARTER');

INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_DIPLO_CULTURE'),
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_DIPLO_GOLD');