--==================
-- Georgia
--==================
-- Georgian Khevsur unit becomes sword replacement
-- 23/04/2021: Firaxis patch
--UPDATE Units SET Combat=35, Cost=100, Maintenance=2, PrereqTech='TECH_IRON_WORKING', StrategicResource='RESOURCE_IRON' WHERE UnitType='UNIT_GEORGIAN_KHEVSURETI';
--UPDATE ModifierArguments SET Value='5' WHERE ModifierId='KHEVSURETI_HILLS_BUFF' AND Name='Amount';
--INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
--	VALUES ('UNIT_GEORGIAN_KHEVSURETI', 'UNIT_SWORDSMAN');
-- Georgia Tsikhe changed to a stronger Ancient Wall replacement instead of a Renaissance Wall replacement
DELETE FROM BuildingPrereqs WHERE Building='BUILDING_TSIKHE';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_TSIKHE' AND ModifierId='TSIKHE_PREVENT_MELEE_ATTACK_OUTER_DEFENSES';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_TSIKHE' AND ModifierId='TSIKHE_PREVENT_BYPASS_OUTER_DEFENSE';
UPDATE BuildingReplaces SET ReplacesBuildingType='BUILDING_WALLS' WHERE CivUniqueBuildingType='BUILDING_TSIKHE';
UPDATE Buildings SET Cost=100, PrereqTech='TECH_MASONRY' , OuterDefenseHitPoints=100 WHERE BuildingType='BUILDING_TSIKHE';
-- Georgia gets 50% faith kills (online) instead of Protectorate War Bonus
UPDATE ModifierArguments SET Value='100' WHERE ModifierId='TRAIT_LEADER_FAITH_KILLS' AND Name='PercentDefeatedStrength';
-- Georgia gets +1 faith for every envoy
INSERT INTO TraitModifiers (TraitType , ModifierId) VALUES
	('TRAIT_LEADER_RELIGION_CITY_STATES' , 'BBG_GEORGIA_FAITH_PER_ENVOY');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_GEORGIA_FAITH_PER_ENVOY', 'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_USED_INFLUENCE_TOKEN');
INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
	('BBG_GEORGIA_FAITH_PER_ENVOY' , 'YieldType', 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
	('BBG_GEORGIA_FAITH_PER_ENVOY' , 'Amount', '1');

--15/06/23 Tsikhe gives 1 culture
INSERT INTO Building_YieldChanges (BuildingType, YieldType, YieldChange) VALUES
	('BUILDING_TSIKHE', 'YIELD_CULTURE', 1);

--12/07/23 Tsikhe gives only 3 faith in golde
UPDATE ModifierArguments SET Value=3 WHERE ModifierId='TSIKHE_FAITH_GOLDEN_AGE' AND Name='Amount';