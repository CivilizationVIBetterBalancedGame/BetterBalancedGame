-- ========================================================================
-- =                             GAUL                                     =
-- ========================================================================
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

-- 7/3/2021: Beta: Remove Apprenticeship free tech
DELETE FROM DistrictModifiers WHERE DistrictType='DISTRICT_OPPIDUM' AND ModifierId='OPPIDUM_GRANT_TECH_APPRENTICESHIP';

    
-- Moved to Vercingetorix, so deleted here
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_GAUL' AND ModifierId='GAUL_MINE_CULTURE';

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

-- 30/11/24 Ancient unit gets -5 agaisnt city center, see Base/Units.sql
INSERT INTO TypeTags (Type, Tag) VALUES
    ('UNIT_GAUL_GAESATAE', 'CLASS_MALUS_CITY_CENTER');

-- 30/07/25 Quarry now give standard adjacency to districts
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY', 'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY'),
    ('BBG_GAUL_QUARRY_CAMPUS_ADJACENCY', 'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY'),
    ('BBG_GAUL_QUARRY_HARBOR_ADJACENCY', 'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY'),
    ('BBG_GAUL_QUARRY_HUB_ADJACENCY', 'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY'),
    ('BBG_GAUL_QUARRY_THEATER_ADJACENCY', 'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY', 'DistrictType', 'DISTRICT_HOLY_SITE'),
    ('BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY', 'YieldType', 'YIELD_FAITH'),
    ('BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY', 'ImprovementType', 'IMPROVEMENT_QUARRY'),
    ('BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY', 'Amount', 1),
    ('BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY', 'TilesRequired', 1),
    ('BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY', 'Description', 'LOC_DISTRICT_QUARRY_1_FAITH'),
    ('BBG_GAUL_QUARRY_CAMPUS_ADJACENCY', 'DistrictType', 'DISTRICT_CAMPUS'),
    ('BBG_GAUL_QUARRY_CAMPUS_ADJACENCY', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_GAUL_QUARRY_CAMPUS_ADJACENCY', 'ImprovementType', 'IMPROVEMENT_QUARRY'),
    ('BBG_GAUL_QUARRY_CAMPUS_ADJACENCY', 'Amount', 1),
    ('BBG_GAUL_QUARRY_CAMPUS_ADJACENCY', 'TilesRequired', 1),
    ('BBG_GAUL_QUARRY_CAMPUS_ADJACENCY', 'Description', 'LOC_DISTRICT_QUARRY_1_SCIENCE'),
    ('BBG_GAUL_QUARRY_HARBOR_ADJACENCY', 'DistrictType', 'DISTRICT_HARBOR'),
    ('BBG_GAUL_QUARRY_HARBOR_ADJACENCY', 'YieldType', 'YIELD_GOLD'),
    ('BBG_GAUL_QUARRY_HARBOR_ADJACENCY', 'ImprovementType', 'IMPROVEMENT_QUARRY'),
    ('BBG_GAUL_QUARRY_HARBOR_ADJACENCY', 'Amount', 1),
    ('BBG_GAUL_QUARRY_HARBOR_ADJACENCY', 'TilesRequired', 1),
    ('BBG_GAUL_QUARRY_HARBOR_ADJACENCY', 'Description', 'LOC_DISTRICT_QUARRY_1_GOLD'),
    ('BBG_GAUL_QUARRY_HUB_ADJACENCY', 'DistrictType', 'DISTRICT_COMMERCIAL_HUB'),
    ('BBG_GAUL_QUARRY_HUB_ADJACENCY', 'YieldType', 'YIELD_GOLD'),
    ('BBG_GAUL_QUARRY_HUB_ADJACENCY', 'ImprovementType', 'IMPROVEMENT_QUARRY'),
    ('BBG_GAUL_QUARRY_HUB_ADJACENCY', 'Amount', 1),
    ('BBG_GAUL_QUARRY_HUB_ADJACENCY', 'TilesRequired', 1),
    ('BBG_GAUL_QUARRY_HUB_ADJACENCY', 'Description', 'LOC_DISTRICT_QUARRY_1_GOLD'),
    ('BBG_GAUL_QUARRY_THEATER_ADJACENCY', 'DistrictType', 'DISTRICT_THEATER'),
    ('BBG_GAUL_QUARRY_THEATER_ADJACENCY', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_GAUL_QUARRY_THEATER_ADJACENCY', 'ImprovementType', 'IMPROVEMENT_QUARRY'),
    ('BBG_GAUL_QUARRY_THEATER_ADJACENCY', 'Amount', 1),
    ('BBG_GAUL_QUARRY_THEATER_ADJACENCY', 'TilesRequired', 1),
    ('BBG_GAUL_QUARRY_THEATER_ADJACENCY', 'Description', 'LOC_DISTRICT_QUARRY_1_CULTURE');

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_GAUL', 'BBG_GAUL_QUARRY_HOLYSITE_ADJACENCY'),
    ('TRAIT_CIVILIZATION_GAUL', 'BBG_GAUL_QUARRY_CAMPUS_ADJACENCY'),
    ('TRAIT_CIVILIZATION_GAUL', 'BBG_GAUL_QUARRY_HARBOR_ADJACENCY'),
    ('TRAIT_CIVILIZATION_GAUL', 'BBG_GAUL_QUARRY_HUB_ADJACENCY'),
    ('TRAIT_CIVILIZATION_GAUL', 'BBG_GAUL_QUARRY_THEATER_ADJACENCY');


-- ========================================================================
-- =                           AMBIORIX                                   =
-- ========================================================================

-- remove culture from unit production
-- 30/07/25 gave back to 25% with bbg expanded but starting bronze working
UPDATE ModifierArguments SET Value=25 WHERE ModifierId='TRAIT_GRANT_CULTURE_UNIT_TRAINED' AND Name='Amount';
UPDATE Modifiers SET OwnerRequirementSetId='BBG_UTILS_PLAYER_HAS_TECH_BRONZE_WORKING' WHERE ModifierId='TRAIT_GRANT_CULTURE_UNIT_TRAINED';

-- reduce king's combat bonus for adj units
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='AMBIORIX_NEIGHBOR_COMBAT' and Name='Amount';
-- remove ranged units from having kings combat bonus
DELETE FROM TypeTags WHERE Type='ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS' AND Tag='CLASS_RANGED';
-- 15/12/24 recode the bonus so only friendly units give combat bonus
-- 30/07/25 Reverted with bbg expanded
-- DELETE FROM UnitAbilityModifiers WHERE UnitAbilityType='ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS';
-- INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) SELECT
--     'ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS', 'BBG_ABILITY_AMBIORIX_COMBAT_' || Units.UnitType || '_MODIFIER' FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) SELECT
--     'BBG_ABILITY_AMBIORIX_COMBAT_' || Units.UnitType || '_MODIFIER', 'GRANT_STRENGTH_PER_ADJACENT_UNIT_TYPE', 'BBG_' || Units.UnitType || '_IS_ADJACENT_REQSET', NULL FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO ModifierArguments(ModifierId, Name, Value) SELECT
--     'BBG_ABILITY_AMBIORIX_COMBAT_' || Units.UnitType || '_MODIFIER', 'Amount', 1 FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO ModifierArguments(ModifierId, Name, Value) SELECT
--     'BBG_ABILITY_AMBIORIX_COMBAT_' || Units.UnitType || '_MODIFIER', 'UnitType', Units.UnitType FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO ModifierStrings(ModifierId, Context, Text) SELECT
--     'BBG_ABILITY_AMBIORIX_COMBAT_' || Units.UnitType || '_MODIFIER', 'Preview',  '{LOC_ABILITY_AMBIORIX_COMBAT_BONUS_DESC} ({'||Units.Name||'}) : +{CalculatedAmount}' FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO Requirements (RequirementId, RequirementType) SELECT
--     'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES' FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO RequirementArguments (RequirementId, Name, Value) SELECT
--     'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ', 'UnitType', Units.UnitType FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) SELECT
--     'BBG_' || Units.UnitType || '_IS_ADJACENT_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
-- INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
--     'BBG_' || Units.UnitType || '_IS_ADJACENT_REQSET', 'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ' FROM Units WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
