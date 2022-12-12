--==============================================================================================
--******				RUSSIA					   ******
--==============================================================================================
-- Lavra only gets 1 Great Prophet Point per turn
UPDATE District_GreatPersonPoints SET PointsPerTurn=1 WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_PROPHET';
-- Only gets 2 extra tiles when founding a new city instead of 8 
--UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRAIT_INCREASED_TILES';
-- Cossacks have same base strength as cavalry instead of +5
UPDATE Units SET Combat=62 WHERE UnitType='UNIT_RUSSIAN_COSSACK';

-- 2020/12/15 - Found in 4.1.2: Fix corner case where Cossacks don't work on borders
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='COSSACK_LOCAL_COMBAT';
UPDATE Modifiers SET OwnerRequirementSetId='COSSACK_PLOT_IS_OWNER_OR_ADJACENT_REQUIREMENTS' WHERE ModifierId='COSSACK_LOCAL_COMBAT';

-- 23/04/2021 iElden: Applied Firaxis patch
-- Lavra district does not acrue Great Person Points unless city has a theater
--UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_ARTIST';
--UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_MUSICIAN';
--UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_WRITER';
--INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
--    VALUES ('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
--INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
--    VALUES
--  ('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIRES_DISTRICT_IS_LAVRA'),
--  ('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIRES_CITY_HAS_THEATER_DISTRICT');
--INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
--  VALUES ('REQUIRES_DISTRICT_IS_LAVRA' , 'REQUIREMENT_DISTRICT_TYPE_MATCHES');
--INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
--  VALUES ('REQUIRES_DISTRICT_IS_LAVRA', 'DistrictType', 'DISTRICT_LAVRA');
--INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
--    VALUES
--  ('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS'),
--    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS'),
--  ('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS');
--INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
--    VALUES
--  ('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_ARTIST'),
--    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_MUSICIAN'),
--  ('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_WRITER'),
--  ('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'Amount' , '1'),
--    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'Amount' , '1'),
--    ('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'Amount' , '1');
--INSERT OR IGNORE INTO DistrictModifiers ( DistrictType , ModifierId )
--  VALUES
--  ( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_ARTIST_GPP_MODIFIER' ),
--  ( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' ),
--  ( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_WRITER_GPP_MODIFIER' );

-- No faith on russia tile
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_MOTHER_RUSSIA' AND ModifierId='TRAIT_INCREASED_TUNDRA_FAITH';
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_MOTHER_RUSSIA' AND ModifierId='TRAIT_INCREASED_TUNDRA_HILLS_FAITH';

-- Russia get one faith.
INSERT OR IGNORE INTO TraitModifiers(TraitType , ModifierId) VALUES
    ('TRAIT_CIVILIZATION_MOTHER_RUSSIA', 'TRAIT_ONE_FAITH');
	
INSERT OR IGNORE INTO Modifiers(ModifierId , ModifierType) VALUES
    ('TRAIT_ONE_FAITH', 'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE');

INSERT OR IGNORE INTO ModifierArguments(ModifierId , Name, Value) VALUES
    ('TRAIT_ONE_FAITH' , 'Amount', 1),
    ('TRAIT_ONE_FAITH' , 'YieldType', 'YIELD_FAITH');

-- Russia GPP Adjustment
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_DISTRICT_LAVRA' AND ModifierId='TRAIT_TIER3_MUSICIAN_POINTS';
UPDATE Modifiers SET SubjectRequirementSetId='REQUIREMENTS_CITY_HAS_TIER3RELIGIOUS' WHERE ModifierId='TRAIT_TEMPLE_ARTIST_POINTS';
UPDATE Modifiers SET SubjectRequirementSetId='REQUIREMENTS_CITY_HAS_TEMPLE' WHERE ModifierId='TRAIT_SHRINE_WRITING_POINTS';

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('PLOT_HAS_TUNDRA_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG'),
    ('PLOT_HAS_TUNDRA_HILLS_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG');