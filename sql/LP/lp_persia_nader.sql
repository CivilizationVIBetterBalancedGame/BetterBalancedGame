--OPPONENT_IS_NOT_DISTRICT was introduced by firaxis in Gaul Byz recreate
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType, Inverse) VALUES
	('OPPONENT_IS_NOT_DISTRICT', 'REQUIREMENT_OPPONENT_IS_DISTRICT', 1);
--actual change
INSERT INTO RequirementSetRequirements VALUES
	('OPPONENT_IS_FULL_HEALTH_REQUIREMENTS', 'OPPONENT_IS_NOT_DISTRICT');