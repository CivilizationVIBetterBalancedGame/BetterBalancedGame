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

-- 09/03/24 Buff military engineers +1 charge
UPDATE Units SET BuildCharges=3 WHERE UnitType='UNIT_MILITARY_ENGINEER';

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

-- Missile Cruiser range from 3 to 4
UPDATE Units SET Range=4 WHERE UnitType='UNIT_MISSILE_CRUISER';

-- 31/07/2021 Late Game Unit rework
UPDATE Units SET Combat=80 WHERE UnitType='UNIT_AT_CREW';
UPDATE Units SET Combat=80, BaseMoves=3 WHERE UnitType='UNIT_INFANTRY';
UPDATE Units SET Combat=65, RangedCombat=75 WHERE UnitType='UNIT_BATTLESHIP';
--03/10/22: movement from 6 to 5
UPDATE Units SET BaseMoves=5 WHERE UnitType='UNIT_HELICOPTER';
-- 20/12/23 movement from 2 to 3 machine gun
UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_MACHINE_GUN';

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

-- Battlecry description is Missleading, in base it works on mele/anticav and ranged.
-- BBG5.0 Changes it to work on Monks as well, here I also let the promo work on recon.
-- So than it works on all land non-cavalary units
-- Monks: Affected by Battlecry
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_OPPONENT_IS_RECON','REQUIREMENT_OPPONENT_UNIT_PROMOTION_CLASS_MATCHES'),
    ('BBG_OPPONENT_IS_NIHANG', 'REQUIREMENT_OPPONENT_UNIT_PROMOTION_CLASS_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_OPPONENT_IS_RECON','UnitPromotionClass','PROMOTION_CLASS_RECON'),
    ('BBG_OPPONENT_IS_NIHANG','UnitPromotionClass','PROMOTION_CLASS_NIHANG');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES 
    ('BATTLECRY_OPPONENT_REQUIREMENTS', 'BBG_OPPONENT_IS_RECON'),
    ('BATTLECRY_OPPONENT_REQUIREMENTS', 'BBG_OPPONENT_IS_NIHANG');

-- 16/12 Mobile SAM buff 110 anti air
-- Start of the -5 vs planes but didn't find an adapted modifier
-- INSERT INTO Tags VALUES
--     ('BBG_CLASS_MOBILE_SAM', 'ABILITY_CLASS');
-- INSERT INTO Types (Type, Kind) VALUES 
--     ('BBG_ABILITY_MINUS_CS_PLANES', 'KIND_ABILITY');
-- INSERT INTO TypesTags VALUES
--     ('UNIT_MOBILE_SAM', 'BBG_CLASS_MOBILE_SAM'),
--     ('BBG_ABILITY_MINUS_PLANES', 'BBG_CLASS_MOBILE_SAM');

-- INSERT INTO UnitAbilitiesModifiers (UnitAbilityType, UnitAbilityModifiers) VALUES
--     ('BBG_ABILITY_MINUS_CS_PLANES', 'BBG_MODIFIER_MINUS_CS_PLANES');
-- INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
--     ('BBG_ABILITY_MINUS_CS_PLANES', 'LOC_BBG_ABILITY_MINUS_CS_PLANES_NAME', 'LOC_BBG_ABILITY_MINUS_CS_PLANES_DESC');

-- INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
--     ('BBG_MODIFIER_MINUS_CS_PLANES', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_REQUIREMENT_')
UPDATE Units SET AntiAirCombat=110 WHERE UnitType='UNIT_MOBILE_SAM';

-- 16/12/22 Obsolescence
-- 15/10/23 added Varus
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_WARRIOR';
UPDATE Units SET MandatoryObsoleteTech='TECH_BALLISTICS' WHERE UnitType='UNIT_HEAVY_CHARIOT';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_SWORDSMAN';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_ROMAN_LEGION';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_KONGO_SHIELD_BEARER';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_JAPANESE_SAMURAI';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_NORWEGIAN_BERSERKER';
UPDATE Units SET MandatoryObsoleteTech='TECH_COMBUSTION' WHERE UnitType='UNIT_KNIGHT';
UPDATE Units SET MandatoryObsoleteTech='TECH_COMBUSTION' WHERE UnitType='UNIT_ARABIAN_MAMLUK';
UPDATE Units SET MandatoryObsoleteTech='TECH_REPLACEABLE_PARTS' WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units SET MandatoryObsoleteTech='TECH_REPLACEABLE_PARTS' WHERE UnitType='UNIT_SPANISH_CONQUISTADOR';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_MAN_AT_ARMS';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_AZTEC_EAGLE_WARRIOR';
UPDATE Units SET MandatoryObsoleteTech='TECH_STEEL' WHERE UnitType='UNIT_KHMER_DOMREY';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_MACEDONIAN_HYPASPIST';
UPDATE Units SET MandatoryObsoleteTech='TECH_BALLISTICS' WHERE UnitType='UNIT_INDIAN_VARU';
UPDATE Units SET MandatoryObsoleteTech='TECH_BALLISTICS' WHERE UnitType='UNIT_MACEDONIAN_HETAIROI';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_PERSIAN_IMMORTAL';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_GEORGIAN_KHEVSURETI';
UPDATE Units SET MandatoryObsoleteTech='TECH_COMBUSTION' WHERE UnitType='UNIT_MALI_MANDEKALU_CAVALRY';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_MAORI_TOA';
UPDATE Units SET MandatoryObsoleteTech='TECH_REPLACEABLE_PARTS' WHERE UnitType='UNIT_SULEIMAN_JANISSARY';
UPDATE Units SET MandatoryObsoleteTech='TECH_COMBUSTION' WHERE UnitType='UNIT_BYZANTINE_TAGMA';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_GAUL_GAESATAE';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_BABYLONIAN_SABUM_KIBITTUM';

--5.2.5 Musketman/Line infantry buff
UPDATE Units SET Cost=220 WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units SET Cost=330 WHERE UnitType='UNIT_LINE_INFANTRY';

--08/06/23 Pikemen cost from 180 to 200
UPDATE Units SET Cost=200 WHERE UnitType='UNIT_PIKEMAN';
--08/06/23 Pike & Shot cost from 250 to 290
UPDATE Units SET Cost=290 WHERE UnitType='UNIT_PIKE_AND_SHOT';

--18/12/23 Medic to military science + reduction cost
UPDATE Units SET PrereqTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_MEDIC';
UPDATE Units SET Cost=300 WHERE UnitType='UNIT_MEDIC';

--19/12/23 Medic gives movement point to melee ranged and anticav
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'CLASS_MEDIC'),
    ('ABILITY_MEDIC_HEAL', 'CLASS_LOGISTIC_MOVEMENT');
DELETE FROM TypeTags WHERE Type='UNIT_SUPPLY_CONVOY' AND Tag='CLASS_MEDIC';

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_MEDIC_MOVEMENT_MELEE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_MEDIC_MOVEMENT_RANGED_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_MEDIC_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_MEDIC_MOVEMENT_MELEE_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_MELEE_REQSET', 'REQUIREMENT_UNIT_IS_MELEE'),
    ('BBG_MEDIC_MOVEMENT_RANGED_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_RANGED_REQSET', 'REQUIREMENT_UNIT_IS_RANGED'),
    ('BBG_MEDIC_MOVEMENT_ANTICAV_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENT_UNIT_IS_ANTI_CAV');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MEDIC_MELEE_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_MELEE_REQSET'),
    ('BBG_MEDIC_RANGED_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_RANGED_REQSET'),
    ('BBG_MEDIC_ANTICAV_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_ANTICAV_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MEDIC_MELEE_MOVEMENT', 'Amount', 1),
    ('BBG_MEDIC_RANGED_MOVEMENT', 'Amount', 1),
    ('BBG_MEDIC_ANTICAV_MOVEMENT', 'Amount', 1);

INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'LOC_BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_NAME', 'LOC_BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_DESC');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_MELEE_MOVEMENT'),
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_RANGED_MOVEMENT'),
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_ANTICAV_MOVEMENT');

-- 19/12/23 Ram and tower obsolete at military science
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType IN ('UNIT_BATTERING_RAM', 'UNIT_SIEGE_TOWER');
UPDATE Units SET ObsoleteCivic=NULL WHERE UnitType IN ('UNIT_BATTERING_RAM', 'UNIT_SIEGE_TOWER');


