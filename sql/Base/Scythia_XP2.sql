--==================
-- Scythia
--==================
-- Scythian horse cost 5 online speed
INSERT INTO Units_XP2(UnitType, ResourceCost) VALUES
    ('UNIT_SCYTHIAN_HORSE_ARCHER', 10);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_SCYTHIAN_HORSE_ARCHER';

-- 02/07/24 nerf kurgan (no base faith)
UPDATE Improvement_YieldChanges SET YieldChange=0 WHERE ImprovementType='IMPROVEMENT_KURGAN' AND YieldType='YIELD_FAITH';
