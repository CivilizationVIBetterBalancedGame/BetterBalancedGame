
-- This file is created to allow BBG to boot on people that didn't have Kublai Vietnam DLC

INSERT INTO District_TradeRouteYields(DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination) VALUES
    ('DISTRICT_PRESERVE', 'YIELD_FOOD', 0.0, 1.0, 0.0),
    ('DISTRICT_PRESERVE', 'YIELD_FAITH', 0.0, 0.0, 1.0);

UPDATE Districts SET CostProgressionModel='COST_PROGRESSION_NUM_UNDER_AVG_PLUS_TECH', CostProgressionParam1=35, CityStrengthModifier=2 WHERE DistrictType='DISTRICT_PRESERVE';

-- 10/03/24 PreservePreserve change: Smoothen the yield scaling on appeal on Groves 
-- -99+ Appeal (whatever) : +1 Food & Faith
-- 2+ Appeal (Charming) : +1 Culture
-- 4+ Appeal (Breathtaking) : +1 Food, Culture & Faith
UPDATE Adjacent_AppealYieldChanges SET MinimumValue=-99 WHERE BuildingType='BUILDING_GROVE' AND MaximumValue=3 AND (YieldType='YIELD_FAITH' OR YieldType='YIELD_FOOD');
INSERT INTO Adjacent_AppealYieldChanges (DistrictType, YieldType, MaximumValue, BuildingType, MinimumValue, YieldChange, Description, Unimproved) VALUES
    ('DISTRICT_PRESERVE', 'YIELD_CULTURE', 3, 'BUILDING_GROVE', 2, 1, 'LOC_TOOLTIP_APPEAL_CHARMING', 1);
-- 10/03/24 PreservePreserve change: Smoothen the yield scaling on appeal on Sanctuary 
-- -99+ Appeal (whatever) : +1 Production & Gold
-- 2+ Appeal (Charming) : +1 Science
-- 4+ Appeal (Breathtaking) : +1 Production, Science & Gold
UPDATE Adjacent_AppealYieldChanges SET MinimumValue=-99 WHERE BuildingType='BUILDING_SANCTUARY' AND MaximumValue=3 AND (YieldType='YIELD_SCIENCE' OR YieldType='YIELD_GOLD');
INSERT INTO Adjacent_AppealYieldChanges (DistrictType, YieldType, MaximumValue, BuildingType, MinimumValue, YieldChange, Description, Unimproved) VALUES
    ('DISTRICT_PRESERVE', 'YIELD_PRODUCTION', 3, 'BUILDING_SANCTUARY', 2, 1, 'LOC_TOOLTIP_APPEAL_CHARMING', 1);