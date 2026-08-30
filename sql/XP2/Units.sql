--==============================================================
--******              UNITS  (NON-UNIQUE)                ******
--==============================================================


--=======================================================================
--******                       GDR                                 ******
--=======================================================================
UPDATE Units_XP2 SET ResourceMaintenanceAmount=2 WHERE UnitType='UNIT_GIANT_DEATH_ROBOT';

--=======================================================================
--******                    LIGHT CAV                              ******
--=======================================================================
UPDATE Units SET StrategicResource='RESOURCE_OIL' WHERE UnitType='UNIT_HELICOPTER';
UPDATE Units_XP2 SET ResourceMaintenanceAmount=1, ResourceCost=1, ResourceMaintenanceType='RESOURCE_OIL' WHERE UnitType='UNIT_HELICOPTER';

UPDATE Units SET Cost=180 WHERE UnitType='UNIT_COURSER';

--=======================================================================
--******                    HEAVY CAV                              ******
--=======================================================================
UPDATE Units SET Cost=200 WHERE UnitType='UNIT_KNIGHT';

--5.2.5 Set heavy chariot cost 5 iron (reverted, greyed out just in case)
-- 12/07/26 rework heavy chariot as an answer to melee uu

INSERT OR IGNORE INTO Units_XP2 (UnitType , ResourceCost  , ResourceMaintenanceAmount , ResourceMaintenanceType)
    VALUES ('UNIT_HEAVY_CHARIOT' , 20 , 0, 'RESOURCE_IRON');
UPDATE Units SET StrategicResource='RESOURCE_IRON' WHERE UnitType='UNIT_HEAVY_CHARIOT';


--=======================================================================
--******                        RECON                              ******
--=======================================================================

--=======================================================================
--******                        RANGE                              ******
--=======================================================================

--=======================================================================
--******                        MELEE                              ******
--=======================================================================

UPDATE Units SET StrategicResource='RESOURCE_NITER' WHERE UnitType='UNIT_INFANTRY';
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_NITER' WHERE UnitType='UNIT_INFANTRY';

--14/07/2022: all spads to 10 normal speed
--03/10/2022: to 15
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_SWORDSMAN';
--17/10/2022: men at arm to 15
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_MAN_AT_ARMS';

--5.2.5 Musketman/Line infantry buff
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units_XP2 SET ResourceCost=15 WHERE UnitType='UNIT_LINE_INFANTRY';


--=======================================================================
--******                     ANTICAV                               ******
--=======================================================================


--=======================================================================
--******                     SIEGE                                 ******
--=======================================================================

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

--=======================================================================
--******                      SUPPORT                              ******
--=======================================================================
UPDATE Units SET PrereqTech='TECH_STEEL' WHERE UnitType='UNIT_ANTIAIR_GUN';
-- 26/08/26 AntiAir Gun base move to 4
UPDATE Units SET BaseMoves=4 WHERE UnitType='UNIT_ANTIAIR_GUN';

-- Military Engineers get tunnels at military science
-- 04/07/26 : Military Engineers get tunnels at  military engineering
UPDATE Improvements SET PrereqTech='TECH_MILITARY_ENGINEERING' WHERE ImprovementType='IMPROVEMENT_MOUNTAIN_TUNNEL';

-- 09/03/2024 Fort to military engineering
UPDATE Improvements SET PrereqTech='TECH_MILITARY_ENGINEERING' WHERE ImprovementType='IMPROVEMENT_FORT';

