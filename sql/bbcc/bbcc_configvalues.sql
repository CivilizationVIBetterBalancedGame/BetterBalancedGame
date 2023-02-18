CREATE TABLE Flat_CutOffYieldValues(
	YieldType TEXT NOT NULL, 
	Amount INT DEFAULT 0
);
INSERT INTO Flat_CutOffYieldValues(YieldType, Amount) VALUES
	('YIELD_FOOD', 3),
	('YIELD_PRODUCTION', 1),
	('YIELD_GOLD', 0),
	('YIELD_FAITH', 0),
	('YIELD_CULTURE', 0),
	('YIELD_SCIENCE', 0);
CREATE TABLE Hill_CutOffYieldValues(
	YieldType TEXT NOT NULL, 
	Amount INT DEFAULT 0
);
INSERT INTO Hill_CutOffYieldValues(YieldType, Amount) VALUES
	('YIELD_FOOD', 2),
	('YIELD_PRODUCTION', 2),
	('YIELD_GOLD', 0),
	('YIELD_FAITH', 0),
	('YIELD_CULTURE', 0),
	('YIELD_SCIENCE', 0);
CREATE TABLE Flat_SpecialTerrain(
	SubjectRequirementSetId TEXT,
	YieldType TEXT NOT NULL,
	TerrainType TEXT NOT NULL
);
CREATE TABLE Hill_SpecialTerrain(
	SubjectRequirementSetId TEXT,
	YieldType TEXT NOT NULL,
	TerrainType TEXT NOT NULL
);