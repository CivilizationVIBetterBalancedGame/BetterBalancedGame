--==============================================================
--******            C I V I L I Z A T I O N S              ******
--==============================================================

--==================
-- Aztec
--==================
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TRAIT_MELEE_PRODUCTION_BBG', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TRAIT_MELEE_PRODUCTION_BBG', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE'),
    ('TRAIT_MELEE_PRODUCTION_BBG', 'EraType', 'NO_ERA'),
    ('TRAIT_MELEE_PRODUCTION_BBG', 'Amount', '50');
INSERT OR IGNORE INTO TraitModifiers VALUES
    ('TRAIT_CIVILIZATION_LEGEND_FIVE_SUNS', 'TRAIT_MELEE_PRODUCTION_BBG');

-- Aztec Tlachtli Unique Building is now slightly cheaper and is +1 AoE Culture instead of +2 Faith/+1 Culture
DELETE FROM Building_YieldChanges WHERE BuildingType='BUILDING_TLACHTLI' AND YieldType='YIELD_FAITH';
UPDATE Building_YieldChanges SET YieldChange=1 WHERE BuildingType='BUILDING_TLACHTLI';
-- 19/05/2021: Tlachtli is 1 AoE amenity.
UPDATE Buildings SET Cost=100, Entertainment=1, RegionalRange=6 WHERE BuildingType='BUILDING_TLACHTLI';

-- 28/02/2022: Builder charge on district => 30%
UPDATE ModifierArguments SET Value=30 WHERE ModifierId='TRAIT_BUILDER_DISTRICT_PERCENT' AND Name='Amount';

-- Huey gives +2 culture to lake tiles
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_HUEY_TEOCALLI', 'HUEY_LAKE_CULTURE');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('HUEY_LAKE_CULTURE', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'FOODHUEY_PLAYER_REQUIREMENTS'),
    ('HUEY_LAKE_CULTURE_MODIFIER', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'FOODHUEY_PLOT_IS_LAKE_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('HUEY_LAKE_CULTURE', 'ModifierId', 'HUEY_LAKE_CULTURE_MODIFIER'),
    ('HUEY_LAKE_CULTURE_MODIFIER', 'Amount', '2'),
    ('HUEY_LAKE_CULTURE_MODIFIER', 'YieldType', 'YIELD_CULTURE');

-- 17/08/2022: fix bug where bonus is not working on gdr
-- 05/04/25 now only work on melee, ranged and anticav
-- 08/04/25 now work on every units but gdr and planes
DELETE FROM TypeTags WHERE Type='ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY';
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_RECON'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_MELEE'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_RANGED'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_ANTI_CAVALRY'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_LIGHT_CAVALRY'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_HEAVY_CAVALRY'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_SIEGE'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_NAVAL_MELEE'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_NAVAL_RANGED'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_NAVAL_RAIDER'),
    ('ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY' ,'CLASS_NAVAL_CARRIER');

-- 12/06/23 Tlachtli gives 3 tourism from start
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_TLACHTLI', 'BBG_ARENA_TOURISM');

-- 30/11/24 Ancient unit gets -5 agaisnt city center, see Base/Units.sql
INSERT INTO TypeTags (Type, Tag) VALUES
    ('UNIT_AZTEC_EAGLE_WARRIOR', 'CLASS_MALUS_CITY_CENTER');


-- 30/06/25 Huey Teocalli : 355 > 250
UPDATE Buildings SET Cost=500 WHERE BuildingType='BUILDING_HUEY_TEOCALLI';
