------------------------------------------------------------------------------
--	FILE:	 new_bbg_rv_2.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				RV: FASTEST SETTINGS 	 			 ******
--==============================================================================================

UPDATE GlobalParameters SET Value='13' WHERE Name='RELIGION_SPREAD_ADJACENT_CITY_DISTANCE';
