--==========
-- Nubia
--==========
INSERT OR IGNORE INTO Improvement_ValidFeatures (ImprovementType , FeatureType)
	VALUES
	('IMPROVEMENT_PYRAMID' , 'FEATURE_FLOODPLAINS_GRASSLAND'),
	('IMPROVEMENT_PYRAMID' , 'FEATURE_FLOODPLAINS_PLAINS');



--==============================================================
--******			W O N D E R S  (MAN-MADE)			  ******
--==============================================================
-- Jebel Barkal bugfix
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='JEBELBARKAL_GRANT_FOUR_IRON_PER_TURN' AND Name='Amount';



-- 30/06/25 Jebel rework
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_JEBEL_BARKAL';
UPDATE Buildings SET RegionalRange=0 WHERE BuildingType='BUILDING_JEBEL_BARKAL';
DELETE FROM Building_YieldChanges WHERE BuildingType='BUILDING_JEBEL_BARKAL';
-- Must be built on a hill next to an improved iron tile 
INSERT INTO Building_ValidTerrains (BuildingType, TerrainType) VALUES
	('BUILDING_JEBEL_BARKAL', 'TERRAIN_GRASS_HILLS'),
	('BUILDING_JEBEL_BARKAL', 'TERRAIN_PLAINS_HILLS'),
	('BUILDING_JEBEL_BARKAL', 'TERRAIN_TUNDRA_HILLS'),
	('BUILDING_JEBEL_BARKAL', 'TERRAIN_SNOW_HILLS');
UPDATE Buildings SET AdjacentImprovement='IMPROVEMENT_MINE', AdjacentResource='RESOURCE_IRON' WHERE BuildingType='BUILDING_JEBEL_BARKAL';
-- +6 iron per turn (no change)
-- Cost reduced to 145 (from 200)
UPDATE Buildings SET Cost=290 WHERE BuildingType='BUILDING_JEBEL_BARKAL';
-- Improved strategics resources 4 tiles around it give +1 amenity
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_HAS_JEBEL_WITHIN_4', 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_HAS_JEBEL_WITHIN_4', 'BuildingType', 'BUILDING_JEBEL_BARKAL'),
    ('BBG_REQUIRES_PLOT_HAS_JEBEL_WITHIN_4', 'MinRange', 0),
    ('BBG_REQUIRES_PLOT_HAS_JEBEL_WITHIN_4', 'MaxRange', 4);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_REQUIRES_STRATEGIC_PLOT_HAS_JEBEL_WITHIN_4_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_REQUIRES_STRATEGIC_PLOT_HAS_JEBEL_WITHIN_4_REQSET', 'BBG_REQUIRES_PLOT_HAS_JEBEL_WITHIN_4'),
    ('BBG_REQUIRES_STRATEGIC_PLOT_HAS_JEBEL_WITHIN_4_REQSET', 'REQUIRES_PLOT_HAS_IMPROVED_STRATEGIC');


INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_JEBEL_BARKAL_AMENITY_STRATEGICS', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY', 'BBG_REQUIRES_STRATEGIC_PLOT_HAS_JEBEL_WITHIN_4_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_JEBEL_BARKAL_AMENITY_STRATEGICS', 'Amount', 1);
INSERT INTO ImprovementModifiers (ImprovementType, ModifierID) VALUES
	('IMPROVEMENT_MINE', 'BBG_JEBEL_BARKAL_AMENITY_STRATEGICS'),
	('IMPROVEMENT_OIL_WELL', 'BBG_JEBEL_BARKAL_AMENITY_STRATEGICS'),
	('IMPROVEMENT_OFFSHORE_OIL_RIG', 'BBG_JEBEL_BARKAL_AMENITY_STRATEGICS'),
	('IMPROVEMENT_PASTURE', 'BBG_JEBEL_BARKAL_AMENITY_STRATEGICS');

