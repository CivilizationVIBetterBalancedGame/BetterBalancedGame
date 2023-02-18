
--5.2.5 Musketman/Line infantry buff
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_LINE_INFANTRY';
UPDATE Units SET Cost=220 WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units SET Cost=330 WHERE UnitType='UNIT_LINE_INFANTRY';

--5.2.5 Set heavy chariot cost 5 iron
INSERT OR IGNORE INTO Units_XP2 (UnitType , ResourceCost  , ResourceMaintenanceAmount , ResourceMaintenanceType)
    VALUES ('UNIT_HEAVY_CHARIOT' , 10 , 0, 'RESOURCE_IRON');
UPDATE Units SET StrategicResource='RESOURCE_IRON' WHERE UnitType='UNIT_HEAVY_CHARIOT';