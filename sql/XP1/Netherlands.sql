--==================
-- Netherlands
--==================
UPDATE Improvements SET ValidAdjacentTerrainAmount=2 WHERE ImprovementType='IMPROVEMENT_POLDER';
UPDATE Units SET StrategicResource='RESOURCE_NITER' WHERE UnitType='UNIT_DE_ZEVEN_PROVINCIEN';