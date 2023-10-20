--==============================================================================================
--******    SUMER    ******
--==============================================================================================
-- Delete old Trait as they are moved and reworked to Gilgamesh
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_FIRST_CIVILIZATION';
--Start bias moved to xp2 (because plains and grass floodplains didn't exist before gs)
-- Farms adjacent to a River yield +1 food, Farms adjacent to a River get + 1 prop if next to Zigurat
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'FIRST_CIVILIZATION_FARM_FOOD'),
    ('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'FIRST_CIVILIZATION_FARM_PROD');
    --('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'FIRST_CIVILIZATION_WAR_CART_PREMIUM'),

INSERT INTO Modifiers
    (ModifierId, ModifierType, SubjectRequirementSetId,    SubjectStackLimit)
VALUES  ('FIRST_CIVILIZATION_FARM_FOOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS', NULL),
    ('FIRST_CIVILIZATION_WAR_CART_PREMIUM', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST', NULL, 1),
    ('FIRST_CIVILIZATION_FARM_PROD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('FIRST_CIVILIZATION_FARM_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('FIRST_CIVILIZATION_FARM_FOOD', 'Amount', 1),

    ('FIRST_CIVILIZATION_FARM_PROD', 'YieldType', 'YIELD_PRODUCTION'),
    ('FIRST_CIVILIZATION_FARM_PROD', 'Amount', 1);

-- This makes War Carts cost 120 gold in Online speed    Increase premium to 40->50. Removed at BBG5.1
    --('FIRST_CIVILIZATION_WAR_CART_PREMIUM', 'UnitType', 'UNIT_SUMERIAN_WAR_CART'),
    --('FIRST_CIVILIZATION_WAR_CART_PREMIUM', 'Amount', -50);

INSERT INTO RequirementSets (RequirementSetId,    RequirementSetType) VALUES
	('FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'),
    ('FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS', 'REQUIRES_PLOT_HAS_FARM'),
	('FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_RIVER'),

	('FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIRES_PLOT_HAS_FARM'),
	('FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_ZIGGURAT'),
	('FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIRES_PLAYER_HAS_EARLY_EMPIRE');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
	('REQUIRES_CITY_HAS_WATER_MILL', 'REQUIREMENT_CITY_HAS_BUILDING'),
    ('REQUIRES_PLOT_ADJACENT_TO_ZIGGURAT', 'REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES'),
    ('REQUIRES_PLAYER_HAS_EARLY_EMPIRE', 'REQUIREMENT_PLAYER_HAS_CIVIC');  

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
	('REQUIRES_CITY_HAS_WATER_MILL', 'BuildingType', 'BUILDING_WATER_MILL'),
	('REQUIRES_PLOT_ADJACENT_TO_ZIGGURAT', 'ImprovementType', 'IMPROVEMENT_ZIGGURAT'),
	('REQUIRES_PLAYER_HAS_EARLY_EMPIRE', 'CivicType', 'CIVIC_EARLY_EMPIRE');  


-- Ziggurat buff
UPDATE Improvements SET SameAdjacentValid=0, Housing=2, TilesRequired=2 WHERE ImprovementType='IMPROVEMENT_ZIGGURAT';

INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
	('IMPROVEMENT_ZIGGURAT', 'YIELD_FAITH', 0);

-- +1 faith for every 2 adjacent farms. +1 faith for each adjacent District.
INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
	('IMPROVEMENT_ZIGGURAT', 'BBG_Ziggurat_Faith_Farm'),
    ('IMPROVEMENT_ZIGGURAT', 'BBG_Ziggurat_Faith_District');

INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement, OtherDistrictAdjacent) VALUES
	('BBG_Ziggurat_Faith_Farm', 'Placeholder', 'YIELD_FAITH', 1, 2, 'IMPROVEMENT_FARM', 0),
    ('BBG_Ziggurat_Faith_District', 'Placeholder', 'YIELD_FAITH', 1, 1, NULL, 1);


-- Sumerian War Carts are nerfed to 26 (BASE = 30)
-- 20-12-07 Hotfix: Nerf from 28->26-->27 (Devries)
-- 05/10/22 reduce cs to 20
UPDATE Units SET Combat=20 WHERE UnitType='UNIT_SUMERIAN_WAR_CART';
-- Sumerian War Carts are cost is dimished to 45 (BASE = 55)
-- 20-12-07 Hotfix: Revert to 55 cost
-- Beta Buff: Revert to 45 cost
-- 05/10/22 reduce cost to 40
UPDATE Units SET Cost=40 WHERE UnitType='UNIT_SUMERIAN_WAR_CART';
--16/04/23 Warcart share movement with civilian
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_ABILITY_WAR_CART_ESCORT_CIVILIANS', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_ABILITY_WAR_CART_ESCORT_CIVILIANS', 'CLASS_WAR_CART');
INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_WAR_CART_ESCORT_CIVILIANS', 'LOC_BBG_ABILITY_WAR_CART_ESCORT_CIVILIANS', 'LOC_BBG_ABILITY_WAR_CART_ESCORT_CIVILIANS_DESCRIPTION');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_WAR_CART_ESCORT_CIVILIANS', 'ESCORT_MOBILITY_SHARED_MOVEMENT');


-- 20-12-07 Hotfix: Increase war-cart strength vs. barbs
INSERT OR IGNORE INTO Types (Type, Kind) VALUES
  ('ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'KIND_ABILITY');
INSERT OR IGNORE INTO TypeTags VALUES
  ('ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG','CLASS_WAR_CART');
INSERT OR IGNORE INTO UnitAbilities (UnitAbilityType, Name, Description, Inactive) VALUES
  ('ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'LOC_ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_NAME_BBG', 'LOC_ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_DESCRIPTION_BBG', 0);
INSERT OR IGNORE INTO UnitAbilityModifiers VALUES
  ('ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG');

INSERT OR IGNORE INTO Modifiers
    (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES  ('WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG','MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'REQUIREMENTS_OPPONENT_IS_BARBARIAN');

INSERT OR IGNORE INTO ModifierStrings
    (ModifierId, Context, Text)
VALUES  ('WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG','Preview', 'LOC_ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_COMBAT_DESCRIPTION_BBG');

INSERT INTO ModifierArguments
    (ModifierId, Name, Value)
VALUES  ('WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'Amount', 4);

-- Sumerian War Carts as a starting unit in Ancient is coded on the lua front

-- 23/04/2021: Delete +5 when war common foe
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_ADVENTURES_ENKIDU' AND ModifierId='TRAIT_ATTACH_ALLIANCE_COMBAT_ADJUSTMENT';


--==============================================================================================
--******            GILGAMESH                         ******
--==============================================================================================
-- Delete some old Traits as they are buggy :( 
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_ADVENTURES_ENKIDU' and ModifierId='TRAIT_ADJUST_JOINTWAR_PLUNDER'; -- Coded on the lua front
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_ADVENTURES_ENKIDU' and ModifierId='TRAIT_ADJUST_JOINTWAR_EXPERIENCE'; -- Coded on the lua front
-- In case heroes mode is enabled, this needs to be re-inserted.
-- Arguably, this makes Gilga OP in heroes, but that's okay.
INSERT OR IGNORE INTO Traits (TraitType , Name , Description) VALUES
   ('TRAIT_LEADER_ADVENTURES_ENKIDU', 'TRAIT_LEADER_ADVENTURES_ENKIDU_NAME', 'TRAIT_LEADER_ADVENTURES_ENKIDU_DESCRIPTION' );

-- Give the Barb modifier + Levy Discount + Add combat experience
INSERT INTO TraitModifiers
        (TraitType,                                 ModifierId)
VALUES  ('TRAIT_LEADER_ADVENTURES_ENKIDU',          'TRAIT_BARBARIAN_CAMP_GOODY'),
--      ('TRAIT_LEADER_ADVENTURES_ENKIDU',          'TRAIT_GILGAMESH_COMBAT_EXPERIENCE'),
        ('TRAIT_LEADER_ADVENTURES_ENKIDU',          'TRAIT_LEVY_DISCOUNT');

INSERT INTO Modifiers
        (ModifierId,                                        ModifierType,                                                       SubjectRequirementSetId)
VALUES  ('TRAIT_GILGAMESH_COMBAT_EXPERIENCE',               'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_EXPERIENCE_MODIFIER',            NULL);

INSERT INTO ModifierArguments
        (ModifierId,                                        Name,                       Value)
VALUES  ('TRAIT_GILGAMESH_COMBAT_EXPERIENCE',               'Amount',                   25);

-- Sumerian War Carts as a starting unit in Ancient is coded on the lua front

-- extra +3 envoys points per turn
--INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
--  VALUES ('SUMERIA_ENVOY_POINTS_FROM_MILITARY_ALLIANCE', 'Amount', '3');
--INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
--  VALUES ('SUMERIA_ENVOY_POINTS_FROM_MILITARY_ALLIANCE', 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN');
--INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
--  VALUES ('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'SUMERIA_ENVOY_POINTS_FROM_MILITARY_ALLIANCE');

-- 15/10/23 remove flood damage (same as Egypt)
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'TRAIT_AVOID_MODERATE_FLOOD'),
    ('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'TRAIT_AVOID_MAJOR_FLOOD'),
    ('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'TRAIT_AVOID_THOUSAND_FLOOD');