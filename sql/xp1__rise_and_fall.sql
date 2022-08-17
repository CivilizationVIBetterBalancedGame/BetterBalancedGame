--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Cree
--==================
--UPDATE UnitAbilityModifiers SET ModifierId='RANGER_IGNORE_FOREST_MOVEMENT_PENALTY' WHERE UnitAbilityType='ABILITY_CREE_OKIHTCITAW';

-- Add Ressource Bias
INSERT INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_CREE', 'RESOURCE_CATTLE', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_HORSES', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_SHEEP', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_DEER', '4');

--==================
-- Egypt
--==================
-- alpine training from matterhorn bugfix
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES ('ABILITY_ALPINE_TRAINING', 'CLASS_LIGHT_CHARIOT');


--==================
-- Georgia
--==================
-- Georgian Khevsur unit becomes sword replacement
-- 23/04/2021: Firaxis patch
--UPDATE Units SET Combat=35, Cost=100, Maintenance=2, PrereqTech='TECH_IRON_WORKING', StrategicResource='RESOURCE_IRON' WHERE UnitType='UNIT_GEORGIAN_KHEVSURETI';
--UPDATE ModifierArguments SET Value='5' WHERE ModifierId='KHEVSURETI_HILLS_BUFF' AND Name='Amount';
--INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
--	VALUES ('UNIT_GEORGIAN_KHEVSURETI', 'UNIT_SWORDSMAN');
-- Georgia Tsikhe changed to a stronger Ancient Wall replacement instead of a Renaissance Wall replacement
DELETE FROM BuildingPrereqs WHERE Building='BUILDING_TSIKHE';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_TSIKHE' AND ModifierId='TSIKHE_PREVENT_MELEE_ATTACK_OUTER_DEFENSES';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_TSIKHE' AND ModifierId='TSIKHE_PREVENT_BYPASS_OUTER_DEFENSE';
UPDATE BuildingReplaces SET ReplacesBuildingType='BUILDING_WALLS' WHERE CivUniqueBuildingType='BUILDING_TSIKHE';
UPDATE Buildings SET Cost=100, PrereqTech='TECH_MASONRY' , OuterDefenseHitPoints=100 WHERE BuildingType='BUILDING_TSIKHE';
-- Georgia gets 50% faith kills (online) instead of Protectorate War Bonus
UPDATE ModifierArguments SET Value='100' WHERE ModifierId='TRAIT_LEADER_FAITH_KILLS' AND Name='PercentDefeatedStrength';
-- Georgia gets +1 faith for every envoy
INSERT INTO TraitModifiers (TraitType , ModifierId) VALUES
	('TRAIT_LEADER_RELIGION_CITY_STATES' , 'BBG_GEORGIA_FAITH_PER_ENVOY');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_GEORGIA_FAITH_PER_ENVOY', 'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_USED_INFLUENCE_TOKEN');
INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
	('BBG_GEORGIA_FAITH_PER_ENVOY' , 'YieldType', 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
	('BBG_GEORGIA_FAITH_PER_ENVOY' , 'Amount', '1');

--==================
-- India (Chandra)
--==================
-- replace Territorial Expansion Declaration Bonus with +1 movement
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_ARTHASHASTRA';

INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_ARTHASHASTRA' , 'TRAIT_EXPANSION_MOVEMENT_BONUS_CPLMOD');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES ('TRAIT_EXPANSION_MOVEMENT_BONUS_CPLMOD' , 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_EXPANSION_MOVEMENT_BONUS_CPLMOD' , 'ModifierId', 'EXPANSION_MOVEMENT_BONUS_MODIFIER_CPLMOD');

INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , OwnerRequirementSetId)
	VALUES ('EXPANSION_MOVEMENT_BONUS_MODIFIER_CPLMOD' , 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT' , 'REQUIREMENTSET_LAND_MILITARY_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('EXPANSION_MOVEMENT_BONUS_MODIFIER_CPLMOD' , 'Amount' , '1');

INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('REQUIREMENTSET_LAND_MILITARY_CPLMOD' , 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('REQUIREMENTSET_LAND_MILITARY_CPLMOD' , 'REQUIREMENTS_LAND_MILITARY_CPLMOD');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('REQUIREMENTSET_LAND_MILITARY_CPLMOD' , 'REQUIRES_UNIT_IS_RELIGIOUS_ALL');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIREMENTS_LAND_MILITARY_CPLMOD', 'REQUIREMENT_UNIT_FORMATION_CLASS_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIREMENTS_LAND_MILITARY_CPLMOD' , 'UnitFormationClass' , 'FORMATION_CLASS_LAND_COMBAT');


--==================
-- Korea
--==================
-- Seowon gets +2 science base yield instead of 4, +1 for every 2 mines adjacent instead of 1 to 1
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='BaseDistrict_Science';
INSERT OR IGNORE INTO Adjacency_YieldChanges
	(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement)
	VALUES ('BBG_Mine_Science', 'LOC_DISTRICT_MINE_SCIENCE', 'YIELD_SCIENCE', 1, 2, 'IMPROVEMENT_MINE');
INSERT OR IGNORE INTO District_Adjacencies
	(DistrictType , YieldChangeId)
	VALUES ('DISTRICT_SEOWON', 'BBG_Mine_Science');
-- seowon gets +1 adjacency from theater squares instead of -1
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES
	('BBG_Theater_Science' , 'LOC_DISTRICT_SEOWON_THEATER_BONUS' , 'YIELD_SCIENCE' , '1' , '1' , 'DISTRICT_THEATER'),
	('BBG_Seowon_Culture'  , 'LOC_DISTRICT_THEATER_SEOWON_BONUS' , 'YIELD_CULTURE' , '1' , '1' , 'DISTRICT_SEOWON' );
INSERT OR IGNORE INTO District_Adjacencies (DistrictType , YieldChangeId)
	VALUES
	('DISTRICT_SEOWON'  , 'BBG_Theater_Science'),
	('DISTRICT_THEATER' , 'BBG_Seowon_Culture' );
-- Seowon bombs
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
	VALUES ('TRAIT_CIVILIZATION_THREE_KINGDOMS' , 'TRAIT_SEOWON_BOMB');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
	VALUES ('TRAIT_SEOWON_BOMB', 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('TRAIT_SEOWON_BOMB', 'DistrictType', 'DISTRICT_SEOWON');


--==================
-- Mapuche
--==================
-- Combat bonus against Golden Age Civs set to 5 instead of 10
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='TRAIT_TOQUI_COMBAT_BONUS_VS_GOLDEN_AGE_CIV';
-- Malon Raiders become Horseman replacement and territory bonus replaced with +1 movement
UPDATE Units SET Combat=36 , Cost=90 , Maintenance=2 , BaseMoves=5 , PrereqTech='TECH_HORSEBACK_RIDING' , MandatoryObsoleteTech='TECH_SYNTHETIC_MATERIALS' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 'UNIT_HORSEMAN');
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CAVALRY' WHERE Unit='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitAbilityModifiers WHERE ModifierId='MALON_RAIDER_TERRITORY_COMBAT_BONUS';
-- Chemamull Unique Improvement gets +1 Production (another at Civil Service Civic)
--INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType , YieldType , YieldChange)
--	VALUES ('IMPROVEMENT_CHEMAMULL' , 'YIELD_PRODUCTION' , 1);
--INSERT OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
--	VALUES ('203' , 'IMPROVEMENT_CHEMAMULL' , 'YIELD_PRODUCTION' , '1' , 'CIVIC_CIVIL_SERVICE');

-- 20/12/14 Chemamull's now allowed on volcanic soil
INSERT OR IGNORE INTO Improvement_ValidFeatures (ImprovementType, FeatureType)
	VALUES ('IMPROVEMENT_CHEMAMULL','FEATURE_VOLCANIC_SOIL');

--==================
-- Netherlands
--==================
UPDATE Improvements SET ValidAdjacentTerrainAmount=2 WHERE ImprovementType='IMPROVEMENT_POLDER';
UPDATE Units SET StrategicResource='RESOURCE_NITER' WHERE UnitType='UNIT_DE_ZEVEN_PROVINCIEN';


--=========
--Mongolia
--=========
-- 23/04/2021 : Fixed by Firaxis
--INSERT OR IGNORE INTO TypeTags VALUES ('ABILITY_GENGHIS_KHAN_CAVALRY_BONUS', 'CLASS_MONGOLIAN_KESHIG');
-- No longer receives +1 diplo visibility for trading post
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
DELETE FROM DiplomaticVisibilitySources WHERE VisibilitySourceType='SOURCE_TRADING_POST_TRAIT';
DELETE FROM DiplomaticVisibilitySources_XP1 WHERE VisibilitySourceType='SOURCE_TRADING_POST_TRAIT';
DELETE FROM ModifierArguments WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
DELETE FROM Modifiers WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
-- +100% production to Ordu
UPDATE Buildings SET Cost=60 WHERE BuildingType='BUILDING_ORDU';
-- Keshig
UPDATE Units SET RangedCombat=40, Cost=180 WHERE UnitType='UNIT_MONGOLIAN_KESHIG';


--==================
-- Scotland
--==================
-- Highlander gets +10 combat strength (defense)
UPDATE Units SET Combat=65, RangedCombat=70 WHERE UnitType='UNIT_SCOTTISH_HIGHLANDER';
-- Golf Course moved to Games and Recreation
-- UPDATE Improvements SET PrereqCivic='CIVIC_GAMES_RECREATION' WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE';
-- Golf Course base yields are 1 Culture and 2 Gold... +1 to each if next to City Center
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE' AND YieldType='YIELD_CULTURE';
-- Golf Course extra housing moved to Urbanization
UPDATE RequirementArguments SET Value='CIVIC_URBANIZATION' WHERE RequirementId='REQUIRES_PLAYER_HAS_GLOBALIZATION' AND Name='CivicType';
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES ('BBG_GOLFCOURSE_CITYCENTERADJACENCY_GOLD' , 'Placeholder' , 'YIELD_GOLD' , 1 , 1 , 'DISTRICT_CITY_CENTER');
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_GOLF_COURSE' , 'BBG_GOLFCOURSE_CITYCENTERADJACENCY_GOLD');
-- Golf Course gets extra yields a bit earlier
INSERT OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('204' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_GOLD' , '1' , 'CIVIC_THE_ENLIGHTENMENT');
INSERT OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('205' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_CULTURE' , '1' , 'CIVIC_THE_ENLIGHTENMENT');


--==================
-- Sumeria
--==================

-- alpine training from matterhorn bugfix
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES ('ABILITY_ALPINE_TRAINING', 'CLASS_WAR_CART');
-- REVERT TO BASE GAME
-- extra +3 envoys points per turn
--INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
--	VALUES ('SUMERIA_ENVOY_POINTS_FROM_MILITARY_ALLIANCE', 'Amount', '3');
--INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
--	VALUES ('SUMERIA_ENVOY_POINTS_FROM_MILITARY_ALLIANCE', 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN');
--INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
--	VALUES ('TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'SUMERIA_ENVOY_POINTS_FROM_MILITARY_ALLIANCE');


--==================
-- Zulu
--==================
-- impi come at stirrips like pikemen
-- UPDATE Units SET PrereqTech='TECH_STIRRUPS' WHERE UnitType='UNIT_ZULU_IMPI';
-- +1 culture and +1 gold for each encampment building
--INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
--	('ZULU_BARRACKS_CULTURE_BBG', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'),
--	('ZULU_BARRACKS_GOLD_BBG', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'),
--	('ZULU_STABLE_CULTURE_BBG',   'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'),
--	('ZULU_STABLE_GOLD_BBG',   'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'),
--	('ZULU_ARMORY_CULTURE_BBG',   'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'),
--	('ZULU_ARMORY_GOLD_BBG',   'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'),
--	('ZULU_ACADEMY_CULTURE_BBG',  'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'),
--	('ZULU_ACADEMY_GOLD_BBG',  'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE');
--INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
--	('ZULU_BARRACKS_CULTURE_BBG', 'BuildingType', 'BUILDING_BARRACKS'),
--	('ZULU_BARRACKS_CULTURE_BBG', 'YieldType', 'YIELD_CULTURE'),
--	('ZULU_BARRACKS_CULTURE_BBG', 'Amount', '1'),
--	('ZULU_BARRACKS_GOLD_BBG',    'BuildingType', 'BUILDING_BARRACKS'),
--	('ZULU_BARRACKS_GOLD_BBG',    'YieldType', 'YIELD_GOLD'),
--	('ZULU_BARRACKS_GOLD_BBG',    'Amount', '1'),
--	('ZULU_STABLE_CULTURE_BBG',   'BuildingType', 'BUILDING_STABLE'),
--	('ZULU_STABLE_CULTURE_BBG',   'YieldType', 'YIELD_CULTURE'),
--	('ZULU_STABLE_CULTURE_BBG',   'Amount', '1'),
--	('ZULU_STABLE_GOLD_BBG',      'BuildingType', 'BUILDING_STABLE'),
--	('ZULU_STABLE_GOLD_BBG',      'YieldType', 'YIELD_GOLD'),
--	('ZULU_STABLE_GOLD_BBG',      'Amount', '1'),
--	('ZULU_ARMORY_CULTURE_BBG',   'BuildingType', 'BUILDING_ARMORY'),
--	('ZULU_ARMORY_CULTURE_BBG',   'YieldType', 'YIELD_CULTURE'),
--	('ZULU_ARMORY_CULTURE_BBG',   'Amount', '1'),
--	('ZULU_ARMORY_GOLD_BBG',      'BuildingType', 'BUILDING_ARMORY'),
--	('ZULU_ARMORY_GOLD_BBG',      'YieldType', 'YIELD_GOLD'),
--	('ZULU_ARMORY_GOLD_BBG',      'Amount', '1'),
--	('ZULU_ACADEMY_CULTURE_BBG',  'BuildingType', 'BUILDING_MILITARY_ACADEMY'),
--	('ZULU_ACADEMY_CULTURE_BBG',  'YieldType', 'YIELD_CULTURE'),
--	('ZULU_ACADEMY_CULTURE_BBG',  'Amount', '1'),
--	('ZULU_ACADEMY_GOLD_BBG',     'BuildingType', 'BUILDING_MILITARY_ACADEMY'),
--	('ZULU_ACADEMY_GOLD_BBG',     'YieldType', 'YIELD_GOLD'),
--	('ZULU_ACADEMY_GOLD_BBG',     'Amount', '1');
--INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_BARRACKS_CULTURE_BBG'),
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_BARRACKS_GOLD_BBG'),
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_STABLE_CULTURE_BBG'),
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_STABLE_GOLD_BBG'),
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_ARMORY_CULTURE_BBG'),
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_ARMORY_GOLD_BBG'),
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_ACADEMY_CULTURE_BBG'),
--	('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'ZULU_ACADEMY_GOLD_BBG');
-- Zulu get corps/armies bonus at nationalism
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('PLAYER_HAS_NATIONALISM_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLAYER_HAS_NATIONALISM' , 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_PLAYER_HAS_NATIONALISM' , 'CivicType' , 'CIVIC_NATIONALISM');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('PLAYER_HAS_NATIONALISM_REQUIREMENTS' , 'REQUIRES_PLAYER_HAS_NATIONALISM');
--UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_NATIONALISM_REQUIREMENTS' WHERE ModifierId='TRAIT_LAND_CORPS_COMBAT_STRENGTH';
--UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_NATIONALISM_REQUIREMENTS' WHERE ModifierId='TRAIT_LAND_ARMIES_COMBAT_STRENGTH';



--==============================================================
--******			  	B U I L D I N G S	 		  	  ******
--==============================================================
UPDATE Building_YieldChanges SET YieldChange=2 WHERE BuildingType='BUILDING_ORDU';
UPDATE ModifierArguments SET Value='6' WHERE ModifierId='SHOPPING_MALL_TOURISM';



--==============================================================
--******			 	  CITY-STATES		 		  	  ******
--==============================================================
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_UNIQUE_INFLUENCE_ARMORY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_ARMORY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_UNIQUE_INFLUENCE_MILITARY_ACADEMY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_MILITARY_ACADEMY_IDENTITY_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='MINOR_CIV_PRESLAV_BARRACKS_STABLE_IDENTITY_BONUS';
UPDATE ModifierArguments SET Value='40' WHERE ModifierId='MINOR_CIV_PRESLAV_BARRACKS_STABLE_IDENTITY_BONUS' AND Name='Amount';




--==============================================================
--******			  D E D I C A T I O N S				  ******
--==============================================================
-- To Arms +10 vs cities
INSERT OR IGNORE INTO CommemorationModifiers (CommemorationType, ModifierId)
    VALUES ('COMMEMORATION_MILITARY', 'COMMEMORATION_MILITARY_GA_ATTACK_CITIES');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , OwnerRequirementSetId)
    VALUES ('COMMEMORATION_MILITARY_GA_ATTACK_CITIES' , 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY' , 'PLAYER_HAS_GOLDEN_AGE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_MILITARY_GA_ATTACK_CITIES' , 'AbilityType' , 'ABILITY_MILITARY_GA_BUFF');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('ABILITY_MILITARY_GA_BUFF', 'KIND_ABILITY');
INSERT OR IGNORE INTO TypeTags (Type, Tag) VALUES
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_MELEE'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_RANGED'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_RAIDER'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_CARRIER'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_RECON'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_MELEE'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_RANGED'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_SIEGE'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_HEAVY_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_LIGHT_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_RANGED_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_ANTI_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_HEAVY_CHARIOT'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_LIGHT_CHARIOT'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_WARRIOR_MONK'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_WAR_CART'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_AIRCRAFT'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_AIR_BOMBER'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_AIR_FIGHTER');
INSERT OR IGNORE INTO UnitAbilities (UnitAbilityType, Name, Description, Inactive) VALUES
	('ABILITY_MILITARY_GA_BUFF', 'LOC_ABILITY_MILITARY_GA_BUFF_NAME', 'LOC_ABILITY_MILITARY_GA_BUFF_DESCRIPTION', 1);
INSERT OR IGNORE INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
	('ABILITY_MILITARY_GA_BUFF', 'MOD_MILITARY_GA_BUFF');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('MOD_MILITARY_GA_BUFF', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'UNIT_ATTACKING_DISTRICT_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('MOD_MILITARY_GA_BUFF', 'Amount', '10');
INSERT OR IGNORE INTO ModifierStrings (ModifierId, Context, Text) VALUES
('MOD_MILITARY_GA_BUFF', 'Preview', 'LOC_MILITARY_GA_BUFF_DESCRIPTION');
-- Sic Hunt Dracones works on all new cities, not just diff continent
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADD_POPULATION', NewOnly=1, Permanent=1 WHERE ModifierId='COMMEMORATION_EXPLORATION_GA_NEW_CITY_POPULATION';
-- Monumentality discount reduced from 30% to 10%
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='COMMEMORATION_INFRASTRUCTURE_BUILDER_DISCOUNT_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='COMMEMORATION_INFRASTRUCTURE_SETTLER_DISCOUNT_MODIFIER' AND Name='Amount';
-- Pen and Brush gives +2 Culture and +1 Gold per District
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , OwnerRequirementSetId)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT' , 'PLAYER_HAS_GOLDEN_AGE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'YieldType' , 'YIELD_GOLD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'Amount' , '1');
INSERT OR IGNORE INTO CommemorationModifiers (CommemorationType, ModifierId)
	VALUES ('COMMEMORATION_CULTURAL', 'COMMEMORATION_CULTURAL_DISTRICTGOLD');
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='COMMEMORATION_CULTURAL_DISTRICTCULTURE' and Name='Amount';




--==============================================================
--******				G O V E R N M E N T				  ******
--==============================================================
-- revert for Firaxis patch (25/02/2021)
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='GOV_TALL_AMENITY_BUFF' AND Name='Amount';
-- audience chamber +1 gov title
-- UPDATE ModifierArguments SET Value='2' WHERE ModifierId='GOV_BUILDING_TALL_GRANT_GOVERNOR_POINTS' AND Name='Delta';
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
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES 
	('BUILDING_GOV_CONQUEST' , 'GOV_CONQUEST_PRODUCTION_BONUS'),
	('BUILDING_GOV_CONQUEST' , 'GOV_CONQUEST_REDUCED_MAINTENANCE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES 
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION'),
	('GOV_CONQUEST_REDUCED_MAINTENANCE' , 'MODIFIER_PLAYER_ADJUST_UNIT_MAINTENANCE_DISCOUNT'       );
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES 
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'Amount'   , '25'             ),
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'StartEra' , 'ERA_ANCIENT'    ),
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'EndEra'   , 'ERA_INFORMATION'),
	('GOV_CONQUEST_REDUCED_MAINTENANCE' , 'Amount'   , '1'              );
-- Foreign Ministry gets +2 influence per turn and 2 envoys
INSERT OR IGNORE INTO BuildingModifiers 
    (BuildingType            , ModifierId)
    VALUES 
    ('BUILDING_GOV_CITYSTATES' , 'GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'),
	('BUILDING_GOV_CITYSTATES' , 'FOREIGN_MINISTRY_ENVOYS');
INSERT OR IGNORE INTO Modifiers 
    (ModifierId                                 , ModifierType)
    VALUES 
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN'),
	('FOREIGN_MINISTRY_ENVOYS'					, 'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN');
INSERT OR IGNORE INTO ModifierArguments 
    (ModifierId                                 , Name                      , Value)
    VALUES 
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'Amount'                  , '2'),
	('FOREIGN_MINISTRY_ENVOYS'					, 'Amount'					, '2');



--==============================================================
--******				G O V E R N O R S				  ******
--==============================================================
-- Victor combat bonus reduced to +3
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS' AND Name='Amount';
-- Magnus' Surplus Logistics gives +2 production in addition to the food
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType) VALUES
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'Amount', '2'),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'Domestic', '1'),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS', 'SURPLUS_LOGISTICS_TRADE_ROUTE_PROD');
-- Magnus provision give 1 PM to Settler.
INSERT INTO Types(Type, Kind) VALUES
    ('BBG_SETTLER_MOUVMENT_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_SETTLER_MOUVMENT_ABILITY', 'CLASS_SETTLER');
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive) VALUES
    ('BBG_SETTLER_MOUVMENT_ABILITY', 'BBG_SETTLER_MOUVMENT_ABILITY_NAME', 'BBG_SETTLER_MOUVMENT_ABILITY_DESC', 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_SETTLER_MOUVMENT_ABILITY', 'BBG_SETTLER_MOUVMENT_ABILITY_MODIFIER');
INSERT INTO Modifiers(ModifierId, ModifierType, Permanent) VALUES
    ('BBG_GIVE_SETTLER_MOUVMENT_ABILITY', 'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS', 0),
    ('BBG_SETTLER_MOUVMENT_ABILITY_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 1);
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GIVE_SETTLER_MOUVMENT_ABILITY', 'AbilityType', 'BBG_SETTLER_MOUVMENT_ABILITY'),
    ('BBG_SETTLER_MOUVMENT_ABILITY_MODIFIER', 'Amount', '1');
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION', 'BBG_GIVE_SETTLER_MOUVMENT_ABILITY');
-- switch Magnus' level 2 promos
UPDATE GovernorPromotions SET 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';




--==============================================================
--******				PANTHEONS					  ******
--==============================================================
-- Lady of the Reeds and Marshes now applies ubsunur
INSERT OR IGNORE INTO RequirementSetRequirements 
    (RequirementSetId              , RequirementId)
    VALUES 
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'    );
INSERT OR IGNORE INTO Requirements 
    (RequirementId                          , RequirementType)
    VALUES 
    ('REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'     , 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments 
    (RequirementId                          , Name          , Value)
    VALUES 
    ('REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'     , 'FeatureType' , 'FEATURE_UBSUNUR_HOLLOW'       );




	--==============================================================
--******				S  C  O  R  E				  	  ******
--==============================================================
-- no double counting for era points
UPDATE ScoringLineItems SET Multiplier=0 WHERE LineItemType='LINE_ITEM_ERA_SCORE';



--==============================================================
--******				START BIASES					  ******
--==============================================================
-- UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_NETHERLANDS' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_MONGOLIA' AND ResourceType='RESOURCE_HORSES';
-- UPDATE StartBiasRivers SET Tier=3 WHERE CivilizationType='CIVILIZATION_NETHERLANDS';
INSERT INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_GEORGIA', 'RESOURCE_STONE', '4'),
    ('CIVILIZATION_GEORGIA', 'RESOURCE_MARBLE', '4'),
    ('CIVILIZATION_GEORGIA', 'RESOURCE_GYPSUM', '4');
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_GRASS_HILLS';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType IN ('TERRAIN_DESERT_HILLS', 'TERRAIN_TUNDRA_HILLS');
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_PLAINS_MOUNTAIN';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_GRASS_MOUNTAIN';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType IN ('TERRAIN_DESERT_MOUNTAIN', 'TERRAIN_TUNDRA_MOUNTAIN');



--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- scott research station can be built and works in tundra
INSERT OR IGNORE INTO Building_ValidTerrains (BuildingType, TerrainType) VALUES
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA'),
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA_HILLS');
UPDATE RequirementArguments SET Value='TERRAIN_TUNDRA' WHERE RequirementId='REQUIRES_CITY_HAS_5_SNOW' AND Name='TerrainType';
-- St. Basil gives 1 relic
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_ST_BASILS_CATHEDRAL', 'WONDER_GRANT_RELIC_BBG');
--Matterhorn +2 down from +3
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='ALPINE_TRAINING_COMBAT_HILLS' AND Name='Amount';



--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- Eye of the Sahara gets 2 Food, 2 Production, and 2 Science
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_PRODUCTION_ATOMIC' AND Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_SCIENCE_ATOMIC' AND Name='Amount';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
		VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_PRODUCTION';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_SCIENCE', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_SCIENCE';
-- lake retba
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_LAKE_RETBA', 'YIELD_FOOD', 2);

UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_FOOD';


--==============================================================
--******				    O T H E R					  ******
--==============================================================
-- Amani Abuse Fix... can immediately re-declare war when an enemy suzerian removes Amani
UPDATE GlobalParameters SET Value='1' WHERE Name='DIPLOMACY_PEACE_MIN_TURNS';

-- citizen yields
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType='DISTRICT_IKANDA';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' 		AND DistrictType='DISTRICT_SEOWON';

-- Offshore Oil can be improved at Plastics
UPDATE Improvements SET PrereqTech='TECH_PLASTICS' WHERE ImprovementType='IMPROVEMENT_OFFSHORE_OIL_RIG';



