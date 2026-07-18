-- ==============
-- == DISTRICT ==
-- ==============

-- Create new district traderoute yield
INSERT INTO District_TradeRouteYields(DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination) VALUES
    ('DISTRICT_AERODROME', 'YIELD_PRODUCTION', 0.0, 1.0, 1.0);

-- Preserve give ability to plant wood.
-- INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
--    ('BBG_PRESERVE_PLANT_WOOD', 'MODIFIER_PLAYER_ADJUST_FEATURE_UNLOCK');
-- INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
--    ('BBG_PRESERVE_PLANT_WOOD', 'FeatureType', 'FEATURE_FOREST'),
--    ('BBG_PRESERVE_PLANT_WOOD', 'CivicType', 'CIVIC_CODE_OF_LAWS');
-- INSERT INTO DistrictModifiers(DistrictType, ModifierId) VALUES
--    ('DISTRICT_PRESERVE', 'BBG_PRESERVE_PLANT_WOOD');

--5.2.5 buff commercial hub +1 gold on hub close to city center / -1 gold on market 
-- 17/12/25 +2 gold when next to city center, but river adj reduced to +1 gold
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_COMMERCIAL_HUB_CITY_CENTER', 'LOC_DISTRICT_CITY_CENTER_GOLD', 'YIELD_GOLD', 2, 'DISTRICT_CITY_CENTER');
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) VALUES
    ('DISTRICT_COMMERCIAL_HUB', 'BBG_COMMERCIAL_HUB_CITY_CENTER');
UPDATE Building_YieldChanges SET YieldChange=2 WHERE BuildingType='BUILDING_MARKET' AND YieldType='YIELD_GOLD';

UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='River_Gold';

-- ===================
-- == Neighborhoods ==
-- ===================

-- 14/07/26 Neighborhoods rework : 1 per city, +2 food, +1 adjacency for all districts
UPDATE Districts SET OnePerCity=1 WHERE DistrictType='DISTRICT_NEIGHBORHOOD';

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_NEIGHBORHOOD_FOOD', 'MODIFIER_PLAYER_DISTRICT_ADJUST_BASE_YIELD_CHANGE');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_NEIGHBORHOOD_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('BBG_NEIGHBORHOOD_FOOD', 'Amount', 2);
INSERT INTO DistrictModifiers(DistrictType, ModifierId) VALUES
    ('DISTRICT_NEIGHBORHOOD', 'BBG_NEIGHBORHOOD_FOOD');

INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_NEIGHBORHOOD_ADJACENCY_FOOD', 'LOC_DISTRICT_NEIGHBORHOOD_FOOD', 'YIELD_FOOD', 1, 1, 'DISTRICT_NEIGHBORHOOD'),
    ('BBG_NEIGHBORHOOD_ADJACENCY_GOLD', 'LOC_DISTRICT_NEIGHBORHOOD_GOLD', 'YIELD_GOLD', 1, 1, 'DISTRICT_NEIGHBORHOOD'),
    ('BBG_NEIGHBORHOOD_ADJACENCY_FAITH', 'LOC_DISTRICT_NEIGHBORHOOD_FAITH', 'YIELD_FAITH', 1, 1, 'DISTRICT_NEIGHBORHOOD'),
    ('BBG_NEIGHBORHOOD_ADJACENCY_SCIENCE', 'LOC_DISTRICT_NEIGHBORHOOD_SCIENCE', 'YIELD_SCIENCE', 1, 1, 'DISTRICT_NEIGHBORHOOD'),
    ('BBG_NEIGHBORHOOD_ADJACENCY_CULTURE', 'LOC_DISTRICT_NEIGHBORHOOD_CULTURE', 'YIELD_CULTURE', 1, 1, 'DISTRICT_NEIGHBORHOOD'),
    ('BBG_NEIGHBORHOOD_ADJACENCY_PRODUCTION', 'LOC_DISTRICT_NEIGHBORHOOD_PRODUCTION', 'YIELD_PRODUCTION', 1, 1, 'DISTRICT_NEIGHBORHOOD');

INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) 
    SELECT DistrictType, 'BBG_NEIGHBORHOOD_ADJACENCY_FOOD' FROM District_Adjacencies WHERE YieldChangeId='Government_Food';
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) 
    SELECT DistrictType, 'BBG_NEIGHBORHOOD_ADJACENCY_GOLD' FROM District_Adjacencies WHERE YieldChangeId='Government_Gold';
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) 
    SELECT DistrictType, 'BBG_NEIGHBORHOOD_ADJACENCY_FAITH' FROM District_Adjacencies WHERE YieldChangeId='Government_Faith';
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) 
    SELECT DistrictType, 'BBG_NEIGHBORHOOD_ADJACENCY_SCIENCE' FROM District_Adjacencies WHERE YieldChangeId='Government_Science';
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) 
    SELECT DistrictType, 'BBG_NEIGHBORHOOD_ADJACENCY_CULTURE' FROM District_Adjacencies WHERE YieldChangeId='Government_Culture';
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) 
    SELECT DistrictType, 'BBG_NEIGHBORHOOD_ADJACENCY_PRODUCTION' FROM District_Adjacencies WHERE YieldChangeId='Government_Production';
