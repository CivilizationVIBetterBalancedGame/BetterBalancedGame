--==================
-- Byzantium
--==================
-- reduce combat bonus for holy cities
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='BYZANTIUM_COMBAT_HOLY_CITIES' AND Name='Amount';
--remove dromon combat bonus
--25/10/23 remove dromon combat bonus again
DELETE FROM UnitAbilityModifiers WHERE ModifierId='DROMON_COMBAT_STRENGTH_AGAINST_UNITS';

-- Delete Byzantium religious spread (script will do it)
DELETE FROM Modifiers WHERE ModifierId='BYZANTIUM_PRESSURE_KILLS';

-- Reduce Tagma bonus to +2 (from +4)
UPDATE ModifierArguments SET Value=2 WHERE ModifierId='TAGMA_COMBAT_STRENGTH' AND Name='Amount';
UPDATE ModifierArguments SET Value=2 WHERE ModifierId='TAGMA_RELIGIOUS_COMBAT' AND Name='Amount';

-- 17/08/2022: fix bug where bonus is not working on gdr
DELETE FROM TypeTags WHERE Type='ABILITY_BYZANTIUM_COMBAT_UNITSABILITY_BYZANTIUM_COMBAT_UNITS';

INSERT OR IGNORE INTO TypeTags (Type , Tag) VALUES
	('ABILITY_BYZANTIUM_COMBAT_UNITS' ,'CLASS_ALL_COMBAT_UNITS');

-- 14/10 discount reduced to 35% (20 for diplo quarter) and unique district to 55%
UPDATE Districts SET CostProgressionParam1=35 WHERE DistrictType='DISTRICT_HIPPODROME';
UPDATE Districts SET Cost=30 WHERE DistrictType='DISTRICT_HIPPODROME';

--19/12/23 hippodromes to 2 amenities (from 3)
UPDATE Districts SET Entertainment=2 WHERE DistrictType='DISTRICT_HIPPODROME';



--==================
-- Gaul
--==================
-- Start Bias
UPDATE StartBiasResources SET Tier=5 WHERE CivilizationType='CIVILIZATION_GAUL' AND ResourceType IN ('RESOURCE_COPPER', 'RESOURCE_DIAMONDS', 'RESOURCE_JADE', 'RESOURCE_MERCURY', 'RESOURCE_SALT', 'RESOURCE_SILVER');
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_GAUL' AND ResourceType='RESOURCE_IRON';
-- 04/10/22 carrier bias to T5
INSERT INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_GAUL', 'RESOURCE_STONE', '5'),
    ('CIVILIZATION_GAUL', 'RESOURCE_MARBLE', '5'),
    ('CIVILIZATION_GAUL', 'RESOURCE_GYPSUM', '5');
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
UPDATE Modifiers SET OwnerRequirementSetId='BBG_UTILS_PLAYER_HAS_TECH_BRONZE_WORKING' WHERE ModifierId='GAUL_MINE_CULTURE';

-- 16/04/23 move culture bomb from mine to oppidum
DELETE FROM TraitModifiers WHERE ModifierId='GAUL_MINE_CULTURE_BOMB';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_OPPIDUM_CULTURE_BOMB', 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_OPPIDUM_CULTURE_BOMB', 'DistrictType', 'DISTRICT_OPPIDUM'),
	('BBG_OPPIDUM_CULTURE_BOMB', 'CaptureOwnedTerritory', 0);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_CIVILIZATION_GAUL', 'BBG_OPPIDUM_CULTURE_BOMB');

-- 14/10 discount reduced to 35% (20 for diplo quarter) and unique district to 55%
UPDATE Districts SET CostProgressionParam1=35 WHERE DistrictType='DISTRICT_OPPIDUM';
UPDATE Districts SET Cost=30 WHERE DistrictType='DISTRICT_OPPIDUM';

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