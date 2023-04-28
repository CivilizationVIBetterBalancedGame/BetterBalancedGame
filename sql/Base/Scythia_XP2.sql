--==================
-- Scythia
--==================
-- Scythian horse cost 5 online speed
INSERT INTO Units_XP2(UnitType, ResourceCost) VALUES
    ('UNIT_SCYTHIAN_HORSE_ARCHER', 10);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_SCYTHIAN_HORSE_ARCHER';