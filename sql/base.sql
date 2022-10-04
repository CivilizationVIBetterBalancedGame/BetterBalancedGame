--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================


--==============================================================
--******				B U I L D I N G S			  	  ******
--==============================================================
UPDATE Building_YieldChanges SET YieldChange=2 WHERE BuildingType='BUILDING_BARRACKS';
UPDATE Building_YieldChanges SET YieldChange=2 WHERE BuildingType='BUILDING_STABLE';
UPDATE Building_YieldChanges SET YieldChange=2 WHERE BuildingType='BUILDING_BASILIKOI_PAIDES';
UPDATE Building_GreatPersonPoints SET PointsPerTurn=2 WHERE BuildingType='BUILDING_ARMORY';
UPDATE Building_GreatPersonPoints SET PointsPerTurn=2 WHERE BuildingType='BUILDING_MILITARY_ACADEMY';
UPDATE Building_GreatPersonPoints SET PointsPerTurn=3 WHERE BuildingType='BUILDING_SEAPORT';



--==============================================================
--******			  C I T Y - S T A T E S				  ******
--==============================================================
-- nan-modal culture per district no longer applies to city center or wonders
INSERT OR IGNORE INTO Requirements ( RequirementId, RequirementType, Inverse )
	VALUES
		( 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
		( 'REQUIRES_DISTRICT_IS_NOT_AQUEDUCT_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
		( 'REQUIRES_DISTRICT_IS_NOT_CANAL_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
		( 'REQUIRES_DISTRICT_IS_NOT_DAM_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
		( 'REQUIRES_DISTRICT_IS_NOT_NEIGHBORHOOD_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
		( 'REQUIRES_DISTRICT_IS_NOT_SPACEPORT_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 ),
		( 'REQUIRES_DISTRICT_IS_NOT_WORLD_WONDER_BBG', 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', 1 );
INSERT OR IGNORE INTO RequirementArguments ( RequirementId, Name, Value )
	VALUES
		( 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG', 'DistrictType', 'DISTRICT_CITY_CENTER' ),
		( 'REQUIRES_DISTRICT_IS_NOT_AQUEDUCT_BBG', 'DistrictType', 'DISTRICT_AQUEDUCT' ),
		( 'REQUIRES_DISTRICT_IS_NOT_CANAL_BBG', 'DistrictType', 'DISTRICT_CANAL' ),
		( 'REQUIRES_DISTRICT_IS_NOT_DAM_BBG', 'DistrictType', 'DISTRICT_DAM' ),
		( 'REQUIRES_DISTRICT_IS_NOT_NEIGHBORHOOD_BBG', 'DistrictType', 'DISTRICT_NEIGHBORHOOD' ),
		( 'REQUIRES_DISTRICT_IS_NOT_SPACEPORT_BBG', 'DistrictType', 'DISTRICT_SPACEPORT' ),
		( 'REQUIRES_DISTRICT_IS_NOT_WORLD_WONDER_BBG', 'DistrictType', 'DISTRICT_WONDER' );
INSERT OR IGNORE INTO RequirementSets ( RequirementSetId, RequirementSetType )
	VALUES ( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIREMENTSET_TEST_ALL' );
INSERT OR IGNORE INTO RequirementSetRequirements ( RequirementSetId, RequirementId )
	VALUES
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_PLOT_IS_ADJACENT_TO_COAST' ),
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER_BBG' ),
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_AQUEDUCT_BBG' ),
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_CANAL_BBG' ),
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_DAM_BBG' ),
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_NEIGHBORHOOD_BBG' ),
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_SPACEPORT_BBG' ),
		( 'SPECIAL_DISTRICT_ON_COAST_BBG', 'REQUIRES_DISTRICT_IS_NOT_WORLD_WONDER_BBG' );
UPDATE Modifiers SET SubjectRequirementSetId='SPECIAL_DISTRICT_ON_COAST_BBG' WHERE ModifierId='MINOR_CIV_NAN_MADOL_DISTRICTS_CULTURE_BONUS';


--==================
-- America
--==================
-- Film Studios tourism bonus reduced from 100% to 50%
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='FILMSTUDIO_ENHANCEDLATETOURISM' AND Name='Modifier';
-- American Rough Riders will now be a cav replacement
-- UPDATE Units SET Combat=62, Cost=340, PromotionClass='PROMOTION_CLASS_LIGHT_CAVALRY', PrereqTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_AMERICAN_ROUGH_RIDER';
-- UPDATE UnitUpgrades SET UpgradeUnit='UNIT_HELICOPTER' WHERE Unit='UNIT_AMERICAN_ROUGH_RIDER';
-- INSERT OR IGNORE INTO UnitReplaces VALUES ('UNIT_AMERICAN_ROUGH_RIDER' , 'UNIT_CAVALRY');
-- UPDATE ModifierArguments SET Value='5' WHERE ModifierId='ROUGH_RIDER_BONUS_ON_HILLS';
-- Continent combat bonus: +5 attack on foreign continent, +5 defense on home continent
-- INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
-- 	('TRAIT_COMBAT_BONUS_FOREIGN_CONTINENT_BBG',    'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 'UNIT_IS_DOMAIN_LAND'),
-- 	('COMBAT_BONUS_FOREIGN_CONTINENT_MODIFIER_BBG', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'REQUIREMENTS_UNIT_ON_FOREIGN_CONTINENT_BBG');
-- INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
-- 	('TRAIT_COMBAT_BONUS_FOREIGN_CONTINENT_BBG', 'ModifierId', 'COMBAT_BONUS_FOREIGN_CONTINENT_MODIFIER_BBG'),
-- 	('COMBAT_BONUS_FOREIGN_CONTINENT_MODIFIER_BBG', 'Amount', '5');
-- INSERT OR IGNORE INTO ModifierStrings (ModifierId, Context, Text) VALUES
-- 	('COMBAT_BONUS_FOREIGN_CONTINENT_MODIFIER_BBG', 'Preview', 'LOC_PROMOTION_COMBAT_FOREIGN_CONTINENT_DESCRIPTION');
-- INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
-- 	('TRAIT_LEADER_ROOSEVELT_COROLLARY', 'TRAIT_COMBAT_BONUS_FOREIGN_CONTINENT_BBG');
-- INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
-- 	('REQUIREMENTS_UNIT_ON_HOME_CONTINENT',    'PLAYER_IS_DEFENDER_REQUIREMENTS'),
-- 	('REQUIREMENTS_UNIT_ON_FOREIGN_CONTINENT_BBG', 'PLAYER_IS_ATTACKER_REQUIREMENTS'),
-- 	('REQUIREMENTS_UNIT_ON_FOREIGN_CONTINENT_BBG', 'REQUIRES_UNIT_ON_FOREIGN_CONTINENT_BBG');
-- INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
-- 	('REQUIREMENTS_UNIT_ON_FOREIGN_CONTINENT_BBG', 'REQUIREMENTSET_TEST_ALL');
-- INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
-- 	('REQUIRES_UNIT_ON_FOREIGN_CONTINENT_BBG', 'REQUIREMENT_UNIT_ON_HOME_CONTINENT', 1);

-- Rough Rider ability to +5 (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='ROUGH_RIDER_BONUS_ON_HILLS' AND Name='Amount';
UPDATE Units SET Combat=64 WHERE UnitType='UNIT_AMERICAN_ROUGH_RIDER';

--==================
-- Arabia
--==================
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

--==================
-- China
--==================
-- great wall gets +1 prod, no initial gold, lowered gold and lowered culture per adj after castles
INSERT OR IGNORE INTO Improvement_YieldChanges VALUES ('IMPROVEMENT_GREAT_WALL', 'YIELD_PRODUCTION', 1);
UPDATE Improvement_YieldChanges SET YieldChange=0 WHERE ImprovementType='IMPROVEMENT_GREAT_WALL' AND YieldType='YIELD_GOLD';
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='GreatWall_Culture';
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='GreatWall_Gold';
-- Crouching Tiger now a crossbowman replacement that gets +7 when adjacent to an enemy unit
INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_CHINESE_CROUCHING_TIGER' , 'UNIT_CROSSBOWMAN');
UPDATE Units SET Cost=190 , RangedCombat=40 , Range=2 WHERE UnitType='UNIT_CHINESE_CROUCHING_TIGER';

INSERT OR IGNORE INTO Tags (Tag , Vocabulary)
	VALUES ('CLASS_CROUCHING_TIGER' , 'ABILITY_CLASS');
INSERT OR IGNORE INTO TypeTags (Type , Tag)
	VALUES ('UNIT_CHINESE_CROUCHING_TIGER' , 'CLASS_CROUCHING_TIGER');
INSERT OR IGNORE INTO Types (Type , Kind)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'KIND_ABILITY');
INSERT OR IGNORE INTO TypeTags (Type , Tag)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'CLASS_CROUCHING_TIGER');
INSERT OR IGNORE INTO UnitAbilities (UnitAbilityType , Name , Description)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'LOC_ABILITY_TIGER_ADJACENCY_NAME' , 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');
INSERT OR IGNORE INTO UnitAbilityModifiers (UnitAbilityType , ModifierId)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'TIGER_ADJACENCY_DAMAGE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('TIGER_ADJACENCY_DAMAGE' , 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH' , 'TIGER_ADJACENCY_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TIGER_ADJACENCY_DAMAGE', 'Amount' , '7'); 
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'PLAYER_IS_ATTACKER_REQUIREMENTS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'ADJACENT_UNIT_REQUIREMENT');
INSERT OR IGNORE INTO ModifierStrings (ModifierId , Context , Text)
    VALUES ('TIGER_ADJACENCY_DAMAGE' , 'Preview' , 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');

--==================
-- Egypt
--==================
-- wonder and district on rivers bonus increased to 25%
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_WONDER';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_DISTRICT';
--
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIRES_PLOT_HAS_FLOODPLAINS');
-- Sphinx base Faith Increased to 2 (from 1)
UPDATE Improvement_YieldChanges SET YieldChange=2 WHERE ImprovementType='IMPROVEMENT_SPHINX' AND YieldType='YIELD_FAITH';
-- +1 Faith and +1 Culture if adjacent to a wonder, instead of 2 Faith.
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='SPHINX_WONDERADJACENCY_FAITH' AND Name='Amount';
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' , 'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'YieldType' , 'YIELD_CULTURE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'Amount' , 1);
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_WONDERADJACENCY_CULTURE_CPLMOD');
-- Increased +1 Culture moved to Diplomatic Service (Was Natural History)
UPDATE Improvement_BonusYieldChanges SET PrereqCivic = 'CIVIC_DIPLOMATIC_SERVICE' WHERE Id = 18;
-- Now grants 1 food and 1 production on desert tiles without floodplains. Go Go Gadget bad-start fixer.
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_FOOD_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_FOOD_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_PRODUCTION_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER');
-- No prod nor food bonus on Floodplains
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
-- Requires Desert or Desert Hills
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');

--14/07/2022: Egypt 6 golds per international traderoutes instead of 4
UPDATE ModifierArguments SET Value='6' WHERE ModifierId='TRAIT_INTERNATIONAL_TRADE_GAIN_GOLD' AND Name='Amount';

--==================
-- England
--==================
-- Sea Dog available at Exploration now
UPDATE Units SET PrereqCivic='CIVIC_EXPLORATION' WHERE UnitType='UNIT_ENGLISH_SEADOG';

-- 15/05/2021: redcoast ability to +5 (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='REDCOAT_FOREIGN_COMBAT' AND Name='Amount';

--==================
-- France
--==================
-- move spies buffs to france and off catherine for eleanor france buff
UPDATE TraitModifiers SET TraitType='TRAIT_CIVILIZATION_WONDER_TOURISM' WHERE TraitType='FLYING_SQUADRON_TRAIT' AND ModifierId='UNIQUE_LEADER_ADD_SPY_CAPACITY';
UPDATE TraitModifiers SET TraitType='TRAIT_CIVILIZATION_WONDER_TOURISM' WHERE TraitType='FLYING_SQUADRON_TRAIT' AND ModifierId='UNIQUE_LEADER_ADD_SPY_UNIT';
UPDATE TraitModifiers SET TraitType='TRAIT_CIVILIZATION_WONDER_TOURISM' WHERE TraitType='FLYING_SQUADRON_TRAIT' AND ModifierId='UNIQUE_LEADER_SPIES_START_PROMOTED';
-- Reduce tourism bonus for wonders
UPDATE ModifierArguments SET Value='150' WHERE ModifierId='TRAIT_WONDER_DOUBLETOURISM' AND Name='ScalingFactor';
-- Chateau now gives 1 housing at Feudalism, and ajacent luxes now give stacking Culture in addition to stacking gold
INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType , YieldType , YieldChange) VALUES
    ('IMPROVEMENT_CHATEAU' , 'YIELD_FOOD' , '1');
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType , YieldChangeId) VALUES
    ('IMPROVEMENT_CHATEAU' , 'BBG_Chateau_Luxury_Gold'),
	('IMPROVEMENT_CHATEAU' , 'BBG_Chateau_Luxury_Culture');
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentResourceClass) VALUES
	('BBG_Chateau_Luxury_Gold' , 'Placeholder' , 'YIELD_GOLD' , '1' , '1' , 'RESOURCECLASS_LUXURY'),
	('BBG_Chateau_Luxury_Culture' , 'Placeholder' , 'YIELD_CULTURE' , '1' , '1' , 'RESOURCECLASS_LUXURY');
UPDATE Improvements SET Housing=2, TilesRequired=2, PreReqCivic='CIVIC_FEUDALISM', RequiresAdjacentBonusOrLuxury=0, RequiresRiver=0, SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_CHATEAU';-- Garde imperial to +5 on continent (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='GARDE_CONTINENT_COMBAT' AND Name='Amount';

--==================
-- Germany
--==================
-- Extra district comes at Guilds
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('PLAYER_HAS_GUILDS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLAYER_HAS_GUILDS' , 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_PLAYER_HAS_GUILDS' , 'CivicType' , 'CIVIC_GUILDS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('PLAYER_HAS_GUILDS_REQUIREMENTS' , 'REQUIRES_PLAYER_HAS_GUILDS');
UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_GUILDS_REQUIREMENTS' WHERE ModifierId='TRAIT_EXTRA_DISTRICT_EACH_CITY';

-- Update Start Bias
UPDATE StartBiasRivers SET Tier=3 WHERE CivilizationType='CIVILIZATION_GERMANY';

--==================
-- Greece
--==================
-- Pericles gets their extra envoy at amphitheater instead of acropolis
DELETE FROM DistrictModifiers WHERE DistrictType='DISTRICT_ACROPOLIS';
INSERT OR IGNORE INTO TraitModifiers
	VALUES ('TRAIT_LEADER_SURROUNDED_BY_GLORY' , 'AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('BUILDING_IS_AMPHITHEATER_CPLMOD', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('BUILDING_IS_AMPHITHEATER_CPLMOD', 'REQUIRES_CITY_HAS_AMPHITHEATER_CPLMOD');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
	VALUES ('REQUIRES_CITY_HAS_AMPHITHEATER_CPLMOD', 'REQUIREMENT_CITY_HAS_BUILDING');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
	VALUES ('REQUIRES_CITY_HAS_AMPHITHEATER_CPLMOD', 'BuildingType', 'BUILDING_AMPHITHEATER');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN' , 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'BUILDING_IS_AMPHITHEATER_CPLMOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN' , 'ModifierId' , 'AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN_MOD');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN_MOD' , 'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN_MOD' , 'Amount' , '1');
--Wildcard delayed to Political Philosophy
UPDATE Modifiers SET OwnerRequirementSetId='PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD' WHERE ModifierId='TRAIT_WILDCARD_GOVERNMENT_SLOT';
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
	VALUES ('REQUIRES_PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
	VALUES ('REQUIRES_PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'CivicType', 'CIVIC_POLITICAL_PHILOSOPHY');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'REQUIRES_PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'REQUIREMENTSET_TEST_ALL');

--==================
-- Greece (Gorgo)
--==================

-- 27/03/2021 Give Gorgo 50% culture online speed
UPDATE ModifierArguments SET Value=100 WHERE ModifierId='UNIQUE_LEADER_CULTURE_KILLS' AND Name='PercentDefeatedStrength';

--==================
-- India
--==================
-- Stepwell Unique Improvement gets +1 base Faith and +1 Food moved from Professional Sports to Feudalism
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_STEPWELL' AND YieldType='YIELD_FAITH'; 
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_FEUDALISM' WHERE Id='20';
-- Stepwells get +1 food per adajacent farm
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement)
	VALUES ('BBG_STEPWELL_FOOD', 'Placeholder', 'YIELD_FOOD', 1, 1, 'IMPROVEMENT_FARM');
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType, YieldChangeId)
	VALUES ('IMPROVEMENT_STEPWELL', 'BBG_STEPWELL_FOOD');
DELETE FROM ImprovementModifiers WHERE ModifierId='STEPWELL_FARMADJACENCY_FOOD';


--==================
-- India (Gandhi)
--==================
-- Extra belief when founding a Religion
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES ('EXTRA_BELIEF_MODIFIER', 'MODIFIER_PLAYER_ADD_BELIEF', 'HAS_A_RELIGION_BBG');
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
    VALUES ('TRAIT_LEADER_SATYAGRAHA', 'EXTRA_BELIEF_MODIFIER');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('HAS_A_RELIGION_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('HAS_A_RELIGION_BBG', 'REQUIRES_FOUNDED_RELIGION_BBG');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType, Inverse)
	VALUES ('REQUIRES_FOUNDED_RELIGION_BBG', 'REQUIREMENT_FOUNDED_NO_RELIGION', 1);
-- +1 movement to builders
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_SATYAGRAHA' , 'GANDHI_FAST_BUILDERS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GANDHI_FAST_BUILDERS' , 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT' , 'UNIT_IS_BUILDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GANDHI_FAST_BUILDERS' , 'Amount' , '1');
-- +1 movement to settlers
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_SATYAGRAHA' , 'GANDHI_FAST_SETTLERS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GANDHI_FAST_SETTLERS' , 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT' , 'UNIT_IS_SETTLER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GANDHI_FAST_SETTLERS' , 'Amount' , '1');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('UNIT_IS_SETTLER' , 'REQUIREMENT_UNIT_IS_SETTLER');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('UNIT_IS_SETTLER' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIREMENT_UNIT_IS_SETTLER' , 'REQUIREMENT_UNIT_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIREMENT_UNIT_IS_SETTLER' , 'UnitType' , 'UNIT_SETTLER');


--==================
-- Japan
--==================
-- Commercial Hubs no longer get adjacency from rivers
INSERT OR IGNORE INTO ExcludedAdjacencies (TraitType , YieldChangeId)
    VALUES
    ('TRAIT_CIVILIZATION_ADJACENT_DISTRICTS' , 'River_Gold');
-- Samurai come at Feudalism now
-- Implemented by Firaxis
-- UPDATE Units SET PrereqCivic='CIVIC_FEUDALISM' , PrereqTech=NULL WHERE UnitType='UNIT_JAPANESE_SAMURAI';


--==================
-- Kongo
--==================
-- +100% prod towards archealogists
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_CIVILIZATION_NKISI', 'TRAIT_ARCHAEOLOGIST_PROD_BBG');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
	('TRAIT_ARCHAEOLOGIST_PROD_BBG', 'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('TRAIT_ARCHAEOLOGIST_PROD_BBG', 'UnitType', 'UNIT_ARCHAEOLOGIST'),
	('TRAIT_ARCHAEOLOGIST_PROD_BBG', 'Amount', '100');

-- Kongo Military Unit get forest and jungle free move. Ngao move on hill but don't get general move.
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_MILITARY_UNITS_IGNORE_WOODS', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_MILITARY_UNITS_IGNORE_WOODS', 'AbilityType', 'BBG_IGNORE_WOODS_ABILITY');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_MILITARY_UNITS_IGNORE_WOODS');

INSERT INTO Types(Type, Kind) VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'KIND_ABILITY');

INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_RECON'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_MELEE'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_RANGED'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_ANTI_CAVALRY'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_LIGHT_CAVALRY'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_HEAVY_CAVALRY'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_SIEGE');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive, ShowFloatTextWhenEarned, Permanent)  VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'LOC_BBG_IGNORE_WOODS_ABILITY_NAME', 'LOC_BBG_IGNORE_WOODS_ABILITY_DESCRIPTION', 1, 0, 1);

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'RANGER_IGNORE_FOREST_MOVEMENT_PENALTY');

-- NGao 3PM
UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_KONGO_SHIELD_BEARER';

-- Grant relic on each gov plaza building.
INSERT INTO Modifiers(ModifierId, ModifierType, RunOnce, Permanent, OwnerRequirementSetId) VALUES
    ('BBG_KONGO_RELIC_GOVBUILDING_TALL', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_TALL_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_WIDE', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_WIDE_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_CONQUEST', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_CONQUEST_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_FAITH', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_FAITH_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_CITYSTATES', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_CITYSTATES_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_SPIES', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_SPIES_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_SCIENCE', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_SCIENCE_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_CULTURE', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_CULTURE_REQUIREMENTS'),
    ('BBG_KONGO_RELIC_GOVBUILDING_MILITARY', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1, 'PLAYER_HAS_GOV_BUILDING_MILITARY_REQUIREMENTS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_KONGO_RELIC_GOVBUILDING_TALL', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_WIDE', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_CONQUEST', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_FAITH', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_CITYSTATES', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_SPIES', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_SCIENCE', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_CULTURE', 'Amount', '1'),
    ('BBG_KONGO_RELIC_GOVBUILDING_MILITARY', 'Amount', '1');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_TALL'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_WIDE'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_CONQUEST'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_FAITH'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_CITYSTATES'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_SPIES'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_SCIENCE'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_CULTURE'),
    ('TRAIT_CIVILIZATION_NKISI', 'BBG_KONGO_RELIC_GOVBUILDING_MILITARY');

-- Put back writer point.
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_NKISI', 'TRAIT_DOUBLE_WRITER_POINTS');

-- +4 faith for each sculture and artifact
UPDATE ModifierArguments SET Value='4' WHERE Name='YieldChange' AND ModifierId IN ('TRAIT_GREAT_WORK_FAITH_SCULPTURE', 'TRAIT_GREAT_WORK_FAITH_ARTIFACT');

--==================
-- Norway
--==================
-- Can only heal on coast tile
UPDATE Modifiers SET SubjectRequirementSetId='LONGSHIP_PLOT_IS_COAST' WHERE ModifierId='MELEE_SHIP_HEAL_NEUTRAL';
-- Berserker
UPDATE Units SET Combat=40 WHERE UnitType='UNIT_NORWEGIAN_BERSERKER';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='UNIT_STRONG_WHEN_ATTACKING';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='UNIT_WEAK_WHEN_DEFENDING';
-- Berserker unit now gets unlocked at Feudalism instead of Military Tactics, and can be purchased with Faith
UPDATE Units SET PrereqTech=NULL , PrereqCivic='CIVIC_FEUDALISM' WHERE UnitType='UNIT_NORWEGIAN_BERSERKER';
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_UNIT_NORWEGIAN_BERSERKER' , 'BERSERKER_FAITH_PURCHASE_CPLMOD');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES ('BERSERKER_FAITH_PURCHASE_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('BERSERKER_FAITH_PURCHASE_CPLMOD' , 'Tag' , 'CLASS_MELEE_BERSERKER');
--Berserker Movement bonus extended to all water tiles
UPDATE RequirementSets SET RequirementSetType='REQUIREMENTSET_TEST_ANY' WHERE RequirementSetId='BERSERKER_PLOT_IS_ENEMY_TERRITORY';
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES
	('BERSERKER_PLOT_IS_ENEMY_TERRITORY' , 'REQUIRES_PLOT_HAS_COAST'),
	('BERSERKER_PLOT_IS_ENEMY_TERRITORY' , 'REQUIRES_TERRAIN_OCEAN' );
-- Stave Church now gives +1 Faith to resource tiles in the city, instead of standard adjacency bonus for woods
INSERT OR IGNORE INTO Modifiers (ModifierID , ModifierType , SubjectRequirementSetId)
	VALUES ('STAVECHURCH_RESOURCE_FAITH' , 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD' , 'STAVE_CHURCH_RESOURCE_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('STAVECHURCH_RESOURCE_FAITH' , 'YieldType' , 'YIELD_FAITH');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('STAVECHURCH_RESOURCE_FAITH' , 'Amount' , '1');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_STAVE_CHURCH' , 'STAVECHURCH_RESOURCE_FAITH');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('STAVE_CHURCH_RESOURCE_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('STAVE_CHURCH_RESOURCE_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='STAVE_CHURCH_FAITHWOODSADJACENCY' AND Name='Amount';

-- +2 gold harbor adjacency if adjacent to holy sites
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
    VALUES
    ('BBG_District_HS_Gold_Positive' , 'LOC_HOLY_SITE_HARBOR_ADJACENCY_DESCRIPTION' , 'YIELD_GOLD' , '2'  , '1' , 'DISTRICT_HOLY_SITE'),
    ('BBG_District_HS_Gold_Negative' , 'LOC_HOLY_SITE_HARBOR_ADJACENCY_DESCRIPTION' , 'YIELD_GOLD' , '-2' , '1' , 'DISTRICT_HOLY_SITE');
INSERT OR IGNORE INTO District_Adjacencies (DistrictType , YieldChangeId)
    VALUES
    ('DISTRICT_HARBOR' , 'BBG_District_HS_Gold_Positive'),
    ('DISTRICT_HARBOR' , 'BBG_District_HS_Gold_Negative');
INSERT OR IGNORE INTO ExcludedAdjacencies (YieldChangeId , TraitType)
    VALUES
    ('BBG_District_HS_Gold_Negative' , 'TRAIT_LEADER_MELEE_COASTAL_RAIDS');

-- INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
--     VALUES
--     ('BBG_District_HS_Gold_Positive' , 'LOC_HOLY_SITE_HARBOR_ADJACENCY_DESCRIPTION' , 'YIELD_GOLD' , '2'  , '1' , 'DISTRICT_HOLY_SITE');
-- INSERT OR IGNORE INTO District_Adjacencies (DistrictType , YieldChangeId)
--     VALUES
--     ('DISTRICT_HARBOR' , 'BBG_District_HS_Gold_Positive');
-- INSERT OR IGNORE INTO ExcludedAdjacencies 
-- 	SELECT DISTINCT TraitType, 'BBG_District_HS_Gold_Positive'
-- 	FROM (SELECT * FROM LeaderTraits WHERE TraitType LIKE 'TRAIT_LEADER_%' GROUP BY LeaderType) 
-- 	WHERE LeaderType!='LEADER_HARDRADA' AND TraitType!='TRAIT_LEADER_MAJOR_CIV';

-- Holy Sites coastal adjacency
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'DistrictType' , 'DISTRICT_HOLY_SITE'             			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'TerrainType'  , 'TERRAIN_COAST'                  			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'YieldType'    , 'YIELD_FAITH'                    			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'Amount'       , '1'                              			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'TilesRequired', '1'                              			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'Description'  , 'LOC_DISTRICT_HOLY_SITE_NORWAY_COAST_FAITH');
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_LEADER_MELEE_COASTAL_RAIDS' , 'TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY');
-- +50% production towards Holy Sites and associated Buildings
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_LEADER_MELEE_COASTAL_RAIDS'          , 'THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'              );
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES
	('THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'               , 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION'                 , null);
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value , Extra , SecondExtra)
	VALUES
	('THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'               , 'DistrictType' , 'DISTRICT_HOLY_SITE' , null , null),
	('THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'               , 'Amount'       , '50'                 , null , null);

--==================
-- Rome
--==================
-- free city center building after code of laws
UPDATE Modifiers SET SubjectRequirementSetId='HAS_CODE_OF_LAWS_SET_BBG' WHERE ModifierId='TRAIT_ADJUST_NON_CAPITAL_FREE_CHEAPEST_BUILDING';
INSERT OR IGNORE INTO RequirementSets VALUES ('HAS_CODE_OF_LAWS_SET_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements VALUES ('HAS_CODE_OF_LAWS_SET_BBG', 'HAS_CODE_OF_LAWS_BBG');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
	('HAS_CODE_OF_LAWS_BBG', 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) VALUES
	('HAS_CODE_OF_LAWS_BBG', 'CivicType', 'CIVIC_CODE_OF_LAWS');
-- Baths get Culture minor adjacency bonus added
INSERT OR IGNORE INTO District_Adjacencies (DistrictType , YieldChangeId)
	VALUES ('DISTRICT_BATH' , 'District_Culture');


--==================
-- Russia
--==================
-- Lavra only gets 1 Great Prophet Point per turn
UPDATE District_GreatPersonPoints SET PointsPerTurn=1 WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_PROPHET';
-- Only gets 2 extra tiles when founding a new city instead of 8 
--UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRAIT_INCREASED_TILES';
-- Cossacks have same base strength as cavalry instead of +5
UPDATE Units SET Combat=62 WHERE UnitType='UNIT_RUSSIAN_COSSACK';

-- 2020/12/15 - Found in 4.1.2: Fix corner case where Cossacks don't work on borders
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='COSSACK_LOCAL_COMBAT';
UPDATE Modifiers SET OwnerRequirementSetId='COSSACK_PLOT_IS_OWNER_OR_ADJACENT_REQUIREMENTS' WHERE ModifierId='COSSACK_LOCAL_COMBAT';

-- 23/04/2021 iElden: Applied Firaxis patch
-- Lavra district does not acrue Great Person Points unless city has a theater
--UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_ARTIST';
--UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_MUSICIAN';
--UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_WRITER';
--INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
--    VALUES ('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
--INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
--    VALUES
--	('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIRES_DISTRICT_IS_LAVRA'),
--	('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIRES_CITY_HAS_THEATER_DISTRICT');
--INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
--	VALUES ('REQUIRES_DISTRICT_IS_LAVRA' , 'REQUIREMENT_DISTRICT_TYPE_MATCHES');
--INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
--	VALUES ('REQUIRES_DISTRICT_IS_LAVRA', 'DistrictType', 'DISTRICT_LAVRA');
--INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
--    VALUES
--	('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS'),
--    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS'),
--	('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS');
--INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
--    VALUES
--	('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_ARTIST'),
--    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_MUSICIAN'),
--	('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_WRITER'),
--	('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'Amount' , '1'),
--    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'Amount' , '1'),
--    ('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'Amount' , '1');
--INSERT OR IGNORE INTO DistrictModifiers ( DistrictType , ModifierId )
--	VALUES
--	( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_ARTIST_GPP_MODIFIER' ),
--	( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' ),
--	( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_WRITER_GPP_MODIFIER' );


--==================
-- Scythia
--==================
-- Scythia no longer gets an extra light cavalry unit when building/buying one
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_EXTRASAKAHORSEARCHER' and NAME='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_EXTRALIGHTCAVALRY' and NAME='Amount';
-- Scythian Horse Archer gets a little more offense and defense, less maintenance, and can upgrade to Crossbowman before Field Cannon now
-- 23/04/2021: Implemented by Firaxis
-- UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CROSSBOWMAN' WHERE Unit='UNIT_SCYTHIAN_HORSE_ARCHER';
UPDATE Units SET Range=2, Cost=70 WHERE UnitType='UNIT_SCYTHIAN_HORSE_ARCHER';
-- Adjacent Pastures now give +1 production in addition to faith
INSERT OR IGNORE INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_KURGAN' , 'BBG_KURGAN_PASTURE_PRODUCTION');
INSERT OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentImprovement)
	VALUES ('BBG_KURGAN_PASTURE_PRODUCTION' , 'Placeholder' , 'YIELD_PRODUCTION' , 1 , 1 , 'IMPROVEMENT_PASTURE');
INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType , YieldType , YieldChange)
	VALUES ('IMPROVEMENT_KURGAN' , 'YIELD_PRODUCTION' , 0);
INSERT OR IGNORE INTO Improvement_ValidTerrains (ImprovementType, TerrainType) VALUES
	('IMPROVEMENT_KURGAN', 'TERRAIN_PLAINS_HILLS'),
	('IMPROVEMENT_KURGAN', 'TERRAIN_GRASS_HILLS'),
	('IMPROVEMENT_KURGAN', 'TERRAIN_DESERT_HILLS'),
	('IMPROVEMENT_KURGAN', 'TERRAIN_SNOW_HILLS'),
	('IMPROVEMENT_KURGAN', 'TERRAIN_TUNDRA_HILLS');

-- Can now purchase cavalry units with faith
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_EXTRA_LIGHT_CAVALRY' , 'SCYTHIA_FAITH_PURCHASE_LCAVALRY_CPLMOD');
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_EXTRA_LIGHT_CAVALRY' , 'SCYTHIA_FAITH_PURCHASE_HCAVALRY_CPLMOD');
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_EXTRA_LIGHT_CAVALRY' , 'SCYTHIA_FAITH_PURCHASE_RCAVALRY_CPLMOD');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES ('SCYTHIA_FAITH_PURCHASE_LCAVALRY_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES ('SCYTHIA_FAITH_PURCHASE_HCAVALRY_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES ('SCYTHIA_FAITH_PURCHASE_RCAVALRY_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SCYTHIA_FAITH_PURCHASE_LCAVALRY_CPLMOD' , 'Tag' , 'CLASS_LIGHT_CAVALRY'); 
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SCYTHIA_FAITH_PURCHASE_HCAVALRY_CPLMOD' , 'Tag' , 'CLASS_HEAVY_CAVALRY');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SCYTHIA_FAITH_PURCHASE_RCAVALRY_CPLMOD' , 'Tag' , 'CLASS_RANGED_CAVALRY'); 

-- 17/08/2022: fix bug where bonus is not working on gdr
DELETE FROM TypeTags WHERE Type='ABILITY_TOMYRIS_BONUS_VS_WOUNDED_UNITS';

INSERT OR IGNORE INTO TypeTags (Type , Tag) VALUES
	('ABILITY_TOMYRIS_BONUS_VS_WOUNDED_UNITS' ,'CLASS_ALL_COMBAT_UNITS');

--==================
-- Spain
--==================
-- Early Fleets moved to Mercenaries
UPDATE ModifierArguments SET Value='CIVIC_MERCENARIES' WHERE Name='CivicType' AND ModifierId='TRAIT_NAVAL_CORPS_EARLY';
-- 30% discount on missionaries
INSERT OR IGNORE INTO TraitModifiers ( TraitType , ModifierId )
	VALUES ('TRAIT_LEADER_EL_ESCORIAL' , 'HOLY_ORDER_MISSIONARY_DISCOUNT_MODIFIER');
-- 15/05/2021: Delete free builder on foreign continent
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_TREASURE_FLEET' AND ModifierId='TRAIT_INTERCONTINENTAL_BUILDER';
-- 15/05/2021: Conquistador to +5 (from +10)
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='CONQUISTADOR_SPECIFIC_UNIT_COMBAT' AND Name='Amount';

--==============================================================
--******			  G O V E R N M E N T S				  ******
--==============================================================
-- fascism attack bonus works on defense now too
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_ATTACK_BUFF';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_LEGACY_ATTACK_BUFF';



--==============================================================
--******			 G R E A T    P E O P L E  			  ******
--==============================================================




--==============================================================
--******				P A N T H E O N S				  ******
--==============================================================
-- religious settlements more border growth since settler removed
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='RELIGIOUS_SETTLEMENTS_CULTUREBORDER';
-- river goddess +2 HS adj on rivers, -1 housing and -1 amentiy tho
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='RIVER_GODDESS_HOLY_SITE_HOUSING_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='RIVER_GODDESS_HOLY_SITE_AMENITIES_MODIFIER' AND Name='Amount';
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId)
	VALUES ('RIVER_GODDESS_HOLY_SITE_FAITH_BBG' , 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_HAS_PANTHEON_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'MODIFIER_PLAYER_CITIES_RIVER_ADJACENCY');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value) VALUES
    ('RIVER_GODDESS_HOLY_SITE_FAITH_BBG', 'ModifierId', 'RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'Amount' , '1'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'DistrictType' , 'DISTRICT_HOLY_SITE'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'YieldType' , 'YIELD_FAITH'),
    ('RIVER_GODDESS_HOLY_SITE_FAITH_MODIFIER_BBG' , 'Description' , 'LOC_DISTRICT_HOLY_SITE_RIVER_FAITH');
INSERT OR IGNORE INTO BeliefModifiers VALUES
	('BELIEF_RIVER_GODDESS', 'RIVER_GODDESS_HOLY_SITE_FAITH_BBG');
-- city patron buff
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='CITY_PATRON_GODDESS_DISTRICT_PRODUCTION_MODIFIER' AND Name='Amount';
-- Dance of Aurora yields reduced... only work for flat tundra
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='DANCE_OF_THE_AURORA_FAITHTUNDRAHILLSADJACENCY' AND Name='Amount';
-- stone circles -1 faith and +1 prod
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='STONE_CIRCLES_QUARRY_FAITH_MODIFIER' and Name='Amount';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('STONE_CIRCLES_QUARRY_PROD_BBG', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
	('STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_QUARRY_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('STONE_CIRCLES_QUARRY_PROD_BBG', 'ModifierId', 'STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG'),
	('STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG', 'YieldType', 'YIELD_PRODUCTION'),
	('STONE_CIRCLES_QUARRY_PROD_MODIFIER_BBG', 'Amount', '1');
INSERT OR IGNORE INTO BeliefModifiers (BeliefType, ModifierID) VALUES
	('BELIEF_STONE_CIRCLES', 'STONE_CIRCLES_QUARRY_PROD_BBG');
-- religious idols +3 gold
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_BBG', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
	('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_BBG', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
	('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_BONUS_MINE_REQUIREMENTS'),
	('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_LUXURY_MINE_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_BBG', 'ModifierId', 'RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG'),
	('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG', 'Amount', '3'),
	('RELIGIOUS_IDOLS_BONUS_MINE_GOLD_MODIFIER_BBG', 'YieldType', 'YIELD_GOLD'),
	('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_BBG', 'ModifierId', 'RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG'),
	('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG', 'Amount', '3'),
	('RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_MODIFIER_BBG', 'YieldType', 'YIELD_GOLD');
INSERT OR IGNORE INTO BeliefModifiers VALUES
	('BELIEF_RELIGIOUS_IDOLS', 'RELIGIOUS_IDOLS_BONUS_MINE_GOLD_BBG'),
	('BELIEF_RELIGIOUS_IDOLS', 'RELIGIOUS_IDOLS_LUXURY_MINE_GOLD_BBG');
UPDATE ModifierArguments SET Value='3' WHERE ModifierId IN ('RELIGIOUS_IDOLS_BONUS_MINE_FAITH_MODIFIER', 'RELIGIOUS_IDOLS_LUXURY_MINE_FAITH_MODIFIER') AND Name='Amount';
-- Goddess of the Harvest is +50% faith from chops instead of +100%
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GODDESS_OF_THE_HARVEST_HARVEST_MODIFIER' and Name='Amount';
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GODDESS_OF_THE_HARVEST_REMOVE_FEATURE_MODIFIER' and Name='Amount';
-- Monument to the Gods affects all wonders... not just Ancient and Classical Era
UPDATE ModifierArguments SET Value='ERA_INFORMATION' WHERE ModifierId='MONUMENT_TO_THE_GODS_ANCIENTCLASSICALWONDER_MODIFIER' AND Name='EndEra';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='MONUMENT_TO_THE_GODS_ANCIENTCLASSICALWONDER_MODIFIER' AND Name='Amount';
-- God of War now God of War and Plunder (similar to divine spark)
DELETE FROM BeliefModifiers WHERE BeliefType='BELIEF_GOD_OF_WAR';
INSERT OR IGNORE INTO Modifiers  ( ModifierId , ModifierType , SubjectRequirementSetId )
	VALUES
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_COMMERCIAL_HUB' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_HARBOR' 		),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_ENCAMPMENT' 	);
INSERT OR IGNORE INTO ModifierArguments ( ModifierId , Name , Type , Value )
	VALUES
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' ),
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_MERCHANT' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_ADMIRAL'  ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_GENERAL'  ),
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' );
INSERT OR IGNORE INTO BeliefModifiers ( BeliefType , ModifierId )
	VALUES
	( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_COMHUB' ),
	( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_HARBOR' ),
	( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' );
-- Fertility Rites gives +1 food for rice and wheat and cattle
INSERT OR IGNORE INTO Tags
	(Tag                                , Vocabulary)
	VALUES 
	('CLASS_FERTILITY_RITES_FOOD'       , 'RESOURCE_CLASS');
INSERT OR IGNORE INTO TypeTags 
	(Type              , Tag)
	VALUES
	('RESOURCE_WHEAT'  , 'CLASS_FERTILITY_RITES_FOOD'),
	('RESOURCE_CATTLE' , 'CLASS_FERTILITY_RITES_FOOD'),
	('RESOURCE_RICE'   , 'CLASS_FERTILITY_RITES_FOOD');
INSERT OR IGNORE INTO Modifiers 
	(ModifierId                                         , ModifierType                                                , SubjectRequirementSetId)
	VALUES
	('FERTILITY_RITES_TAG_FOOD'                         , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER'                       , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'      ),
	('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD'               , 'PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments 
	(ModifierId                                         , Name                       , Value)
	VALUES
	('FERTILITY_RITES_TAG_FOOD'                         , 'ModifierId'                , 'FERTILITY_RITES_TAG_FOOD_MODIFIER'             ),
	('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'YieldType'                 , 'YIELD_FOOD'                                    ),
	('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'Amount'                    , '1'                                             );
INSERT OR IGNORE INTO Requirements 
	(RequirementId                                , RequirementType)
	VALUES 
	('REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD'       , 'REQUIREMENT_PLOT_RESOURCE_TAG_MATCHES');
INSERT OR IGNORE INTO RequirementArguments 
	(RequirementId                                , Name  , Value)
	VALUES 
	('REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD'       , 'Tag'         , 'CLASS_FERTILITY_RITES_FOOD');
INSERT OR IGNORE INTO RequirementSets 
	(RequirementSetId                                 , RequirementSetType)
	VALUES 
	('PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS'       , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements 
	(RequirementSetId                                 , RequirementId)
	VALUES 
	('PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS'       , 'REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD');
UPDATE BeliefModifiers SET ModifierID='FERTILITY_RITES_TAG_FOOD' WHERE BeliefType='BELIEF_FERTILITY_RITES' AND ModifierID='FERTILITY_RITES_GROWTH';
-- Sacred Path +1 Faith Holy Site adjacency now applies to both Woods and Rainforest
INSERT OR IGNORE INTO BeliefModifiers 
	(BeliefType                   , ModifierId)
	VALUES
	('BELIEF_SACRED_PATH'         , 'SACRED_PATH_WOODS_FAITH_ADJACENCY');
INSERT OR IGNORE INTO Modifiers 
	(ModifierId                                         , ModifierType                                                , SubjectRequirementSetId)
	VALUES
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'MODIFIER_ALL_CITIES_FEATURE_ADJACENCY'                     , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments 
	(ModifierId                                         , Name                       , Value)
	VALUES
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'DistrictType'              , 'DISTRICT_HOLY_SITE'                            ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'FeatureType'               , 'FEATURE_FOREST'                                ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'YieldType'                 , 'YIELD_FAITH'                                   ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'Amount'                    , '1'                                             ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'Description'               , 'LOC_DISTRICT_SACREDPATH_WOODS_FAITH'           );
-- Lady of the Reeds and Marshes now applies pantanal
INSERT OR IGNORE INTO RequirementSetRequirements 
    (RequirementSetId              , RequirementId)
    VALUES 
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_PANTANAL'          );
INSERT OR IGNORE INTO Requirements 
    (RequirementId                          , RequirementType)
    VALUES 
    ('REQUIRES_PLOT_HAS_PANTANAL'           , 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments 
    (RequirementId                          , Name          , Value)
    VALUES 
    ('REQUIRES_PLOT_HAS_PANTANAL'           , 'FeatureType' , 'FEATURE_PANTANAL'             );

--04/10/22 goddess of the hunt nerf from 1p/1f to 1p/2g
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
    ('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_CAMP_REQUIREMENTS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER', 'YieldType', 'YIELD_GOLD'),
	('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER', 'Amount', '2'),
	('BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD', 'ModifierId', 'BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD_MODIFIER');

INSERT INTO BeliefModifiers (BeliefType, ModifierId) VALUES
	('BELIEF_GODDESS_OF_THE_HUNT', 'BBG_GODDESS_OF_THE_HUNT_CAMP_GOLD');

DELETE FROM BeliefModifiers WHERE ModifierId='GODDESS_OF_THE_HUNT_CAMP_FOOD';





--==============================================================
--******			P O L I C Y   C A R D S				  ******
--==============================================================




--==============================================================================================
--******				R E L I G I O N					  ******
--==============================================================================================
-- Monks: Base Game BugFixes
-- Monks: Added: Work with Rams/SeigeTowers, Removed: Wall Breaker 
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('BBG_ENABLE_WALL_ATTACK_MONK', 'MODIFIER_PLAYER_UNIT_ADJUST_ENABLE_WALL_ATTACK_PROMOTION_CLASS'),
	('BBG_BYPASS_WALLS_MONK','MODIFIER_PLAYER_UNIT_ADJUST_BYPASS_WALLS_PROMOTION_CLASS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_ENABLE_WALL_ATTACK_MONK', 'PromotionClass', 'PROMOTION_CLASS_MONK'),
	('BBG_BYPASS_WALLS_MONK', 'PromotionClass', 'PROMOTION_CLASS_MONK');

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
	('ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS','BBG_ENABLE_WALL_ATTACK_MONK'),
	('ABILITY_BYPASS_WALLS_PROMOTION_CLASS','BBG_BYPASS_WALLS_MONK');
-- Monks: Added Great General +5 CS/ +1 MS
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_MONK', 'REQUIREMENT_UNIT_TAG_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name , Value) VALUES
	('BBG_REQUIRES_MONK', 'Tag', 'CLASS_WARRIOR_MONK');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('AOE_CLASSICAL_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
	('AOE_MEDIEVAL_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
	('AOE_RENAISSANCE_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
	('AOE_INDUSTRIAL_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
	('AOE_MODERN_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
	('AOE_ATOMIC_REQUIREMENTS', 'BBG_REQUIRES_MONK'),
	('AOE_INFORMATION_REQUIREMENTS', 'BBG_REQUIRES_MONK');

-- Monks: Added Abilities from General Retire
INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_GEORGY_ZHUKOV_FLANKING_BONUS', 'CLASS_WARRIOR_MONK'),
	('ABILITY_VIJAYA_WIMALARATNE_BONUS_EXPERIENCE', 'CLASS_WARRIOR_MONK'),
	('ABILITY_JOHN_MONASH_BONUS_EXPERIENCE','CLASS_WARRIOR_MONK'),
	('ABILITY_TIMUR_BONUS_EXPERIENCE', 'CLASS_WARRIOR_MONK');

--Monks: All civs CS/MS interractions:
INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_BARRACKS_TRAINED_UNIT_XP','CLASS_WARRIOR_MONK'),
	('ABILITY_ARMORY_TRAINED_UNIT_XP', 'CLASS_WARRIOR_MONK'),
	('ABILITY_MILITARY_ACADEMY_TRAINED_UNIT_XP','CLASS_WARRIOR_MONK'),
	('ABILITY_GREAT_LIGHTHOUSE_EMBARKED_MOVEMENT', 'CLASS_WARRIOR_MONK'),
	('ABILITY_COMMUNISM_DEFENSE_BUFF', 'CLASS_WARRIOR_MONK');

-- Monks: Affected by Battlecry
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_OPPONENT_IS_MONK','REQUIREMENT_OPPONENT_UNIT_PROMOTION_CLASS_MATCHES');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_OPPONENT_IS_MONK','UnitPromotionClass','PROMOTION_CLASS_MONK');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES 
	('BATTLECRY_OPPONENT_REQUIREMENTS', 'BBG_OPPONENT_IS_MONK');

-- Monks: Civ Combat Bonus Interractions
INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_TOMYRIS_HEAL_AFTER_DEFEATING_UNIT', 'CLASS_WARRIOR_MONK'),
	('ABILITY_TOMYRIS_BONUS_VS_WOUNDED_UNITS', 'CLASS_WARRIOR_MONK'),
	('ABILITY_HOJO_TOKIMUNE_COASTAL_COMBAT_BONUS', 'CLASS_WARRIOR_MONK'),
	('BBG_IGNORE_WOODS_ABILITY', 'CLASS_WARRIOR_MONK'),
	('ABILITY_PHILIP_II_COMBAT_BONUS_OTHER_RELIGION', 'CLASS_WARRIOR_MONK');

-- Monks: Rework
-- Monks: Defines Scaling Combat Strength with Civics, Capped at the End of Industrial Civis
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_UNIT_IS_MONK_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_UNIT_IS_MONK_REQUIREMENTS', 'BBG_REQUIRES_MONK');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) 
	SELECT 'BBG_ABILITY_MODIFIER_MONKS_' || Civics.CivicType  , 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 'BBG_UNIT_IS_MONK_REQUIREMENTS'
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO Modifiers(ModifierId, ModifierType)
	SELECT 'BBG_MODIFIER_MONKS_CS_' || Civics.CivicType , 'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH'
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_MODIFIER_MONKS_CS_'|| Civics.CivicType , 'Amount', '1'
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BBG_ABILITY_MODIFIER_MONKS_' || Civics.CivicType , 'ModifierId', 'BBG_MODIFIER_MONKS_CS_' || Civics.CivicType 
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

INSERT INTO CivicModifiers(CivicType, ModifierId)
	SELECT Civics.CivicType, 'BBG_ABILITY_MODIFIER_MONKS_' || Civics.CivicType
	FROM Civics WHERE EraType IN ('ERA_ANCIENT','ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');

--DELETE UNIQUE TEMPLES requirements
DELETE FROM Unit_BuildingPrereqs
	WHERE Unit = 'UNIT_WARRIOR_MONK' AND PrereqBuilding = 'BUILDING_STAVE_CHURCH';

--Relax Requirement to SHRINE
UPDATE Unit_BuildingPrereqs SET PrereqBuilding = 'BUILDING_SHRINE' WHERE Unit = 'UNIT_WARRIOR_MONK' AND PrereqBuilding = 'BUILDING_TEMPLE';

--Reduce Base Cost and Strength, SET Scaling Cost to match closely non-unique units
--with the same CS across eras up to Industrial, Monk then stops scaling and Cost doesn't justify the str.
--Becomes Obsolete in Modern due to str/price. Still should kick ass in Industrial esp with tier II promo.
--Around Shrines Religion Timing should be around sword in strength
UPDATE Units SET Combat = '31' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET Cost = '60' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET CostProgressionModel = 'COST_PROGRESSION_GAME_PROGRESS' WHERE UnitType = 'UNIT_WARRIOR_MONK';
UPDATE Units SET CostProgressionParam1 = '1000' WHERE UnitType = 'UNIT_WARRIOR_MONK';

--Nerf Tier 2 promo Exploding Palms from +10 down to +5 to stay more in line with mele units
UPDATE ModifierArguments SET Value = '5' WHERE ModifierId = 'EXPLODING_PALMS_INCREASED_COMBAT_STRENGTH';
--Nerf Tier 4 promo Cobra Strike +15 down to +7 to be more in line with other promos
UPDATE ModifierArguments SET Value = '7' WHERE ModifierId = 'COBRA_STRIKE_INCREASED_COMBAT_STRENGTH';

--Add Unique Ability Icon and description to Monk's Scaling Ability in Unit Preview
--Modifiers Themself are added through civic tree as monk is not unique to a given player.
INSERT INTO Types(Type, Kind) VALUES
	('BBG_ABILITY_MONK_SCALING', 'KIND_ABILITY');
	
INSERT INTO TypeTags(Type, Tag) VALUES
	('BBG_ABILITY_MONK_SCALING', 'CLASS_WARRIOR_MONK');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
	('BBG_ABILITY_MONK_SCALING', 'LOC_BBG_ABILITY_MONK_SCALING_NAME', 'LOC_BBG_ABILITY_MONK_SCALING_DESCRIPTION');

-- Nerf Inquisitors
-- UPDATE Units SET ReligionEvictPercent=50, SpreadCharges=2 WHERE UnitType='UNIT_INQUISITOR';
-- Religious spread from trade routes increased
UPDATE GlobalParameters SET Value='2.0' WHERE Name='RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_DESTINATION';
UPDATE GlobalParameters SET Value='1.0' WHERE Name='RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_ORIGIN'     ;
-- Divine Inspiration yield increased
UPDATE ModifierArguments SET Value='6' WHERE ModifierId='DIVINE_INSPIRATION_WONDER_FAITH_MODIFIER' AND Name='Amount';
-- Crusader +7 instead of +10
UPDATE ModifierArguments SET Value='7' WHERE ModifierId='JUST_WAR_COMBAT_BONUS_MODIFIER';
-- Lay Ministry now +2 Culture and +2 Faith per Theater and Holy Site
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='LAY_MINISTRY_CULTURE_DISTRICTS_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='LAY_MINISTRY_FAITH_DISTRICTS_MODIFIER' AND Name='Amount';
-- Itinerant Preachers now causes a Religion to spread 40% father away instead of only 30%
-- UPDATE ModifierArguments SET Value='4' WHERE ModifierId='ITINERANT_PREACHERS_SPREAD_DISTANCE';
-- Cross-Cultural Dialogue is now +1 Science for every 3 foreign followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='CROSS_CULTURAL_DIALOGUE_SCIENCE_FOREIGN_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- Tithe is now +1 Gold for every 3 followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TITHE_GOLD_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- World Church is now +1 Culture for every 3 foreign followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='WORLD_CHURCH_CULTURE_FOREIGN_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- Zen Meditation now only requires 1 District to get the +1 Amentity
UPDATE RequirementArguments SET Value='1' WHERE RequirementId='REQUIRES_CITY_HAS_2_SPECIALTY_DISTRICTS' AND Name='Amount';
-- Religious Communities now gives +1 Housing to Holy Sites, like it does for Shines and Temples
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER' , 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_HOUSING');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING' , 'ModifierId' , 'RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO BeliefModifiers (BeliefType , ModifierId)
	VALUES ('BELIEF_RELIGIOUS_COMMUNITY' , 'RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIRES_CITY_FOLLOWS_RELIGION');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIRES_CITY_HAS_HOLY_SITE');
-- Warrior Monks +5 Combat Strength
-- 23/04/2021: Implemented by Firaxis
-- UPDATE Units SET Combat=40 WHERE UnitType='UNIT_WARRIOR_MONK';
-- Work Ethic now provides production equal to base yield for Shrine and Temple
DELETE From BeliefModifiers WHERE ModifierId='WORK_ETHIC_FOLLOWER_PRODUCTION';
INSERT OR IGNORE INTO Modifiers 
	(ModifierId                              , ModifierType                          , SubjectRequirementSetId)
	VALUES 
	('WORK_ETHIC_SHRINE_PRODUCTION'          , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_SHRINE'),
	('WORK_ETHIC_TEMPLE_PRODUCTION'          , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_TEMPLE'),
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'MODIFIER_BUILDING_YIELD_CHANGE'      , null                              ),
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'MODIFIER_BUILDING_YIELD_CHANGE'      , null                              );
INSERT OR IGNORE INTO ModifierArguments 
	(ModifierId                              , Name           , Value)
	VALUES 
	('WORK_ETHIC_SHRINE_PRODUCTION'          , 'ModifierId'   , 'WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER'),
	('WORK_ETHIC_TEMPLE_PRODUCTION'          , 'ModifierId'   , 'WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER'),
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'BuildingType' , 'BUILDING_SHRINE'                      ),
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'YieldType'    , 'YIELD_PRODUCTION'                     ),
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'Amount'       , '2'                                    ),
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'BuildingType' , 'BUILDING_TEMPLE'                      ),
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'YieldType'    , 'YIELD_PRODUCTION'                     ),
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'Amount'       , '4'                                    );
INSERT OR IGNORE INTO BeliefModifiers 
	(BeliefType          , ModifierId)
	VALUES 
	('BELIEF_WORK_ETHIC' , 'WORK_ETHIC_TEMPLE_PRODUCTION'),
	('BELIEF_WORK_ETHIC' , 'WORK_ETHIC_SHRINE_PRODUCTION');
-- Dar E Mehr provides +2 culture instead of faith from eras
DELETE FROM Building_YieldsPerEra WHERE BuildingType='BUILDING_DAR_E_MEHR';
INSERT OR IGNORE INTO Building_YieldChanges 
	(BuildingType          , YieldType       , YieldChange)
	VALUES 
	('BUILDING_DAR_E_MEHR' , 'YIELD_CULTURE' , '2');
-- All worship building production costs reduced	

--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_CATHEDRAL'    ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_GURDWARA'     ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_MEETING_HOUSE';
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_MOSQUE'       ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_PAGODA'       ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_SYNAGOGUE'    ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_WAT'          ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_STUPA'        ;
--UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_DAR_E_MEHR'   ;



--==============================================================
--******				S  C  O  R  E				  	  ******
--==============================================================
-- more points for techs and civics
UPDATE ScoringLineItems SET Multiplier=4 WHERE LineItemType='LINE_ITEM_CIVICS';
UPDATE ScoringLineItems SET Multiplier=3 WHERE LineItemType='LINE_ITEM_TECHS';
-- less points for wide, more for tall
UPDATE ScoringLineItems SET Multiplier=2 WHERE LineItemType='LINE_ITEM_CITIES';
UPDATE ScoringLineItems SET Multiplier=2 WHERE LineItemType='LINE_ITEM_POPULATION';
-- Wonders Provide +4 score instead of +15
UPDATE ScoringLineItems SET Multiplier=4 WHERE LineItemType='LINE_ITEM_WONDERS';
-- Great People worth only 3 instead of 5
UPDATE ScoringLineItems SET Multiplier=3 WHERE LineItemType='LINE_ITEM_GREAT_PEOPLE';
-- converting foreign populations reduced from 2 to 1
UPDATE ScoringLineItems SET Multiplier=1 WHERE LineItemType='LINE_ITEM_ERA_CONVERTED';



--==============================================================
--******				START BIASES					  ******
--==============================================================
-- t1 take up essential coastal spots first
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_ENGLAND' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_NORWAY' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_JAPAN' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_RUSSIA' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_RUSSIA' AND TerrainType='TERRAIN_TUNDRA';
-- t2 must haves
UPDATE StartBiasFeatures SET Tier=2 WHERE CivilizationType='CIVILIZATION_BRAZIL' AND FeatureType='FEATURE_JUNGLE';
-- t3 identities
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_SCYTHIA' AND ResourceType='RESOURCE_HORSES';
-- t4 river mechanics
--UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_SUMERIA';
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_FRANCE';
-- t4 feature mechanics
UPDATE StartBiasFeatures SET Tier=3 WHERE CivilizationType='CIVILIZATION_KONGO' AND FeatureType='FEATURE_JUNGLE';
-- t4 terrain mechanics
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_GRASS_HILLS';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_PLAINS_HILLS';
-- t4 resource mechanics
INSERT OR IGNORE INTO StartBiasResources (CivilizationType , ResourceType , Tier) VALUES
	('CIVILIZATION_SCYTHIA' , 'RESOURCE_SHEEP'  , 4),
	('CIVILIZATION_SCYTHIA' , 'RESOURCE_CATTLE' , 4);
-- t5 last resorts
UPDATE StartBiasFeatures SET Tier=5 WHERE CivilizationType='CIVILIZATION_KONGO' AND FeatureType='FEATURE_FOREST';
UPDATE StartBiasFeatures SET Tier=5 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS';
-- Delete bad bias
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType IN ('TERRAIN_TUNDRA_HILLS', 'TERRAIN_DESERT_HILLS');


--==============================================================
--******					W A L L S					  ******
--==============================================================
UPDATE Buildings SET OuterDefenseHitPoints=75, Cost=100 WHERE BuildingType='BUILDING_WALLS';
UPDATE Buildings SET OuterDefenseHitPoints=75, Cost=200 WHERE BuildingType='BUILDING_CASTLE';
UPDATE Buildings SET OuterDefenseHitPoints=75 WHERE BuildingType='BUILDING_STAR_FORT';
UPDATE ModifierArguments SET Value='300' WHERE ModifierId='STEEL_UNLOCK_URBAN_DEFENSES';



--==============================================================
--******			W O N D E R S  (MAN-MADE)			  ******
--==============================================================
-- cristo gets 1 relic
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , RunOnce , Permanent)
	VALUES ('WONDER_GRANT_RELIC_BBG' , 'MODIFIER_PLAYER_GRANT_RELIC' , 1 , 1);	
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('WONDER_GRANT_RELIC_BBG' , 'Amount' , '1');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_CRISTO_REDENTOR', 'WONDER_GRANT_RELIC_BBG');
-- Hanging Gardens gives +1 housing to cities within 6 tiles
UPDATE Buildings SET Housing='1' WHERE BuildingType='BUILDING_HANGING_GARDENS';
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_HANGING_GARDENS' , 'HANGING_GARDENS_REGIONAL_HOUSING');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_HOUSING' , 'HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING' , 'Amount' , '1');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'BuildingType' ,'BUILDING_HANGING_GARDENS');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'MaxRange' ,'6');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'MinRange' ,'0');

-- Great Library unlocks at Drama & Poetry instead of Recorded History
UPDATE Buildings SET PrereqCivic='CIVIC_DRAMA_POETRY' WHERE BuildingType='BUILDING_GREAT_LIBRARY';

-- Venetian Arsenal gives 80% production boost to all naval units in all cities instead of an extra naval unit in its city each time you build one
DELETE FROM BuildingModifiers WHERE	BuildingType='BUILDING_VENETIAN_ARSENAL';

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_MELEE_PRODUCTION');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RANGED_PRODUCTION');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RAIDER_PRODUCTION');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_CARRIER_PRODUCTION');



--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- great barrier reef gives +2 science adj
-- INSERT OR IGNORE INTO District_Adjacencies VALUES
--	('DISTRICT_CAMPUS', 'BarrierReef_Science');
--INSERT OR IGNORE INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentFeature) VALUES
--	('BarrierReef_Science', 'LOC_DISTRICT_REEF_SCIENCE', 'YIELD_SCIENCE', 2, 1, 'FEATURE_BARRIER_REEF');
-- Several lack-luster wonders improved
UPDATE Features SET Settlement=1 WHERE FeatureType='FEATURE_CLIFFS_DOVER';
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_PANTANAL', 'YIELD_SCIENCE', 2);
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CLIFFS_DOVER', 'YIELD_FOOD', 2);
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_DEAD_SEA', 'YIELD_FOOD', 2);
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CRATER_LAKE', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_CRATER_LAKE' AND YieldType='YIELD_SCIENCE'; 
INSERT OR IGNORE INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_GALAPAGOS', 'YIELD_FOOD', 1);
--Causeway +3 down from +5
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='SPEAR_OF_FIONN_ADJUST_COMBAT_STRENGTH' AND Name='Amount';
UPDATE Modifiers SET SubjectRequirementSetId='ATTACKING_REQUIREMENT_SET' WHERE ModifierId='SPEAR_OF_FIONN_ADJUST_COMBAT_STRENGTH';


--==============================================================
--******				    O T H E R					  ******
--==============================================================
-- chancery science from captured spies increased
UPDATE ModifierArguments SET Value='200' WHERE ModifierId='CHANCERY_COUNTERYSPY_SCIENCE' AND Name='Amount';
-- oil can be found on flat plains
INSERT OR IGNORE INTO Resource_ValidTerrains (ResourceType, TerrainType)
	VALUES ('RESOURCE_OIL', 'TERRAIN_PLAINS');
-- incense +1 food
INSERT OR IGNORE INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange)
	VALUES ('RESOURCE_INCENSE', 'YIELD_FOOD', 1);
-- add 1 production to fishing boat improvement
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_FISHING_BOATS' AND YieldType='YIELD_PRODUCTION';

-- Citizen specialists give +1 main yield
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' 		AND DistrictType='DISTRICT_ACROPOLIS';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' 		AND DistrictType='DISTRICT_CAMPUS';
UPDATE District_CitizenYieldChanges SET YieldChange=4 WHERE YieldType='YIELD_GOLD' 			AND DistrictType='DISTRICT_COMMERCIAL_HUB';
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType='DISTRICT_ENCAMPMENT';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType='DISTRICT_HANSA';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' 			AND DistrictType='DISTRICT_HARBOR';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' 		AND DistrictType='DISTRICT_HOLY_SITE';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType='DISTRICT_INDUSTRIAL_ZONE';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' 		AND DistrictType='DISTRICT_LAVRA';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' 			AND DistrictType='DISTRICT_ROYAL_NAVY_DOCKYARD';
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' 		AND DistrictType='DISTRICT_THEATER';

-- Free amenity on new city
UPDATE GlobalParameters SET Value=1 WHERE Name='CITY_AMENITIES_FOR_FREE';
UPDATE Buildings SET Entertainment=1 WHERE BuildingType='BUILDING_PALACE';

-- Seaside Ressort buildable on hills
INSERT INTO Improvement_ValidTerrains(ImprovementType, TerrainType) VALUES
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_GRASS_HILLS'),
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_PLAINS_HILLS'),
    ('IMPROVEMENT_BEACH_RESORT', 'TERRAIN_DESERT_HILLS');

--****		REQUIREMENTS		****--
INSERT OR IGNORE INTO Requirements
	(RequirementId , RequirementType)
	VALUES
	('PLAYER_HAS_MEDIEVAL_FAIRES_CPLMOD', 	'REQUIREMENT_PLAYER_HAS_CIVIC'),
	('PLAYER_HAS_URBANIZATION_CPLMOD', 		'REQUIREMENT_PLAYER_HAS_CIVIC'),
	('PLAYER_HAS_BANKING_CPLMOD'   , 		'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
	('PLAYER_HAS_ECONOMICS_CPLMOD' , 		'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT OR IGNORE INTO RequirementArguments
	(RequirementId , Name , Value)
	VALUES
	('PLAYER_HAS_MEDIEVAL_FAIRES_CPLMOD',	'CivicType', 		'CIVIC_MEDIEVAL_FAIRES'  ),
	('PLAYER_HAS_URBANIZATION_CPLMOD', 	 	'CivicType', 		'CIVIC_URBANIZATION'),
	('PLAYER_HAS_BANKING_CPLMOD'   , 		'TechnologyType', 	'TECH_BANKING'  ),
	('PLAYER_HAS_ECONOMICS_CPLMOD' , 		'TechnologyType', 	'TECH_ECONOMICS');

-- 2022-06-04 -- Add Scientific Theory as Prereq for Steam Power
INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
	VALUES ('TECH_STEAM_POWER', 'TECH_SCIENTIFIC_THEORY');

-- This is simply a visual change which makes the tech paths slighly more understandable (the dotted lines)
-- UPDATE Technologies SET UITreeRow=-3 WHERE TechnologyType='TECH_INDUSTRIALIZATION';