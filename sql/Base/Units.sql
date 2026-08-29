------------------------------------------------------------------------------
--	FILE:	 new_bbg_base_units.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database leader related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******						STANDARD UNITS FROM VANILLA GAME                          ******
--==============================================================================================
-- Old Codenaugh's Unit change
UPDATE UnitCommands SET VisibleInUI=0 WHERE CommandType='UNITCOMMAND_PRIORITY_TARGET';

--=======================================================================
--******                       GDR                                 ******
--=======================================================================

UPDATE Units SET Combat=140, AntiAirCombat=120 WHERE UnitType='UNIT_GIANT_DEATH_ROBOT';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='GDR_AA_DEFENSE' AND Name='Amount';

-- 29/03/25 GDR can't be gold bought
-- 08/04/25 Reverted
-- UPDATE Units SET PurchaseYield=NULL WHERE UnitType='UNIT_GIANT_DEATH_ROBOT';


--=======================================================================
--******                    LIGHT CAV                              ******
--=======================================================================

-- old change : don't affect uu
UPDATE Units SET Cost=310 WHERE UnitType='UNIT_CAVALRY';

-- 03/10/22: movement from 6 to 5
UPDATE Units SET BaseMoves=5 WHERE UnitType='UNIT_HELICOPTER';

-- 04/07/26 Light cav heal +10 on kill
-- 29/08/26 reverted
-- INSERT INTO Types(Type, Kind) VALUES
--     ('BBG_ABILITY_LIGHT_CAV_HEAL_ON_KILL', 'KIND_ABILITY');
-- INSERT INTO TypeTags(Type, Tag) VALUES
--     ('BBG_ABILITY_LIGHT_CAV_HEAL_ON_KILL', 'CLASS_LIGHT_CAVALRY');

-- INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
--     ('BBG_LIGHT_CAV_HEAL_ON_KILL', 'MODIFIER_PLAYER_UNIT_ADJUST_HEAL_FROM_COMBAT');
-- INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
--     ('BBG_LIGHT_CAV_HEAL_ON_KILL', 'Amount', 10);

-- INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
--     ('BBG_ABILITY_LIGHT_CAV_HEAL_ON_KILL', 'LOC_BBG_ABILITY_LIGHT_CAV_HEAL_ON_KILL_NAME', 'LOC_BBG_ABILITY_LIGHT_CAV_HEAL_ON_KILL_DESC');
-- INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
--     ('BBG_ABILITY_LIGHT_CAV_HEAL_ON_KILL', 'BBG_LIGHT_CAV_HEAL_ON_KILL');

--=======================================================================
--******                    HEAVY CAV                              ******
--=======================================================================

-- 03/03/25 Modern Armor : Gets +1 movement.  
UPDATE Units SET BaseMoves=5 WHERE UnitType='UNIT_MODERN_ARMOR';
-- +5 when defending inside friendly territory and +5 when attacking outside of friendly territory
-- 04/07/26 reverted, replaced with base +5

-- INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
--     ('BBG_UNIT_IS_DEFENDER_IN_FRIENDLY_REQSET', 'REQUIREMENTSET_TEST_ALL'),
--     ('BBG_UNIT_IS_ATTACKER_NOT_IN_FRIENDLY_REQSET', 'REQUIREMENTSET_TEST_ALL');
-- INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
--     ('BBG_UNIT_IS_DEFENDER_IN_FRIENDLY_REQSET', 'PLAYER_IS_DEFENDER_REQUIREMENTS'),
--     ('BBG_UNIT_IS_DEFENDER_IN_FRIENDLY_REQSET', 'IS_FRIENDLY_TERRITORY_REQUIREMENT'),
--     ('BBG_UNIT_IS_ATTACKER_NOT_IN_FRIENDLY_REQSET', 'PLAYER_IS_ATTACKER_REQUIREMENTS'),
--     ('BBG_UNIT_IS_ATTACKER_NOT_IN_FRIENDLY_REQSET', 'REQUIRES_UNIT_NOT_IN_OWNER_TERRITORY');

-- -- Mandatory if the player doesn't have Australian DLC
-- INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
--     ('REQUIRES_UNIT_NOT_IN_OWNER_TERRITORY', 'REQUIREMENT_UNIT_IN_OWNER_TERRITORY', 1);

