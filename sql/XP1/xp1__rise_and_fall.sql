







INSERT INTO Unit_BuildingPrereqs(Unit, PrereqBuilding, NumSupported) VALUES
	('UNIT_WARRIOR_MONK', 'BUILDING_KOTOKU_IN', '-1');

--5.1 Kotoku Allows Monk Buy SQL
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_CITY_HAS_KOTOKU', 'REQUIREMENT_CITY_HAS_BUILDING');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_CITY_HAS_KOTOKU', 'BuildingType','BUILDING_KOTOKU_IN');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_CITY_HAS_KOTOKU_REQSET', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_CITY_HAS_KOTOKU_REQSET', 'BBG_REQUIRES_CITY_HAS_KOTOKU');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_KOTOKU_ALLOW_MONK_BUY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 'BBG_CITY_HAS_KOTOKU_REQSET');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_KOTOKU_ALLOW_MONK_BUY', 'Tag', 'CLASS_WARRIOR_MONK');

INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
	('BUILDING_KOTOKU_IN', 'BBG_KOTOKU_ALLOW_MONK_BUY');


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
--******                RELIGION                          ******
--==============================================================
-- Monks: Cards
INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_FASCISM_ATTACK_BUFF', 'CLASS_WARRIOR_MONK'),
	('ABILITY_FASCISM_LEGACY_ATTACK_BUFF', 'CLASS_WARRIOR_MONK'),
	('ABILITY_TWILIGHT_VALOR_ATTACK_BONUS', 'CLASS_WARRIOR_MONK');

-- Monks: Matternhorn
INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_ALPINE_TRAINING', 'CLASS_WARRIOR_MONK');

	--==============================================================
--******				S  C  O  R  E				  	  ******
--==============================================================
-- no double counting for era points
UPDATE ScoringLineItems SET Multiplier=0 WHERE LineItemType='LINE_ITEM_ERA_SCORE';



--==============================================================
--******				START BIASES					  ******
--==============================================================
-- Add Ressource Bias
INSERT INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_CREE', 'RESOURCE_CATTLE', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_HORSES', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_SHEEP', '4'),
    ('CIVILIZATION_CREE', 'RESOURCE_DEER', '4');
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
--******			W O N D E R S  (MAN-MADE)			  ******
--==============================================================
-- Statue Liberty from 4 to 3 diplo points
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='STATUELIBERTY_DIPLOVP' AND Name='Amount';

-- scott research station can be built and works in tundra
INSERT OR IGNORE INTO Building_ValidTerrains (BuildingType, TerrainType) VALUES
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA'),
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA_HILLS');
UPDATE RequirementArguments SET Value='TERRAIN_TUNDRA' WHERE RequirementId='REQUIRES_CITY_HAS_5_SNOW' AND Name='TerrainType';
-- St. Basil gives 1 relic
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_ST_BASILS_CATHEDRAL', 'WONDER_GRANT_RELIC_BBG');

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



