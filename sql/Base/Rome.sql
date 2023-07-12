-- free city center building after code of laws
--====Trajan====--
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_HAS_CIVIC_CODE_OF_LAWS_REQSET' WHERE ModifierId='TRAIT_ADJUST_NON_CAPITAL_FREE_CHEAPEST_BUILDING';

--====Rome======--
-- reverted 04/10/22
-- INSERT OR IGNORE INTO District_Adjacencies (DistrictType , YieldChangeId)
-- 	VALUES ('DISTRICT_BATH' , 'District_Culture');