-- INSERT INTO Tags (Tag, Vocabulary) VALUES
--     ('CLASS_MODERN_ARMOR', 'ABILITY_CLASS');
-- INSERT INTO Types (Type, Kind) VALUES
--     ('BBG_ABILITY_STRENGTH_DEFENDING_FRIENDLY', 'KIND_ABILITY'),
--     ('BBG_ABILITY_STRENGTH_ATTACKING_UNFRIENDLY', 'KIND_ABILITY');
-- INSERT INTO TypeTags (Type, Tag) VALUES
--     ('UNIT_MODERN_ARMOR', 'CLASS_MODERN_ARMOR'),
--     ('BBG_ABILITY_STRENGTH_DEFENDING_FRIENDLY', 'CLASS_MODERN_ARMOR'),
--     ('BBG_ABILITY_STRENGTH_ATTACKING_UNFRIENDLY', 'CLASS_MODERN_ARMOR');
-- INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
--     ('BBG_ABILITY_STRENGTH_DEFENDING_FRIENDLY', 'LOC_BBG_ABILITY_STRENGTH_DEFENDING_FRIENDLY_NAME', 'LOC_BBG_ABILITY_STRENGTH_DEFENDING_FRIENDLY_DESC'),
--     ('BBG_ABILITY_STRENGTH_ATTACKING_UNFRIENDLY', 'LOC_BBG_ABILITY_STRENGTH_ATTACKING_UNFRIENDLY_NAME', 'LOC_BBG_ABILITY_STRENGTH_ATTACKING_UNFRIENDLY_DESC');
-- INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
--     ('BBG_ABILITY_STRENGTH_DEFENDING_FRIENDLY', 'BBG_STRENGTH_DEFENDING_FRIENDLY'),
--     ('BBG_ABILITY_STRENGTH_ATTACKING_UNFRIENDLY', 'BBG_STRENGTH_ATTACKING_UNFRIENDLY');
-- INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
--     ('BBG_STRENGTH_DEFENDING_FRIENDLY', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_UNIT_IS_DEFENDER_IN_FRIENDLY_REQSET'),
--     ('BBG_STRENGTH_ATTACKING_UNFRIENDLY', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_UNIT_IS_ATTACKER_NOT_IN_FRIENDLY_REQSET');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--     ('BBG_STRENGTH_DEFENDING_FRIENDLY', 'Amount', 5),
--     ('BBG_STRENGTH_ATTACKING_UNFRIENDLY', 'Amount', 5);
-- INSERT INTO ModifierStrings (ModifierId , Context , Text) VALUES
--     ('BBG_STRENGTH_DEFENDING_FRIENDLY', 'Preview', 'LOC_BBG_ABILITY_STRENGTH_DEFENDING_FRIENDLY_DESC'),
--     ('BBG_STRENGTH_ATTACKING_UNFRIENDLY', 'Preview', 'LOC_BBG_ABILITY_STRENGTH_ATTACKING_UNFRIENDLY_DESC');

UPDATE Units SET Combat=100 WHERE UnitType='UNIT_MODERN_ARMOR';

-- 04/07/26 Heavy cav +5 vs melee
-- 26/08/26 +3
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_HEAVY_CAVALRY_VS_MELEE_REQSET', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_HEAVY_CAVALRY_VS_MELEE_REQSET', 'OPPONENT_IS_PROMOTION_CLASS_MELEE'),
    ('BBG_HEAVY_CAVALRY_VS_MELEE_REQSET', 'BBG_OPPONENT_IS_NIHANG'),
    ('BBG_HEAVY_CAVALRY_VS_MELEE_REQSET', 'BBG_OPPONENT_IS_MONK');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId ) VALUES
    ('BBG_HEAVY_CAVALRY_BONUS_VS_MELEE', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_HEAVY_CAVALRY_VS_MELEE_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_HEAVY_CAVALRY_BONUS_VS_MELEE', 'Amount', 3);
INSERT INTO ModifierStrings(ModifierId, Context, Text) VALUES
    ('BBG_HEAVY_CAVALRY_BONUS_VS_MELEE', 'Preview', 'LOC_BBG_ABILITY_HEAVY_CAVALRY_BONUS_VS_MELEE_DESC');

INSERT INTO Types(Type, Kind) VALUES
    ('BBG_ABILITY_HEAVY_CAVALRY_BONUS_VS_MELEE', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_ABILITY_HEAVY_CAVALRY_BONUS_VS_MELEE', 'CLASS_HEAVY_CAVALRY');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_HEAVY_CAVALRY_BONUS_VS_MELEE', 'LOC_BBG_ABILITY_HEAVY_CAVALRY_BONUS_VS_MELEE_NAME', 'LOC_BBG_ABILITY_HEAVY_CAVALRY_BONUS_VS_MELEE_DESC');
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_HEAVY_CAVALRY_BONUS_VS_MELEE', 'BBG_HEAVY_CAVALRY_BONUS_VS_MELEE');

-- 12/07/26 rework heavy chariot as an answer to melee uu
UPDATE Units set Combat=36, BaseMoves=2, Cost=90 where UnitType='UNIT_HEAVY_CHARIOT';
--=======================================================================
--******                        RECON                              ******
--=======================================================================

-- 1 sight after ranger
UPDATE Units SET BaseSightRange=3 WHERE UnitType IN ('UNIT_RANGER', 'UNIT_SPEC_OPS');

-- 02/07/24 Recon Units get +1 sight (except scouts/oki)
UPDATE Units SET BaseSightRange=BaseSightRange+1 WHERE PromotionClass='PROMOTION_CLASS_RECON' AND UnitType NOT IN ('UNIT_SCOUT', 'UNIT_CREE_OKIHTCITAW', 'UNIT_CVS_TAINO_UU');

-- Upgrade ReconUnit strengh
-- 08/04/25 +5 melee
UPDATE Units SET Combat=30, RangedCombat=35 WHERE UnitType='UNIT_SKIRMISHER'; -- +5/+5
UPDATE Units SET Combat=60, RangedCombat=65 WHERE UnitType='UNIT_RANGER'; -- +10/+5
UPDATE Units SET Combat=70, RangedCombat=75 WHERE UnitType='UNIT_SPEC_OPS'; -- +10/+10
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

-- 04/07/26 Skirmisher cost reduced to 60 from 75 (150 -> 120)
UPDATE Units SET Cost=120 WHERE UnitType='UNIT_SKIRMISHER';

--=======================================================================
--******                        RANGE                              ******
--=======================================================================

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


-- 16/03/26 Reduce promotion from garnison to 7 (from 10)
UPDATE ModifierArguments SET Value='7' WHERE ModifierId='GARRISON_BONUS_DISTRICTS' AND Name='Amount';

-- 20/12/23 movement from 2 to 3 machine gun
UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_MACHINE_GUN';
-- 18/12/25 Machine gun get aa
-- 04/07/26 Reverted
-- UPDATE Units SET AntiAirCombat=80 WHERE UnitType='UNIT_MACHINE_GUN';
-- 14/07/26 Machine Gun -5 range cs
UPDATE Units SET RangedCombat=RangedCombat-5 WHERE UnitType='UNIT_MACHINE_GUN';
-- 07/08/26 Machine Gun more expensive
UPDATE Units SET Cost=600 WHERE UnitType='UNIT_MACHINE_GUN';


--=======================================================================
--******                        MELEE                              ******
--=======================================================================

-- Melee changes
UPDATE Units SET Combat=46, PrereqTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_MAN_AT_ARMS';
UPDATE Units SET Combat=36 WHERE UnitType='UNIT_SWORDSMAN';

-- Melee vs Anticav +10 instead of +5
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='ANTI_SPEAR' AND Name='Amount';

-- PROMOTIONS

-- 26/08/26 Battlecry reduce to +5 (from +7)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='BATTLECRY_BONUS_VS_MELEE_RANGED' AND Name='Amount';

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


-- 31/07/2021 Late Game Unit rework
UPDATE Units SET Combat=80, BaseMoves=3 WHERE UnitType='UNIT_INFANTRY';

-- 02/07/22 5.2.5 Musketman/Line infantry buff
UPDATE Units SET Cost=220 WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units SET Cost=330 WHERE UnitType='UNIT_LINE_INFANTRY';

-- 16/12/22
UPDATE Units SET Combat=90 WHERE UnitType='UNIT_MECHANIZED_INFANTRY';

-- 03/03/25 UNIT_MECHANIZED_INFANTRY 5 mov and ignores zoc
-- 04/07/26 Reverted
-- UPDATE Units SET BaseMoves=5 WHERE UnitType='UNIT_MECHANIZED_INFANTRY';
-- INSERT INTO Tags (Tag, Vocabulary) VALUES
--     ('CLASS_MECHANIZED_INFANTRY', 'ABILITY_CLASS');
-- INSERT INTO TypeTags (Type, Tag) VALUES
--     ('UNIT_MECHANIZED_INFANTRY', 'CLASS_MECHANIZED_INFANTRY'),
--     ('ABILITY_IGNORE_ZOC', 'CLASS_MECHANIZED_INFANTRY');

UPDATE Units SET Combat=90 WHERE UnitType='UNIT_MECHANIZED_INFANTRY';
-- 04/07/26 Modern Era Tech path Rework
UPDATE Units SET PrereqTech='TECH_REFINING' WHERE UnitType='UNIT_INFANTRY';
-- 04/07/26 Informations Era Tech path Rework
UPDATE Units SET PrereqTech='TECH_GUIDANCE_SYSTEMS' WHERE UnitType='UNIT_MECHANIZED_INFANTRY';


--=======================================================================
--******                     ANTICAV                               ******
--=======================================================================

-- Anticav promote to +10
-- 26/08/26 revert to +5
-- UPDATE ModifierArguments SET Value='10' WHERE ModifierId='THRUST_BONUS_VS_MELEE' AND Name='Amount';

-- 31/07/2021 Late Game Unit rework
UPDATE Units SET Combat=80 WHERE UnitType='UNIT_AT_CREW';
-- 04/07/26 AT CREW +1 movement
UPDATE Units SET BaseMoves=BaseMoves+1 WHERE UnitType='UNIT_AT_CREW';
-- 04/07/26 MODERN AT +1 movement
UPDATE Units SET BaseMoves=BaseMoves+1 WHERE UnitType='UNIT_MODERN_AT';

-- 08/06/23 
UPDATE Units SET Combat=90 WHERE UnitType='UNIT_MODERN_AT';

--08/06/23 Pikemen cost from 180 to 200
UPDATE Units SET Cost=200 WHERE UnitType='UNIT_PIKEMAN';
--08/06/23 Pike & Shot cost from 250 to 290
UPDATE Units SET Cost=290 WHERE UnitType='UNIT_PIKE_AND_SHOT';

-- 04/07/26 Modern Era Tech path Rework
UPDATE Units SET PrereqTech='TECH_ADVANCED_BALLISTICS' WHERE UnitType='UNIT_AT_CREW';

-- 07/08/26 AT Crew more expensive per turn (same as infantry)
UPDATE Units SET Maintenance=6, Cost=460 WHERE UnitType='UNIT_AT_CREW';

--=======================================================================
--******                     SIEGE                               ******
--=======================================================================
-- UPDATE Units SET Combat=75 WHERE UnitType='UNIT_ROCKET_ARTILLERY';
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('GRAPE_SHOT_REQUIREMENTS',	'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('SHRAPNEL_REQUIREMENTS', 'PLAYER_IS_ATTACKER_REQUIREMENTS');



-- 30/06/25 Artillery & Rocket Artillery : +5 combat strength against city center.
-- 12/07/26 moved to all siege units
INSERT INTO Tags (Tag, Vocabulary) VALUES
    ('CLASS_ARTILLERY', 'ABILITY_CLASS');
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_ABILITY_ARTILLERY_DEFENSIBLE_DISTRICTS', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('UNIT_ARTILLERY', 'CLASS_ARTILLERY'),
    ('UNIT_ROCKET_ARTILLERY', 'CLASS_ARTILLERY'),
    ('BBG_ABILITY_ARTILLERY_DEFENSIBLE_DISTRICTS', 'CLASS_SIEGE');

INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_ARTILLERY_DEFENSIBLE_DISTRICTS', 'LOC_BBG_ABILITY_ARTILLERY_DEFENSIBLE_DISTRICTS_NAME', 'LOC_BBG_ABILITY_ARTILLERY_DEFENSIBLE_DISTRICTS_DESC');
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_ARTILLERY_DEFENSIBLE_DISTRICTS', 'BBG_ARTILLERY_DEFENSIBLE_DISTRICTS');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_ARTILLERY_DEFENSIBLE_DISTRICTS', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'UNIT_ATTACKING_DISTRICT_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_ARTILLERY_DEFENSIBLE_DISTRICTS', 'Amount', 5);
INSERT INTO ModifierStrings (ModifierId, Context , Text) VALUES
    ('BBG_ARTILLERY_DEFENSIBLE_DISTRICTS', 'Preview', 'LOC_BBG_ABILITY_ARTILLERY_DEFENSIBLE_DISTRICTS_DESC');

--=======================================================================
--******                      SUPPORT                              ******
--=======================================================================
-- 16/12/23 Mobile SAM buff 110 anti air
-- 29/03/25 5 movement (from 3)
-- 30/06/25 SAM 125 anti air (stop all nukes)
UPDATE Units SET AntiAirCombat=125, BaseMoves=5 WHERE UnitType='UNIT_MOBILE_SAM';

-- 04/07/26 Modern Era Tech path Rework
UPDATE Units SET PrereqTech='TECH_SATELLITES' WHERE UnitType='UNIT_MOBILE_SAM';

--18/12/23 Medic to military science + reduction cost
UPDATE Units SET PrereqTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_MEDIC';
UPDATE Units SET Cost=300 WHERE UnitType='UNIT_MEDIC';

--19/12/23 Medic gives movement point to melee ranged and anticav
-- 14/07/26 also works on nihang & warrior monks
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'CLASS_MEDIC'),
    ('ABILITY_MEDIC_HEAL', 'CLASS_LOGISTIC_MOVEMENT');
