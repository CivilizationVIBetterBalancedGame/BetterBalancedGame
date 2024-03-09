--==============================================================
--******              UNITS  (NON-UNIQUE)                ******
--==============================================================
UPDATE Units_XP2 SET ResourceMaintenanceAmount=2 WHERE UnitType='UNIT_GIANT_DEATH_ROBOT';
UPDATE Units SET StrategicResource='RESOURCE_OIL' WHERE UnitType='UNIT_HELICOPTER';
UPDATE Units_XP2 SET ResourceMaintenanceAmount=1, ResourceCost=1, ResourceMaintenanceType='RESOURCE_OIL' WHERE UnitType='UNIT_HELICOPTER';
UPDATE Units SET Cost=200 WHERE UnitType='UNIT_KNIGHT';
UPDATE Units SET Cost=180 WHERE UnitType='UNIT_COURSER';
UPDATE Units SET StrategicResource='RESOURCE_NITER' WHERE UnitType='UNIT_INFANTRY';
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_NITER' WHERE UnitType='UNIT_INFANTRY';
UPDATE Units SET PrereqTech='TECH_STEEL' WHERE UnitType='UNIT_ANTIAIR_GUN';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES ('SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'SIEGE_DEFENSE_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT', 'Amount', '10');
INSERT OR IGNORE INTO ModifierStrings (ModifierId, Context, Text)
    VALUES ('SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT', 'Preview', '{LOC_SIEGE_RANGED_DEFENSE_DESCRIPTION}');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('SIEGE_DEFENSE_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('SIEGE_DEFENSE_REQUIREMENTS', 'RANGED_COMBAT_REQUIREMENTS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('SIEGE_DEFENSE_REQUIREMENTS', 'PLAYER_IS_DEFENDER_REQUIREMENTS');
INSERT OR IGNORE INTO Types (Type, Kind)
    VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'KIND_ABILITY');
INSERT OR IGNORE INTO TypeTags (Type, Tag)
    VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'CLASS_SIEGE');
INSERT OR IGNORE INTO UnitAbilities (UnitAbilityType, Name, Description)
    VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'LOC_PROMOTION_TORTOISE_NAME', 'LOC_PROMOTION_TORTOISE_DESCRIPTION');
INSERT OR IGNORE INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
    VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT');

-- -5 combat strength to all airplanes (P-51 change in America section)
UPDATE Units SET Combat=75,  RangedCombat=70  WHERE UnitType='UNIT_BIPLANE';
UPDATE Units SET Combat=95,  RangedCombat=95  WHERE UnitType='UNIT_FIGHTER';
UPDATE Units SET Combat=105, RangedCombat=105 WHERE UnitType='UNIT_JET_FIGHTER';
UPDATE Units SET Combat=80,  Bombard=105      WHERE UnitType='UNIT_BOMBER';
UPDATE Units SET Combat=85,  Bombard=115      WHERE UnitType='UNIT_JET_BOMBER';

-- Military Engineers get tunnels at military science
UPDATE Improvements SET PrereqTech='TECH_MILITARY_SCIENCE' WHERE ImprovementType='IMPROVEMENT_MOUNTAIN_TUNNEL';
-- 09/03/2024 Fort to military engineering
UPDATE Improvements SET PrereqTech='TECH_MILITARY_ENGINEERING' WHERE ImprovementType='IMPROVEMENT_FORT';

-- 09/03/2024 +1 sigth range for units in fort
-- INSERT INTO Types
INSERT INTO Types (Type, Kind)
	VALUES
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'KIND_ABILITY'),

