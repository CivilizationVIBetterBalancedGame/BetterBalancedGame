--==================
-- Byzantium
--==================
-- reduce combat bonus for holy cities
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='BYZANTIUM_COMBAT_HOLY_CITIES' AND Name='Amount';
-- remove dromon combat bonus
--DELETE FROM UnitAbilityModifiers WHERE ModifierId='DROMON_COMBAT_STRENGTH_AGAINST_UNITS';

-- Delete Byzantium religious spread (script will do it)
DELETE FROM Modifiers WHERE ModifierId='BYZANTIUM_PRESSURE_KILLS';

-- Reduce Tagma bonus to +2 (from +4)
UPDATE ModifierArguments SET Value=2 WHERE ModifierId='TAGMA_COMBAT_STRENGTH' AND Name='Amount';
UPDATE ModifierArguments SET Value=2 WHERE ModifierId='TAGMA_RELIGIOUS_COMBAT' AND Name='Amount';

-- 17/08/2022: fix bug where bonus is not working on gdr
DELETE FROM TypeTags WHERE Type='ABILITY_BYZANTIUM_COMBAT_UNITSABILITY_BYZANTIUM_COMBAT_UNITS';

INSERT OR IGNORE INTO TypeTags (Type , Tag) VALUES
	('ABILITY_BYZANTIUM_COMBAT_UNITS' ,'CLASS_ALL_COMBAT_UNITS');

--==================
-- Gaul
--==================
-- Start Bias
UPDATE StartBiasResources SET Tier=5 WHERE CivilizationType='CIVILIZATION_GAUL' AND ResourceType IN ('RESOURCE_COPPER', 'RESOURCE_DIAMONDS', 'RESOURCE_JADE', 'RESOURCE_MERCURY', 'RESOURCE_SALT', 'RESOURCE_SILVER');
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_GAUL' AND ResourceType='RESOURCE_IRON';
INSERT INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_GAUL', 'RESOURCE_STONE', '3'),
    ('CIVILIZATION_GAUL', 'RESOURCE_MARBLE', '3'),
    ('CIVILIZATION_GAUL', 'RESOURCE_GYPSUM', '3');
-- set citizen yields to same as other IZ
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' AND DistrictType='DISTRICT_OPPIDUM';
-- remove culture from unit production
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_GRANT_CULTURE_UNIT_TRAINED';
-- reduce king's combat bonus for adj units
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='AMBIORIX_NEIGHBOR_COMBAT' and Name='Amount';
-- remove ranged units from having kings combat bonus
DELETE FROM TypeTags WHERE Type='ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS' AND Tag='CLASS_RANGED';

-- 7/3/2021: Beta: Remove Apprenticeship free tech
DELETE FROM DistrictModifiers WHERE DistrictType='DISTRICT_OPPIDUM' AND ModifierId='OPPIDUM_GRANT_TECH_APPRENTICESHIP';

-- Delay culture to bronze working
UPDATE Modifiers SET OwnerRequirementSetId='BBG_PLAYER_HAS_BRONZE_WORKING_REQUIREMENTS' WHERE ModifierId='GAUL_MINE_CULTURE';

INSERT OR IGNORE INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('BBG_PLAYER_HAS_BRONZE_WORKING_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');

INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('BBG_PLAYER_HAS_BRONZE_WORKING_REQUIREMENTS', 'BBG_PLAYER_HAS_BRONZE_WORKING_REQUIREMENT');

INSERT OR IGNORE INTO Requirements(RequirementId , RequirementType) VALUES
	('BBG_PLAYER_HAS_BRONZE_WORKING_REQUIREMENT' , 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');

INSERT OR IGNORE INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('BBG_PLAYER_HAS_BRONZE_WORKING_REQUIREMENT' , 'TechnologyType', 'TECH_BRONZE_WORKING');

--==============================================================
--******                RELIGION                          ******
--==============================================================
--Monks: Gaul CS

INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS', 'CLASS_WARRIOR_MONK');

--==============================================================
--******                  WONDER                          ******
--==============================================================

--reduce statue of zeus from 50 to 35
UPDATE ModifierArguments SET Value=35 WHERE ModifierId='STAUEZEUS_ANTI_CAVALRY_PRODUCTION' AND Name='Amount';