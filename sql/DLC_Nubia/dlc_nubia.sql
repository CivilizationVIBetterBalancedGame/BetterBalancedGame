--==============================================================
--******            C I V I L I Z A T I O N S              ******
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

--15/06/23 Nubia also gets xp bonus for naval ranged units
INSERT INTO TypeTags (Type, Tag) VALUES
    ('ABILITY_NUBIA_RANGED_EXPERIENCE_MODIFIER', 'CLASS_NAVAL_RANGED');

--==============================================================
--******                START BIASES                      ******
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


--==============================================================
--******                     PYRAMIDS                     ******
--==============================================================

-- Nubian Pyramid can also be built on flat plains
INSERT OR IGNORE INTO Improvement_ValidTerrains (ImprovementType, TerrainType)
    VALUES
    ('IMPROVEMENT_PYRAMID' , 'TERRAIN_PLAINS'),
    ('IMPROVEMENT_PYRAMID' , 'TERRAIN_GRASS');
-- 05/09/2021 Pyramid moved to craftsmanship
UPDATE Improvements SET PrereqTech=NULL, PrereqCivic='CIVIC_CRAFTSMANSHIP' WHERE ImprovementType='IMPROVEMENT_PYRAMID';

-- 01/12/24 Nubia gets +40% production on districts when a Pyramid is in the city (from 20%, doubled when adjacent to city center) 
-- Pyramid can be placed on any flat tiles, limited to one per city and non adjacent to another pyramid
-- Nubian district gets standard adjacency from nubian pyramid
-- Base Nubian Pyramid is +2 food/2 faith
-- Encampment and Aerodrome give +1 production to Pyramid, Diplo Quarter and Gov Plaza give +1 culture/2 gold, city center +1 food (from +2)

-- Nubia gets +40% production on districts when a Pyramid is in the city (from 20%, doubled when adjacent to city center) 
-- Nubian Pyramid double district bonus even if not adjacent to city center
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='TRAIT_PYRAMID_DISTRICT_PRODUCTION_MODIFIER';
UPDATE Modifiers SET ModifierType='MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_MODIFIER' WHERE ModifierId='TRAIT_PYRAMID_DISTRICT_PRODUCTION_MODIFIER';
UPDATE ModifierArguments SET Value=40 WHERE ModifierId='TRAIT_PYRAMID_DISTRICT_PRODUCTION_MODIFIER' AND Name='Amount';
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_PYRAMID_DISTRICT_PRODUCTION_MODIFIER';
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_LEADER_KANDAKE_OF_MEROE';
INSERT INTO ImprovementModifiers (ImprovementType, ModifierID) VALUES
    ('IMPROVEMENT_PYRAMID', 'TRAIT_PYRAMID_DISTRICT_PRODUCTION_MODIFIER');

-- Pyramid can be placed on any flat tiles, limited to one per city and non adjacent to another pyramid
UPDATE Improvements SET OnePerCity=1, SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_PYRAMID';

-- 01/12/24 removed
-- Base Nubian Pyramid is +2 food/2 faith
-- Nubian Pyramid gets double adjacency yields
-- UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CityCenterAdjacency';
-- UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CampusAdjacency';
-- UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CommercialHubAdjacency';
-- UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_HarborAdjacency';
-- UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_HolySiteAdjacency';
-- UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_IndustrialZoneAdjacency';
-- UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_TheaterAdjacency';
-- Nubian Pyramid -1 food (to avoid +4 foods tile)
-- 01/12/24 removed
-- UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_PYRAMID' AND YieldType='YIELD_FOOD';

-- Nubian district gets standard adjacency from nubian pyramid
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement) VALUES
    ('BBG_PYRAMID_DISTRICT_SCIENCE', 'LOC_BBG_PYRAMID_DISTRICT_SCIENCE_DESC', 'YIELD_SCIENCE', 1, 1, 'IMPROVEMENT_PYRAMID'),
    ('BBG_PYRAMID_DISTRICT_PRODUCTION', 'LOC_BBG_PYRAMID_DISTRICT_PRODUCTION_DESC', 'YIELD_PRODUCTION', 1, 1, 'IMPROVEMENT_PYRAMID'),
    ('BBG_PYRAMID_DISTRICT_CULTURE', 'LOC_BBG_PYRAMID_DISTRICT_CULTURE_DESC', 'YIELD_CULTURE', 1, 1, 'IMPROVEMENT_PYRAMID'),
    ('BBG_PYRAMID_DISTRICT_FAITH', 'LOC_BBG_PYRAMID_DISTRICT_FAITH_DESC', 'YIELD_FAITH', 1, 1, 'IMPROVEMENT_PYRAMID'),
    ('BBG_PYRAMID_DISTRICT_GOLD', 'LOC_BBG_PYRAMID_DISTRICT_GOLD_DESC', 'YIELD_GOLD', 1, 1, 'IMPROVEMENT_PYRAMID');
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_CAMPUS', 'BBG_PYRAMID_DISTRICT_SCIENCE'),
    ('DISTRICT_INDUSTRIAL_ZONE', 'BBG_PYRAMID_DISTRICT_PRODUCTION'),
    ('DISTRICT_THEATER', 'BBG_PYRAMID_DISTRICT_CULTURE'),
    ('DISTRICT_HOLY_SITE', 'BBG_PYRAMID_DISTRICT_FAITH'),
    ('DISTRICT_COMMERCIAL_HUB', 'BBG_PYRAMID_DISTRICT_GOLD'),
    ('DISTRICT_HARBOR', 'BBG_PYRAMID_DISTRICT_GOLD');

-- Encampment and Aerodrome give +1 production to Pyramid, Diplo Quarter and Gov Plaza give +1 culture/2 gold
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('BBG_PYRAMID_GOV_CULTURE', 'Placeholder', 'YIELD_CULTURE', 1, 1, 'DISTRICT_GOVERNMENT'),
    ('BBG_PYRAMID_DIPLO_CULTURE', 'Placeholder', 'YIELD_CULTURE', 1, 1, 'DISTRICT_DIPLOMATIC_QUARTER'),
    ('BBG_PYRAMID_GOV_GOLD', 'Placeholder', 'YIELD_GOLD', 2, 1, 'DISTRICT_GOVERNMENT'),
    ('BBG_PYRAMID_DIPLO_GOLD', 'Placeholder', 'YIELD_GOLD', 2, 1, 'DISTRICT_DIPLOMATIC_QUARTER'),
    ('BBG_PYRAMID_ENCAMPMENT_PROD', 'Placeholder', 'YIELD_PRODUCTION', 1, 1, 'DISTRICT_ENCAMPMENT'),
    ('BBG_PYRAMID_AERODROME_PROD', 'Placeholder', 'YIELD_PRODUCTION', 1, 1, 'DISTRICT_AERODROME');
INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_GOV_CULTURE'),
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_DIPLO_CULTURE'),
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_GOV_GOLD'),
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_DIPLO_GOLD'),
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_ENCAMPMENT_PROD'),
    ('IMPROVEMENT_PYRAMID', 'BBG_PYRAMID_AERODROME_PROD');