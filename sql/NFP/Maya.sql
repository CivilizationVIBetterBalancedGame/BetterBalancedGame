-- reduce combat bonus to 3 from 5
--16/04/23 Remove combat bonus
-- UPDATE ModifierArguments SET Value='3' WHERE ModifierId='MUTAL_NEAR_CAPITAL_COMBAT' AND Name='Amount';
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_LEADER_NEARBY_CITIES_GAIN_ABILITY';
-- set citizen yields to same as other campuses
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' AND DistrictType='DISTRICT_OBSERVATORY';
--- start biases ---
-- after coastals and tundra and desert; delete non-plantation lux biases; add banana bias; make flat land bias last priority
INSERT OR REPLACE INTO StartBiasResources(CivilizationType, ResourceType, Tier) VALUES
    ('CIVILIZATION_MAYA', 'RESOURCE_CITRUS', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_COFFEE', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_COCOA', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_COTTON', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_DYES', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_SILK', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_SPICES', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_SUGAR', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_TEA', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_TOBACCO', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_WINE', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_INCENSE', 3),
    --('CIVILIZATION_MAYA', 'RESOURCE_OLIVES', 3),
    ('CIVILIZATION_MAYA', 'RESOURCE_BANANAS', 4);

DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_GYPSUM';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_JADE';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_MARBLE';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_MERCURY';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_SALT';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_IVORY';

-- Delete StartBiasTerrain
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_MAYA';

-- 15/05/2021: Delete free builder
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_MUTAL' AND ModifierId='TRAIT_LEADER_NEARBY_CITIES_GAIN_BUILDER';

-- 24/04/23 Reduced bonus/malus to cities
UPDATE ModifierArguments SET Value='5, 5, 5, 5, 5, 5' WHERE ModifierId='TRAIT_LEADER_NEARBY_CITIES_GAIN_YIELDS' AND Name='Amount';
UPDATE ModifierArguments SET Value='-10, -10, -10, -10, -10, -10' WHERE ModifierId='TRAIT_LEADER_NEARBY_CITIES_LOSE_YIELDS' AND Name='Amount';

-- Monks: Maya CS
INSERT INTO TypeTags(Type, Tag) Values
    ('ABILITY_MUTAL_COMBAT_STRENGTH_NEAR_CAPITAL', 'CLASS_WARRIOR_MONK');
