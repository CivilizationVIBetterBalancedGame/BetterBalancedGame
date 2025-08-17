-- ========================================================================
-- =                             THULE                                    =
-- ========================================================================

-- Start bias
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_LIME_THULE';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_LIME_THULE';
INSERT INTO StartBiasTerrains (CivilizationType, TerrainType, Tier) VALUES
    ('CIVILIZATION_LIME_THULE', 'TERRAIN_TUNDRA', 1),
    ('CIVILIZATION_LIME_THULE', 'TERRAIN_TUNDRA_HILLS', 1),
    ('CIVILIZATION_LIME_THULE', 'TERRAIN_COAST', 2);

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_TILE_NEXT_WBH','REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_TILE_NEXT_WBH', 'ImprovementType', 'IMPROVEMENT_LIME_THULE_WBH');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_TILE_NEXT_WBH_TUNDRA_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_TILE_NEXT_WBH_TUNDRA_HILLS_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_TILE_NEXT_WBH_SNOW_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_TILE_NEXT_WBH_SNOW_HILLS_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_TILE_NEXT_WBH_TUNDRA_REQSET', 'BBG_TILE_NEXT_WBH'), 
    ('BBG_TILE_NEXT_WBH_TUNDRA_REQSET', 'REQUIRES_PLOT_HAS_TUNDRA'), 
    ('BBG_TILE_NEXT_WBH_TUNDRA_HILLS_REQSET', 'BBG_TILE_NEXT_WBH'), 
    ('BBG_TILE_NEXT_WBH_TUNDRA_HILLS_REQSET', 'REQUIRES_PLOT_HAS_TUNDRA_HILLS'), 
    ('BBG_TILE_NEXT_WBH_SNOW_REQSET', 'BBG_TILE_NEXT_WBH'), 
    ('BBG_TILE_NEXT_WBH_SNOW_REQSET', 'REQ_LIME_THULE_DAVE_SNOW'), 
    ('BBG_TILE_NEXT_WBH_SNOW_HILLS_REQSET', 'BBG_TILE_NEXT_WBH'), 
    ('BBG_TILE_NEXT_WBH_SNOW_HILLS_REQSET', 'REQ_LIME_THULE_DAVE_SNOW_HILLS');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_WBH_ADJACENT_FOOD_TUNDRA', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_TILE_NEXT_WBH_TUNDRA_REQSET'),
    ('BBG_WBH_ADJACENT_FOOD_TUNDRA_HILLS', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_TILE_NEXT_WBH_TUNDRA_HILLS_REQSET'),
    ('BBG_WBH_ADJACENT_FOOD_SNOW', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_TILE_NEXT_WBH_SNOW_REQSET'),
    ('BBG_WBH_ADJACENT_FOOD_SNOW_HILLS', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_TILE_NEXT_WBH_SNOW_HILLS_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_WBH_ADJACENT_FOOD_TUNDRA', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_ADJACENT_FOOD_TUNDRA', 'Amount', 1),
    ('BBG_WBH_ADJACENT_FOOD_TUNDRA_HILLS', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_ADJACENT_FOOD_TUNDRA_HILLS', 'Amount', 1),
    ('BBG_WBH_ADJACENT_FOOD_SNOW', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_ADJACENT_FOOD_SNOW', 'Amount', 2),
    ('BBG_WBH_ADJACENT_FOOD_SNOW_HILLS', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_ADJACENT_FOOD_SNOW_HILLS', 'Amount', 2);

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_ADJACENT_FOOD_TUNDRA'),
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_ADJACENT_FOOD_TUNDRA_HILLS'),
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_ADJACENT_FOOD_SNOW'),
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_ADJACENT_FOOD_SNOW_HILLS');

DELETE FROM Improvement_Adjacencies WHERE YieldChangeId IN ('Lime_WBH_FishingBoats_Food', 'Lime_WBH_FishingBoats_Production');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_WBH_CAMP_PROD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_CAMP_NEXT_WBH_REQSET'),
    ('BBG_WBH_CAMP_FOOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_CAMP_NEXT_WBH_REQSET'),
    ('BBG_WBH_FISHING_BOAT_PROD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_FISHING_BOAT_NEXT_WBH_REQSET'),
    ('BBG_WBH_FISHING_BOAT_FOOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_FISHING_BOAT_NEXT_WBH_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_WBH_CAMP_PROD', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_WBH_CAMP_PROD', 'Amount', 1),
    ('BBG_WBH_CAMP_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_CAMP_FOOD', 'Amount', 1),
    ('BBG_WBH_FISHING_BOAT_PROD', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_WBH_FISHING_BOAT_PROD', 'Amount', 1),
    ('BBG_WBH_FISHING_BOAT_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_FISHING_BOAT_FOOD', 'Amount', 1);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CAMP_NEXT_WBH_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_FISHING_BOAT_NEXT_WBH_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_CAMP_NEXT_WBH_REQSET', 'REQUIRES_PLOT_HAS_CAMP'), 
    ('BBG_CAMP_NEXT_WBH_REQSET', 'BBG_TILE_NEXT_WBH'), 
    ('BBG_FISHING_BOAT_NEXT_WBH_REQSET', 'BBG_TILE_NEXT_WBH'), 
    ('BBG_FISHING_BOAT_NEXT_WBH_REQSET', 'REQUIRES_PLOT_HAS_FISHINGBOATS');

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_CAMP_PROD'),
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_CAMP_FOOD'),
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_FISHING_BOAT_PROD'),
    ('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD', 'BBG_WBH_FISHING_BOAT_FOOD');

-- ==========================================================
-- =                        DOGSLED                         =
-- ==========================================================

DELETE FROM UnitReplaces WHERE CivUniqueUnitType='UNIT_LIME_THULE_DOGSLED';
INSERT INTO UnitReplaces (CivUniqueUnitType, ReplacesUnitType) VALUES
    ('UNIT_LIME_THULE_DOGSLED', 'UNIT_SCOUT');
DELETE FROM UnitUpgrades WHERE Unit='UNIT_LIME_THULE_DOGSLED';
INSERT INTO UnitUpgrades (Unit, UpgradeUnit) VALUES
    ('UNIT_LIME_THULE_DOGSLED', 'UNIT_SKIRMISHER');

-- 17/08/25 No longer has ranged attack
UPDATE Units SET BaseSightRange=2, Combat=10, RangedCombat=0, Range=0, Cost=30, BuildCharges=1, Maintenance=0, PrereqTech=NULL WHERE UnitType='UNIT_LIME_THULE_DOGSLED';
DELETE FROM UnitAbilityModifiers WHERE UnitAbilityType='ABIL_LIME_THULE_DOGSLED';
DELETE FROM UnitAbilities WHERE UnitAbilityType='ABIL_LIME_THULE_DOGSLED';
DELETE FROM TypeTags WHERE Type='ABIL_LIME_THULE_DOGSLED' AND Tag='CLASS_LIME_THULE_DOGSLED';
DELETE FROM Types WHERE Type='ABIL_LIME_THULE_DOGSLED';

INSERT INTO Improvement_ValidBuildUnits (ImprovementType, UnitType) VALUES
    ('IMPROVEMENT_LIME_THULE_WBH', 'UNIT_LIME_THULE_DOGSLED');

-- ==========================================================
-- =                       WB HOUSE                         =
-- ==========================================================

UPDATE Improvements SET PrereqTech=NULL, ValidAdjacentTerrainAmount=0, RequiresAdjacentBonusOrLuxury=1, TilesRequired=2, Housing=2 WHERE ImprovementType='IMPROVEMENT_LIME_THULE_WBH';
DELETE FROM Improvement_ValidAdjacentTerrains WHERE ImprovementType='IMPROVEMENT_LIME_THULE_WBH';

INSERT INTO Improvement_ValidFeatures (ImprovementType, FeatureType) VALUES
    ('IMPROVEMENT_LIME_THULE_WBH', 'FEATURE_FOREST');

INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_LIME_THULE_WBH', 'YIELD_FOOD', 0);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_TILE_IS_TUNDRA_OR_TUNDRA_HILL_REQSET', 'REQUIREMENTSET_TEST_ANY'),
    ('BBG_TILE_IS_SNOW_OR_SNOW_HILL_REQSET', 'REQUIREMENTSET_TEST_ANY');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_TILE_IS_TUNDRA_OR_TUNDRA_HILL_REQSET', 'REQUIRES_PLOT_HAS_TUNDRA'),
    ('BBG_TILE_IS_TUNDRA_OR_TUNDRA_HILL_REQSET', 'REQUIRES_PLOT_HAS_TUNDRA_HILLS'),
    ('BBG_TILE_IS_SNOW_OR_SNOW_HILL_REQSET', 'REQ_LIME_THULE_DAVE_SNOW'),
    ('BBG_TILE_IS_SNOW_OR_SNOW_HILL_REQSET', 'REQ_LIME_THULE_DAVE_SNOW_HILLS');    

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_WBH_FOOD_TUNDRA', 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'BBG_TILE_IS_TUNDRA_OR_TUNDRA_HILL_REQSET'),
    ('BBG_WBH_FOOD_SNOW', 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'BBG_TILE_IS_SNOW_OR_SNOW_HILL_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_WBH_FOOD_TUNDRA', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_FOOD_TUNDRA', 'Amount', 1),
    ('BBG_WBH_FOOD_SNOW', 'YieldType', 'YIELD_FOOD'),
    ('BBG_WBH_FOOD_SNOW', 'Amount', 2);

INSERT INTO ImprovementModifiers (ImprovementType, ModifierId) VALUES
    ('IMPROVEMENT_LIME_THULE_WBH', 'BBG_WBH_FOOD_TUNDRA'),
    ('IMPROVEMENT_LIME_THULE_WBH', 'BBG_WBH_FOOD_SNOW');

INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement) VALUES
    ('BBG_WBH_CULTURE_CAMP', 'Placeholder', 'YIELD_CULTURE', 1, 1, 'IMPROVEMENT_CAMP'),
    ('BBG_WBH_FAITH_CAMP', 'Placeholder', 'YIELD_FAITH', 1, 1, 'IMPROVEMENT_CAMP');

INSERT INTO Improvement_Adjacencies (ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_LIME_THULE_WBH', 'BBG_WBH_CULTURE_CAMP'),
    ('IMPROVEMENT_LIME_THULE_WBH', 'BBG_WBH_FAITH_CAMP');

UPDATE Improvement_Tourism SET PrereqTech='TECH_FLIGHT' WHERE ImprovementType='IMPROVEMENT_LIME_THULE_WBH';

-- cannot be placed next to each other
UPDATE Improvements SET SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_LIME_THULE_WBH';

-- ========================================================================
-- =                             KIVIUQ                                   =
-- ========================================================================

UPDATE ModifierArguments SET Value=5 WHERE ModifierId='LIME_RECON_STRONG' AND Name='Amount';