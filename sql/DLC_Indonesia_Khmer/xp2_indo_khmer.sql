--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Indonesia
--==================
-- Jongs cost Niter
INSERT OR IGNORE INTO Units_XP2 (UnitType , ResourceCost)
	VALUES ('UNIT_INDONESIAN_JONG' , 10);
UPDATE Units SET StrategicResource ='RESOURCE_NITER'  WHERE UnitType='UNIT_INDONESIAN_JONG';




