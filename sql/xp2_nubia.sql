--==========
-- Nubia
--==========
INSERT OR IGNORE INTO Improvement_ValidFeatures (ImprovementType , FeatureType)
	VALUES
	('IMPROVEMENT_PYRAMID' , 'FEATURE_FLOODPLAINS_GRASSLAND'),
	('IMPROVEMENT_PYRAMID' , 'FEATURE_FLOODPLAINS_PLAINS');



--==============================================================
--******			W O N D E R S  (MAN-MADE)			  ******
--==============================================================
-- Jebel Barkal bugfix
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='JEBELBARKAL_GRANT_FOUR_IRON_PER_TURN' AND Name='Amount';