--19/12/23 Naval support only from naval units
INSERT INTO Types(Type, Kind) VALUES
    ('BBG_ABILITY_SUPPORT_NAVAL_MELEE', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_ABILITY_SUPPORT_NAVAL_MELEE', 'CLASS_NAVAL_MELEE'),
    ('BBG_ABILITY_NO_SUPPORT_BONUS', 'CLASS_NAVAL_MELEE');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_IS_DEFENDER_IN_MELEE', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_IS_DEFENDER_IN_MELEE', 'PLAYER_IS_DEFENDER_REQUIREMENTS'),
    ('BBG_UNIT_IS_DEFENDER_IN_MELEE', 'MELEE_COMBAT_REQUIREMENTS');
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_SUPPORT_NAVAL_MELEE', 'LOC_BBG_ABILITY_SUPPORT_NAVAL_MELEE_NAME', 'LOC_BBG_ABILITY_SUPPORT_NAVAL_MELEE_DESC');

CREATE TABLE TmpNavalUnit(UnitType PRIMARY KEY NOT NULL);
INSERT INTO TmpNavalUnit(UnitType) VALUES
    ('UNIT_GALLEY'),
    ('UNIT_NORWEGIAN_LONGSHIP'),
    ('UNIT_QUADRIREME'),
    ('UNIT_CARAVEL'),
    ('UNIT_FRIGATE'),
    ('UNIT_PRIVATEER'),
    ('UNIT_ENGLISH_SEADOG'),
    ('UNIT_IRONCLAD'),
    ('UNIT_BATTLESHIP'),
    ('UNIT_BRAZILIAN_MINAS_GERAES'),
    ('UNIT_SUBMARINE'),
    ('UNIT_GERMAN_UBOAT'),
    ('UNIT_AIRCRAFT_CARRIER'),
    ('UNIT_DESTROYER'),
    ('UNIT_NUCLEAR_SUBMARINE'),
    ('UNIT_MISSILE_CRUISER');
    --also see portugal, indo, dutch, byzantium and xp2/units.sql

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

-- 10/03/24
-- INSERT INTO Requirements (RequirementId, RequirementType) VALUES
--     ('BBG_REQUIRE_MEDIEVAL', 'REQUIREMENT_UNIT_ERA_TYPE_MATCHES');
-- INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
--     ('BBG_REQUIRE_MEDIEVAL', 'EraType', 'ERA_MEDIEVAL');
-- INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
--     ('BBG_REQUIRE_MEDIEVAL_REQSET', 'REQUIREMENTSET_TEST_ALL');
-- INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
--     ('BBG_REQUIRE_MEDIEVAL_REQSET', 'BBG_REQUIRE_MEDIEVAL');
-- INSERT INTO Tags (Tag, Vocabulary) VALUES
--     ('CLASS_GREAT_ADMIRAL', 'ABILITY_CLASS');
-- INSERT INTO Types (Type, Kind) VALUES
--     ('BBG_ABILITY_GREAT_ADMIRAL_MOVEMENT_BONUS', 'KIND_ABILITY');
-- INSERT INTO TypeTags (Type, Tag) VALUES
--     ('BBG_ABILITY_GREAT_ADMIRAL_MOVEMENT_BONUS', 'CLASS_GREAT_ADMIRAL'),
--     ('UNIT_GREAT_ADMIRAL', 'CLASS_GREAT_ADMIRAL');
-- INSERT INTO Modifiers ( ModifierId, ModifierType) VALUES
--     ('BBG_GREAT_ADMIRAL_MOVEMENT_BONUS', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--     ('BBG_GREAT_ADMIRAL_MOVEMENT_BONUS', 'Amount', '1');
-- INSERT INTO UnitAbilityModifiers VALUES
--     ('BBG_ABILITY_GREAT_ADMIRAL_MOVEMENT_BONUS', 'BBG_GREAT_ADMIRAL_MOVEMENT_BONUS');
-- INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
--     ('BBG_ABILITY_GREAT_ADMIRAL_MOVEMENT_BONUS', 'LOC_BBG_ABILITY_GREAT_ADMIRAL_MOVEMENT_BONUS_NAME', 'LOC_BBG_ABILITY_GREAT_ADMIRAL_MOVEMENT_BONUS_DESC');


-- 02/07/24 Naval first promote (melee and ranged) reduced to +5 from +7 
UPDATE ModifierArguments SET Value=5 WHERE ModifierId='EMBOLON_BONUS_VS_NAVAL';
UPDATE ModifierArguments SET Value=5 WHERE ModifierId='LINE_OF_BATTLE_BONUS_VS_NAVAL';

-- 02/07/24 Recon Units get +1 sight (except scouts/oki)
UPDATE Units SET BaseSightRange=BaseSightRange+1 WHERE PromotionClass='PROMOTION_CLASS_RECON' AND UnitType NOT IN ('UNIT_SCOUT', 'UNIT_CREE_OKIHTCITAW');