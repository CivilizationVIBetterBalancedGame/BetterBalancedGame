UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CAVALRY' WHERE Unit='UNIT_MAPUCHE_MALON_RAIDER';
-- 20/12/14 Chemamull's now allowed on volcanic soil
INSERT OR IGNORE INTO Improvement_ValidFeatures (ImprovementType, FeatureType)
	VALUES ('IMPROVEMENT_CHEMAMULL', 'FEATURE_VOLCANIC_SOIL');