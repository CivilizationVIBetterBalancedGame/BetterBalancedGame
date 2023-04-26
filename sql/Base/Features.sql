-- 25/04/23 reverted
-- UPDATE Features SET RemoveTech='TECH_MINING' WHERE FeatureType='FEATURE_JUNGLE';



--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- great barrier reef gives +2 science adj
-- INSERT OR IGNORE INTO District_Adjacencies VALUES
--	('DISTRICT_CAMPUS', 'BarrierReef_Science');
--INSERT OR IGNORE INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentFeature) VALUES
--	('BarrierReef_Science', 'LOC_DISTRICT_REEF_SCIENCE', 'YIELD_SCIENCE', 2, 1, 'FEATURE_BARRIER_REEF');
-- Several lack-luster wonders improved
UPDATE Features SET Settlement=1 WHERE FeatureType='FEATURE_CLIFFS_DOVER';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CLIFFS_DOVER', 'YIELD_FOOD', 2);

INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_PANTANAL', 'YIELD_SCIENCE', 2);

INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_DEAD_SEA', 'YIELD_FOOD', 2);

INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CRATER_LAKE', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_CRATER_LAKE' AND YieldType='YIELD_SCIENCE'; 

INSERT OR IGNORE INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_GALAPAGOS', 'YIELD_FOOD', 1);

-- Tsingy
INSERT INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange) VALUES
    ('FEATURE_TSINGY', 'YIELD_FOOD', 1);

-- Pantanal
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange) VALUES
    ('FEATURE_PANTANAL', 'YIELD_PRODUCTION', 1);

-- Everest
UPDATE Feature_AdjacentYields SET YieldChange=3 WHERE FeatureType='FEATURE_EVEREST';

-- Barrier Reef
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange) VALUES
    ('FEATURE_BARRIER_REEF', 'YIELD_PRODUCTION', 1);


