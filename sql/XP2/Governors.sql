--==============================================================
--******                G O V E R N O R S                 ******
--==============================================================
--===============================Amani====================------
-- Amani's changed 1st right ability
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE';

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES
    ('HORSES_AMANI_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_HORSES'),
    ('IRON_AMANI_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_IRON'),
    ('NITER_AMANI_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_NITER'),
    ('COAL_AMANI_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_COAL'),
    ('ALUMINUM_AMANI_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_ALUMINUM'),
    ('OIL_AMANI_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_OIL'),
    ('URANIUM_AMANI_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_URANIUM');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
    ('HORSES_AMANI_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_HORSES'),
    ('HORSES_AMANI_AMOUNT_MODIFIER', 'Amount', '2'),
    ('IRON_AMANI_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_IRON'),
    ('IRON_AMANI_AMOUNT_MODIFIER', 'Amount', '2'),
    ('NITER_AMANI_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_NITER'),
    ('NITER_AMANI_AMOUNT_MODIFIER', 'Amount', '2'),
    ('COAL_AMANI_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_COAL'),
    ('COAL_AMANI_AMOUNT_MODIFIER', 'Amount', '2'),
    ('ALUMINUM_AMANI_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_ALUMINUM'),
    ('ALUMINUM_AMANI_AMOUNT_MODIFIER', 'Amount', '2'),
    ('OIL_AMANI_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_OIL'),
    ('OIL_AMANI_AMOUNT_MODIFIER', 'Amount', '2'),
    ('URANIUM_AMANI_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_URANIUM'),
    ('URANIUM_AMANI_AMOUNT_MODIFIER', 'Amount', '2');
INSERT INTO GovernorPromotionModifiers VALUES
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'HORSES_AMANI_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'IRON_AMANI_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'NITER_AMANI_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'COAL_AMANI_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'ALUMINUM_AMANI_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'OIL_AMANI_AMOUNT_MODIFIER'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'URANIUM_AMANI_AMOUNT_MODIFIER');

-- Correct Amani's Spies promo
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
        ('GOVERNOR_PROMOTION_LOCAL_INFORMANTS', 'GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE');
UPDATE GovernorPromotions SET Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_LOCAL_INFORMANTS';


--=============================================================================================
--=                                        LIANG                                              =
--=============================================================================================

-- 07/12/22 Liang 3 turns
-- xx/xx/xx Liang 4 turns ?
-- 06/07/24 Liang rework stay to 4 turns
UPDATE Governors SET TransitionStrength=125 WHERE GovernorType='GOVERNOR_THE_BUILDER';