DELETE FROM TypeTags WHERE Type='UNIT_SUPPLY_CONVOY' AND Tag='CLASS_MEDIC';

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_MEDIC_MOVEMENT_MELEE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_MEDIC_MOVEMENT_RANGED_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_MEDIC_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_MEDIC_MOVEMENT_WARRIOR_MONK_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_MEDIC_MOVEMENT_MELEE_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_MELEE_REQSET', 'REQUIREMENT_UNIT_IS_MELEE'),
    ('BBG_MEDIC_MOVEMENT_RANGED_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_RANGED_REQSET', 'REQUIREMENT_UNIT_IS_RANGED'),
    ('BBG_MEDIC_MOVEMENT_ANTICAV_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENT_UNIT_IS_ANTI_CAV'),
    ('BBG_MEDIC_MOVEMENT_WARRIOR_MONK_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_MEDIC_MOVEMENT_WARRIOR_MONK_REQSET', 'BBG_UNIT_IS_PROMOTION_CLASS_MONK');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, SubjectStackLimit ) VALUES
    ('BBG_MEDIC_MELEE_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_MELEE_REQSET', 1),
    ('BBG_MEDIC_RANGED_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_RANGED_REQSET', 1),
    ('BBG_MEDIC_ANTICAV_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_ANTICAV_REQSET', 1),
    ('BBG_MEDIC_WARRIOR_MONK_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_MEDIC_MOVEMENT_WARRIOR_MONK_REQSET', 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MEDIC_MELEE_MOVEMENT', 'Amount', 1),
    ('BBG_MEDIC_RANGED_MOVEMENT', 'Amount', 1),
    ('BBG_MEDIC_ANTICAV_MOVEMENT', 'Amount', 1),
    ('BBG_MEDIC_WARRIOR_MONK_MOVEMENT', 'Amount', 1);

INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'LOC_BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_NAME', 'LOC_BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_DESC');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_MELEE_MOVEMENT'),
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_RANGED_MOVEMENT'),
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_ANTICAV_MOVEMENT'),
    ('BBG_MEDIC_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_MEDIC_WARRIOR_MONK_MOVEMENT');

