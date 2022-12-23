-- Green District cost same as other district (from 81)
UPDATE Districts SET Cost=54 WHERE DistrictType IN ('DISTRICT_CANAL', 'DISTRICT_DAM');

