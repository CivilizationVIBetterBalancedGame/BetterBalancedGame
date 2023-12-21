-- by: iElden

-- Portugal UI (Feitora) nerf
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRADE_GOLD_FROM_FEITORIA' AND Name='Amount';

-- Trade route only give gold yield multiplier.
-- UPDATE ModifierArguments SET Value='0, 0, 0, 0, 50, 0' WHERE ModifierId='TRAIT_INTERNATIONAL_TRADE_GAIN_ALL_YIELDS' AND Name='Amount';

-- Remove trade route on meet
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_JOAO_III' AND ModifierId='TRAIT_JOAO_TRADE_ROUTE_ON_MEET';

-- ===Give 1 traderoute per era===

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId, RunOnce, Permanent)
    SELECT 'BBG_GRANT_TRADE_ROUTE_ON_' || EraType, 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 'BBG_GAME_IS_IN_' || EraType || '_REQUIREMENTS', 1, 1
    FROM Eras;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_GRANT_TRADE_ROUTE_ON_' || EraType, 'Amount', '1'
    FROM Eras;

INSERT INTO TraitModifiers(TraitType, ModifierId)
    SELECT 'TRAIT_LEADER_JOAO_III', 'BBG_GRANT_TRADE_ROUTE_ON_' || EraType
    FROM Eras;

-- 15/06/23 50% bonus yields on trade routes at Carto (gold), Medieval (culture), Education (science)
INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) VALUES
    ('BBG_PORTUGAL_GAIN_GOLD_ON_INTERNATIONAL_CARTOGRAPHY', 'MODIFIER_PLAYER_ADJUST_INTERNATIONAL_TRADE_ROUTE_YIELD_MODIFIER_WARLORDS', 'BBG_UTILS_PLAYER_HAS_TECH_CARTOGRAPHY'),
    ('BBG_PORTUGAL_GAIN_SCIENCE_ON_INTERNATIONAL_EDUCATION', 'MODIFIER_PLAYER_ADJUST_INTERNATIONAL_TRADE_ROUTE_YIELD_MODIFIER_WARLORDS', 'BBG_UTILS_PLAYER_HAS_TECH_EDUCATION'),
    ('BBG_PORTUGAL_GAIN_CULTURE_ON_INTERNATIONAL_MEDIEVAL_FAIRES', 'MODIFIER_PLAYER_ADJUST_INTERNATIONAL_TRADE_ROUTE_YIELD_MODIFIER_WARLORDS', 'BBG_UTILS_PLAYER_HAS_CIVIC_MEDIEVAL_FAIRES_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_PORTUGAL_GAIN_GOLD_ON_INTERNATIONAL_CARTOGRAPHY', 'YieldType', 'YIELD_GOLD'),
    ('BBG_PORTUGAL_GAIN_GOLD_ON_INTERNATIONAL_CARTOGRAPHY', 'Amount', '50'),
    ('BBG_PORTUGAL_GAIN_SCIENCE_ON_INTERNATIONAL_EDUCATION', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_PORTUGAL_GAIN_SCIENCE_ON_INTERNATIONAL_EDUCATION', 'Amount', '50'),
    ('BBG_PORTUGAL_GAIN_CULTURE_ON_INTERNATIONAL_MEDIEVAL_FAIRES', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_PORTUGAL_GAIN_CULTURE_ON_INTERNATIONAL_MEDIEVAL_FAIRES', 'Amount', '50');
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_INTERNATIONAL_TRADE_GAIN_ALL_YIELDS';
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_PORTUGAL', 'BBG_PORTUGAL_GAIN_GOLD_ON_INTERNATIONAL_CARTOGRAPHY'),
    ('TRAIT_CIVILIZATION_PORTUGAL', 'BBG_PORTUGAL_GAIN_SCIENCE_ON_INTERNATIONAL_EDUCATION'),
    ('TRAIT_CIVILIZATION_PORTUGAL', 'BBG_PORTUGAL_GAIN_CULTURE_ON_INTERNATIONAL_MEDIEVAL_FAIRES');

-- === Etemenanki ===
UPDATE ModifierArguments SET Value=1 WHERE ModifierId='ETEMENANKI_SCIENCE_MARSH' AND Name='Amount';

-- 18/12/23 Etemenanki science needs tile to be improved
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_TILE_IS_IMPROVED_GRASS_FLOODPLAIN_REQSET', 'REQUIREMENTSET_TEST_ALL'),
    ('BBG_TILE_IS_IMPROVED_PLAINS_FLOODPLAIN_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_TILE_IS_IMPROVED_GRASS_FLOODPLAIN_REQSET', 'REQUIRES_PLOT_HAS_GRASS_FLOODPLAINS'),
    ('BBG_TILE_IS_IMPROVED_GRASS_FLOODPLAIN_REQSET', 'REQUIRES_PLOT_HAS_FARM'),
    ('BBG_TILE_IS_IMPROVED_PLAINS_FLOODPLAIN_REQSET', 'REQUIRES_PLOT_HAS_PLAINS_FLOODPLAINS'),
    ('BBG_TILE_IS_IMPROVED_PLAINS_FLOODPLAIN_REQSET', 'REQUIRES_PLOT_HAS_FARM');
UPDATE Modifiers SET SubjectRequirementSetId='BBG_TILE_IS_IMPROVED_GRASS_FLOODPLAIN_REQSET' WHERE ModifierId='ETEMENANKI_SCIENCE_GRASS_FLOODPLAINS';
UPDATE Modifiers SET SubjectRequirementSetId='BBG_TILE_IS_IMPROVED_PLAINS_FLOODPLAIN_REQSET' WHERE ModifierId='ETEMENANKI_SCIENCE_PLAINS_FLOODPLAINS';

--19/12/23 Naval support only from naval units (see Base/Units.sql)
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_ABILITY_SUPPORT_NAVAL_MELEE', 'BBG_ABILITY_SUPPORT_NAVAL_MELEE_UNIT_PORTUGUESE_NAU_MODIFIER');
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
    ('BBG_ABILITY_SUPPORT_NAVAL_MELEE_UNIT_PORTUGUESE_NAU_MODIFIER', 'GRANT_STRENGTH_PER_ADJACENT_UNIT_TYPE', 'BBG_UNIT_PORTUGUESE_NAU_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_UNIT_IS_DEFENDER');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_ABILITY_SUPPORT_NAVAL_MELEE_UNIT_PORTUGUESE_NAU_MODIFIER', 'Amount', '2');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_ABILITY_SUPPORT_NAVAL_MELEE_UNIT_PORTUGUESE_NAU_MODIFIER', 'UnitType', 'UNIT_PORTUGUESE_NAU');
INSERT INTO ModifierStrings(ModifierId, Context, Text) SELECT
    'BBG_ABILITY_SUPPORT_NAVAL_MELEE_UNIT_PORTUGUESE_NAU_MODIFIER', 'Preview', '{'||Units.Name||'} : +{CalculatedAmount}' From Units WHERE UnitType='UNIT_PORTUGUESE_NAU';
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_UNIT_PORTUGUESE_NAU_IS_ADJACENT_REQ', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_UNIT_PORTUGUESE_NAU_IS_ADJACENT_REQ', 'UnitType', 'UNIT_PORTUGUESE_NAU');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_PORTUGUESE_NAU_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_PORTUGUESE_NAU_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_UNIT_PORTUGUESE_NAU_IS_ADJACENT_REQ');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_PORTUGUESE_NAU_IS_ADJACENT_AND_MILITARY_TRADITION_REQSET', 'BBG_UTILS_PLAYER_HAS_CIVIC_MILITARY_TRADITION_REQUIREMENT');
