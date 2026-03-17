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