-- LI Reinforced Materials : Prod +1 for floodplains and volcanic soils. This city's improvements, buildings and District Districts cannot be damaged by Environmental Effects.
UPDATE GovernorPromotions SET Level=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE', 'GOVERNOR_PROMOTION_BUILDER_GUILDMASTER');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_REQUIRES_PLOT_HAS_VOLCANIC_SOIL', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_REQUIRES_PLOT_HAS_VOLCANIC_SOIL', 'PLOT_VOLCANIC_SOIL_REQUIREMENT');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'BBG_REQUIRES_PLOT_HAS_FLOODPLAINS'),
    ('BBG_REINFORCED_INFRASTRUCTURE_VOLCANO_PROD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'BBG_REQUIRES_PLOT_HAS_VOLCANIC_SOIL');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD', 'Amount', '1'),
    ('BBG_REINFORCED_INFRASTRUCTURE_VOLCANO_PROD', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_REINFORCED_INFRASTRUCTURE_VOLCANO_PROD', 'Amount', '1');
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE', 'BBG_REINFORCED_INFRASTRUCTURE_FLOODPLAINS_PROD'),
    ('GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE', 'BBG_REINFORCED_INFRASTRUCTURE_VOLCANO_PROD');

-- RI Agriculture : +1 food on every resource
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AQUACULTURE';
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column)
    VALUES ('BBG_AGRICULTURE_PROMOTION', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_NAME', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_DESCRIPTION', 1, 2);
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES ('BBG_AGRICULTURE_PROMOTION', 'GOVERNOR_PROMOTION_BUILDER_GUILDMASTER');
DELETE FROM Types WHERE Type='GOVERNOR_PROMOTION_AQUACULTURE';
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_LIANG_AGRICULTURE_FOOD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'BBG_PLOT_HAS_VISIBLE_RESOURCE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_LIANG_AGRICULTURE_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('BBG_LIANG_AGRICULTURE_FOOD', 'Amount', '1');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_PLOT_HAS_VISIBLE_RESOURCE', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_PLOT_HAS_VISIBLE_RESOURCE', 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
INSERT INTO Types (Type, Kind) VALUES ('BBG_AGRICULTURE_PROMOTION', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_BUILDER', 'BBG_AGRICULTURE_PROMOTION');
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES ('BBG_AGRICULTURE_PROMOTION', 'BBG_LIANG_AGRICULTURE_FOOD');

-- LII Park & Recreation : The City Park unique improvement can be built in the city. Yields 2 Appeal, 3 science, 2 culture, +1 amenity and +2 housing.  
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_PARKS_RECREATION';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_PARKS_RECREATION', 'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE');
UPDATE GovernorPromotions SET Level=2, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_PARKS_RECREATION';      
UPDATE Improvement_YieldChanges SET YieldChange=2 WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND YieldType='YIELD_CULTURE';
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_CITY_PARK', 'YIELD_SCIENCE', 3);
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='CITY_PARK_WATER_AMENITY';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_CITY_PARK_HOUSING', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_CITY_PARK_HOUSING', 'Amount', 2);
INSERT INTO ImprovementModifiers (ImprovementType, ModifierID) VALUES
    ('IMPROVEMENT_CITY_PARK', 'BBG_CITY_PARK_HOUSING');
DELETE FROM ImprovementModifiers WHERE ModifierID='CITY_PARK_GOVERNOR_CULTURE';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_DESERT_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_GRASS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_SNOW_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE Improvements SET OnePerCity=1 WHERE ImprovementType='IMPROVEMENT_CITY_PARK';

-- RII Urbanism : +1 production on revealed resources in the city.
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER';
UPDATE GovernorPromotions SET Level=2, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_ZONING_COMMISSIONER', 'BBG_AGRICULTURE_PROMOTION');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_LIANG_PROD_RESOURCES', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'BBG_PLOT_HAS_VISIBLE_RESOURCE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_LIANG_PROD_RESOURCES', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_LIANG_PROD_RESOURCES', 'Amount', 1);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_ZONING_COMMISSIONER', 'BBG_LIANG_PROD_RESOURCES');

-- MIII Water Work : +1 housing, +1 amenity per specialized district in the city.    
-- +1 housing for districts
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='WATER_WORKS_NEIGHBORHOOD_HOUSING';
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='WATER_WORKS_CANAL_AMENITY';
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='WATER_WORKS_DAM_AMENITY';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='WATER_WORKS_AQUEDUCT_HOUSING';
UPDATE ModifierArguments SET Value=1 WHERE ModifierId='WATER_WORKS_AQUEDUCT_HOUSING' AND Name='Amount';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_WATER_WORKS', 'GOVERNOR_PROMOTION_ZONING_COMMISSIONER'),
    ('GOVERNOR_PROMOTION_WATER_WORKS', 'GOVERNOR_PROMOTION_PARKS_RECREATION');
UPDATE GovernorPromotions SET Level=3, Column=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_WATER_WORKS';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_LIANG_AMENITY', 'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_LIANG_AMENITY', 'Amount', 1);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_WATER_WORKS', 'BBG_LIANG_AMENITY');
    
-- Fishery moved to tech tree
UPDATE Improvements SET TraitType=NULL WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM ImprovementModifiers WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM Modifiers WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
DELETE FROM ModifierArguments WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
UPDATE Improvements SET PrereqTech='TECH_CARTOGRAPHY' WHERE ImprovementType='IMPROVEMENT_FISHERY';