-- 05/07/26 Ram and tower also give movement point to melee, ranged and anticav (depending on era)
-- 14/07/26 also works on nihang & warrior monks
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'CLASS_BATTERING_RAM');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_RAM_MOVEMENT_MELEE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_RAM_MOVEMENT_RANGED_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_RAM_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_RAM_MOVEMENT_WARRIOR_MONK_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_RAM_MOVEMENT_MELEE_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_RAM_MOVEMENT_MELEE_REQSET', 'REQUIREMENT_UNIT_IS_MELEE'),
    ('BBG_RAM_MOVEMENT_MELEE_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_CLASSICAL'),

    ('BBG_RAM_MOVEMENT_RANGED_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_RAM_MOVEMENT_RANGED_REQSET', 'REQUIREMENT_UNIT_IS_RANGED'),
    ('BBG_RAM_MOVEMENT_RANGED_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_CLASSICAL'),

    ('BBG_RAM_MOVEMENT_ANTICAV_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_RAM_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENT_UNIT_IS_ANTI_CAV'),
    ('BBG_RAM_MOVEMENT_ANTICAV_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_CLASSICAL'),
    
    ('BBG_RAM_MOVEMENT_WARRIOR_MONK_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_RAM_MOVEMENT_WARRIOR_MONK_REQSET', 'BBG_UNIT_IS_PROMOTION_CLASS_MONK'),
    ('BBG_RAM_MOVEMENT_WARRIOR_MONK_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_CLASSICAL');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, SubjectStackLimit ) VALUES
    ('BBG_RAM_MELEE_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_RAM_MOVEMENT_MELEE_REQSET', 1),
    ('BBG_RAM_RANGED_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_RAM_MOVEMENT_RANGED_REQSET', 1),
    ('BBG_RAM_ANTICAV_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_RAM_MOVEMENT_ANTICAV_REQSET', 1),
    ('BBG_RAM_WARRIOR_MONK_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_RAM_MOVEMENT_WARRIOR_MONK_REQSET', 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_RAM_MELEE_MOVEMENT', 'Amount', 1),
    ('BBG_RAM_RANGED_MOVEMENT', 'Amount', 1),
    ('BBG_RAM_ANTICAV_MOVEMENT', 'Amount', 1),
    ('BBG_RAM_WARRIOR_MONK_MOVEMENT', 'Amount', 1);

INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'LOC_BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_NAME', 'LOC_BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_DESC');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_RAM_MELEE_MOVEMENT'),
    ('BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_RAM_RANGED_MOVEMENT'),
    ('BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_RAM_ANTICAV_MOVEMENT'),
    ('BBG_RAM_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_RAM_WARRIOR_MONK_MOVEMENT');

