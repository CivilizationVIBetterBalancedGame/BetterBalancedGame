-- ========================================================================
-- =                            SWAHILI                                   =
-- ========================================================================

-- Start bias
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_SUK_SWAHILI';
DELETE FROM StartBiasFeatures WHERE CivilizationType='CIVILIZATION_SUK_SWAHILI';
INSERT INTO StartBiasTerrains (CivilizationType, TerrainType, Tier) VALUES
    ('CIVILIZATION_SUK_SWAHILI', 'TERRAIN_COAST', 1);

-- 30/07/25 No more adjacency shenanigans
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION' AND ModifierId IS NOT 'TRAIT_SUK_SWAHILI_REEF_PRODUCTION';

-- 30/07/25 Reef bonus production +1 at sailing on unimproved tiles only
UPDATE ModifierArguments SET Value=1 WHERE ModifierId='TRAIT_SUK_SWAHILI_REEF_PRODUCTION' AND Name='Amount';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_REEF_UNIMPROVED_SAILING_REQSET' WHERE ModifierId='TRAIT_SUK_SWAHILI_REEF_PRODUCTION';
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_REEF_UNIMPROVED_SAILING_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_REEF_UNIMPROVED_SAILING_REQSET', 'REQUIRES_PLOT_HAS_REEF'),
    ('BBG_REEF_UNIMPROVED_SAILING_REQSET', 'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
    ('BBG_REEF_UNIMPROVED_SAILING_REQSET', 'BBG_UTILS_PLAYER_HAS_TECH_SAILING_REQUIREMENT');

-- 30/07/25 Coastal cities receive 25% production toward districts
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_SWAHILI_DISTRICT_COASTAL_CITY', 'MODIFIER_PLAYER_CITIES_ADJUST_ALL_DISTRICTS_PRODUCTION', 'PLOT_IS_OR_ADJACENT_TO_COAST');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_SWAHILI_DISTRICT_COASTAL_CITY', 'Amount', 25);
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION', 'BBG_SWAHILI_DISTRICT_COASTAL_CITY');


-- ==========================================================
-- =                        JAHAZI                          =
-- ==========================================================

INSERT INTO UnitCaptures (CapturedUnitType, BecomesUnitType) VALUES
    ('UNIT_SUK_JAHAZI', 'UNIT_SUK_JAHAZI');

UPDATE ModifierArguments SET Value='YIELD_GOLD' WHERE Name='YieldType' AND ModifierId='SUK_JAHAZI_YIELD_BONUS';
UPDATE ModifierArguments SET Value=3 WHERE Name='Amount' AND ModifierId='SUK_JAHAZI_YIELD_BONUS';

-- ==========================================================
-- =                     PILLAR TOMB                        =
-- ==========================================================

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_SUK_PILLAR_TOMB', 'MONUMENT_CULTURE_AT_FULL_LOYALTY');

UPDATE Buildings SET Cost=50 WHERE BuildingType='BUILDING_SUK_PILLAR_TOMB';


-- ========================================================================
-- =                             AL HASAN                                 =
-- ========================================================================

DELETE FROM TraitModifiers WHERE ModifierId='SUK_HUSUNI_KUBWA_PATRONAGE_DISCOUNT' AND TraitType='TRAIT_LEADER_SUK_HUSUNI_KUBWA';