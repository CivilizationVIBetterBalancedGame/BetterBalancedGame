------------------------------------------------------------------------------
--	FILE:	 new_bbg_england.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database Civilization related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				ENGLAND						   ******
--==============================================================================================

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