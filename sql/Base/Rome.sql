-- free city center building after code of laws
--====Trajan====--
-- 08/07/24 delayed to foreign trade
-- 08/04/25 delayed to early empire
UPDATE Modifiers SET SubjectRequirementSetId='BBG_UTILS_PLAYER_HAS_CIVIC_EARLY_EMPIRE_REQSET' WHERE ModifierId='TRAIT_ADJUST_NON_CAPITAL_FREE_CHEAPEST_BUILDING';

--====Rome======--
-- reverted 04/10/22
-- back to the menu 07/07/25
-- 14/07/26 increase to standard adjacency
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
	('DISTRICT_BATH' , 'District_Culture_Standard');

-- 07/07/25 Bath no longer give amenity
UPDATE Districts SET Entertainment=0 WHERE DistrictType='DISTRICT_BATH';


-- 08/04/25 Legions down to 38
-- 04/07/26 reverted
-- UPDATE Units SET Combat=38 WHERE UnitType='UNIT_ROMAN_LEGION';

-- 04/07/26 Fort, Roman Fort and PA : Add one prod and one gold
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
	('IMPROVEMENT_ROMAN_FORT', 'YIELD_PRODUCTION', 1),
	('IMPROVEMENT_ROMAN_FORT', 'YIELD_GOLD', 1);

-- 11/07/26 roman fort give golden age point
INSERT INTO Types(Type, Kind) VALUES
	('TRAIT_CIVILIZATION_IMPROVEMENT_ROMAN_FORT', 'KIND_TRAIT');
INSERT INTO Traits(TraitType, Name) VALUES
	('TRAIT_CIVILIZATION_IMPROVEMENT_ROMAN_FORT', 'LOC_TRAIT_CIVILIZATION_IMPROVEMENT_ROMAN_FORT');
INSERT INTO CivilizationTraits(CivilizationType, TraitType) VALUES
	('CIVILIZATION_ROME', 'TRAIT_CIVILIZATION_IMPROVEMENT_ROMAN_FORT');
UPDATE Improvements SET TraitType='TRAIT_CIVILIZATION_IMPROVEMENT_ROMAN_FORT' WHERE ImprovementType='IMPROVEMENT_ROMAN_FORT';