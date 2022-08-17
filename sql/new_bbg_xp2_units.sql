------------------------------------------------------------------------------
--	FILE:	 new_bbg_xp2_units.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database leader related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******						STANDARD UNITS FROM GS 										******
--==============================================================================================
-- Jack the Ripper proposal (31/12/2020) to boost Naval Movement
-- Resource cost / Maintenance is 1 in GS
UPDATE Units_XP2 SET ResourceCost=0 WHERE  UnitType='UNIT_SUBMARINE';
UPDATE Units_XP2 SET ResourceMaintenanceAmount=0 WHERE  UnitType='UNIT_SUBMARINE';
UPDATE Units SET StrategicResource=NULL WHERE UnitType='UNIT_SUBMARINE';
UPDATE Units_XP2 SET ResourceMaintenanceType=NULL WHERE  UnitType='UNIT_SUBMARINE';



-- 23/04/2021: Implemented by Firaxis
--UPDATE Units_XP2 SET ResourceCost='0' WHERE  UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units_XP2 SET ResourceMaintenanceAmount='0' WHERE  UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units SET StrategicResource=NULL WHERE UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units_XP2 SET ResourceMaintenanceType=NULL WHERE  UnitType='UNIT_GERMAN_UBOAT';