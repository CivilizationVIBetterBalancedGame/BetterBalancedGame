------------------------------------------------------------------------------
--	FILE:	 config.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Config Database adjustment for front-end
------------------------------------------------------------------------------
--==============================================================================================
--******								ADDITIONAL CONFIG								******
--==============================================================================================

UPDATE Parameters SET Visible=0 WHERE Key2 IN ('RULESET_STANDARD', 'RULESET_EXPANSION_1', 'RULESET_EXPANSION_2') AND ConfigurationId='GAME_NO_BARBARIANS';

-- Separating description between Eleanors
UPDATE Players SET LeaderAbilityDescription='LOC_TRAIT_LEADER_ELEANOR_ENGLAND_LOYALTY_DESCRIPTION' WHERE LeaderType='LEADER_ELEANOR_ENGLAND';
UPDATE Players SET LeaderAbilityDescription='LOC_TRAIT_LEADER_ELEANOR_FRANCE_LOYALTY_DESCRIPTION' WHERE LeaderType='LEADER_ELEANOR_FRANCE';