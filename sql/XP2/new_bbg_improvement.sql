-- Created by: iElden

-- Geothermal plant
UPDATE Improvements SET PrereqTech='TECH_CHEMISTRY', PlunderType='PLUNDER_SCIENCE' WHERE ImprovementType='IMPROVEMENT_GEOTHERMAL_PLANT';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GEOTHERMAL_GENERATE_POWER' AND Name='Amount';
INSERT INTO Improvement_BonusYieldChanges(Id, ImprovementType, YieldType, BonusYieldChange, PrereqTech) VALUES
    (3010, 'IMPROVEMENT_GEOTHERMAL_PLANT', 'YIELD_PRODUCTION', 1, 'TECH_SYNTHETIC_MATERIALS'),
    (3011, 'IMPROVEMENT_GEOTHERMAL_PLANT', 'YIELD_SCIENCE', 1, 'TECH_SYNTHETIC_MATERIALS');
INSERT INTO Modifiers(ModifierId, ModifierType, RunOnce, Permanent, SubjectRequirementSetId) VALUES
    ('BBG_GEOTHERMAL_GENERATE_POWER_SYNTHETIC', 'MODIFIER_SINGLE_CITY_ADJUST_FREE_POWER', 0, 0, 'BBG_PLAYER_HAVE_SYNTHETIC_MATERIALS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GEOTHERMAL_GENERATE_POWER_SYNTHETIC', 'Amount', '3'),
    ('BBG_GEOTHERMAL_GENERATE_POWER_SYNTHETIC', 'SourceType', 'FREE_POWER_SOURCE_GEOTHERMAL');
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('BBG_PLAYER_HAVE_SYNTHETIC_MATERIALS', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('BBG_PLAYER_HAVE_SYNTHETIC_MATERIALS', 'BBG_PLAYER_HAVE_SYNTHETIC_MATERIALS_REQUIREMENT');
INSERT INTO Requirements(RequirementId , RequirementType) VALUES
	('BBG_PLAYER_HAVE_SYNTHETIC_MATERIALS_REQUIREMENT' , 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('BBG_PLAYER_HAVE_SYNTHETIC_MATERIALS_REQUIREMENT' , 'TechnologyType', 'TECH_SYNTHETIC_MATERIALS');

INSERT INTO ImprovementModifiers(ImprovementType, ModifierID) VALUES
    ('IMPROVEMENT_GEOTHERMAL_PLANT', 'BBG_GEOTHERMAL_GENERATE_POWER_SYNTHETIC');

-- Plantation +1 production if on flat tile
-- REQUIRES_PLOT_IS_FLAT defined in Nasca line
INSERT INTO Modifiers(ModifierId, ModifierType, RunOnce, Permanent, SubjectRequirementSetId) VALUES
    ('BBG_PLANTATION_PROD_FLAT_TILE', 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 0, 0, 'BBG_PLOT_IS_FLAT');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_PLANTATION_PROD_FLAT_TILE', 'Amount', '1'),
    ('BBG_PLANTATION_PROD_FLAT_TILE', 'YieldType', 'YIELD_PRODUCTION');
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('BBG_PLOT_IS_FLAT', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('BBG_PLOT_IS_FLAT', 'REQUIRES_PLOT_IS_FLAT');

INSERT INTO ImprovementModifiers(ImprovementType, ModifierID) VALUES
    ('IMPROVEMENT_PLANTATION', 'BBG_PLANTATION_PROD_FLAT_TILE');

-- 05/10/22 railroad from 1 coal 1 iron to 2 irons
-- 16/04/23 from 2 irons to 1
DELETE FROM Route_ResourceCosts WHERE RouteType='ROUTE_RAILROAD' and ResourceType='RESOURCE_COAL';
-- UPDATE Route_ResourceCosts SET BuildwithUnitCost=2 WHERE RouteType='ROUTE_RAILROAD' and ResourceType='RESOURCE_IRON';