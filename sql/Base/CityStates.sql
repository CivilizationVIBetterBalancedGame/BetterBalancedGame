--==============================================================
--******			       CITY STATES      			  ******
--==============================================================

UPDATE Resources SET Happiness=4 WHERE ResourceType IN ('RESOURCE_CINNAMON', 'RESOURCE_CLOVES');

--08/03/24 Mexico aqueduct amenities
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MINOR_CIV_MEXICO_CITY_UNIQUE_INFLUENCE_BONUS_AQUEDUCT', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_IS_SUZERAIN'),
    ('BBG_MINOR_CIV_MEXICO_CITY_AMENITY_PER_AQUEDUCT', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_AMENITIES_FROM_CITY_STATES', 'REQSET_CITY_HAS_AQUEDUCT');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MINOR_CIV_MEXICO_CITY_UNIQUE_INFLUENCE_BONUS_AQUEDUCT', 'ModifierId', 'BBG_MINOR_CIV_MEXICO_CITY_AMENITY_PER_AQUEDUCT'),
    ('BBG_MINOR_CIV_MEXICO_CITY_AMENITY_PER_AQUEDUCT', 'Amount', 1);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('REQSET_CITY_HAS_AQUEDUCT', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('REQSET_CITY_HAS_AQUEDUCT', 'REQUIRES_CITY_HAS_AQUEDUCT');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('MINOR_CIV_MEXICO_CITY_TRAIT', 'BBG_MINOR_CIV_MEXICO_CITY_UNIQUE_INFLUENCE_BONUS_AQUEDUCT');

--10/03/24 Jerusalem gives +1 gold per holy site
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MINOR_CIV_JERUSALEM_UNIQUE_INFLUENCE_BONUS_GOLD_HS', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_IS_SUZERAIN'),
    ('BBG_MINOR_CIV_JERUSALEM_UNIQUE_INFLUENCE_BONUS_GOLD_HS_MODIFIER', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'BBG_CITY_HAS_DISTRICT_HOLY_SITE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MINOR_CIV_JERUSALEM_UNIQUE_INFLUENCE_BONUS_GOLD_HS', 'ModifierId', 'BBG_MINOR_CIV_JERUSALEM_UNIQUE_INFLUENCE_BONUS_GOLD_HS_MODIFIER'),
    ('BBG_MINOR_CIV_JERUSALEM_UNIQUE_INFLUENCE_BONUS_GOLD_HS_MODIFIER', 'YieldType', 'YIELD_GOLD'),
    ('BBG_MINOR_CIV_JERUSALEM_UNIQUE_INFLUENCE_BONUS_GOLD_HS_MODIFIER', 'Amount', 1);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('MINOR_CIV_JERUSALEM_TRAIT', 'BBG_MINOR_CIV_JERUSALEM_UNIQUE_INFLUENCE_BONUS_GOLD_HS');

