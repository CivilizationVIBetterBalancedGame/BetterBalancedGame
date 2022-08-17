------------------------------------------------------------------------------
--	FILE:	 new_bbg_cv_2.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				CV: FASTEST SETTINGS a.k.a Legacy BBG		  ******
--==============================================================================================

-- Reduce amount of tourism needed for foreign tourist from 200 to 150
UPDATE GlobalParameters SET Value='150' WHERE Name='TOURISM_TOURISM_TO_MOVE_CITIZEN';