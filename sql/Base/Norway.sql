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

-- Naval Melee Production from 50% to 25%
update ModifierArguments
set Value = '25'
where ModifierId in (
	'TRAIT_ANCIENT_NAVAL_MELEE_PRODUCTION',
	'TRAIT_ATOMIC_NAVAL_MELEE_PRODUCTION',
	'TRAIT_CLASSICAL_NAVAL_MELEE_PRODUCTION',
	'TRAIT_INDUSTRIAL_NAVAL_MELEE_PRODUCTION',
	'TRAIT_INFORMATION_NAVAL_MELEE_PRODUCTION',
	'TRAIT_MEDIEVAL_NAVAL_MELEE_PRODUCTION',
	'TRAIT_MODERN_NAVAL_MELEE_PRODUCTION',
	'TRAIT_RENAISSANCE_NAVAL_MELEE_PRODUCTION'
) and name = 'Amount';