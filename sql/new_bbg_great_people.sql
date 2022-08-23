-- Reduce Imhotep to 1 charge
UPDATE GreatPersonIndividuals SET ActionCharges=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP';

-- Fix Ibn Khaldun Bug
UPDATE ModifierArguments SET Value=4 WHERE Name='Amount' AND ModifierId IN
    ('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_SCIENCE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_CULTURE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_PRODUCTION',
    'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_GOLD', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_FAITH');
UPDATE ModifierArguments SET Value=8 WHERE Name='Amount' AND ModifierId IN
    ('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_SCIENCE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_CULTURE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_PRODUCTION',
    'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_GOLD', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_FAITH');

-- Alfred Nobel grants one diplo point
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_GREATPERSON_1DIPLOPOINT', 'MODIFIER_PLAYER_ADJUST_DIPLOMATIC_VICTORY_POINTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_GREATPERSON_1DIPLOPOINT', 'Amount', '1');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALFRED_NOBEL', 'BBG_GREATPERSON_1DIPLOPOINT', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');

-- 21/08/22 Margaret Mead buff (2000 culture/science)
UPDATE ModifierArguments SET Value='2000' WHERE ModifierId='GREAT_PERSON_GRANT_LOTSO_SCIENCE' AND Name='Amount';
UPDATE ModifierArguments SET Value='2000' WHERE ModifierId='GREAT_PERSON_GRANT_LOTSO_CULTURE' AND Name='Amount';

-- 21/08/22 Mendeleev also gives 50% bonus prod towards labs
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_GREATPERSON_LAB_BOOST', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_GREATPERSON_LAB_BOOST', 'BuildingType', 'BUILDING_RESEARCH_LAB'),
	('BBG_GREATPERSON_LAB_BOOST', 'Amount', '50');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV', 'BBG_GREATPERSON_LAB_BOOST', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');

