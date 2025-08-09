-- move spies buffs to france and off catherine for eleanor france buff
UPDATE TraitModifiers SET TraitType='TRAIT_CIVILIZATION_WONDER_TOURISM' WHERE TraitType='FLYING_SQUADRON_TRAIT' AND ModifierId='UNIQUE_LEADER_ADD_SPY_CAPACITY';
UPDATE TraitModifiers SET TraitType='TRAIT_CIVILIZATION_WONDER_TOURISM' WHERE TraitType='FLYING_SQUADRON_TRAIT' AND ModifierId='UNIQUE_LEADER_ADD_SPY_UNIT';
UPDATE TraitModifiers SET TraitType='TRAIT_CIVILIZATION_WONDER_TOURISM' WHERE TraitType='FLYING_SQUADRON_TRAIT' AND ModifierId='UNIQUE_LEADER_SPIES_START_PROMOTED';

-- Bugfix: French spy extra promotion choice on changing cities.
UPDATE Modifiers SET ModifierType = 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', SubjectRequirementSetId = NULL WHERE ModifierId = 'UNIQUE_LEADER_SPIES_START_PROMOTED';
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_LEADER_SPIES_START_PROMOTED_CITY_ATTACH', 'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE', 'UNIT_IS_SPY');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_LEADER_SPIES_START_PROMOTED_CITY_ATTACH', 'Amount', '-1'),
	('UNIQUE_LEADER_SPIES_START_PROMOTED','ModifierId','BBG_LEADER_SPIES_START_PROMOTED_CITY_ATTACH');

-- Reduce tourism bonus for wonders
UPDATE ModifierArguments SET Value='150' WHERE ModifierId='TRAIT_WONDER_DOUBLETOURISM' AND Name='ScalingFactor';
-- Chateau now gives 1 housing at Feudalism, and ajacent luxes now give stacking Culture in addition to stacking gold
INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType , YieldType , YieldChange) VALUES
    ('IMPROVEMENT_CHATEAU' , 'YIELD_FOOD' , '1');
UPDATE Improvement_YieldChanges SET YieldChange = '1' WHERE YieldType = 'YIELD_CULTURE' AND ImprovementType = 'IMPROVEMENT_CHATEAU';
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType , YieldChangeId) VALUES
    ('IMPROVEMENT_CHATEAU' , 'BBG_Chateau_Luxury_Gold'),
	('IMPROVEMENT_CHATEAU' , 'BBG_Chateau_Luxury_Culture');
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentResourceClass) VALUES
	('BBG_Chateau_Luxury_Gold' , 'Placeholder' , 'YIELD_GOLD' , '1' , '1' , 'RESOURCECLASS_LUXURY'),
	('BBG_Chateau_Luxury_Culture' , 'Placeholder' , 'YIELD_CULTURE' , '1' , '1' , 'RESOURCECLASS_LUXURY');
UPDATE Improvements SET Housing=2, TilesRequired=2, PreReqCivic='CIVIC_FEUDALISM', RequiresAdjacentBonusOrLuxury=0, RequiresRiver=0, SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_CHATEAU';-- Garde imperial to +5 on continent (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='GARDE_CONTINENT_COMBAT' AND Name='Amount';
