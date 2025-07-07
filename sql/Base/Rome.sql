-- free city center building after code of laws
--====Trajan====--
-- 08/07/24 delayed to foreign trade
-- 08/04/25 delayed to early empire
UPDATE Modifiers SET SubjectRequirementSetId='BBG_UTILS_PLAYER_HAS_CIVIC_EARLY_EMPIRE_REQSET' WHERE ModifierId='TRAIT_ADJUST_NON_CAPITAL_FREE_CHEAPEST_BUILDING';

--====Rome======--
-- reverted 04/10/22
-- back to the menu 07/07/25
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
	('DISTRICT_BATH' , 'District_Culture');

-- 07/07/25 Bath no longer give amenity
UPDATE Districts SET Entertainment=0 WHERE DistrictType='DISTRICT_BATH';


-- 08/04/25 Legions down to 38
UPDATE Units SET Combat=38 WHERE UnitType='UNIT_ROMAN_LEGION';