-- 07/07/24 Mali 128973e rework

--===========================================================================
--=                                   MALI                                  =
--===========================================================================
UPDATE Units SET Combat=53 WHERE UnitType='UNIT_MALI_MANDEKALU_CAVALRY';

-- 25/10/23 Remove 30% prod malus for units/buildings, add global 10% prod malus
DELETE FROM TraitModifiers WHERE TraitType = 'TRAIT_CIVILIZATION_MALI_GOLD_DESERT' AND ModifierId = 'TRAIT_LESS_UNIT_PRODUCTION';
DELETE FROM TraitModifiers WHERE TraitType = 'TRAIT_CIVILIZATION_MALI_GOLD_DESERT' AND ModifierId = 'TRAIT_LESS_BUILDING_PRODUCTION';

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_TRAIT_MALI_LESS_CITY_PRODUCTION');
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_TRAIT_MALI_LESS_CITY_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_MALI_LESS_CITY_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_TRAIT_MALI_LESS_CITY_PRODUCTION', 'Amount', '-15');

-- Faith if the city own at least 2 desert tiles
DELETE FROM TraitModifiers WHERE TraitType = 'TRAIT_CIVILIZATION_MALI_GOLD_DESERT' AND ModifierId = 'TRAIT_DESERT_CITY_CENTER_FAITH';
DELETE FROM TraitModifiers WHERE TraitType = 'TRAIT_CIVILIZATION_MALI_GOLD_DESERT' AND ModifierId = 'TRAIT_DESERT_HILLS_CITY_CENTER_FAITH';
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MALI_FAITH_IF_2_DESERT_TILES', 'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE', 'BBG_REQUIRES_CITY_CENTER_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MALI_FAITH_IF_2_DESERT_TILES', 'YieldType', 'YIELD_FAITH'),
    ('BBG_MALI_FAITH_IF_2_DESERT_TILES', 'Amount', '2');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_REQUIRES_CITY_CENTER_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_REQUIRES_CITY_CENTER_REQSET', 'REQUIRES_DISTRICT_IS_CITY_CENTER'),
    ('BBG_REQUIRES_CITY_CENTER_REQSET', 'BBG_REQUIRES_CITY_HAS_2_DESERT');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_CITY_HAS_2_DESERT', 'REQUIREMENT_CITY_HAS_X_TERRAIN_TYPE');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_CITY_HAS_2_DESERT', 'TerrainType', 'TERRAIN_DESERT'),
    ('BBG_REQUIRES_CITY_HAS_2_DESERT', 'Hills', '1'),
-- Necessits X+1...
    ('BBG_REQUIRES_CITY_HAS_2_DESERT', 'Amount', '3');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_MALI_GOLD_DESERT', 'BBG_MALI_FAITH_IF_2_DESERT_TILES');


--===========================================================================
--=                                 SUGUBA                                  =
--===========================================================================

-- Cheaper purchase
UPDATE ModifierArguments SET Value=10 WHERE ModifierId IN ('SUGUBA_CHEAPER_BUILDING_PURCHASE', 'SUGUBA_CHEAPER_DISTRICT_PURCHASE');
UPDATE ModifierArguments SET Value=10 WHERE ModifierId='SUGUBA_CHEAPER_UNIT_PURCHASE' AND Name='Amount';

-- Normal adj from HS, City center, Rivers, Oasis and Gov Plaza
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentFeature) VALUES
    ('BBG_SUGUBA_OASIS', 'LOC_SUGUBA_OASIS_GOLD', 'YIELD_GOLD', 1, 'FEATURE_OASIS');
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentRiver) VALUES
    ('BBG_SUGUBA_RIVER', 'LOC_SUGUBA_RIVER_GOLD', 'YIELD_GOLD', 1, 1);
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_SUGUBA_CITY_CENTER', 'LOC_DISTRICT_CITY_CENTER_GOLD', 'YIELD_GOLD', 1, 'DISTRICT_CITY_CENTER');
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) VALUES
    ('DISTRICT_SUGUBA', 'BBG_SUGUBA_OASIS'),
    ('DISTRICT_SUGUBA', 'BBG_SUGUBA_RIVER'),
    ('DISTRICT_SUGUBA', 'BBG_SUGUBA_CITY_CENTER');
DELETE FROM District_Adjacencies WHERE DistrictType = 'DISTRICT_SUGUBA' AND YieldChangeId = 'River_Gold';

UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='Holy_Site_Gold';

--===========================================================================
--=                                 MANSA                                   =
--===========================================================================

-- Delete gold from traderoute based on number of desert tile in origin
DELETE FROM TraitModifiers WHERE ModifierId='TRADE_ROUTE_GOLD_DESERT_ORIGIN';

-- 19/03/24 Remove free trader per golden Mansa
-- Moved to 1 traderoute at Banking
DELETE FROM TraitModifiers WHERE ModifierId='GOLDEN_AGE_TRADE_ROUTE';
DELETE FROM Modifiers WHERE ModifierId='GOLDEN_AGE_TRADE_ROUTE';
DELETE FROM ModifierArguments WHERE ModifierId='GOLDEN_AGE_TRADE_ROUTE';

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('TRAIT_BBG_MANSA_FREE_TRADER_BANKS', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 'BBG_UTILS_PLAYER_HAS_TECH_BANKING');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TRAIT_BBG_MANSA_FREE_TRADER_BANKS', 'Amount', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_SAHEL_MERCHANTS', 'TRAIT_BBG_MANSA_FREE_TRADER_BANKS');

-- Holy site +1 to Suguba / Sundiata is excluded in LP/Sundiata.sql
-- remove the classic +1 and give +2 on the Mansa one
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
    ('TRAIT_LEADER_SAHEL_MERCHANTS', 'Holy_Site_Gold');
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_SUGUBA_HOLY_SITE_MANSA', 'LOC_BBG_SUGUBA_HOLY_SITE_MANSA', 'YIELD_GOLD', 2, 'DISTRICT_HOLY_SITE');
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) VALUES
    ('DISTRICT_SUGUBA', 'BBG_SUGUBA_HOLY_SITE_MANSA');

-- 15% towards Holy Sites and its building
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION', 'DistrictType', 'DISTRICT_HOLY_SITE'),
    ('BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION', 'Amount', 15);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_SAHEL_MERCHANTS', 'BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION_BUILDING', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION_BUILDING', 'DistrictType', 'DISTRICT_HOLY_SITE'),
    ('BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION_BUILDING', 'Amount', 15);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_SAHEL_MERCHANTS', 'BBG_MANSA_HOLY_SITE_BONUS_PRODUCTION_BUILDING');