-- nan-modal culture per district no longer applies to city center or wonders
INSERT OR IGNORE INTO Requirements ( RequirementId, RequirementType, Inverse ) VALUES
    ( 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
    ( 'REQUIRES_DISTRICT_IS_NOT_AQUEDUCT_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
    ( 'REQUIRES_DISTRICT_IS_NOT_CANAL_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
    ( 'REQUIRES_DISTRICT_IS_NOT_DAM_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
    ( 'REQUIRES_DISTRICT_IS_NOT_NEIGHBORHOOD_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
    ( 'REQUIRES_DISTRICT_IS_NOT_SPACEPORT_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
    ( 'REQUIRES_DISTRICT_IS_NOT_WORLD_WONDER_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 );
INSERT OR IGNORE INTO RequirementArguments ( RequirementId, Name, Value ) VALUES
    ( 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG', 'DistrictType', 'DISTRICT_CITY_CENTER' ),
    ( 'REQUIRES_DISTRICT_IS_NOT_AQUEDUCT_BBG', 'DistrictType', 'DISTRICT_AQUEDUCT' ),
    ( 'REQUIRES_DISTRICT_IS_NOT_CANAL_BBG', 'DistrictType', 'DISTRICT_CANAL' ),
    ( 'REQUIRES_DISTRICT_IS_NOT_DAM_BBG', 'DistrictType', 'DISTRICT_DAM' ),
    ( 'REQUIRES_DISTRICT_IS_NOT_NEIGHBORHOOD_BBG', 'DistrictType', 'DISTRICT_NEIGHBORHOOD' ),
    ( 'REQUIRES_DISTRICT_IS_NOT_SPACEPORT_BBG', 'DistrictType', 'DISTRICT_SPACEPORT' ),
    ( 'REQUIRES_DISTRICT_IS_NOT_WORLD_WONDER_BBG', 'DistrictType', 'DISTRICT_WONDER' );
INSERT OR IGNORE INTO RequirementSets ( RequirementSetId, RequirementSetType ) VALUES
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIREMENTSET_TEST_ALL' );
INSERT OR IGNORE INTO RequirementSetRequirements ( RequirementSetId, RequirementId ) VALUES
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_PLOT_IS_ADJACENT_TO_COAST' ),
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG' ),
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_AQUEDUCT_BBG' ),
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_CANAL_BBG' ),
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_DAM_BBG' ),
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_NEIGHBORHOOD_BBG' ),
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_SPACEPORT_BBG' ),
    ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_WORLD_WONDER_BBG' );

INSERT INTO Requirements(RequirementId,RequirementType) VALUES
    ('REQUIRES_SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIREMENT_REQUIREMENTSET_IS_MET');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQUIRES_SPECIAL_DISTRICT_ON_COAST_BBG', 'RequirementSetId', 'SPECIAL_DISTRICT_ON_COAST_BBG');

UPDATE Modifiers SET SubjectRequirementSetId='SPECIAL_DISTRICT_ON_COAST_BBG' WHERE ModifierId='MINOR_CIV_NAN_MADOL_DISTRICTS_CULTURE_BONUS';

-- Nan madol nerf to +1 culture.
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='MINOR_CIV_NAN_MADOL_DISTRICTS_CULTURE_BONUS' AND Name='Amount';
-- +1 culture once exploration reach
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('MINOR_CIV_NAN_MADOL_TRAIT', 'BBG_NAN_MADOL_UNIQUE_INFLUENCE_EXPLORATION_MODIFIER');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_NAN_MADOL_UNIQUE_INFLUENCE_EXPLORATION_MODIFIER', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_IS_SUZERAIN'),
    ('BBG_NAN_MADOL_EXPLORATION_BONUS_MODIFIER', 'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE', 'SPECIAL_DISTRICT_ON_COAST_EXPLORATION_BBG');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_NAN_MADOL_UNIQUE_INFLUENCE_EXPLORATION_MODIFIER', 'ModifierId', 'BBG_NAN_MADOL_EXPLORATION_BONUS_MODIFIER'),
    ('BBG_NAN_MADOL_EXPLORATION_BONUS_MODIFIER', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_NAN_MADOL_EXPLORATION_BONUS_MODIFIER', 'Amount', '1');

INSERT INTO RequirementSets('RequirementSetId', 'RequirementSetType') VALUES
    ('SPECIAL_DISTRICT_ON_COAST_EXPLORATION_BBG', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('SPECIAL_DISTRICT_ON_COAST_EXPLORATION_BBG', 'REQUIRES_SPECIAL_DISTRICT_ON_COAST_BBG'),
    ('SPECIAL_DISTRICT_ON_COAST_EXPLORATION_BBG', 'BBG_UTILS_PLAYER_HAS_CIVIC_EXPLORATION_REQUIREMENT');


-- Ngazargamu legacy city-state is carthage
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='MINOR_CIV_CARTHAGE_BARRACKS_STABLE_PURCHASE_BONUS';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='MINOR_CIV_CARTHAGE_ARMORY_PURCHASE_BONUS';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='MINOR_CIV_CARTHAGE_MILITARY_ACADEMY_PURCHASE_BONUS';

-- 09/03/24 Lisbon pillage apply on land too
UPDATE ModifierArguments SET Value='ABILITY_ECONOMIC_GOLDEN_AGE_PLUNDER_IMMUNITY' WHERE ModifierId='MINOR_CIV_LISBON_SEA_TRADE_ROUTE_PLUNDER_IMMUNITY_BONUS' AND Name='AbilityType';

-- 09/03/2024 colossal heads +1 food, +1 housing
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES ('IMPROVEMENT_COLOSSAL_HEAD', 'YIELD_FOOD', 1);
UPDATE Improvements SET Housing=1 WHERE ImprovementType='IMPROVEMENT_COLOSSAL_HEAD';

--09/03/2024 Hattusa gives 2 Strategic that you discovered even if improved
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_HORSES' WHERE ModifierId='MINOR_CIV_HATTUSA_HORSES_RESOURCE_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_IRON' WHERE ModifierId='MINOR_CIV_HATTUSA_IRON_RESOURCE_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_NITER' WHERE ModifierId='MINOR_CIV_HATTUSA_NITER_RESOURCE_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_COAL' WHERE ModifierId='MINOR_CIV_HATTUSA_COAL_RESOURCE_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_OIL' WHERE ModifierId='MINOR_CIV_HATTUSA_OIL_RESOURCE_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_ALUMINUM' WHERE ModifierId='MINOR_CIV_HATTUSA_ALUMINUM_RESOURCE_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_URANIUM' WHERE ModifierId='MINOR_CIV_HATTUSA_URANIUM_RESOURCE_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_HORSES' WHERE ModifierId='MINOR_CIV_HATTUSA_HORSES_RESOURCE_XP2';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_IRON' WHERE ModifierId='MINOR_CIV_HATTUSA_IRON_RESOURCE_XP2';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_NITER' WHERE ModifierId='MINOR_CIV_HATTUSA_NITER_RESOURCE_XP2';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_COAL' WHERE ModifierId='MINOR_CIV_HATTUSA_COAL_RESOURCE_XP2';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_OIL' WHERE ModifierId='MINOR_CIV_HATTUSA_OIL_RESOURCE_XP2';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_ALUMINUM' WHERE ModifierId='MINOR_CIV_HATTUSA_ALUMINUM_RESOURCE_XP2';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_CAN_SEE_URANIUM' WHERE ModifierId='MINOR_CIV_HATTUSA_URANIUM_RESOURCE_XP2';