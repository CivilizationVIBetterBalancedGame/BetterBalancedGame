-- 05/03/2024 Green District cost same as other district (from 81)
UPDATE Districts SET Cost=36 WHERE DistrictType IN ('DISTRICT_CANAL', 'DISTRICT_DAM');

-- 05/03/2024 neighboo
-- Custom Placement for canal
INSERT INTO CustomPlacement(ObjectType, Hash, PlacementFunction)
    SELECT Types.Type, Types.Hash, 'BBG_CANAL_CUSTOM_PLACEMENT'
    FROM Types WHERE Type = 'DISTRICT_CANAL';

-- 07/06/23 : Canal to butress
UPDATE Districts SET PrereqTech='TECH_BUTTRESS' WHERE DistrictType='DISTRICT_CANAL';

-- 05/03/2024 Reduce cost of Neighborhood
UPDATE Districts SET Cost=40 WHERE DistrictType IN ('DISTRICT_NEIGHBORHOOD');