-- 
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'CLASS_SIEGE_TOWER');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_SIEGE_TOWER_MOVEMENT_MELEE_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_SIEGE_TOWER_MOVEMENT_RANGED_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_SIEGE_TOWER_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_SIEGE_TOWER_MOVEMENT_WARRIOR_MONK_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_SIEGE_TOWER_MOVEMENT_MELEE_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_SIEGE_TOWER_MOVEMENT_MELEE_REQSET', 'REQUIREMENT_UNIT_IS_MELEE'),
    ('BBG_SIEGE_TOWER_MOVEMENT_MELEE_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_RENAISSANCE'),

    ('BBG_SIEGE_TOWER_MOVEMENT_RANGED_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_SIEGE_TOWER_MOVEMENT_RANGED_REQSET', 'REQUIREMENT_UNIT_IS_RANGED'),
    ('BBG_SIEGE_TOWER_MOVEMENT_RANGED_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_RENAISSANCE'),

    ('BBG_SIEGE_TOWER_MOVEMENT_ANTICAV_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_SIEGE_TOWER_MOVEMENT_ANTICAV_REQSET', 'REQUIREMENT_UNIT_IS_ANTI_CAV'),
    ('BBG_SIEGE_TOWER_MOVEMENT_ANTICAV_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_RENAISSANCE'),
    
    
    ('BBG_SIEGE_TOWER_MOVEMENT_WARRIOR_MONK_REQSET', 'ADJACENT_UNIT_REQUIREMENT'),
    ('BBG_SIEGE_TOWER_MOVEMENT_WARRIOR_MONK_REQSET', 'BBG_UNIT_IS_PROMOTION_CLASS_MONK'),
    ('BBG_SIEGE_TOWER_MOVEMENT_WARRIOR_MONK_REQSET', 'BBG_UNIT_IS_UP_TO_ERA_CLASSICAL');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, SubjectStackLimit ) VALUES
    ('BBG_SIEGE_TOWER_MELEE_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_SIEGE_TOWER_MOVEMENT_MELEE_REQSET', 1),
    ('BBG_SIEGE_TOWER_RANGED_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_SIEGE_TOWER_MOVEMENT_RANGED_REQSET', 1),
    ('BBG_SIEGE_TOWER_ANTICAV_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_SIEGE_TOWER_MOVEMENT_ANTICAV_REQSET', 1),
    ('BBG_SIEGE_TOWER_WARRIOR_MONK_MOVEMENT', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'BBG_SIEGE_TOWER_MOVEMENT_WARRIOR_MONK_REQSET', 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SIEGE_TOWER_MELEE_MOVEMENT', 'Amount', 1),
    ('BBG_SIEGE_TOWER_RANGED_MOVEMENT', 'Amount', 1),
    ('BBG_SIEGE_TOWER_ANTICAV_MOVEMENT', 'Amount', 1),
    ('BBG_SIEGE_TOWER_WARRIOR_MONK_MOVEMENT', 'Amount', 1);

INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'LOC_BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_NAME', 'LOC_BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY_DESC');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_SIEGE_TOWER_MELEE_MOVEMENT'),
    ('BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_SIEGE_TOWER_RANGED_MOVEMENT'),
    ('BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_SIEGE_TOWER_ANTICAV_MOVEMENT'),
    ('BBG_SIEGE_TOWER_MOVEMENT_AOE_MELEE_ANTICAV_RANGE_ABILITY', 'BBG_SIEGE_TOWER_WARRIOR_MONK_MOVEMENT');

-- 19/12/23 Ram and tower obsolete at military science
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType IN ('UNIT_BATTERING_RAM', 'UNIT_SIEGE_TOWER');
UPDATE Units SET ObsoleteCivic=NULL WHERE UnitType IN ('UNIT_BATTERING_RAM', 'UNIT_SIEGE_TOWER');

-- 17/08/22
UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_MILITARY_ENGINEER';
-- 09/03/24 Buff military engineers +1 charge
UPDATE Units SET BuildCharges=3 WHERE UnitType='UNIT_MILITARY_ENGINEER';

