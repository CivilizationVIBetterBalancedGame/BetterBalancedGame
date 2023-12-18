--==============================================================
--******			  	B U I L D I N G S	 		  	  ******
--==============================================================
-- 12/06/23 from 6 to 20
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='SHOPPING_MALL_TOURISM';
-- 12/06/23 gold from 2/2 to 10/10
UPDATE Building_YieldChanges SET YieldChange=10 WHERE BuildingType='BUILDING_SHOPPING_MALL';
UPDATE Building_YieldChangesBonusWithPower SET YieldChange=10 WHERE BuildingType='BUILDING_SHOPPING_MALL';

-- Grandmaster Chapel only faith buy in owned city. (XP1)
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_WAS_FOUNDED', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_WAS_FOUNDED', 'REQUIRES_CITY_WAS_FOUNDED');
UPDATE Modifiers SET SubjectRequirementSetId='BBG_CITY_WAS_FOUNDED' WHERE ModifierId LIKE 'GOV_FAITH_PURCHASE_%';

-- 04/10/22: intel agency buff
UPDATE ModifierArguments SET Value=2 WHERE ModifierId='GOV_GRANT_SPY' AND Name='Amount';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_INTEL_AGENCY_SPY_PROD_BONUS', 'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_INTEL_AGENCY_SPY_PROD_BONUS', 'UnitType', 'UNIT_SPY'),
	('BBG_INTEL_AGENCY_SPY_PROD_BONUS', 'Amount', '50');
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_GOV_SPIES', 'BBG_INTEL_AGENCY_SPY_PROD_BONUS');

-- revert for Firaxis patch (25/02/2021)
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='GOV_TALL_AMENITY_BUFF' AND Name='Amount';
-- Audience Hall gets +3 Food and +3 Housing instead of +4 Housing
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_GOV_TALL' , 'GOV_TALL_FOOD_BUFF');
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GOV_TALL_HOUSING_BUFF';
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE' , 'CITY_HAS_GOVERNOR_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'YieldType' , 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'Amount' , '2');

--Warlord's Throne gives +25% production to naval and land military units... also reduces unit maintenance by 1
DELETE FROM BuildingModifiers WHERE ModifierId='GOV_PRODUCTION_BOOST_FROM_CAPTURE';
DELETE FROM ModifierArguments WHERE ModifierId='GOV_PRODUCTION_BOOST_FROM_CAPTURE';
DELETE FROM Modifiers WHERE ModifierId='GOV_PRODUCTION_BOOST_FROM_CAPTURE';
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId) VALUES 
	('BUILDING_GOV_CONQUEST' , 'GOV_CONQUEST_PRODUCTION_BONUS'),
	('BUILDING_GOV_CONQUEST' , 'GOV_CONQUEST_REDUCED_MAINTENANCE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType) VALUES 
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION'),
	('GOV_CONQUEST_REDUCED_MAINTENANCE' , 'MODIFIER_PLAYER_ADJUST_UNIT_MAINTENANCE_DISCOUNT'       );
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value) VALUES 
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'Amount'   , '25'             ),
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'StartEra' , 'ERA_ANCIENT'    ),
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'EndEra'   , 'ERA_INFORMATION'),
	('GOV_CONQUEST_REDUCED_MAINTENANCE' , 'Amount'   , '1'              );
-- Warlord's Throne extra resource stockpile
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_GOV_CONQUEST', 'BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
	VALUES ('BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE', 'MODIFIER_PLAYER_ADJUST_RESOURCE_STOCKPILE_CAP');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE', 'Amount', '30');
--Warlord's Throne +2 revealed strategics/turn (abstract, robust to reveal tech change in Resources Table)
--Creating Modifiers
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_'||REPLACE(Resources.ResourceType, 'RESOURCE_','')||'_CPLMOD'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER', 'ResourceType', Resources.ResourceType
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER', 'Amount', 2
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
--Attaching Modifiers to Warlor's Throne
INSERT INTO BuildingModifiers(BuildingType, ModifierId)
	SELECT 'BUILDING_GOV_CONQUEST', 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';


-- Foreign Ministry gets +2 influence per turn and 2 envoys
INSERT OR IGNORE INTO BuildingModifiers(BuildingType, ModifierId) VALUES 
    ('BUILDING_GOV_CITYSTATES' , 'GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'),
	('BUILDING_GOV_CITYSTATES' , 'FOREIGN_MINISTRY_ENVOYS');
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType) VALUES 
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN'),
	('FOREIGN_MINISTRY_ENVOYS'					, 'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN');
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'Amount'                  , '2'),
	('FOREIGN_MINISTRY_ENVOYS'					, 'Amount'					, '2');
