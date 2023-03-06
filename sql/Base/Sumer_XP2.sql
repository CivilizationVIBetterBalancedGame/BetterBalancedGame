------------------------------------------------------------------------------
--	FILE:	 new_bbg_sumer_xp2.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database Civilization related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				SUMER	XP2					   ******
--==============================================================================================

-- Ziggurat buff
INSERT INTO Improvements_XP2
		(ImprovementType,				DisasterResistant)
VALUES	('IMPROVEMENT_ZIGGURAT',		1);

-- Start Bias
INSERT INTO StartBiasFeatures(CivilizationType, FeatureType, Tier) VALUES
    ('CIVILIZATION_SUMERIA', 'FEATURE_FLOODPLAINS_PLAINS', '4'),
    ('CIVILIZATION_SUMERIA', 'FEATURE_FLOODPLAINS_GRASSLAND', '4');

-- StartBiasFeatures add Floodplains
-- BETA Remove the Floodplains Bias
--INSERT INTO StartBiasFeatures
--		(CivilizationType,					FeatureType,						Tier)
--VALUES	('CIVILIZATION_SUMERIA',			'FEATURE_FLOODPLAINS',				3),
--		('CIVILIZATION_SUMERIA',			'FEATURE_FLOODPLAINS_GRASSLAND',	3),
--		('CIVILIZATION_SUMERIA',			'FEATURE_FLOODPLAINS_PLAINS',		3);