-- 09/03/2024 +1 sigth range for units in fort
INSERT INTO Types (Type, Kind) VALUES
	('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'KIND_ABILITY');

INSERT INTO TypeTags (Type, Tag) VALUES
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
		
INSERT INTO UnitAbilities (UnitAbilityType, Inactive) VALUES
	('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 0);
		
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES ('ABILITY_DEFENSIVE_IMPROVEMENT_BONUS_SIGHT', 'DEFENSIVEIMPROVEMENT_BONUS_SIGHT');
		
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES ('DEFENSIVEIMPROVEMENT_BONUS_SIGHT', 'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT', 'IMPROVEMENT_IS_DEFENSIVE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('DEFENSIVEIMPROVEMENT_BONUS_SIGHT', 'Amount', 1);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
	('IMPROVEMENT_IS_DEFENSIVE', 'REQUIREMENTSET_TEST_ANY'),
	('PLOT_ADJACENT_TO_ALHAMBRA', 'REQUIREMENT_TEST_ALL'),
	('TCS_UNIT_IS_MILITARY_ENGINEER', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_FORT_IN_PLOT'),
	('IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_ROMANFORT_IN_PLOT'),
	('IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_GREATWALL_IN_PLOT'),
	('IMPROVEMENT_IS_DEFENSIVE', 'REQUIRES_PA_IN_PLOT'),
	('PLOT_ADJACENT_TO_ALHAMBRA', 'REQUIRES_PLOT_ADJACENT_TO_ALHAMBRA'),
	('TCS_UNIT_IS_MILITARY_ENGINEER', 'TCS_REQUIRES_TCS_UNIT_IS_MILITARY_ENGINEER');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
	('REQUIRES_FORT_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
	('REQUIRES_ROMANFORT_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
	('REQUIRES_GREATWALL_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
	('REQUIRES_PA_IN_PLOT', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
	('REQUIRES_PLOT_ADJACENT_TO_ALHAMBRA', 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES'),
	('TCS_REQUIRES_TCS_UNIT_IS_MILITARY_ENGINEER', 'REQUIREMENT_UNIT_TYPE_MATCHES'),
	('REQUIRES_IMPROVEMENT_IS_DEFENSIVE', 'REQUIREMENT_REQUIREMENTSET_IS_MET');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
	('REQUIRES_FORT_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_FORT'),
	('REQUIRES_ROMANFORT_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_ROMAN_FORT'),
	('REQUIRES_GREATWALL_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_GREAT_WALL'),
	('REQUIRES_PA_IN_PLOT', 'ImprovementType', 'IMPROVEMENT_MAORI_PA'),
	('REQUIRES_PLOT_ADJACENT_TO_ALHAMBRA', 'BuildingType', 'BUILDING_ALHAMBRA'),
	('TCS_REQUIRES_TCS_UNIT_IS_MILITARY_ENGINEER', 'UnitType', 'UNIT_MILITARY_ENGINEER'),
	('REQUIRES_IMPROVEMENT_IS_DEFENSIVE', 'RequirementSetId', 'IMPROVEMENT_IS_DEFENSIVE');


-- Military Engineers can build roads without using charges
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_ANCIENT_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_INDUSTRIAL_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_MEDIEVAL_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_MODERN_ROAD';

-- 23/08/22 move road from 
UPDATE Routes_XP2 SET PrereqTech='TECH_SCIENTIFIC_THEORY' WHERE RouteType='ROUTE_RAILROAD';

--=======================================================================
--******                   MELEE  NAVAL                            ******
--=======================================================================

--=======================================================================
--******                   RANGE  NAVAL                            ******
--=======================================================================

--=======================================================================
--******                  NAVAL RAIDER                             ******
--=======================================================================

-- Jack the Ripper proposal (31/12/2020) to boost Naval Movement
-- Resource cost / Maintenance is 1 in GS
UPDATE Units_XP2 SET ResourceCost=0 WHERE  UnitType='UNIT_SUBMARINE';
UPDATE Units_XP2 SET ResourceMaintenanceAmount=0 WHERE  UnitType='UNIT_SUBMARINE';
UPDATE Units SET StrategicResource=NULL WHERE UnitType='UNIT_SUBMARINE';
UPDATE Units_XP2 SET ResourceMaintenanceType=NULL WHERE  UnitType='UNIT_SUBMARINE';

-- 23/04/2021: Implemented by Firaxis
--UPDATE Units_XP2 SET ResourceCost='0' WHERE  UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units_XP2 SET ResourceMaintenanceAmount='0' WHERE  UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units SET StrategicResource=NULL WHERE UnitType='UNIT_GERMAN_UBOAT';
--UPDATE Units_XP2 SET ResourceMaintenanceType=NULL WHERE  UnitType='UNIT_GERMAN_UBOAT';

--=======================================================================
--******                 AIRCRAFT CARRIER                          ******
--=======================================================================

--=======================================================================
--******                   OTHER  NAVAL                            ******
--=======================================================================

--=======================================================================
--******                        Spy                                ******
--=======================================================================

--=======================================================================
--******                        OTHER                              ******
--=======================================================================

-- Monks: Cards/Governments
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_GLOBAL_COALITION_FRIENDLY_TERRITORY', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_DIGITAL_DEMOCRACY_DEBUFF', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_FINEST_HOUR_FRIENDLY_TERRITORY', 'CLASS_WARRIOR_MONK');

--=======================================================================
--******                        ROCKBAND                           ******
--=======================================================================

-- 02/07/23: Strange that it does not exist in Types table
INSERT INTO Types(Type, Kind) VALUES
    ('RESULT_OPENING_ACT', 'KIND_ROCKBAND_RESULT');

-- ROCKBAND 
-- 02/07/23: Nerfed scaling of rockbands
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=40 WHERE ResultType='RESULT_OPENING_ACT';
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=80 WHERE ResultType='RESULT_RISING_STARS';
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=120 WHERE ResultType='RESULT_HEADLINERS';
UPDATE Unit_RockbandResults_XP2 SET AlbumSales=160 WHERE ResultType='RESULT_LEGENDS_OF_ROCK';

-- 17/03/26 : delay Rockband to SPACE RACE
UPDATE Units SET PrereqCivic='CIVIC_SPACE_RACE' WHERE UnitType='UNIT_ROCK_BAND';

-- 22/07/26 : Rockbands lose movements and can be killed
UPDATE Units SET BaseMoves=2, CanCapture=0, CanRetreatWhenCaptured=0 WHERE UnitType='UNIT_ROCK_BAND';