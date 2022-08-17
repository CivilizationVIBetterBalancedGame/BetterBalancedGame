-- Author: iElden
-- Making this is like spain but s is silent

-- Spain got coastal bias again
INSERT INTO StartBiasTerrains(CivilizationType, TerrainType, Tier) VALUES
    ('CIVILIZATION_SPAIN', 'TERRAIN_COAST', 1);

-- Give x2 yield instead of x3
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRAIT_INTERCONTINENTAL_INTERNATIONAL_FAITH' AND Name='Amount';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TRAIT_INTERCONTINENTAL_INTERNATIONAL_GOLD' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_INTERCONTINENTAL_INTERNATIONAL_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRAIT_INTERCONTINENTAL_DOMESTIC_FAITH' AND Name='Amount';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TRAIT_INTERCONTINENTAL_DOMESTIC_GOLD' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_INTERCONTINENTAL_DOMESTIC_PRODUCTION' AND Name='Amount';

-- ==== MISSIONS ====
-- missions get +1 housing on home continent
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
	('REQUIRES_PLOT_IS_OWNER_CAPITAL_CONTINENT_BBG', 'REQUIREMENT_PLOT_IS_OWNER_CAPITAL_CONTINENT');
INSERT OR IGNORE INTO RequirementSets VALUES
	('PLOT_CAPITAL_CONTINENT_REQUIREMENTS_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements VALUES
	('PLOT_CAPITAL_CONTINENT_REQUIREMENTS_BBG', 'REQUIRES_PLOT_IS_OWNER_CAPITAL_CONTINENT_BBG');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('MISSION_HOMECONTINENT_HOUSING_BBG' , 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING', 'PLOT_CAPITAL_CONTINENT_REQUIREMENTS_BBG');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('MISSION_HOMECONTINENT_HOUSING_BBG' , 'Amount' , 1);
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_MISSION' , 'MISSION_HOMECONTINENT_HOUSING_BBG');
-- Missions cannot be placed next to each other
UPDATE Improvements SET SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_MISSION';
-- Missions moved to Theology
UPDATE Improvements SET PrereqTech=NULL, PrereqCivic='CIVIC_THEOLOGY' WHERE ImprovementType='IMPROVEMENT_MISSION';
-- Missions get bonus science at Enlightenment instead of cultural heritage
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_THE_ENLIGHTENMENT' WHERE Id='17';



-- Can make fleet with shipyard.
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId) VALUES
    ('BBG_SPAIN_FLEET_DISCOUNT', 'MODIFIER_CITY_CORPS_ARMY_ADJUST_DISCOUNT', 'BBG_PLAYER_IS_SPAIN');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_SPAIN_FLEET_DISCOUNT', 'UnitDomain', 'DOMAIN_SEA'),
    ('BBG_SPAIN_FLEET_DISCOUNT', 'Amount', '25');

INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_SHIPYARD', 'BBG_SPAIN_FLEET_DISCOUNT');

-- Leader is Phillipe Requirement.
INSERT OR IGNORE INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('BBG_PLAYER_IS_SPAIN', 'REQUIREMENTSET_TEST_ANY');

INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('BBG_PLAYER_IS_SPAIN', 'BBG_PLAYER_IS_SPAIN_REQUIREMENT');

INSERT OR IGNORE INTO Requirements(RequirementId , RequirementType) VALUES
	('BBG_PLAYER_IS_SPAIN_REQUIREMENT' , 'REQUIREMENT_PLAYER_TYPE_MATCHES');

INSERT OR IGNORE INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('BBG_PLAYER_IS_SPAIN_REQUIREMENT' , 'CivilizationType', 'CIVILIZATION_SPAIN');