INSERT INTO TypeTags (Type, Tag)
	VALUES
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_RECON'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_MELEE'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_RANGED'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_ANTI_CAVALRY'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_SIEGE'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_HEAVY_CAVALRY'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_HEAVY_CHARIOT'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_LIGHT_CAVALRY'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_LIGHT_CHARIOT'),
		('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'CLASS_RANGED_CAVALRY');


INSERT INTO UnitAbilities (UnitAbilityType, Name, Description, Inactive) VALUES
	('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'LOC_ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT_NAME', 'LOC_ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT_DESCRIPTION', 0),
		
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
	('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'DEFENSIVEIMPROVEMENT_BONUS_SIGHT'),
		
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('DEFENSIVEIMPROVEMENT_BONUS_SIGHT', 'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT', 'IMPROVEMENT_IS_DEFENSIVE'),

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('DEFENSIVEIMPROVEMENT_BONUS_SIGHT', 'Amount', 1),

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
	('IMPROVEMENT_IS_DEFENSIVE', 'REQUIREMENTSET_TEST_ANY'),

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES
		('IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_FORT_IN_PLOT'),
		('IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_ROMANFORT_IN_PLOT'),
		('IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_GREATWALL_IN_PLOT'),

INSERT INTO Requirements (RequirementId, RequirementType)
	VALUES
		('REQUIRES_FORT_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
		('REQUIRES_ROMANFORT_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
		('REQUIRES_GREATWALL_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),

INSERT INTO RequirementArguments (RequirementId, Name, Value)
	VALUES
		('REQUIRES_FORT_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_FORT'),
		('REQUIRES_ROMANFORT_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_ROMAN_FORT'),
		('REQUIRES_GREATWALL_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_GREAT_WALL'),

-- Military Engineers can build roads without using charges
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_ANCIENT_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_INDUSTRIAL_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_MEDIEVAL_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_MODERN_ROAD';

-- 23/08/22 move road from 
UPDATE Routes_XP2 SET PrereqTech='TECH_SCIENTIFIC_THEORY' WHERE RouteType='ROUTE_RAILROAD';

--14/07/2022: all spads to 10 normal speed
--03/10/2022: to 15
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_SWORDSMAN';
--17/10/2022: men at arm to 15
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_MAN_AT_ARMS';

--5.2.5 Musketman/Line infantry buff
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_LINE_INFANTRY';
UPDATE Units SET Cost=220 WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units SET Cost=330 WHERE UnitType='UNIT_LINE_INFANTRY';

--5.2.5 Set heavy chariot cost 5 iron (reverted, greyed out just in case)
--INSERT OR IGNORE INTO Units_XP2 (UnitType , ResourceCost  , ResourceMaintenanceAmount , ResourceMaintenanceType)
    --VALUES ('UNIT_HEAVY_CHARIOT' , 10 , 0, 'RESOURCE_IRON');
--UPDATE Units SET StrategicResource='RESOURCE_IRON' WHERE UnitType='UNIT_HEAVY_CHARIOT';

-- Jack the Ripper proposal (31/12/2020) to boost Naval Movement
-- Resource cost / Maintenance is 1 in GS
UPDATE Units_XP2 SET ResourceCost=0 WHERE  UnitType='UNIT_SUBMARINE';
UPDATE Units_XP2 SET ResourceMaintenanceAmount=0 WHERE  UnitType='UNIT_SUBMARINE';
UPDATE Units SET StrategicResource=NULL WHERE UnitType='UNIT_SUBMARINE';
UPDATE Units_XP2 SET ResourceMaintenanceType=NULL WHERE  UnitType='UNIT_SUBMARINE';

-- Monks: Cards/Governments
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_GLOBAL_COALITION_FRIENDLY_TERRITORY', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_DIGITAL_DEMOCRACY_DEBUFF', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_FINEST_HOUR_FRIENDLY_TERRITORY', 'CLASS_WARRIOR_MONK');

-- 23/04/2021: Implemented by Firaxis
--UPDATE Units_XP2 SET ResourceCost='0' WHERE  UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units_XP2 SET ResourceMaintenanceAmount='0' WHERE  UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units SET StrategicResource=NULL WHERE UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units_XP2 SET ResourceMaintenanceType=NULL WHERE  UnitType='UNIT_GERMAN_UBOAT';

-- 02/07/23: Strange that it does not exist in Types table
INSERT INTO Types(Type, Kind) VALUES
    ('RESULT_OPENING_ACT', 'KIND_ROCKBAND_RESULT');

-- 02/07/23: Nerfed scaling of rockbands
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=40 WHERE ResultType='RESULT_OPENING_ACT';
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=80 WHERE ResultType='RESULT_RISING_STARS';
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=120 WHERE ResultType='RESULT_HEADLINERS';
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=160 WHERE ResultType='RESULT_LEGENDS_OF_ROCK';


CREATE TABLE TmpNavalUnit(UnitType PRIMARY KEY NOT NULL);
INSERT INTO TmpNavalUnit(UnitType) VALUES
    ('UNIT_OTTOMAN_BARBARY_CORSAIR'),
    ('UNIT_PHOENICIA_BIREME');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE', 'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'GRANT_STRENGTH_PER_ADJACENT_UNIT_TYPE', 'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_UNIT_IS_DEFENDER_IN_MELEE' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO ModifierArguments(ModifierId, Name, Value) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'Amount', '2' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO ModifierArguments(ModifierId, Name, Value) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'UnitType', Units.UnitType FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO ModifierStrings(ModifierId, Context, Text) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'Preview', '{'||Units.Name||'} : +{CalculatedAmount}' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO Requirements (RequirementId, RequirementType) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO RequirementArguments (RequirementId, Name, Value) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ', 'UnitType', Units.UnitType FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_UTILS_PLAYER_HAS_CIVIC_MILITARY_TRADITION_REQUIREMENT' FROM Units INNER JOIN TmpNavalUnit ON Units.UnitType = TmpNavalUnit.UnitType;
    
DROP TABLE TmpNavalUnit;