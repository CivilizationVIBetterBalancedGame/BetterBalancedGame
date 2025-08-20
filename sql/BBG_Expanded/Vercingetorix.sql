-- ========================================================================
-- =                           VERCINGETORIX                              =
-- ========================================================================

-- 30/07/25 Vercingetorix gets the culture on mine
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_SUK_GALLIC_WAR', 'GAUL_MINE_CULTURE');

-- Delay culture to bronze working
UPDATE Modifiers SET OwnerRequirementSetId='BBG_UTILS_PLAYER_HAS_TECH_BRONZE_WORKING' WHERE ModifierId='GAUL_MINE_CULTURE';

    
-- 30/07/25 envoy from great engineer
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_UNIT_IS_GREAT_ENGINEER', 'REQUIREMENT_GREAT_PERSON_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_UNIT_IS_GREAT_ENGINEER', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_IS_GREAT_ENGINEER_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_IS_GREAT_ENGINEER_REQSET', 'BBG_UNIT_IS_GREAT_ENGINEER');
UPDATE Modifiers SET SubjectRequirementSetId='BBG_UNIT_IS_GREAT_ENGINEER_REQSET' WHERE ModifierId='SUK_GALLIC_WAR_ENVOY';

-- 30/07/25 Remove free walls
DELETE FROM TraitModifiers WHERE ModifierId='SUK_GALLIC_WAR_FREE_WALLS_DISTRICTS';

-- 30/07/25 Workshop give 1 influence point
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_VERCINGETORIX_INFLUENCE_WORKSHOP', 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN', 'SUK_GALLIC_WAR_FREE_WALLS_IS_VERCINGETORIX_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_VERCINGETORIX_INFLUENCE_WORKSHOP', 'Amount', 1);
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
    ('BUILDING_WORKSHOP', 'BBG_VERCINGETORIX_INFLUENCE_WORKSHOP');


DELETE FROM TraitModifiers WHERE ModifierId LIKE 'SUK_GALLIC_WAR_COMBAT_LEADER_MINOR_CIV_%';
DELETE FROM TraitModifiers WHERE ModifierId='SUK_GALLIC_WAR_COMBAT_ABILTIY';