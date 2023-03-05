INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
	('REQUIRES_OBJECT_1_OR_MORE_TILES_FROM_CAPITAL','REQUIREMENT_PLOT_NEAR_CAPITAL');
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('REQUIRES_OBJECT_1_OR_MORE_TILES_FROM_CAPITAL', 'MinDistance', '1');

--Disabling Mbande's effect on the capital city
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('REQUIRES_CITY_IS_SAME_CONTINENT', 'REQUIRES_OBJECT_1_OR_MORE_TILES_FROM_CAPITAL');