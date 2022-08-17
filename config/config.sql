------------------------------------------------------------------------------
--	FILE:	 config.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Config Database adjustment for front-end
------------------------------------------------------------------------------
--==============================================================================================
--******								ADDITIONAL CONFIG								******
--==============================================================================================

UPDATE Parameters SET Visible=0 WHERE Key2 IN ('RULESET_STANDARD', 'RULESET_EXPANSION_1', 'RULESET_EXPANSION_2') AND ConfigurationId='GAME_NO_BARBARIANS';

-- Beta
INSERT INTO Parameters(ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, SortIndex) VALUES
    ('BETA_BAN_TRADE_TREATY', 'LOC_BBG_FRONT_BETA_BAN_TRADE_TREATY_NAME', 'LOC_BBG_FRONT_BETA_BAN_TRADE_TREATY_DESC', 'bool', '0', 'Game', 'BETA_BAN_TRADE_TREATY', 'AdvancedOptions', '20000');
