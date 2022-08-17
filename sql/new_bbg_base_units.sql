------------------------------------------------------------------------------
--	FILE:	 new_bbg_base_units.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database leader related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******						STANDARD UNITS FROM VANILLA GAME							******
--==============================================================================================
-- Old Codenaugh's Unit change
UPDATE UnitCommands SET VisibleInUI=0 WHERE CommandType='UNITCOMMAND_PRIORITY_TARGET';
UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_MILITARY_ENGINEER';
UPDATE Units SET Cost=310 WHERE UnitType='UNIT_CAVALRY';
UPDATE Units SET PrereqCivic='CIVIC_EXPLORATION' WHERE UnitType='UNIT_PRIVATEER';
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('GRAPE_SHOT_REQUIREMENTS',	'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('SHRAPNEL_REQUIREMENTS', 'PLAYER_IS_ATTACKER_REQUIREMENTS');

-- Melee changes
UPDATE Units SET Combat=46, PrereqTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_MAN_AT_ARMS';
UPDATE Units SET Combat=36 WHERE UnitType='UNIT_SWORDSMAN';
-- Melee vs Anticav +10 instead of +5
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='ANTI_SPEAR' AND Name='Amount';
-- Anticav promote to +10
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='THRUST_BONUS_VS_MELEE' AND Name='Amount';

-- Jack the Ripper proposal (31/12/2020) to boost Naval Movement
-- Base is 3, Resource cost / Maintenance is 1 in GS
UPDATE Units SET BaseMoves=4 WHERE  UnitType='UNIT_SUBMARINE';
UPDATE Units SET BaseMoves=4 WHERE  UnitType='UNIT_GERMAN_UBOAT';
-- Base is 4
UPDATE Units SET BaseMoves=6 WHERE  UnitType='UNIT_DESTROYER';
-- Base is 3
UPDATE Units SET BaseMoves=5 WHERE  UnitType='UNIT_AIRCRAFT_CARRIER';

-- 31/07/2021 Late Game Unit rework
UPDATE Units SET Combat=80 WHERE UnitType='UNIT_AT_CREW';
UPDATE Units SET Combat=80, BaseMoves=3 WHERE UnitType='UNIT_INFANTRY';
UPDATE Units SET Combat=65, RangedCombat=75 WHERE UnitType='UNIT_BATTLESHIP';
UPDATE Units SET BaseMoves=6 WHERE UnitType='UNIT_HELICOPTER';
-- UPDATE Units SET Combat=75, RangedCombat=95 WHERE UnitType='UNIT_MACHINE_GUN';
UPDATE Units SET Combat=70 WHERE UnitType='UNIT_AIRCRAFT_CARRIER';
UPDATE Units SET Combat=90 WHERE UnitType='UNIT_DESTROYER';
-- UPDATE Units SET Combat=75 WHERE UnitType='UNIT_ROCKET_ARTILLERY';
UPDATE Units SET Combat=90 WHERE UnitType='UNIT_MODERN_AT';
UPDATE Units SET Combat=90 WHERE UnitType='UNIT_MECHANIZED_INFANTRY';
-- UPDATE Units SET Combat=85, RangedCombat=95 WHERE UnitType='UNIT_NUCLEAR_SUBMARINE';
-- UPDATE Units SET Combat=80, RangedCombat=95 WHERE UnitType='UNIT_MISSILE_CRUISER';
UPDATE Units SET Combat=140, AntiAirCombat=120 WHERE UnitType='UNIT_GIANT_DEATH_ROBOT';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='GDR_AA_DEFENSE' AND Name='Amount';

--=== RECON UNITS ===--
-- 1 sight after ranger
UPDATE Units SET BaseSightRange=3 WHERE UnitType IN ('UNIT_RANGER', 'UNIT_SPEC_OPS');
-- Upgrade ReconUnit strengh
UPDATE Units SET Combat=25, RangedCombat=35 WHERE UnitType='UNIT_SKIRMISHER'; -- +5/+5
UPDATE Units SET Combat=55, RangedCombat=65 WHERE UnitType='UNIT_RANGER'; -- +10/+5
UPDATE Units SET Combat=65, RangedCombat=75 WHERE UnitType='UNIT_SPEC_OPS'; -- +10/+10
-- Reduce Ambush Strength to 15 (from 20)
UPDATE ModifierArguments SET Value='15' WHERE ModifierId='AMBUSH_INCREASED_COMBAT_STRENGTH';
-- Merge SpyGlass and Sentry promotion
UPDATE UnitPromotionModifiers SET UnitPromotionType='PROMOTION_SENTRY' WHERE ModifierId='SPYGLASS_BONUS_SIGHT';
-- Create new Promotion : Endurance, +2 PM
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_PROMOTION_ENDURANCE', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_PROMOTION_ENDURANCE', 'Amount', '2');
INSERT INTO UnitPromotionModifiers(UnitPromotionType, ModifierId) VALUES
    ('PROMOTION_SPYGLASS', 'BBG_PROMOTION_ENDURANCE');

-- 05/09/2021: Ranged unit don't get support bonus
INSERT INTO Types(Type, Kind) VALUES
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'CLASS_NAVAL_RAIDER'),
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'CLASS_NAVAL_RANGED'),
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'CLASS_RANGED'),
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'CLASS_RANGED_CAVALRY'),
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'CLASS_SIEGE');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'LOC_BBG_ABILITY_NO_SUPPORT_BONUS_NAME', 'LOC_BBG_ABILITY_NO_SUPPORT_BONUS_DESC');
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'BBG_NO_SUPPORT_BONUS_MODIFIER');
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_NO_SUPPORT_BONUS_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_SUPPORT_BONUS_MODIFIER');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_NO_SUPPORT_BONUS_MODIFIER', 'Percent', '-100');