------------------------------------------------------------------------------
--	FILE:	 new_bbg_policies.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------


-- === Existing Policies Adjustments ===
-- Buff Discipline +5 -> +10
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='DISCIPLINE_BARBARIANCOMBAT' AND Name='Amount';

-- Bastillon ""bugfix"" (Value is doubled, so put 2*+3 instead of 2*+5)
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='BASTIONS_RANGEDSTRIKE' AND Name='Amount';
-- 02/07/24 Bastion ranged strength removed
DELETE FROM PolicyModifiers WHERE PolicyType='POLICY_BASTIONS' AND ModifierId='BASTIONS_RANGEDSTRIKE';

-- Communications Office give 2 Loyalty per governor promotion (from +1)
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='COMMUNICATIONS_OFFICE_GOVERNOR_IDENTITY_PER_TITLE' AND Name='Amount';

-- LIMES
-- Limes to 50%
UPDATE ModifierArguments SET Value='50' WHERE Name='Amount' AND ModifierId IN (
    SELECT ModifierId FROM PolicyModifiers WHERE PolicyType='POLICY_LIMES'
);
-- Limes doesn't Obsolete
DELETE FROM ObsoletePolicies WHERE PolicyType='POLICY_LIMES';

-- Move infantry card
UPDATE Policies SET PrereqCivic='CIVIC_MOBILIZATION' WHERE PolicyType='POLICY_MILITARY_FIRST';

-- === New Policies ===
INSERT INTO Types(Type, Kind) VALUES
	('POLICY_SIEGE', 'KIND_POLICY'),
	('POLICY_HARD_SHELL_EXPLOSIVES', 'KIND_POLICY'),
	('POLICY_TRENCH_WARFARE', 'KIND_POLICY');

INSERT INTO Policies(PolicyType, Name, Description, PrereqCivic, GovernmentSlotType) VALUES
	('POLICY_SIEGE', 'LOC_POLICY_SIEGE_NAME', 'LOC_POLICY_SIEGE_DESCRIPTION', 'CIVIC_MILITARY_TRAINING', 'SLOT_MILITARY'),
	('POLICY_HARD_SHELL_EXPLOSIVES', 'LOC_POLICY_HARD_SHELL_EXPLOSIVES_NAME', 'LOC_POLICY_HARD_SHELL_EXPLOSIVES_DESCRIPTION', 'CIVIC_MEDIEVAL_FAIRES', 'SLOT_MILITARY'),
	('POLICY_TRENCH_WARFARE', 'LOC_POLICY_TRENCH_WARFARE_NAME', 'LOC_POLICY_TRENCH_WARFARE_DESCRIPTION', 'CIVIC_SCORCHED_EARTH', 'SLOT_MILITARY');
	
INSERT OR IGNORE INTO ObsoletePolicies(PolicyType, ObsoletePolicy) VALUES
	('POLICY_SIEGE', 'POLICY_HARD_SHELL_EXPLOSIVES'),
	('POLICY_HARD_SHELL_EXPLOSIVES', 'POLICY_TRENCH_WARFARE');
	
