-- ========================================================================
-- =                           TEOTIHUACAN                                =
-- ========================================================================

-- New city names cause this was meant to be a one city civ :D
INSERT INTO CityNames (CivilizationType, CityName) VALUES
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_CACAXTLA'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_CANTONA'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_CUICUILCO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_MONTE_ALBAN'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_YAGUL'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_ZAACHILA'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_TEOTENANGO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_CALIXTLAHUACA'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_HUAMANGO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_XOCHITECATL'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_TZINTZUNTZAN'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_PATZCUARO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_TINGUINDIN'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_IHUATZIO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_TZACAPU'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_TINGAMBATO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_HUANDACAREO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_ZINAPECUARO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_COYOACAN'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_TLATELOLCO'),
    ('CIVILIZATION_LIME_TEOTIHUACAN', 'LOC_CITY_NAME_TLACOCHCALCO');

-- Start bias
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_LIME_TEOTIHUACAN';
DELETE FROM StartBiasFeatures WHERE CivilizationType='CIVILIZATION_LIME_TEOTIHUACAN';


DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_LIME_TEO_MEN_BECOME_GODS';

-- International trade routes to allies gain yields per type of CS under your control
CREATE TEMPORARY TABLE "Teotihucan_trades"(
        'LeaderType' TEXT,
        'YieldType' TEXT,
        'Amount' INT
    );

INSERT INTO Teotihucan_trades (LeaderType, YieldType, Amount) VALUES
    ('LEADER_MINOR_CIV_SCIENTIFIC', 'YIELD_SCIENCE', 1),
    ('LEADER_MINOR_CIV_RELIGIOUS', 'YIELD_FOOD', 1),
    ('LEADER_MINOR_CIV_TRADE', 'YIELD_GOLD', 3),
    ('LEADER_MINOR_CIV_CULTURAL', 'YIELD_CULTURE', 1),
    ('LEADER_MINOR_CIV_MILITARISTIC', 'YIELD_PRODUCTION', 1),
    ('LEADER_MINOR_CIV_INDUSTRIAL', 'YIELD_PRODUCTION', 1);

INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) SELECT
    'BBG_INTERNATIONAL_' || LeaderType || '_ONE', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL', 'SUK_GALLIC_WAR_COMBAT_REQUIREMENTS_' || LeaderType FROM Teotihucan_trades;
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_INTERNATIONAL_' || LeaderType || '_ONE', 'YieldType', YieldType FROM Teotihucan_trades; 
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_INTERNATIONAL_' || LeaderType || '_ONE', 'Amount', Amount FROM Teotihucan_trades; 
INSERT INTO TraitModifiers (TraitType, ModifierId) SELECT
    'TRAIT_CIVILIZATION_LIME_TEO_MEN_BECOME_GODS', 'BBG_INTERNATIONAL_' || LeaderType || '_ONE' FROM Teotihucan_trades;

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) SELECT
    'BBG_PLAYER_SUZ_2_' || LeaderType || '_REQSET', 'REQUIREMENTSET_TEST_ALL' FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) SELECT
    'BBG_PLAYER_SUZ_2_' || LeaderType || '_REQSET', 'BBG_PLAYER_SUZ_2_' || LeaderType || '_REQUIREMENT' FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
INSERT INTO Requirements(RequirementId , RequirementType) SELECT
    'BBG_PLAYER_SUZ_2_' || LeaderType || '_REQUIREMENT', 'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE' FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
INSERT INTO RequirementArguments(RequirementId, Name, Value) SELECT
    'BBG_PLAYER_SUZ_2_' || LeaderType || '_REQUIREMENT', 'LeaderType', LeaderType FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
INSERT INTO RequirementArguments(RequirementId, Name, Value) SELECT
    'BBG_PLAYER_SUZ_2_' || LeaderType || '_REQUIREMENT', 'Amount', 2 FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';

INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) SELECT
    'BBG_INTERNATIONAL_' || LeaderType || '_TWO', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL', 'BBG_PLAYER_SUZ_2_' || LeaderType || '_REQSET' FROM Teotihucan_trades;
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_INTERNATIONAL_' || LeaderType || '_TWO', 'YieldType', YieldType FROM Teotihucan_trades; 
INSERT INTO ModifierArguments (ModifierId, Name, Value) SELECT
    'BBG_INTERNATIONAL_' || LeaderType || '_TWO', 'Amount', Amount*2 FROM Teotihucan_trades; 
INSERT INTO TraitModifiers (TraitType, ModifierId) SELECT
    'TRAIT_CIVILIZATION_LIME_TEO_MEN_BECOME_GODS', 'BBG_INTERNATIONAL_' || LeaderType || '_TWO' FROM Teotihucan_trades;


-- ==========================================================
-- =                  POCHTECA ENCLAVE                      =
-- ==========================================================

-- 30/07/25 Unlock at Political, doesn't require population, doesn't give internal yields
UPDATE Districts SET PrereqCivic='CIVIC_POLITICAL_PHILOSOPHY', AllowsHolyCity=0, RequiresPopulation=0 WHERE DistrictType='DISTRICT_LIME_TEO_TOLLAN';

-- ==========================================================
-- =                   EHUATL WEARER                        =
-- ==========================================================

-- +1 base vision, unlock at political and doesn't need iron
UPDATE Units SET BaseSightRange=3, Cost=90, PrereqCivic='CIVIC_POLITICAL_PHILOSOPHY', PurchaseYield='YIELD_GOLD', Maintenance=2 WHERE UnitType='UNIT_LIME_TEO_OWL_WARRIOR';

-- ========================================================================
-- =                           SPEARTHROWER                               =
-- ========================================================================

DELETE FROM DistrictModifiers WHERE ModifierId IN ('MOD_LIME_TOLLAN_ATTACH_TRADE_ROUTE', 'MOD_LIME_TOLLAN_ATTACH_DISTRICT_ROUTE');

-- 30/07/25 UD & Chancery give trader capacity
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_HAS_ENCLAVE_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_HAS_ENCLAVE_REQSET', 'BBG_REQUIRES_CITY_HAS_ENCLAVE');
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_CITY_HAS_ENCLAVE', 'REQUIREMENT_CITY_HAS_DISTRICT');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_CITY_HAS_ENCLAVE', 'DistrictType', 'DISTRICT_LIME_TEO_TOLLAN');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_SPEARTHROWER_TRADEROUTE_UD', 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_CAPACITY', 'BBG_CITY_HAS_ENCLAVE_REQSET'),
    ('BBG_SPEARTHROWER_TRADEROUTE_CHANCERY', 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_CAPACITY', 'BUILDING_IS_CHANCERY');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SPEARTHROWER_TRADEROUTE_UD', 'Amount', 1),
    ('BBG_SPEARTHROWER_TRADEROUTE_CHANCERY', 'Amount', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST', 'BBG_SPEARTHROWER_TRADEROUTE_UD'),
    ('TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST', 'BBG_SPEARTHROWER_TRADEROUTE_CHANCERY');



-- ==========================================================
-- =                     FIRE IS BORN                       =
-- ==========================================================

-- Base : May be assigned to a City State. Friendly Units defending this city gain +5 Combat Strength. Give 1 envoy to the city state
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_FIREISBORN_BASE_ENVOY', 'MODIFIER_GOVERNOR_ADJUST_CITY_ENVOYS'); 
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_FIREISBORN_BASE_ENVOY', 'Amount', 1);

-- L1 : While established in a City State, provides a copy of its Luxury resources.

-- R1 : This city garrison gains +10 combat strength.
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_SAP_WALLS_ATTACH';
UPDATE ModifierArguments SET Value=10 WHERE ModifierId='MOD_LIME_TEO_OWL_EMISSARY_ARRIVAL_FORTIFY_UNITS';

-- L2 : Envoy send to this city state are doubled, cities 15 tiles from the city gets +25% production toward hub building
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL';

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_DUPLICATE_ENVOY_IF_TRADER', 'MODIFIER_PLAYER_ADJUST_DUPLICATE_INFLUENCE_TOKEN_WHEN_TRADE_ROUTE_TO', NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_DUPLICATE_ENVOY_IF_TRADER', 'Amount', 1);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL', 'BBG_DUPLICATE_ENVOY_IF_TRADER');

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_PLOT_15_TILES_MAX_REQUIREMENT', 'REQUIREMENT_PLOT_ADJACENT_TO_OWNER');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_PLOT_15_TILES_MAX_REQUIREMENT', 'MinDistance', '0'),
    ('BBG_PLOT_15_TILES_MAX_REQUIREMENT', 'MaxDistance', '15');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_PLOT_15_TILES_MAX_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_PLOT_15_TILES_MAX_REQSET', 'BBG_PLOT_15_TILES_MAX_REQUIREMENT');


INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_HUB_BUILDING_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION', 'BBG_PLOT_15_TILES_MAX_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_HUB_BUILDING_PRODUCTION', 'DistrictType', 'DISTRICT_COMMERCIAL_HUB'),
    ('BBG_HUB_BUILDING_PRODUCTION', 'Amount', 25);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL', 'BBG_HUB_BUILDING_PRODUCTION');


-- R2 : Levied Units 10 tiles from this city gets +5 combat strength
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER';

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_PLOT_10_TILES_AWAY_LEVIED_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_PLOT_10_TILES_AWAY_LEVIED_REQSET', '10_PLOTS_AWAY_MAX_UNIT_REQUIREMENT'),
    ('BBG_PLOT_10_TILES_AWAY_LEVIED_REQSET', 'REQUIRES_UNIT_IS_LEVIED');

INSERT INTO UnitAbilities (UnitAbilityType , Name , Description) VALUES
    ('BBG_LEVIED_UNIT_COMBAT_ABILITY', 'LOC_BBG_LEVIED_UNIT_COMBAT_ABILITY_NAME', 'LOC_BBG_LEVIED_UNIT_COMBAT_ABILITY_DESC');
INSERT INTO UnitAbilityModifiers (UnitAbilityType , ModifierId) VALUES
    ('BBG_LEVIED_UNIT_COMBAT_ABILITY', 'BBG_LEVIED_UNIT_COMBAT_MODIFIER');
INSERT INTO ModifierStrings (ModifierId , Context , Text) VALUES
    ('BBG_LEVIED_UNIT_COMBAT_MODIFIER', 'Preview', 'LOC_BBG_LEVIED_UNIT_COMBAT_ABILITY_DESC');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_LEVIED_UNIT_COMBAT_GIVER', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 'BBG_PLOT_10_TILES_AWAY_LEVIED_REQSET'),
    ('BBG_LEVIED_UNIT_COMBAT_MODIFIER', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_LEVIED_UNIT_COMBAT_GIVER', 'ModifierId', 'BBG_LEVIED_UNIT_COMBAT_MODIFIER'),
    ('BBG_LEVIED_UNIT_COMBAT_MODIFIER', 'Amount', 5);

INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER', 'BBG_LEVIED_UNIT_COMBAT_GIVER');

-- M3 : City States suzed give +2 diplo favour.
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='MOD_LIME_TEO_OWL_EMISSARY_CONQUERED_FAVOR_ATTACH';
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='MOD_LIME_TEO_OWL_EMISSARY_VASSAL_CS_FAVOR_ATTACH'; -- doesn't work
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY', 'MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_CS_FAVOR_ATTACH');
UPDATE ModifierArguments SET Value=2 WHERE ModifierId='MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_FAVOR';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_CS_FAVOR_ATTACH';

