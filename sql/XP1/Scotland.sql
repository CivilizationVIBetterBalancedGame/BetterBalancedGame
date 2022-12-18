-- Created by iElden

--==================
-- Scotland
--==================
-- Highlander gets +10 combat strength (defense)
UPDATE Units SET Combat=65, RangedCombat=70 WHERE UnitType='UNIT_SCOTTISH_HIGHLANDER';

-- Change Bannockburn to +1 movement for recon and civilian units
DELETE FROM TraitModifiers WHERE ModifierId in (
	'TRAIT_LIBERATION_WAR_PRODUCTION',
	'TRAIT_LIBERATION_WAR_MOVEMENT',
	'TRAIT_LIBERATION_WAR_PREREQ_OVERRIDE'
);

INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
	VALUES ('TRAIT_LEADER_BANNOCKBURN', 'RECON_AND_CIVILIAN_MOVEMENT_BONUS');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
	VALUES ('RECON_AND_CIVILIAN_MOVEMENT_BONUS', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('RECON_AND_CIVILIAN_MOVEMENT_BONUS', 'ModifierId', 'MODIFIER_RECON_AND_CIVILIAN_MOVEMENT_BONUS');

-- BBG_UNIT_ON_HILL_REQUIREMENTS is in _utils.sql
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	VALUES ('MODIFIER_RECON_AND_CIVILIAN_MOVEMENT_BONUS', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 'REQUIREMENTS_RECON_OR_CIVILIAN_UNIT', 'BBG_UNIT_ON_HILL_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('MODIFIER_RECON_AND_CIVILIAN_MOVEMENT_BONUS', 'Amount', '1');

INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('REQUIREMENTS_RECON_OR_CIVILIAN_UNIT', 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('REQUIREMENTS_RECON_OR_CIVILIAN_UNIT', 'REQUIRES_RECON_TAG');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('REQUIREMENTS_RECON_OR_CIVILIAN_UNIT', 'REQUIRES_CIVILIAN_TAG');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_RECON_TAG', 'REQUIREMENT_UNIT_TAG_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Type,  Value)
	VALUES ('REQUIRES_RECON_TAG', 'Tag', 'ARGTYPE_IDENTITY', 'CLASS_RECON');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_CIVILIAN_TAG', 'REQUIREMENT_UNIT_TAG_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Type,  Value)
	VALUES ('REQUIRES_CIVILIAN_TAG', 'Tag', 'ARGTYPE_IDENTITY', 'CLASS_LANDCIVILIAN');


--============================
-- Golf Course Related Changes
--============================

-- Golf Course moved to Games and Recreation
UPDATE Improvements SET PrereqCivic='CIVIC_GAMES_RECREATION' WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE';
-- Golf Course base yields are 1 Culture and 2 Gold... +1 to each if next to City Center
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE' AND YieldType='YIELD_CULTURE';
-- Golf Course extra housing moved to Urbanization
UPDATE RequirementArguments SET Value='CIVIC_URBANIZATION' WHERE RequirementId='REQUIRES_PLAYER_HAS_GLOBALIZATION' AND Name='CivicType';
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES ('BBG_GOLFCOURSE_CITYCENTERADJACENCY_GOLD', 'Placeholder', 'YIELD_GOLD', 1 , 1 , 'DISTRICT_CITY_CENTER');
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_GOLF_COURSE', 'BBG_GOLFCOURSE_CITYCENTERADJACENCY_GOLD');
-- Golf Course gets extra yields a bit earlier
INSERT OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('204', 'IMPROVEMENT_GOLF_COURSE', 'YIELD_GOLD', '1', 'CIVIC_THE_ENLIGHTENMENT');
INSERT OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('205', 'IMPROVEMENT_GOLF_COURSE', 'YIELD_CULTURE', '1', 'CIVIC_THE_ENLIGHTENMENT');
-- golf Course +1 amentity Base
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='GOLFCOURSE_AMENITIES' AND Name='Amount';
-- Golf Course +1 amentity if next to an entertainment complex
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_GOLF_COURSE_AMENITIES_ENTERTAINMENT_COMPLEX_MODIFIER', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY', 'BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GOLF_COURSE_AMENITIES_ENTERTAINMENT_COMPLEX_MODIFIER', 'Amount', '1');
INSERT OR IGNORE INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENTS', 'BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENT');
INSERT OR IGNORE INTO Requirements(RequirementId , RequirementType) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENT', 'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('BBG_NEXT_TO_ENTERTAINMENT_COMPLEX_REQUIREMENT', 'DistrictType', 'DISTRICT_ENTERTAINMENT_COMPLEX');
INSERT OR IGNORE INTO ImprovementModifiers(ImprovementType, ModifierId) VALUES
    ('IMPROVEMENT_GOLF_COURSE', 'BBG_GOLF_COURSE_AMENITIES_ENTERTAINMENT_COMPLEX_MODIFIER');
-- Golf Course +1 additional amentity once Guilds is unlocked 
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('GOLF_COURSE_AMENTITY_AT_GUILDS', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY', 'PLAYER_HAS_GUILDS_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('GOLF_COURSE_AMENTITY_AT_GUILDS', 'Amount', '1');
INSERT OR IGNORE INTO ImprovementModifiers(ImprovementType, ModifierId) VALUES
    ('IMPROVEMENT_GOLF_COURSE', 'GOLF_COURSE_AMENTITY_AT_GUILDS');
-- Firaxis bugfix: Golf course have 2 modifiers : GOLFCOURSE_AMENITIES and GOLFCOURSE_AMENITY.
DELETE FROM ImprovementModifiers WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE' AND ModifierId='GOLFCOURSE_AMENITY';