INSERT OR IGNORE INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_SIEGE', 'SIEGE_ANCIENT_SIEGE_PRODUCTION'),
	('POLICY_SIEGE', 'SIEGE_CLASSICAL_SIEGE_PRODUCTION'),
    ('POLICY_SIEGE', 'SIEGE_MEDIEVAL_SIEGE_PRODUCTION'),
	('POLICY_HARD_SHELL_EXPLOSIVES', 'HARD_SHELL_ANCIENT_SIEGE_PRODUCTION'),
	('POLICY_HARD_SHELL_EXPLOSIVES', 'HARD_SHELL_CLASSICAL_SIEGE_PRODUCTION'),
	('POLICY_HARD_SHELL_EXPLOSIVES', 'HARD_SHELL_MEDIEVAL_SIEGE_PRODUCTION'),
	('POLICY_HARD_SHELL_EXPLOSIVES', 'HARD_SHELL_RENAISSANCE_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_ANCIENT_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_CLASSICAL_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_MEDIEVAL_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_RENAISSANCE_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_INDUSTRIAL_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_MODERN_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_ATOMIC_SIEGE_PRODUCTION'),
	('POLICY_TRENCH_WARFARE', 'TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION');
	
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType) VALUES
	('SIEGE_ANCIENT_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('SIEGE_CLASSICAL_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('SIEGE_MEDIEVAL_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('HARD_SHELL_ANCIENT_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('HARD_SHELL_CLASSICAL_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('HARD_SHELL_MEDIEVAL_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('HARD_SHELL_RENAISSANCE_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_ANCIENT_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_CLASSICAL_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_MEDIEVAL_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_RENAISSANCE_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_INDUSTRIAL_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_MODERN_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_ATOMIC_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
	
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value, Extra) VALUES
	('SIEGE_ANCIENT_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('SIEGE_ANCIENT_SIEGE_PRODUCTION', 'EraType', 'ERA_ANCIENT', -1 ),
	('SIEGE_ANCIENT_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('SIEGE_CLASSICAL_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('SIEGE_CLASSICAL_SIEGE_PRODUCTION', 'EraType', 'ERA_CLASSICAL', -1 ),
	('SIEGE_CLASSICAL_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('SIEGE_MEDIEVAL_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('SIEGE_MEDIEVAL_SIEGE_PRODUCTION', 'EraType', 'ERA_MEDIEVAL', -1 ),
	('SIEGE_MEDIEVAL_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('HARD_SHELL_ANCIENT_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('HARD_SHELL_ANCIENT_SIEGE_PRODUCTION', 'EraType', 'ERA_ANCIENT', -1 ),
	('HARD_SHELL_ANCIENT_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('HARD_SHELL_CLASSICAL_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('HARD_SHELL_CLASSICAL_SIEGE_PRODUCTION', 'EraType', 'ERA_CLASSICAL', -1 ),
	('HARD_SHELL_CLASSICAL_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('HARD_SHELL_MEDIEVAL_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('HARD_SHELL_MEDIEVAL_SIEGE_PRODUCTION', 'EraType', 'ERA_MEDIEVAL', -1 ),
	('HARD_SHELL_MEDIEVAL_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('HARD_SHELL_RENAISSANCE_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('HARD_SHELL_RENAISSANCE_SIEGE_PRODUCTION', 'EraType', 'ERA_RENAISSANCE', -1 ),
	('HARD_SHELL_RENAISSANCE_SIEGE_PRODUCTION', 'Amount', 50, -1),	
	('TRENCH_WARFARE_ANCIENT_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_ANCIENT_SIEGE_PRODUCTION', 'EraType', 'ERA_ANCIENT', -1 ),
	('TRENCH_WARFARE_ANCIENT_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('TRENCH_WARFARE_CLASSICAL_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_CLASSICAL_SIEGE_PRODUCTION', 'EraType', 'ERA_CLASSICAL', -1 ),
	('TRENCH_WARFARE_CLASSICAL_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('TRENCH_WARFARE_MEDIEVAL_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_MEDIEVAL_SIEGE_PRODUCTION', 'EraType', 'ERA_MEDIEVAL', -1 ),
	('TRENCH_WARFARE_MEDIEVAL_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('TRENCH_WARFARE_RENAISSANCE_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_RENAISSANCE_SIEGE_PRODUCTION', 'EraType', 'ERA_RENAISSANCE', -1 ),
	('TRENCH_WARFARE_RENAISSANCE_SIEGE_PRODUCTION', 'Amount', 50, -1),		
	('TRENCH_WARFARE_INDUSTRIAL_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_INDUSTRIAL_SIEGE_PRODUCTION', 'EraType', 'ERA_INDUSTRIAL', -1 ),
	('TRENCH_WARFARE_INDUSTRIAL_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('TRENCH_WARFARE_MODERN_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_MODERN_SIEGE_PRODUCTION', 'EraType', 'ERA_MODERN', -1 ),
	('TRENCH_WARFARE_MODERN_SIEGE_PRODUCTION', 'Amount', 50, -1),	
	('TRENCH_WARFARE_ATOMIC_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_ATOMIC_SIEGE_PRODUCTION', 'EraType', 'ERA_ATOMIC', -1 ),
	('TRENCH_WARFARE_ATOMIC_SIEGE_PRODUCTION', 'Amount', 50, -1),
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_SIEGE', -1 ),
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'EraType', 'ERA_INFORMATION', -1 ),
	('TRENCH_WARFARE_INFORMATION_SIEGE_PRODUCTION', 'Amount', 50, -1);	

-- 03/10/22: recon units to melee/ranged cards
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_AGOGE_ANCIENT_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('BBG_AGOGE_CLASSICAL_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('BBG_FEUDALCONTRACT_MEDIEVAL_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('BBG_FEUDALCONTRACT_RENAISSANCE_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('BBG_GRANDEARMEE_INDUSTRIAL_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('BBG_GRANDEARMEE_MODERN_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('BBG_MILITARYFIRST_ATOMIC_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
    ('BBG_MILITARYFIRST_INFORMATION_RECON_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');

INSERT INTO ModifierArguments(ModifierId, Name, Value, Extra) VALUES
	('BBG_AGOGE_ANCIENT_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_AGOGE_ANCIENT_RECON_PRODUCTION', 'EraType', 'ERA_ANCIENT', -1 ),
	('BBG_AGOGE_ANCIENT_RECON_PRODUCTION', 'Amount', 50, -1),
	('BBG_AGOGE_CLASSICAL_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_AGOGE_CLASSICAL_RECON_PRODUCTION', 'EraType', 'ERA_CLASSICAL', -1 ),
	('BBG_AGOGE_CLASSICAL_RECON_PRODUCTION', 'Amount', 50, -1),
	('BBG_FEUDALCONTRACT_MEDIEVAL_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_FEUDALCONTRACT_MEDIEVAL_RECON_PRODUCTION', 'EraType', 'ERA_MEDIEVAL', -1 ),
	('BBG_FEUDALCONTRACT_MEDIEVAL_RECON_PRODUCTION', 'Amount', 50, -1),
	('BBG_FEUDALCONTRACT_RENAISSANCE_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_FEUDALCONTRACT_RENAISSANCE_RECON_PRODUCTION', 'EraType', 'ERA_RENAISSANCE', -1 ),
	('BBG_FEUDALCONTRACT_RENAISSANCE_RECON_PRODUCTION', 'Amount', 50, -1),		
	('BBG_GRANDEARMEE_INDUSTRIAL_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_GRANDEARMEE_INDUSTRIAL_RECON_PRODUCTION', 'EraType', 'ERA_INDUSTRIAL', -1 ),
	('BBG_GRANDEARMEE_INDUSTRIAL_RECON_PRODUCTION', 'Amount', 50, -1),
	('BBG_GRANDEARMEE_MODERN_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_GRANDEARMEE_MODERN_RECON_PRODUCTION', 'EraType', 'ERA_MODERN', -1 ),
	('BBG_GRANDEARMEE_MODERN_RECON_PRODUCTION', 'Amount', 50, -1),	
	('BBG_MILITARYFIRST_ATOMIC_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_MILITARYFIRST_ATOMIC_RECON_PRODUCTION', 'EraType', 'ERA_ATOMIC', -1 ),
	('BBG_MILITARYFIRST_ATOMIC_RECON_PRODUCTION', 'Amount', 50, -1),
	('BBG_MILITARYFIRST_INFORMATION_RECON_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RECON', -1 ),
	('BBG_MILITARYFIRST_INFORMATION_RECON_PRODUCTION', 'EraType', 'ERA_INFORMATION', -1 ),
	('BBG_MILITARYFIRST_INFORMATION_RECON_PRODUCTION', 'Amount', 50, -1);	

INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_AGOGE', 'BBG_AGOGE_ANCIENT_RECON_PRODUCTION'),
	('POLICY_AGOGE', 'BBG_AGOGE_CLASSICAL_RECON_PRODUCTION'),
	('POLICY_FEUDAL_CONTRACT', 'BBG_AGOGE_ANCIENT_RECON_PRODUCTION'),
	('POLICY_FEUDAL_CONTRACT', 'BBG_AGOGE_CLASSICAL_RECON_PRODUCTION'),
	('POLICY_FEUDAL_CONTRACT', 'BBG_FEUDALCONTRACT_MEDIEVAL_RECON_PRODUCTION'),
	('POLICY_FEUDAL_CONTRACT', 'BBG_FEUDALCONTRACT_RENAISSANCE_RECON_PRODUCTION'),
	('POLICY_GRANDE_ARMEE', 'BBG_AGOGE_ANCIENT_RECON_PRODUCTION'),
	('POLICY_GRANDE_ARMEE', 'BBG_AGOGE_CLASSICAL_RECON_PRODUCTION'),
	('POLICY_GRANDE_ARMEE', 'BBG_FEUDALCONTRACT_MEDIEVAL_RECON_PRODUCTION'),
	('POLICY_GRANDE_ARMEE', 'BBG_FEUDALCONTRACT_RENAISSANCE_RECON_PRODUCTION'),
	('POLICY_GRANDE_ARMEE', 'BBG_GRANDEARMEE_INDUSTRIAL_RECON_PRODUCTION'),
	('POLICY_GRANDE_ARMEE', 'BBG_GRANDEARMEE_MODERN_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_AGOGE_ANCIENT_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_AGOGE_CLASSICAL_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_FEUDALCONTRACT_MEDIEVAL_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_FEUDALCONTRACT_RENAISSANCE_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_GRANDEARMEE_INDUSTRIAL_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_GRANDEARMEE_MODERN_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_MILITARYFIRST_ATOMIC_RECON_PRODUCTION'),
	('POLICY_MILITARY_FIRST', 'BBG_MILITARYFIRST_INFORMATION_RECON_PRODUCTION');

-- 10/03/24 Medina +1 housing per district
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_MEDINA_HOUSING_DISTRICT', 'MODIFIER_PLAYER_DISTRICTS_ADJUST_HOUSING', 'BBG_IS_SPECIALTY_DISTRICT');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_MEDINA_HOUSING_DISTRICT', 'Amount', 1);
UPDATE PolicyModifiers SET ModifierId='BBG_MEDINA_HOUSING_DISTRICT' WHERE ModifierId='MEDINAQUARTER_SPECIALTYHOUSING';

-- 28/11/24 Raj now gives +1 prod/food, +2sci/culture/faith/gold per traderoute to a city state
DELETE FROM PolicyModifiers WHERE ModifierId LIKE 'RAJ%TRIBUTARY';

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_RAJ_CITY_TRADE_ROUTE_FOOD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTES_CITY_STATE_YIELD'),
	('BBG_RAJ_CITY_TRADE_ROUTE_PROD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTES_CITY_STATE_YIELD'),
	('BBG_RAJ_CITY_TRADE_ROUTE_FAITH', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTES_CITY_STATE_YIELD'),
	('BBG_RAJ_CITY_TRADE_ROUTE_SCIENCE', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTES_CITY_STATE_YIELD'),
	('BBG_RAJ_CITY_TRADE_ROUTE_CULTURE', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTES_CITY_STATE_YIELD');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_RAJ_CITY_TRADE_ROUTE_FOOD', 'YieldType', 'YIELD_FOOD'),
	('BBG_RAJ_CITY_TRADE_ROUTE_FOOD', 'Amount', 1),
	('BBG_RAJ_CITY_TRADE_ROUTE_PROD', 'YieldType', 'YIELD_PRODUCTION'),
	('BBG_RAJ_CITY_TRADE_ROUTE_PROD', 'Amount', 1),
	('BBG_RAJ_CITY_TRADE_ROUTE_FAITH', 'YieldType', 'YIELD_FAITH'),
	('BBG_RAJ_CITY_TRADE_ROUTE_FAITH', 'Amount', 2),
	('BBG_RAJ_CITY_TRADE_ROUTE_SCIENCE', 'YieldType', 'YIELD_SCIENCE'),
	('BBG_RAJ_CITY_TRADE_ROUTE_SCIENCE', 'Amount', 2),
	('BBG_RAJ_CITY_TRADE_ROUTE_CULTURE', 'YieldType', 'YIELD_CULTURE'),
	('BBG_RAJ_CITY_TRADE_ROUTE_CULTURE', 'Amount', 2);

INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_RAJ', 'BBG_RAJ_CITY_TRADE_ROUTE_FOOD'),
	('POLICY_RAJ', 'BBG_RAJ_CITY_TRADE_ROUTE_PROD'),
	('POLICY_RAJ', 'BBG_RAJ_CITY_TRADE_ROUTE_FAITH'),
	('POLICY_RAJ', 'BBG_RAJ_CITY_TRADE_ROUTE_SCIENCE'),
	('POLICY_RAJ', 'BBG_RAJ_CITY_TRADE_ROUTE_CULTURE');

-- 28/11/24 Merchant Confederation/Gunboat Diplomacy/Ideology changes
-- 28/11/24 Merchant confederation obsolete at Ideology/Gunboat Diplomacy
INSERT INTO ObsoletePolicies (PolicyType, ObsoletePolicy) VALUES
	('POLICY_MERCHANT_CONFEDERATION', 'POLICY_GUNBOAT_DIPLOMACY');
-- 28/11/24 New green card giving freedom of movement into city state at Civil, osbsolete at Ideology/Gunboat Diplomacy /!\ care if you move gunboat as it is ideology which give open borders with cs now
INSERT INTO Types(Type, Kind) VALUES
	('POLICY_SOVEREIGN_STATE', 'KIND_POLICY');
INSERT INTO Policies(PolicyType, Name, Description, PrereqCivic, GovernmentSlotType) VALUES
	('POLICY_SOVEREIGN_STATE', 'LOC_POLICY_SOVEREIGN_STATE_NAME', 'LOC_POLICY_SOVEREIGN_STATE_DESCRIPTION', 'CIVIC_CIVIL_SERVICE', 'SLOT_DIPLOMATIC');
INSERT INTO ObsoletePolicies (PolicyType, ObsoletePolicy) VALUES
	('POLICY_SOVEREIGN_STATE', 'POLICY_GUNBOAT_DIPLOMACY');
DELETE FROM PolicyModifiers WHERE PolicyType='POLICY_GUNBOAT_DIPLOMACY' AND ModifierId='GUNBOATDIPLOMACY_OPENBORDERS';
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_SOVEREIGN_STATE', 'GUNBOATDIPLOMACY_OPENBORDERS');
-- 28/11/24 Ideology now gives open border without card
INSERT INTO CivicModifiers (CivicType, ModifierId) VALUES
	('CIVIC_IDEOLOGY', 'GUNBOATDIPLOMACY_OPENBORDERS');
-- 28/11/24 Gunboat Diplomacy now gets Merchant confederation bonus of +4 golds (do not grant open border with cs anymore)
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_GUNBOAT_DIPLOMACY', 'MERCHANTCONFEDERATION_INFLUENCETOKENGOLD');

-- 28/11/24 Colonial Taxes/Offices changes
-- 28/11/24 both cards now work for cities 8+ tiles away from cap and not based on continent
UPDATE Modifiers SET SubjectRequirementSetId='BBG_IS_PLOT_8_TILES_OR_MORE_FROM_CAPITAL_REQUIREMENTS' WHERE ModifierId IN ('COLONIALOFFICES_FOREIGNGROWTH', 'COLONIALTAXES_FOREIGNGOLD', 'COLONIALOFFICES_FOREIGNIDENTITY', 'COLONIALTAXES_FOREIGNPRODUCTION');
-- 28/11/24 offices is obsolete when taxes is unlocked
INSERT INTO ObsoletePolicies (PolicyType, ObsoletePolicy) VALUES
	('POLICY_COLONIAL_OFFICES', 'POLICY_COLONIAL_TAXES');
-- 28/11/24 offices also gives production
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_COLONIAL_OFFICES', 'COLONIALTAXES_FOREIGNPRODUCTION');

-- 15/12/24 Veterancy now obsolete at mobi replaced by arms race that also give production to aerodrome and its building
INSERT INTO Types(Type, Kind) VALUES
	('POLICY_ARMS_RACE', 'KIND_POLICY');
INSERT INTO Policies(PolicyType, Name, Description, PrereqCivic, GovernmentSlotType) VALUES
	('POLICY_ARMS_RACE', 'LOC_POLICY_ARMS_RACE_NAME', 'LOC_POLICY_ARMS_RACE_DESCRIPTION', 'CIVIC_MOBILIZATION', 'SLOT_MILITARY');
INSERT INTO ObsoletePolicies (PolicyType, ObsoletePolicy) VALUES
	('POLICY_VETERANCY', 'POLICY_ARMS_RACE');

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_ARMS_RACE_AERODROME_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION'),
	('BBG_ARMS_RACE_AERODROME_BUILDING_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_ARMS_RACE_AERODROME_PRODUCTION', 'DistrictType', 'DISTRICT_AERODROME'),
	('BBG_ARMS_RACE_AERODROME_PRODUCTION', 'Amount', '30'),
	('BBG_ARMS_RACE_AERODROME_BUILDING_PRODUCTION', 'DistrictType', 'DISTRICT_AERODROME'),
	('BBG_ARMS_RACE_AERODROME_BUILDING_PRODUCTION', 'Amount', '30');
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
	('POLICY_ARMS_RACE', 'BBG_ARMS_RACE_AERODROME_PRODUCTION'),
	('POLICY_ARMS_RACE', 'BBG_ARMS_RACE_AERODROME_BUILDING_PRODUCTION'),
	('POLICY_ARMS_RACE', 'VETERANCY_ENCAMPMENT_PRODUCTION'),
	('POLICY_ARMS_RACE', 'VETERANCY_ENCAMPMENT_BUILDINGS_PRODUCTION'),
	('POLICY_ARMS_RACE', 'VETERANCY_HARBOR_PRODUCTION'),
	('POLICY_ARMS_RACE', 'VETERANCY_HARBOR_BUILDINGS_PRODUCTION');


-- 30/03/25 Defense of the motherland now on Ideology and no longers needs Communism
UPDATE Policies SET PrereqCivic='CIVIC_IDEOLOGY' WHERE PolicyType='POLICY_DEFENSE_OF_MOTHERLAND';
DELETE FROM Policy_GovernmentExclusives_XP2 WHERE PolicyType='POLICY_DEFENSE_OF_MOTHERLAND';
	