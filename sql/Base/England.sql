--==============================================================================================
--******				ENGLAND						   ******
--==============================================================================================

-- Sea Dog available at Exploration now
UPDATE Units SET PrereqCivic='CIVIC_EXPLORATION' WHERE UnitType='UNIT_ENGLISH_SEADOG';

-- 15/05/2021: redcoast ability to +5 (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='REDCOAT_FOREIGN_COMBAT' AND Name='Amount';

UPDATE District_GreatPersonPoints SET PointsPerTurn=1 WHERE DistrictType='DISTRICT_ROYAL_NAVY_DOCKYARD' AND GreatPersonClassType='GREAT_PERSON_CLASS_ADMIRAL';

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_PAX_BRITANNICA', 'BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD_GIVER');

INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
    ('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD_GIVER', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', NULL, NULL),
	('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD', 'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT', NULL, 'BUILDING_IS_LIGHTHOUSE');

INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
    ('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD_GIVER', 'ModifierId', 'BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD'),
	('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ADMIRAL'),
	('BBG_ADMIRAL_LIGHTHOUSE_DOCKYARD', 'Amount', '1');