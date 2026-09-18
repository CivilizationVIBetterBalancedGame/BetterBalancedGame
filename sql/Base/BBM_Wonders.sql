--=======================================================================
--******                          WONDERS                          ******
--=======================================================================
--need to run after bbm as this is an update and not and insert
-- 14/07/26 Lac Victoria : +1 food
DELETE FROM Feature_YieldChanges WHERE FeatureType='FEATURE_LAKE_VICTORIA' AND YieldType='YIELD_FOOD';
INSERT INTO Feature_YieldChanges(FeatureType, YieldType, YieldChange) VALUES
	('FEATURE_LAKE_VICTORIA', 'YIELD_FOOD', 3);

	
-- 14/07/26 Rock of Gibraltar : +1 prod 
INSERT INTO Feature_AdjacentYields(FeatureType, YieldType, YieldChange) VALUES
	('FEATURE_GIBRALTAR', 'YIELD_PRODUCTION', 1);


-- 17/07/26 StartBias no jungle
-- in bbm only
INSERT INTO StartBiasNegatives(CivilizationType, FeatureType, Tier) VALUES
    ('CIVILIZATION_NORWAY', 'FEATURE_JUNGLE', 4);

-- 18/09/26 Namib : more yield but no bonus movement
DELETE FROM GameModifiers WHERE ModifierId='NAMIB_UNITS_GRANT_ABILITY';
INSERT INTO Feature_YieldChanges(FeatureType, YieldType, YieldChange) VALUES
	('FEATURE_NAMIB', 'YIELD_FOOD', 2);