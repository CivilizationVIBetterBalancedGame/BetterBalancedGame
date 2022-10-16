-- Arabia's Worship Building Bonus increased from 10% to 20%
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='TRAIT_RELIGIOUS_BUILDING_MULTIPLIER_CULTURE' AND Name='Multiplier';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='TRAIT_RELIGIOUS_BUILDING_MULTIPLIER_FAITH' AND Name='Multiplier';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='TRAIT_RELIGIOUS_BUILDING_MULTIPLIER_SCIENCE' AND Name='Multiplier';
-- Arabia gets +1 Great Prophet point per turn after researching astrology
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId)
    VALUES ('TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' , 'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS' , 'PLAYER_HAS_ASTROLOGY_REQUIREMENTS_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_PROPHET');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' , 'Amount' , '1');
--UPDATE TraitModifiers SET ModifierId='TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' WHERE ModifierId='TRAIT_GUARANTEE_ONE_PROPHET';
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES ('TRAIT_CIVILIZATION_LAST_PROPHET', 'TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('PLAYER_HAS_ASTROLOGY_REQUIREMENTS_CPLMOD' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('PLAYER_HAS_ASTROLOGY_REQUIREMENTS_CPLMOD' , 'REQUIRES_PLAYER_HAS_ASTROLOGY_CPLMOD');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_PLAYER_HAS_ASTROLOGY_CPLMOD' , 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLAYER_HAS_ASTROLOGY_CPLMOD' , 'TechnologyType' , 'TECH_ASTROLOGY');

-- 18/05/2021: Mamluk 53 strengh
UPDATE Units SET Combat=53 WHERE UnitType='UNIT_ARABIAN_MAMLUK';
-- 18/05/2021: Madrasa cost to 175
-- UPDATE Buildings SET Cost=175 WHERE BuildingType='BUILDING_MADRASA';

-- Campus and Holy Site +1 if adjacant to each other
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_Campus_Arabia_HS', 'BBG_LOC_CAMPUS_ARABIA_HS', 'YIELD_SCIENCE', 1, 'DISTRICT_HOLY_SITE'),
    ('BBG_HS_Arabia_Campus', 'BBG_LOC_HS_ARABIA_CAMPUS', 'YIELD_FAITH', 1, 'DISTRICT_CAMPUS');
INSERT INTO District_Adjacencies(DistrictType, YieldChangeId) VALUES
    ('DISTRICT_CAMPUS', 'BBG_Campus_Arabia_HS'),
    ('DISTRICT_HOLY_SITE', 'BBG_HS_Arabia_Campus');
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId)
    SELECT TraitType, 'BBG_Campus_Arabia_HS' FROM CivilizationTraits WHERE CivilizationType != 'CIVILIZATION_ARABIA' GROUP BY CivilizationType;
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId)
    SELECT TraitType, 'BBG_HS_Arabia_Campus' FROM CivilizationTraits WHERE CivilizationType != 'CIVILIZATION_ARABIA' GROUP BY CivilizationType;