--23/08/22 Turing also gives the tech if you already have eureka
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'TechType', 'TECH_COMPUTERS'),
	('BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'GrantTechIfBoosted', '1');
DELETE FROM GreatPersonIndividualActionModifiers WHERE ModifierId='GREATPERSON_COMPUTERSTECHBOOST' AND GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_ALAN_TURING';
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
	('GREAT_PERSON_INDIVIDUAL_ALAN_TURING', 'BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');

--23/08/22 Sinan give 1 housing and 1 amenity on city center (2 charges) instead of culture bomb on industrial zone
DELETE FROM GreatPersonIndividualActionModifiers WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN';
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN', 'GREATPERSON_CITY_HOUSING_SMALL', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
    ('GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN', 'GREATPERSON_CITY_AMENITIES_SMALL', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');
UPDATE GreatPersonIndividuals SET ActionCharges=2 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN';

-- Boudica gives Military Engineer (instead of convert barbarian units)
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL' WHERE ModifierId='GREATPERSON_BOUDICA_ACTIVE';
UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_AT_LEAST_ONE_CITY_REQUIREMENTS' WHERE ModifierId='GREATPERSON_BOUDICA_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREATPERSON_BOUDICA_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_BOUDICA_ACTIVE', 'UnitType', 'UNIT_MILITARY_ENGINEER'),
    ('GREATPERSON_BOUDICA_ACTIVE', 'Amount', '1');
UPDATE GreatPersonIndividuals SET ActionRequiresAdjacentBarbarianUnit=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_BOUDICA';
UPDATE GreatPersonIndividuals SET ActionEffectTileHighlighting=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_BOUDICA';
UPDATE GreatPersonIndividuals SET ActionRequiresNoMilitaryUnit=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_BOUDICA';

-- Aethelflaed gives trebuchet with experience (instead of +2 loyalty)
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE' WHERE ModifierId='GREATPERSON_AETHELFLAED_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREATPERSON_AETHELFLAED_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_AETHELFLAED_ACTIVE', 'UnitType', 'UNIT_TREBUCHET'),
    ('GREATPERSON_AETHELFLAED_ACTIVE', 'Experience', '-1'),
    ('GREATPERSON_AETHELFLAED_ACTIVE', 'UniqueOverride', '1');
UPDATE GreatPersonIndividualActionModifiers SET AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionRequiresCompletedDistrictType=NULL WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionRequiresOwnedTile=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionRequiresNoMilitaryUnit=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionEffectTileHighlighting=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';

-- Nzinga gives 2 free envoys (instead of 1)
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='GREATPERSON_ANA_NZINGA_ACTIVE' AND Name='Amount';

-- Joan d'arc gives 2 relics (instead of 1)
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='GREATPERSON_JOAN_OF_ARC_ACTIVE' AND Name='Amount';

-- Lakshmibai gives an helicopter with experience (instead of a cavalry)
UPDATE ModifierArguments SET Value='UNIT_HELICOPTER' WHERE ModifierId='GREATPERSON_RANI_LAKSHMIBAI_ACTIVE' AND Name='UnitType';
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI', 'GREATPERSON_GRANT_1_OIL_PER_TURN', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');

-- Tupac Amaru gives an infantry in each city (instead of a musket)
UPDATE ModifierArguments SET Value='UNIT_INFANTRY' WHERE ModifierId='GREAT_PERSON_INDIVIDUAL_TUPAC_AMARU_ACTIVE' AND Name='UnitType';

-- Eisenhower gives 15% production toward military units (instead of 5%)
UPDATE ModifierArguments SET Value='15' WHERE ModifierId='GREATPERSON_DWIGHT_EISENHOWER_ACTIVE' AND Name='Amount';

-- Jose de Sucre (aka Simon Bolivar) gives 2 oils per turn
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
    ('GREATPERSON_GRANT_2_OIL_PER_TURN', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_EXTRACTION', 1, 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_GRANT_2_OIL_PER_TURN', 'ResourceType', 'RESOURCE_OIL');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_GRANT_2_OIL_PER_TURN', 'Amount', '2');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR', 'GREATPERSON_GRANT_2_OIL_PER_TURN', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');

-- Jose de Sucre (aka Simon Bolivar) gives tank with experience (instead of +4 loyalty)
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE' WHERE ModifierId='GREATPERSON_SIMON_BOLIVAR_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREATPERSON_SIMON_BOLIVAR_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_SIMON_BOLIVAR_ACTIVE', 'UnitType', 'UNIT_TANK'),
    ('GREATPERSON_SIMON_BOLIVAR_ACTIVE', 'Experience', '-1'),
    ('GREATPERSON_SIMON_BOLIVAR_ACTIVE', 'UniqueOverride', '1');
UPDATE GreatPersonIndividualActionModifiers SET AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR';
UPDATE GreatPersonIndividuals SET ActionRequiresCompletedDistrictType=NULL WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR';
UPDATE GreatPersonIndividuals SET ActionRequiresOwnedTile=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR';
UPDATE GreatPersonIndividuals SET ActionRequiresNoMilitaryUnit=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR';
UPDATE GreatPersonIndividuals SET ActionEffectTileHighlighting=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR';

-- Douglas MacArthur gives 2 Uranium per turn (and keep the free promoted tank) (and remove 1 oil per turn)
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
    ('GREATPERSON_GRANT_2_URANIUM_PER_TURN', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_EXTRACTION', 1, 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_GRANT_2_URANIUM_PER_TURN', 'ResourceType', 'RESOURCE_URANIUM');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_GRANT_2_URANIUM_PER_TURN', 'Amount', '2');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_DOUGLAS_MACARTHUR', 'GREATPERSON_GRANT_2_URANIUM_PER_TURN', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');
DELETE FROM GreatPersonIndividualActionModifiers WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_DOUGLAS_MACARTHUR' AND ModifierId='GREATPERSON_GRANT_1_OIL_PER_TURN'; 

-- Sudirman gives 2 Aluminium per turn
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
    ('GREATPERSON_GRANT_2_ALUMINUM_PER_TURN', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_EXTRACTION', 1, 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_GRANT_2_ALUMINUM_PER_TURN', 'ResourceType', 'RESOURCE_ALUMINUM');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_GRANT_2_ALUMINUM_PER_TURN', 'Amount', '2');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_SUDIRMAN', 'GREATPERSON_GRANT_2_ALUMINUM_PER_TURN', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');

-- Sudirman gives fighter with experience (instead of +6 loyalty)
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE' WHERE ModifierId='GREATPERSON_SUDIRMAN_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREATPERSON_SUDIRMAN_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_SUDIRMAN_ACTIVE', 'UnitType', 'UNIT_FIGHTER'),
    ('GREATPERSON_SUDIRMAN_ACTIVE', 'Experience', '-1'),
    ('GREATPERSON_SUDIRMAN_ACTIVE', 'UniqueOverride', '1');
UPDATE GreatPersonIndividualActionModifiers SET AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SUDIRMAN';
UPDATE GreatPersonIndividuals SET ActionRequiresCompletedDistrictType=NULL WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SUDIRMAN';
UPDATE GreatPersonIndividuals SET ActionRequiresOwnedTile=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SUDIRMAN';
UPDATE GreatPersonIndividuals SET ActionRequiresNoMilitaryUnit=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SUDIRMAN';
UPDATE GreatPersonIndividuals SET ActionEffectTileHighlighting=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_SUDIRMAN';

-- Dandara gives the most advanced support unit (instead of a warrior monk with experience)
UPDATE Modifiers SET ModifierType='MODIFIER_SINGLE_CITY_GRANT_UNIT_BY_CLASS_IN_NEAREST_CITY' WHERE ModifierId='GREAT_PERSON_INDIVIDUAL_DANDARA_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREAT_PERSON_INDIVIDUAL_DANDARA_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREAT_PERSON_INDIVIDUAL_DANDARA_ACTIVE', 'UnitPromotionClassType', 'PROMOTION_CLASS_SUPPORT');
UPDATE GreatPersonIndividuals SET ActionCharges=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_DANDARA_';

--Alvaro Aalto add +2 gold per breathtaking tile in the city
INSERT INTO Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 1, 'PLOT_BREATHTAKING_APPEAL');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'YieldType', 'YIELD_GOLD');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'Amount', '2');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO', 'GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');
