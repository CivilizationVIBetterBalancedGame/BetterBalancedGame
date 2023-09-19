--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Nubia
--==================
-- no extra Nubia ranged production and experience cut to 25% (from %50)
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_ANCIENT_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_CLASSICAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_MEDIEVAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_RENAISSANCE_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_INDUSTRIAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_MODERN_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_ATOMIC_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_INFORMATION_RANGED_UNIT_PRODUCTION' and Name='Amount';
--UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RANGED_EXPERIENCE_MODIFIER' and Name='Amount';
-- Nubian Pyramid can also be built on flat plains, but not adjacent to each other
INSERT OR IGNORE INTO Improvement_ValidTerrains (ImprovementType, TerrainType)
	VALUES
	('IMPROVEMENT_PYRAMID' , 'TERRAIN_PLAINS'),
	('IMPROVEMENT_PYRAMID' , 'TERRAIN_GRASS');
UPDATE Improvements SET SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_PYRAMID';
-- Nubian Pyramid gets double adjacency yields
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CityCenterAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CampusAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CommercialHubAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_HarborAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_HolySiteAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_IndustrialZoneAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_TheaterAdjacency';
-- Nubian Pyramid -1 food (to avoid +4 foods tile)
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_PYRAMID' AND YieldType='YIELD_FOOD';
-- 05/09/2021 Pyramid moved to craftsmanship
UPDATE Improvements SET PrereqTech=NULL, PrereqCivic='CIVIC_CRAFTSMANSHIP' WHERE ImprovementType='IMPROVEMENT_PYRAMID';

--15/06/23 Nubia also gets xp bonus for naval ranged units
INSERT INTO TypeTags (Type, Tag) VALUES
	('ABILITY_NUBIA_RANGED_EXPERIENCE_MODIFIER', 'CLASS_NAVAL_RANGED');

--==============================================================
--******				START BIASES					  ******
--==============================================================
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_NUBIA' AND TerrainType='TERRAIN_DESERT_HILLS';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_NUBIA' AND TerrainType='TERRAIN_DESERT';
--UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_NUBIA' AND TerrainType='TERRAIN_DESERT_HILLS';
--UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_NUBIA' AND TerrainType='TERRAIN_DESERT';
-- 04/10/22 from T4 to T2
INSERT OR IGNORE INTO StartBiasTerrains (CivilizationType , TerrainType , Tier)
	VALUES
	('CIVILIZATION_NUBIA', 'TERRAIN_PLAINS', 2),
	('CIVILIZATION_NUBIA', 'TERRAIN_PLAINS_HILLS', 2);

