--==================
-- Maori
--==================
--(5.2.5) revert pop on settle
--DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_KUPES_VOYAGE' AND ModifierId='POPULATION_PRESETTLEMENT';
--(5.2.5) revert remove builder
-- DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_KUPES_VOYAGE' AND ModifierId='BUILDER_PRESETTLEMENT';

UPDATE Modifiers SET SubjectRequirementSetId='UNIT_IS_DOMAIN_LAND' WHERE ModifierId='TRAIT_MAORI_MANA_OCEAN';
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('VARU_ADJACENT_AT_WAR_REQUIREMENTS', 'REQUIRES_UNIT_IS_DOMAIN_LAND');
-- UPDATE Units SET Maintenance=2, Combat=40 WHERE UnitType='UNIT_MAORI_TOA';

-- Delay bonus production
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_PLOT_HAS_FOREST_EARLY_EMPIRE', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_PLOT_HAS_JUNGLE_EARLY_EMPIRE', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_PLOT_HAS_FOREST_EARLY_EMPIRE', 'BBG_UTILS_PLAYER_HAS_EARLY_EMPIRE_REQUIREMENT'),
    ('BBG_PLOT_HAS_FOREST_EARLY_EMPIRE', 'PLOT_IS_FOREST_REQUIREMENT'),
    ('BBG_PLOT_HAS_FOREST_EARLY_EMPIRE', 'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
    ('BBG_PLOT_HAS_JUNGLE_EARLY_EMPIRE', 'BBG_UTILS_PLAYER_HAS_EARLY_EMPIRE_REQUIREMENT'),
    ('BBG_PLOT_HAS_JUNGLE_EARLY_EMPIRE', 'PLOT_IS_JUNGLE_REQUIREMENT'),
    ('BBG_PLOT_HAS_JUNGLE_EARLY_EMPIRE', 'REQUIRES_PLOT_HAS_NO_IMPROVEMENT');
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_UTILS_PLAYER_HAS_EARLY_EMPIRE_REQUIREMENT', 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_UTILS_PLAYER_HAS_EARLY_EMPIRE_REQUIREMENT', 'CivicType', 'CIVIC_EARLY_EMPIRE');

UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLOT_HAS_FOREST_EARLY_EMPIRE' WHERE ModifierId='TRAIT_MAORI_PRODUCTION_WOODS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLOT_HAS_JUNGLE_EARLY_EMPIRE' WHERE ModifierId='TRAIT_MAORI_PRODUCTION_RAINFOREST';



-- Complete reset to vanilla +
-- spawn on coast like other naval civ x
-- settler can embark at sailing 
-- land units in water get 2 extra movement at ship building x
-- no longer free builder or 2pop in capital x
-- no longer sailing and shipbuilding unlocked at start of the game x

-- 15/10/23 Maori does not start on ocean
UPDATE Leaders_XP2 SET OceanStart=0 WHERE LeaderType='LEADER_KUPE';
INSERT INTO StartBiasTerrains (CivilizationType, TerrainType, Tier) VALUES
    ('CIVILIZATION_MAORI', 'TERRAIN_COAST', '1');

-- 15/10/23 no pop/builder on settle
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_KUPES_VOYAGE' AND ModifierId='POPULATION_PRESETTLEMENT';
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_KUPES_VOYAGE' AND ModifierId='BUILDER_PRESETTLEMENT';

-- 25/10/23 no science/culture before settling
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_KUPES_VOYAGE' AND ModifierId='SCIENCE_PRESETTLEMENT';
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_KUPES_VOYAGE' AND ModifierId='CULTURE_PRESETTLEMENT';

-- 15/10/23 no more embark earlier, free sailing/shipbuilding
DELETE FROM TraitModifiers WHERE ModifierId IN ('TRAIT_MAORI_MANA_OCEAN', 'TRAIT_MAORI_MANA_SAILING', 'TRAIT_MAORI_MANA_SHIPBUILDING');

-- 15/10/23 bonus movement points at shipbuilding
UPDATE Modifiers SET OwnerRequirementSetId='BBG_UTILS_PLAYER_HAS_TECH_SHIPBUILDING' WHERE ModifierId='TRAIT_MAORI_EMBARKED_ABILITY';

-- 15/10/23 settler can embark at sailing
INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) VALUES
    ('BBG_MAORI_EARLY_SETTLER_NAVIGATION', 'MODIFIER_PLAYER_ADJUST_EMBARK_UNIT_PASS', 'BBG_UTILS_PLAYER_HAS_TECH_SAILING');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MAORI_EARLY_SETTLER_NAVIGATION', 'UnitType', 'UNIT_SETTLER');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_MAORI_MANA', 'BBG_MAORI_EARLY_SETTLER_NAVIGATION');