-- 04/07/26 Military Engineers require barracks or stable, moved to engineering (and units buildings in corresponding files)
UPDATE Units SET PrereqTech='TECH_ENGINEERING' WHERE UnitType='UNIT_MILITARY_ENGINEER';
DELETE FROM Unit_BuildingPrereqs WHERE Unit='UNIT_MILITARY_ENGINEER';
INSERT INTO Unit_BuildingPrereqs (Unit, PrereqBuilding)
    VALUES ('UNIT_MILITARY_ENGINEER', 'BUILDING_BARRACKS'), ('UNIT_MILITARY_ENGINEER', 'BUILDING_STABLE');

--=======================================================================
--******                   MELEE  NAVAL                            ******
--=======================================================================

-- Jack the Ripper proposal (31/12/2020) to boost Naval Movement
-- Base is 4
UPDATE Units SET BaseMoves=6 WHERE UnitType='UNIT_DESTROYER';

-- 17/08/22
UPDATE Units SET Combat=90 WHERE UnitType='UNIT_DESTROYER';

-- 02/07/24 Naval first promote (melee and ranged) reduced to +5 from +7 
UPDATE ModifierArguments SET Value=5 WHERE ModifierId='EMBOLON_BONUS_VS_NAVAL';
--=======================================================================
--******                   RANGE  NAVAL                            ******
--=======================================================================

-- 18/08/22 Missile Cruiser range from 3 to 4
UPDATE Units SET Range=4 WHERE UnitType='UNIT_MISSILE_CRUISER';

-- UPDATE Units SET Combat=80, RangedCombat=95 WHERE UnitType='UNIT_MISSILE_CRUISER';
UPDATE Units SET Combat=65, RangedCombat=75 WHERE UnitType='UNIT_BATTLESHIP';

-- 02/07/24 Naval first promote (melee and ranged) reduced to +5 from +7 
UPDATE ModifierArguments SET Value=5 WHERE ModifierId='LINE_OF_BATTLE_BONUS_VS_NAVAL';

-- 04/07/26  All quads have 2 range
UPDATE Units SET Range=2 WHERE UnitType='UNIT_QUADRIREME';
-- 12/07/26  All quads have 2 range --> reduce ranged combat 
UPDATE Units SET RangedCombat=23 WHERE UnitType='UNIT_QUADRIREME';
-- 07/08/26 Quads cost more 
UPDATE Units SET Cost=160 WHERE UnitType='UNIT_QUADRIREME';

--=======================================================================
--******                  NAVAL RAIDER                             ******
--=======================================================================
UPDATE Units SET PrereqCivic='CIVIC_EXPLORATION' WHERE UnitType='UNIT_PRIVATEER';
-- UPDATE Units SET Combat=85, RangedCombat=95 WHERE UnitType='UNIT_NUCLEAR_SUBMARINE';
-- Jack the Ripper proposal (31/12/2020) to boost Naval Movement
-- Base is 3, Resource cost / Maintenance is 1 in GS
UPDATE Units SET BaseMoves=4 WHERE UnitType='UNIT_SUBMARINE';
UPDATE Units SET BaseMoves=4 WHERE UnitType='UNIT_GERMAN_UBOAT';

--=======================================================================
--******                 AIRCRAFT CARRIER                          ******
--=======================================================================

-- Jack the Ripper proposal (31/12/2020) to boost Naval Movement
-- Base is 3
UPDATE Units SET BaseMoves=5 WHERE UnitType='UNIT_AIRCRAFT_CARRIER';

-- 02/07/24 UNIT_AIRCRAFT_CARRIER CS to 80 from 70
UPDATE Units SET Combat=80 WHERE UnitType='UNIT_AIRCRAFT_CARRIER';


-- 03/03/25 Aircraft carrier +25 def against planes when next to aa unit
INSERT INTO Tags (Tag, Vocabulary) VALUES
    ('CLASS_HAS_ANTI_AIR', 'ABILITY_CLASS');
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_ABILITY_STRENGTH_NEXT_TO_ANTI_AIR', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) SELECT
    UnitType, 'CLASS_HAS_ANTI_AIR' FROM Units WHERE FormationClass='FORMATION_CLASS_AIR' OR AntiAirCombat IS NOT 0;
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_ABILITY_STRENGTH_NEXT_TO_ANTI_AIR', 'CLASS_NAVAL_CARRIER');

INSERT INTO UnitAbilities (UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_STRENGTH_NEXT_TO_ANTI_AIR', 'LOC_BBG_ABILITY_STRENGTH_NEXT_TO_ANTI_AIR_NAME', 'LOC_BBG_ABILITY_STRENGTH_NEXT_TO_ANTI_AIR_DESC');
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_STRENGTH_NEXT_TO_ANTI_AIR', 'BBG_STRENGTH_NEXT_TO_ANTI_AIR');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_STRENGTH_NEXT_TO_ANTI_AIR', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_UNIT_IS_DEFENDER_AGAINST_PLANES_NEXT_TO_ANTI_AIR_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_STRENGTH_NEXT_TO_ANTI_AIR', 'Amount', 25);
INSERT INTO ModifierStrings (ModifierId , Context , Text) VALUES
    ('BBG_STRENGTH_NEXT_TO_ANTI_AIR', 'Preview', 'LOC_BBG_ABILITY_STRENGTH_NEXT_TO_ANTI_AIR_DESC');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_IS_DEFENDER_AGAINST_PLANES_NEXT_TO_ANTI_AIR_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_IS_DEFENDER_AGAINST_PLANES_NEXT_TO_ANTI_AIR_REQSET', 'PLAYER_IS_DEFENDER_REQUIREMENTS'),
    ('BBG_UNIT_IS_DEFENDER_AGAINST_PLANES_NEXT_TO_ANTI_AIR_REQSET', 'OPPONENT_IS_AIR_UNIT_REQUIREMENTS'),
    ('BBG_UNIT_IS_DEFENDER_AGAINST_PLANES_NEXT_TO_ANTI_AIR_REQSET', 'BBG_ADJACENT_UNIT_HAS_ANTI_AIR');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_ADJACENT_UNIT_HAS_ANTI_AIR', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TAG_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_ADJACENT_UNIT_HAS_ANTI_AIR', 'Tag', 'CLASS_HAS_ANTI_AIR');

