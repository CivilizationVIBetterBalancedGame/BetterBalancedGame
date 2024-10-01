------------------------------------------------------------------------------
--	FILE:	 new_bbg_dv_2.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				DV: FASTEST SETTINGS a.k.a Legacy BBG		  ******
--==============================================================================================

UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_DIPLOVICTORY';