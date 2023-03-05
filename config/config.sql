------------------------------------------------------------------------------
--	FILE:	 config.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Config Database adjustment for front-end
------------------------------------------------------------------------------
--==============================================================================================
--******								ADDITIONAL CONFIG								******
--==============================================================================================

UPDATE Parameters SET Visible=0 WHERE Key2 IN ('RULESET_STANDARD', 'RULESET_EXPANSION_1', 'RULESET_EXPANSION_2') AND ConfigurationId='GAME_NO_BARBARIANS';

