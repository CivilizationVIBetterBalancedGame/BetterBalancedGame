-- ==============
-- == DISTRICT ==
-- ==============

-- Create new district traderoute yield
INSERT INTO District_TradeRouteYields(DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination) VALUES
    ('DISTRICT_AERODROME', 'YIELD_PRODUCTION', 0.0, 1.0, 1.0);

-- Green District cost same as other district (from 81)
UPDATE Districts SET Cost=54 WHERE DistrictType IN ('DISTRICT_CANAL', 'DISTRICT_DAM');

-- Preserve give ability to plant wood.
-- INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
--    ('BBG_PRESERVE_PLANT_WOOD', 'MODIFIER_PLAYER_ADJUST_FEATURE_UNLOCK');
-- INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
--    ('BBG_PRESERVE_PLANT_WOOD', 'FeatureType', 'FEATURE_FOREST'),
--    ('BBG_PRESERVE_PLANT_WOOD', 'CivicType', 'CIVIC_CODE_OF_LAWS');
-- INSERT INTO DistrictModifiers(DistrictType, ModifierId) VALUES
--    ('DISTRICT_PRESERVE', 'BBG_PRESERVE_PLANT_WOOD');

-- ==============
-- == BUILDING ==
-- ==============

-- Give sewers +1 amenity
UPDATE Buildings SET Entertainment=1 WHERE BuildingType='BUILDING_SEWER';

-- Watermill no longer give food on "farmable" resources.
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_WATER_MILL' AND
    ModifierId IN ('WATERMILL_ADDRICEFOOD', 'WATERMILL_ADDWHEATYIELD', 'WATERMILL_ADDMAIZEYIELD');
-- Watermill give 1 production towards farm
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_WATERMILL_PRODUCTION_FARM', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_FARM_REQUIREMENTS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_WATERMILL_PRODUCTION_FARM', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_WATERMILL_PRODUCTION_FARM', 'Amount', '1');
INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_WATER_MILL', 'BBG_WATERMILL_PRODUCTION_FARM');

-- Pagoda: 1 Influance instead of 1 diplo favour
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_PAGODA' AND ModifierId='PAGODA_ADJUST_FAVOR';
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_PAGODA_INFLUENCE', 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_PAGODA_INFLUENCE', 'Amount', '1');
INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_PAGODA', 'BBG_PAGODA_INFLUENCE');

-- Grandmaster Chapel only faith buy in owned city. (XP1)
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_WAS_FOUNDED', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_WAS_FOUNDED', 'REQUIRES_CITY_WAS_FOUNDED');
UPDATE Modifiers SET SubjectRequirementSetId='BBG_CITY_WAS_FOUNDED' WHERE ModifierId LIKE 'GOV_FAITH_PURCHASE_%';

-- Workshop cost less and give more production
UPDATE Buildings SET Cost=160 WHERE BuildingType='BUILDING_WORKSHOP';
UPDATE Building_YieldChanges SET YieldChange=4 WHERE BuildingType='BUILDING_WORKSHOP' AND YieldType='YIELD_PRODUCTION';

-- Factory
UPDATE Buildings SET Cost=290 WHERE BuildingType IN ('BUILDING_FACTORY', 'BUILDING_ELECTRONICS_FACTORY');
-- UPDATE Buildings SET PrereqTech='TECH_MASS_PRODUCTION' WHERE BuildingType='BUILDING_FACTORY';

-- Coal Powerplant
UPDATE Buildings SET Cost=330 WHERE BuildingType='BUILDING_COAL_POWER_PLANT';

--=============
--== WONDERS ==
--=============

-- Colosseum - reduce culture to 1 (from 2)
UPDATE Building_YieldChanges SET YieldChange=1 WHERE BuildingType='BUILDING_COLOSSEUM' AND YieldType='YIELD_CULTURE';

-- Jabel Barkal - Increase strategics ressource storage by 20 (online speed).


-- Chichen Itza - Culture +1 for all jungle in the empire.


-- Hagia Sophia - Religious pressure +200% for this city.


-- Kotoku-in - Increase strength of player warrior Monk.


-- Meenakshi Temple - Religious pressure +50% in Empire? (TODO: Check if Guru can heal Warrior Monk => Should)


-- Mont St. Michel - Awards a relic.


-- University of Sankore - Increase trade route yield given by wonder.


-- Great Zimbabwe


-- Orszaghaz


-- Taj Mahal


-- Torre de Belem - Remove free building to avoid conflict with dummy.


-- Amundsen-Scott Research Station - +1 Science per snow tile in the city. Citizen can work snow tile for 3 science.


-- Golden Gate Bridge


-- BioSphere - Drastically reduce polution (making player generating more diplomatic favour by pollution modifier).



