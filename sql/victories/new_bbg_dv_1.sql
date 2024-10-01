------------------------------------------------------------------------------
--	FILE:	 new_bbg_dv_1.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				DV: FAST SETTINGS		 		 ******
--==============================================================================================

UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_DIPLOVICTORY';
