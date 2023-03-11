
--==================
-- Korea
--==================
-- Seowon gets +2 science base yield instead of 4, +1 for every 2 mines adjacent instead of 1 to 1
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='BaseDistrict_Science';
INSERT OR IGNORE INTO Adjacency_YieldChanges
	(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement)
	VALUES ('BBG_Mine_Science', 'LOC_DISTRICT_MINE_SCIENCE', 'YIELD_SCIENCE', 1, 2, 'IMPROVEMENT_MINE');
INSERT OR IGNORE INTO District_Adjacencies
	(DistrictType , YieldChangeId)
	VALUES ('DISTRICT_SEOWON', 'BBG_Mine_Science');
-- seowon gets +1 adjacency from theater squares instead of -1
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES
	('BBG_Theater_Science' , 'LOC_DISTRICT_SEOWON_THEATER_BONUS' , 'YIELD_SCIENCE' , '1' , '1' , 'DISTRICT_THEATER'),
	('BBG_Seowon_Culture'  , 'LOC_DISTRICT_THEATER_SEOWON_BONUS' , 'YIELD_CULTURE' , '1' , '1' , 'DISTRICT_SEOWON' );
INSERT OR IGNORE INTO District_Adjacencies (DistrictType , YieldChangeId)
	VALUES
	('DISTRICT_SEOWON'  , 'BBG_Theater_Science'),
	('DISTRICT_THEATER' , 'BBG_Seowon_Culture' );
-- Seowon bombs
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
	VALUES ('TRAIT_CIVILIZATION_THREE_KINGDOMS' , 'TRAIT_SEOWON_BOMB');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
	VALUES ('TRAIT_SEOWON_BOMB', 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('TRAIT_SEOWON_BOMB', 'DistrictType', 'DISTRICT_SEOWON');
--citizen yields
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' 		AND DistrictType='DISTRICT_SEOWON';