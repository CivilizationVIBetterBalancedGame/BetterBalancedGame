-- by: iElden

-- This file is created to allow BBG to boot on people that didn't have Kublai Vietnam DLC

INSERT INTO District_TradeRouteYields(DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination) VALUES
    ('DISTRICT_PRESERVE', 'YIELD_FOOD', 0.0, 1.0, 0.0),
    ('DISTRICT_PRESERVE', 'YIELD_FAITH', 0.0, 0.0, 1.0);

UPDATE Districts SET CostProgressionModel='COST_PROGRESSION_NUM_UNDER_AVG_PLUS_TECH', CostProgressionParam1=40, CityStrengthModifier=2 WHERE DistrictType='DISTRICT_PRESERVE';
