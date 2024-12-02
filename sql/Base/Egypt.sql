--=============================================
--=                 EGYPT                     =
--=============================================

-- wonder and district on rivers bonus increased to 25%
-- 05/03/2024 nerf bonus on river 25% -> 20%
-- 02/12/24 reduced to 15% with Egypt changes
UPDATE ModifierArguments SET Value=15 WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_WONDER';
UPDATE ModifierArguments SET Value=15 WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_DISTRICT';
--
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('BBG_REQUIRES_PLOT_HAS_FLOODPLAINS', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('BBG_REQUIRES_PLOT_HAS_FLOODPLAINS', 'REQUIRES_PLOT_HAS_FLOODPLAINS');
-- Sphinx base Faith Increased to 2 (from 1)
UPDATE Improvement_YieldChanges SET YieldChange=2 WHERE ImprovementType='IMPROVEMENT_SPHINX' AND YieldType='YIELD_FAITH';
-- +1 Faith and +1 Culture if adjacent to a wonder, instead of 2 Faith.
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='SPHINX_WONDERADJACENCY_FAITH' AND Name='Amount';
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' , 'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'YieldType' , 'YIELD_CULTURE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'Amount' , 1);
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_WONDERADJACENCY_CULTURE_CPLMOD');
-- Increased +1 Culture moved to Diplomatic Service (Was Natural History)
UPDATE Improvement_BonusYieldChanges SET PrereqCivic = 'CIVIC_DIPLOMATIC_SERVICE' WHERE Id = 18;
-- Now grants 1 food and 1 production on desert tiles without floodplains. Go Go Gadget bad-start fixer.
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_FOOD_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_FOOD_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_PRODUCTION_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER');
-- No prod nor food bonus on Floodplains
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
-- Requires Desert or Desert Hills
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');

--=============================================
--=               CLEOPATRA                   =
--=============================================

--14/07/2022: Egypt 6 golds per international traderoutes instead of 4
-- 02/12/24 reverted
-- UPDATE ModifierArguments SET Value='6' WHERE ModifierId='TRAIT_INTERNATIONAL_TRADE_GAIN_GOLD' AND Name='Amount';
-- 02/12/24 food reduced to 1
UPDATE ModifierArguments SET Value=1 WHERE ModifierId='TRAIT_INCOMING_TRADE_OFFER_FOOD' AND Name='Amount';

-- 02/12/24 bonus production doubled when city is settled on river for com hub and iz
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_CLEO_FASTER_HUB_RIVER', 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION', 'PLOT_ADJACENT_TO_RIVER_REQUIREMENTS'),
	('BBG_CLEO_FASTER_IZ_RIVER', 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION', 'PLOT_ADJACENT_TO_RIVER_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_CLEO_FASTER_HUB_RIVER', 'DistrictType', 'DISTRICT_COMMERCIAL_HUB'),
	('BBG_CLEO_FASTER_HUB_RIVER', 'Amount', 15),
	('BBG_CLEO_FASTER_IZ_RIVER', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE'),
	('BBG_CLEO_FASTER_IZ_RIVER', 'Amount', 15);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_LEADER_MEDITERRANEAN', 'BBG_CLEO_FASTER_HUB_RIVER'),
	('TRAIT_LEADER_MEDITERRANEAN', 'BBG_CLEO_FASTER_IZ_RIVER');

