--==============================================================
--******			C I V I L I Z A T I O N S			  ******
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
UPDATE ModifierArguments SET Value='30' WHERE ModifierId='TRAIT_BUILDER_DISTRICT_PERCENT' AND Name='Amount';

-- Huey gives +2 culture to lake tiles
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
	VALUES ('BUILDING_HUEY_TEOCALLI', 'HUEY_LAKE_CULTURE');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	VALUES
	('HUEY_LAKE_CULTURE', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'FOODHUEY_PLAYER_REQUIREMENTS'),
	('HUEY_LAKE_CULTURE_MODIFIER', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'FOODHUEY_PLOT_IS_LAKE_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
	('HUEY_LAKE_CULTURE', 'ModifierId', 'HUEY_LAKE_CULTURE_MODIFIER'),
	('HUEY_LAKE_CULTURE_MODIFIER', 'Amount', '2'),
	('HUEY_LAKE_CULTURE_MODIFIER', 'YieldType', 'YIELD_CULTURE');