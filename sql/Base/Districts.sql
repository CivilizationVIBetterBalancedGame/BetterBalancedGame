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
