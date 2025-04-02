-- Alfred Nobel grants one diplo point
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_GREATPERSON_1DIPLOPOINT', 'MODIFIER_PLAYER_ADJUST_DIPLOMATIC_VICTORY_POINTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_GREATPERSON_1DIPLOPOINT', 'Amount', '1');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALFRED_NOBEL', 'BBG_GREATPERSON_1DIPLOPOINT', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');

---- GREAT MERCHANTS
-- John Spilsbury
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='GREATPERSON_GRANT_TOYS' AND Name='Amount';

-- Jamsetji Tata
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GREATPERSON_CAMPUS_TOURISM' AND Name='Amount';

-- Masary Ibuka
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GREATPERSON_INDUSTRIAL_ZONE_TOURISM' AND Name='Amount';

-- Raja Toda Mal
UPDATE ModifierArguments SET Value='1.0' WHERE ModifierId='GREATPERSON_DOMESTIC_ROUTE_GOLD_PER_SPECIALTY_DISTRICT' AND Name='Amount';

-- Sarah Breedlove
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_SARAH_BREEDLOVE', 'GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');
    
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

--PLAYER_HAS_AT_LEAST_ONE_CITY_REQUIREMENTS was introduced in GS recreate
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQUIRES_PLAYER_HAS_AT_LEAST_ONE_CITY', 'REQUIREMENT_PLAYER_HAS_AT_LEAST_NUMBER_CITIES');
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQUIRES_PLAYER_HAS_AT_LEAST_ONE_CITY', 'Amount', 1);
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('PLAYER_HAS_AT_LEAST_ONE_CITY_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('PLAYER_HAS_AT_LEAST_ONE_CITY_REQUIREMENTS', 'REQUIRES_PLAYER_HAS_AT_LEAST_ONE_CITY');

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
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL' WHERE ModifierId='GREATPERSON_AETHELFLAED_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREATPERSON_AETHELFLAED_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_AETHELFLAED_ACTIVE', 'UnitType', 'UNIT_TREBUCHET'),
    ('GREATPERSON_AETHELFLAED_ACTIVE', 'Amount', '1'),
    ('GREATPERSON_AETHELFLAED_ACTIVE', 'AllowUniqueOverride', '1');
UPDATE GreatPersonIndividualActionModifiers SET AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionRequiresCompletedDistrictType=NULL WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionRequiresOwnedTile=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionRequiresNoMilitaryUnit=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
UPDATE GreatPersonIndividuals SET ActionEffectTileHighlighting=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED';

-- Nzinga gives 2 free envoys (instead of 1)
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='GREATPERSON_ANA_NZINGA_ACTIVE' AND Name='Amount';

-- Joan d'arc gives 2 relics (instead of 1)
-- UPDATE GreatPersonIndividuals SET ActionCharges=2 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JOAN_OF_ARC';
-- 24/07/24 now become the army general
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_ADJUST_MILITARY_FORMATION' WHERE ModifierId='GREATPERSON_JOAN_OF_ARC_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREATPERSON_JOAN_OF_ARC_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_JOAN_OF_ARC_ACTIVE', 'MilitaryFormationType', 'ARMY_MILITARY_FORMATION');
UPDATE GreatPersonIndividualActionModifiers SET AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_DOMAIN_MILITARY_IN_TILE' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JOAN_OF_ARC';
UPDATE GreatPersonIndividuals SET ActionRequiresPlayerRelicSlot=0, ActionRequiresMilitaryUnitDomain='DOMAIN_LAND', ActionRequiresUnitMilitaryFormation='STANDARD_MILITARY_FORMATION' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JOAN_OF_ARC';

-- 24/07/24 Napoleon grant 1 baloon
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE' WHERE ModifierId='GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE';
DELETE FROM ModifierArguments WHERE ModifierId='GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE', 'UnitType', 'UNIT_OBSERVATION_BALLOON'),
    ('GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE', 'Experience', '0'),
    ('GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE', 'UniqueOverride', '1');
UPDATE GreatPersonIndividualActionModifiers SET AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE';
UPDATE GreatPersonIndividuals SET ActionRequiresNoMilitaryUnit=1, ActionRequiresMilitaryUnitDomain=NULL, ActionRequiresUnitMilitaryFormation=NULL WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE';


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

--Alvaro Aalto add +2 gold per breathtaking tile in the city
--PLOT_BREATHTAKING_APPEAL doesn't exist recreate
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('PLOT_BREATHTAKING_APPEAL', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('PLOT_BREATHTAKING_APPEAL', 'REQUIRES_PLOT_BREATHTAKING_APPEAL');
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQUIRES_PLOT_BREATHTAKING_APPEAL', 'REQUIRES_PLOT_BREATHTAKING_APPEAL');
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQUIRES_PLOT_BREATHTAKING_APPEAL', 'MinimumAppeal', '4');

INSERT INTO Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 1, 'PLOT_BREATHTAKING_APPEAL');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'YieldType', 'YIELD_GOLD');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'Amount', '2');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO', 'GREAT_PERSON_INDIVIDUAL_ALVARO_AALTO_ACTIVE', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');

--16/04/23 exchange Rajendra and Drake bonus
UPDATE GreatPersonIndividualActionModifiers SET GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_RAJENDRA_CHOLA' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN';
UPDATE GreatPersonIndividualActionModifiers SET GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN' WHERE ModifierId='GREATPERSON_RAJENDRA_CHOLA_ACTIVE';

INSERT INTO Modifiers (ModifierId, ModifierType, Permanent) VALUES
    ('BBG_GREATPERSON_DRAKE_NAVAL_RANGED', 'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION', 1),
    ('BBG_GREATPERSON_DRAKE_NAVAL_RAIDER', 'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION', 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_GREATPERSON_DRAKE_NAVAL_RANGED', 'Amount', 25),
    ('BBG_GREATPERSON_DRAKE_NAVAL_RANGED', 'PromotionClass', 'PROMOTION_CLASS_NAVAL_RANGED'),
    ('BBG_GREATPERSON_DRAKE_NAVAL_RAIDER', 'Amount', 25),
    ('BBG_GREATPERSON_DRAKE_NAVAL_RAIDER', 'PromotionClass', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE', 'BBG_GREATPERSON_DRAKE_NAVAL_RANGED', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON'),
    ('GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE', 'BBG_GREATPERSON_DRAKE_NAVAL_RAIDER', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');

UPDATE GreatPersonIndividuals SET ActionRequiresVisibleLuxury=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN';
UPDATE GreatPersonIndividuals SET ActionEffectTileHighlighting=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN';
UPDATE GreatPersonIndividuals SET ActionRequiresVisibleLuxury=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_RAJENDRA_CHOLA';
UPDATE GreatPersonIndividuals SET ActionEffectTileHighlighting=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_RAJENDRA_CHOLA';

--10/03/2024 zhou dagan can be activated in hostile territory

UPDATE GreatPersonIndividuals SET ActionRequiresNonHostileTerritory=0 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN';