--=======================================================================
--******                   OTHER  NAVAL                            ******
--=======================================================================
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

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE', 'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER' FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'GRANT_STRENGTH_PER_ADJACENT_UNIT_TYPE', 'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_UNIT_IS_DEFENDER_IN_MELEE' FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO ModifierArguments(ModifierId, Name, Value) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'Amount', 2 FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO ModifierArguments(ModifierId, Name, Value) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'UnitType', Units.UnitType FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO ModifierStrings(ModifierId, Context, Text) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_' || Units.UnitType || '_MODIFIER', 'Preview', '{'||Units.Name||'} : +{CalculatedAmount}' FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO Requirements (RequirementId, RequirementType) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES' FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO RequirementArguments (RequirementId, Name, Value) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ', 'UnitType', Units.UnitType FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_' || Units.UnitType || '_IS_ADJACENT_REQ' FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) SELECT
    'BBG_' || Units.UnitType || '_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_UTILS_PLAYER_HAS_CIVIC_MILITARY_TRADITION_REQUIREMENT' FROM Units WHERE FormationClass='FORMATION_CLASS_NAVAL';


--=======================================================================
--******                        Spy                                ******
--=======================================================================
--Creating Spy Capacity Modifier (lua attaches it)
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('MODIFIER_CAPTURED_ADD_SPY_CAPACITY_BBG', 'MODIFIER_PLAYER_GRANT_SPY');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('MODIFIER_CAPTURED_ADD_SPY_CAPACITY_BBG', 'Amount', '1');

-- 15/12/24 spy progression cost change (based on the % of techs/civics)
UPDATE Units SET CostProgressionModel='COST_PROGRESSION_GAME_PROGRESS', CostProgressionParam1=500, Cost=120 WHERE UnitType='UNIT_SPY';

-- 15/12/24 Spy can stack so Wu can faith buy spies when there is one opponent in they city 
UPDATE Units SET Stackable=1 WHERE UnitType='UNIT_SPY';

--=======================================================================
--******                        AIRCRAFT                           ******
--=======================================================================
-- moved from xp2 file to here

-- -5 combat strength to all airplanes (P-51 change in America section)
UPDATE Units SET Combat=75,  RangedCombat=70  WHERE UnitType='UNIT_BIPLANE';
UPDATE Units SET Combat=95,  RangedCombat=95  WHERE UnitType='UNIT_FIGHTER';
UPDATE Units SET Combat=105, RangedCombat=105 WHERE UnitType='UNIT_JET_FIGHTER';
UPDATE Units SET Combat=80,  Bombard=105      WHERE UnitType='UNIT_BOMBER';
UPDATE Units SET Combat=85,  Bombard=115      WHERE UnitType='UNIT_JET_BOMBER';

--=======================================================================
--******                        OTHER                              ******
--=======================================================================


-- 16/12/22 Obsolescence
-- 15/10/23 Added Varus
-- 30/03/25 Units are now obsolete when the next tech is unlocked 05/04/25 reverted
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_WARRIOR';
UPDATE Units SET MandatoryObsoleteTech='TECH_BALLISTICS' WHERE UnitType='UNIT_HEAVY_CHARIOT';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_SWORDSMAN';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_ROMAN_LEGION';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUNPOWDER' WHERE UnitType='UNIT_KONGO_SHIELD_BEARER';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_JAPANESE_SAMURAI';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_NORWEGIAN_BERSERKER';
UPDATE Units SET MandatoryObsoleteTech='TECH_COMBUSTION' WHERE UnitType='UNIT_KNIGHT';
UPDATE Units SET MandatoryObsoleteTech='TECH_COMBUSTION' WHERE UnitType='UNIT_ARABIAN_MAMLUK';
UPDATE Units SET MandatoryObsoleteTech='TECH_REFINING' WHERE UnitType='UNIT_MUSKETMAN';
UPDATE Units SET MandatoryObsoleteTech='TECH_REFINING' WHERE UnitType='UNIT_SPANISH_CONQUISTADOR';
UPDATE Units SET MandatoryObsoleteTech='TECH_REFINING' WHERE UnitType='UNIT_SULEIMAN_JANISSARY';
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
UPDATE Units SET MandatoryObsoleteTech='TECH_COMBUSTION' WHERE UnitType='UNIT_BYZANTINE_TAGMA';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_GAUL_GAESATAE';
UPDATE Units SET MandatoryObsoleteTech='TECH_MILITARY_TACTICS' WHERE UnitType='UNIT_BABYLONIAN_SABUM_KIBITTUM';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUIDANCE_SYSTEMS' WHERE UnitType='UNIT_LINE_INFANTRY';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUIDANCE_SYSTEMS' WHERE UnitType='UNIT_ENGLISH_REDCOAT';
UPDATE Units SET MandatoryObsoleteTech='TECH_GUIDANCE_SYSTEMS' WHERE UnitType='UNIT_FRENCH_GARDE_IMPERIALE';

UPDATE Units SET MandatoryObsoleteTech='TECH_ADVANCED_BALLISTICS' WHERE UnitType='UNIT_PIKEMAN';
UPDATE Units SET MandatoryObsoleteTech='TECH_COMPOSITES' WHERE UnitType='UNIT_PIKE_AND_SHOT';
UPDATE Units SET MandatoryObsoleteTech='TECH_REFINING' WHERE UnitType='UNIT_QUADRIREME';


-- 30/11/24 Ancient unit gets -5 agaisnt city center
    -- UNIT_WARRIOR
    -- UNIT_AZTEC_EAGLE_WARRIOR
    -- UNIT_GAUL_GAESATAE
    -- UNIT_SCOUT
    -- UNIT_CREE_OKIHTCITAW
    -- UNIT_SUMERIAN_WAR_CART
    -- UNIT_GALLEY
    -- UNIT_NORWEGIAN_LONGSHIP
    -- UNIT_PHOENICIA_BIREME
    -- UNIT_BABYLONIAN_SABUM_KIBITTUM
    -- UNIT_HEAVY_CHARIOT
    -- UNIT_ARCHER
    -- UNIT_EGYPTIAN_CHARIOT_ARCHER
    -- UNIT_NUBIAN_PITATI
    -- UNIT_MAYAN_HULCHE
    -- UU are in corresponding file

INSERT INTO Tags (Tag, Vocabulary) VALUES
    ('CLASS_MALUS_CITY_CENTER', 'ABILITY_CLASS');
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_ABILITY_UNITS_MALUS_AGAINST_CITY_BEFORE_CLASSICAL', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('UNIT_WARRIOR', 'CLASS_MALUS_CITY_CENTER'),
    ('UNIT_SCOUT', 'CLASS_MALUS_CITY_CENTER'),
    ('UNIT_GALLEY', 'CLASS_MALUS_CITY_CENTER'),
    ('UNIT_ARCHER', 'CLASS_MALUS_CITY_CENTER'),
    ('UNIT_HEAVY_CHARIOT', 'CLASS_MALUS_CITY_CENTER'),
    ('BBG_ABILITY_UNITS_MALUS_AGAINST_CITY_BEFORE_CLASSICAL', 'CLASS_MALUS_CITY_CENTER');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_UNITS_MALUS_AGAINST_CITY_BEFORE_CLASSICAL', 'LOC_BBG_ABILITY_UNITS_MALUS_AGAINST_CITY_BEFORE_CLASSICAL_NAME', 'LOC_BBG_ABILITY_UNITS_MALUS_AGAINST_CITY_BEFORE_CLASSICAL_DESC');
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_UNITS_MALUS_AGAINST_CITY_BEFORE_CLASSICAL', 'BBG_UNITS_MINUS_AGAINST_CITY_BEFORE_CLASSICAL');
INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
    ('BBG_UNITS_MINUS_AGAINST_CITY_BEFORE_CLASSICAL', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_PLAYER_IS_NOT_IN_ERA_CLASSICAL_REQSET', 'UNIT_ATTACKING_DISTRICT_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_UNITS_MINUS_AGAINST_CITY_BEFORE_CLASSICAL', 'Amount', -5);
INSERT INTO ModifierStrings (ModifierId , Context , Text) VALUES
    ('BBG_UNITS_MINUS_AGAINST_CITY_BEFORE_CLASSICAL', 'Preview', 'LOC_BBG_ABILITY_UNITS_MALUS_AGAINST_CITY_BEFORE_CLASSICAL_DESC');

--=======================================================================
--******                    FORTIFY                                ******
--=======================================================================
--20/03/26 Instead of removing the fortify operation, we will add +4 modifier when attacking fortified cavalry.
--24/03/26 reverted, waiting for a bigger rework of fortify that may include this change
-- 04/07/26 retry 
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_CHARGE_VS_FORTIFIED_CAVALRY', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_ATTACKING_FORTIFIED_CAVALRY_REQSET');
INSERT INTO ModifierStrings (ModifierId , Context , Text) VALUES
    ('BBG_CHARGE_VS_FORTIFIED_CAVALRY', 'Preview', 'LOC_BBG_ABILITY_CHARGE_VS_FORTIFIED_CAVALRY_PREVIEW');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_CHARGE_VS_FORTIFIED_CAVALRY', 'Amount', 4);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_ATTACKING_FORTIFIED_CAVALRY_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_ATTACKING_FORTIFIED_CAVALRY_REQSET', 'PLAYER_IS_ATTACKER_REQUIREMENTS'),
    ('BBG_ATTACKING_FORTIFIED_CAVALRY_REQSET', 'OPPONENT_IS_FORTIFIED'),                --existing requirement that checks if opponent is fortified, from charge promotion
    ('BBG_ATTACKING_FORTIFIED_CAVALRY_REQSET', 'OPPONENT_IS_CAVALRY_REQUIREMENTS_MET'); --existing requirement that checks if opponent is cavalry, from anti-cavalry

-- attach modifier to all units
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
    ('BBG_ABILITY_CHARGE_VS_FORTIFIED_CAVALRY', 'LOC_BBG_ABILITY_CHARGE_VS_FORTIFIED_CAVALRY_NAME', 'LOC_BBG_ABILITY_CHARGE_VS_FORTIFIED_CAVALRY_DESC');
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_CHARGE_VS_FORTIFIED_CAVALRY', 'BBG_CHARGE_VS_FORTIFIED_CAVALRY');
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_ABILITY_CHARGE_VS_FORTIFIED_CAVALRY', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_ABILITY_CHARGE_VS_FORTIFIED_CAVALRY', 'CLASS_ALL_COMBAT_UNITS');