-- Commercial hub buildings buff :
UPDATE Building_GreatPersonPoints SET PointsPerTurn=2 WHERE BuildingType='BUILDING_BANK';
UPDATE Building_GreatPersonPoints SET PointsPerTurn=3 WHERE BuildingType='BUILDING_STOCK_EXCHANGE';
UPDATE Building_YieldChanges SET YieldChange=6 WHERE BuildingType='BUILDING_BANK' AND YieldType='YIELD_GOLD';
UPDATE Building_YieldChanges SET YieldChange=8 WHERE BuildingType='BUILDING_STOCK_EXCHANGE' AND YieldType='YIELD_GOLD';
UPDATE Building_YieldChangesBonusWithPower SET YieldChange=12 WHERE BuildingType='BUILDING_STOCK_EXCHANGE' AND YieldType='YIELD_GOLD';

-- Commercial hub building traderoute modifier :
UPDATE Buildings SET Description='LOC_BBG_BUILDING_BANK_DESCRIPTION' WHERE BuildingType='BUILDING_BANK';
UPDATE Buildings SET Description='LOC_BBG_BUILDING_STOCK_EXCHANGE_DESCRIPTION' WHERE BuildingType='BUILDING_STOCK_EXCHANGE';

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_BANK_TRADEROUTE_FROM_DOMESTIC', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC'),
    ('BBG_BANK_TRADEROUTE_TO_DOMESTIC', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_DOMESTIC', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_DOMESTIC', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS'),
    ('BBG_BANK_TRADEROUTE_FROM_INTERNATIONAL', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL'),
    ('BBG_BANK_TRADEROUTE_TO_INTERNATIONAL', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_INTERNATIONAL', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_INTERNATIONAL', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_BANK_TRADEROUTE_FROM_DOMESTIC', 'YieldType', 'YIELD_GOLD'),
    ('BBG_BANK_TRADEROUTE_FROM_DOMESTIC', 'Amount', '2'),
    ('BBG_BANK_TRADEROUTE_FROM_DOMESTIC', 'Domestic', '1'),
    ('BBG_BANK_TRADEROUTE_TO_DOMESTIC', 'YieldType', 'YIELD_GOLD'),
    ('BBG_BANK_TRADEROUTE_TO_DOMESTIC', 'Amount', '1'),
    ('BBG_BANK_TRADEROUTE_TO_DOMESTIC', 'Domestic', '1'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_DOMESTIC', 'YieldType', 'YIELD_GOLD'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_DOMESTIC', 'Amount', '4'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_DOMESTIC', 'Domestic', '1'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_DOMESTIC', 'YieldType', 'YIELD_GOLD'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_DOMESTIC', 'Amount', '2'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_DOMESTIC', 'Domestic', '1'),
    ('BBG_BANK_TRADEROUTE_FROM_INTERNATIONAL', 'YieldType', 'YIELD_GOLD'),
    ('BBG_BANK_TRADEROUTE_FROM_INTERNATIONAL', 'Amount', '2'),
    ('BBG_BANK_TRADEROUTE_FROM_INTERNATIONAL', 'Domestic', '0'),
    ('BBG_BANK_TRADEROUTE_TO_INTERNATIONAL', 'YieldType', 'YIELD_GOLD'),
    ('BBG_BANK_TRADEROUTE_TO_INTERNATIONAL', 'Amount', '1'),
    ('BBG_BANK_TRADEROUTE_TO_INTERNATIONAL', 'Domestic', '0'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_INTERNATIONAL', 'YieldType', 'YIELD_GOLD'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_INTERNATIONAL', 'Amount', '4'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_INTERNATIONAL', 'Domestic', '0'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_INTERNATIONAL', 'YieldType', 'YIELD_GOLD'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_INTERNATIONAL', 'Amount', '2'),
    ('BBG_STOCK_EXCHANGE_TRADEROUTE_TO_INTERNATIONAL', 'Domestic', '0');

INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_BANK', 'BBG_BANK_TRADEROUTE_FROM_DOMESTIC'),
    ('BUILDING_BANK', 'BBG_BANK_TRADEROUTE_TO_DOMESTIC'),
    ('BUILDING_STOCK_EXCHANGE', 'BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_DOMESTIC'),
    ('BUILDING_STOCK_EXCHANGE', 'BBG_STOCK_EXCHANGE_TRADEROUTE_TO_DOMESTIC'),
    ('BUILDING_BANK', 'BBG_BANK_TRADEROUTE_FROM_INTERNATIONAL'),
    ('BUILDING_BANK', 'BBG_BANK_TRADEROUTE_TO_INTERNATIONAL'),
    ('BUILDING_STOCK_EXCHANGE', 'BBG_STOCK_EXCHANGE_TRADEROUTE_FROM_INTERNATIONAL'),
    ('BUILDING_STOCK_EXCHANGE', 'BBG_STOCK_EXCHANGE_TRADEROUTE_TO_INTERNATIONAL');
