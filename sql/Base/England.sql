--==============================================================================================
--******				ENGLAND						   ******
--==============================================================================================

-- Sea Dog available at Exploration now
UPDATE Units SET PrereqCivic='CIVIC_EXPLORATION' WHERE UnitType='UNIT_ENGLISH_SEADOG';

-- 15/05/2021: redcoast ability to +5 (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='REDCOAT_FOREIGN_COMBAT' AND Name='Amount';

UPDATE District_GreatPersonPoints SET PointsPerTurn=1 WHERE DistrictType='DISTRICT_ROYAL_NAVY_DOCKYARD' AND GreatPersonClassType='GREAT_PERSON_CLASS_ADMIRAL';

--Doesn't have lighthouse req, recreate
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
	('REQUIRES_CITY_HAS_LIGHTHOUSE', 'REQUIREMENT_CITY_HAS_BUILDING');
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('REQUIRES_CITY_HAS_LIGHTHOUSE', 'BuildingType', 'BUILDING_LIGHTHOUSE');
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BUILDING_IS_LIGHTHOUSE', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BUILDING_IS_LIGHTHOUSE', 'REQUIRES_CITY_HAS_LIGHTHOUSE');

INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
    ('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD_GIVER', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', NULL, NULL),
	('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD', 'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT', NULL, 'BUILDING_IS_LIGHTHOUSE');

INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
    ('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD_GIVER', 'ModifierId', 'BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD'),
	('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ADMIRAL'),
	('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD', 'Amount', '1');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_PAX_BRITANNICA', 'BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD_GIVER');


-- 04/07/24 England rework
-- Production towards IZ building deleted from England (moved to Victoria AoS)
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_ADJUST_INDUSTRIAL_ZONE_BUILDINGS_PRODUCTION';

-- 04/07/24 Seadogs nerfed to 53CS (from 55)
UPDATE Units SET RangedCombat=53 WHERE UnitType='UNIT_ENGLISH_SEADOG';


