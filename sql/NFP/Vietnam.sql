
-- UD Trigger culture bomb
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_THANH_CULTURE_BOMB', 'MODIFIER_ALL_PLAYERS_ADD_CULTURE_BOMB_TRIGGER');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_THANH_CULTURE_BOMB', 'DistrictType', 'DISTRICT_THANH'),
    ('BBG_THANH_CULTURE_BOMB', 'CaptureOwnedTerritory', '0');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_DISTRICT_THANH', 'BBG_THANH_CULTURE_BOMB');

-- Nerf UA
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='TRIEU_FRIENDLY_COMBAT' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRIEU_UNFRIENDLY_COMBAT' AND Name='Amount';
--16/04/23 delete combat bonus outside own territory
--25/10/23 cancel nerf on combat bonus outside own territory
--DELETE FROM UnitAbilityModifiers WHERE ModifierId='TRIEU_UNFRIENDLY_COMBAT';

-- Nerf PM of UU
UPDATE Units SET BaseMoves=2 WHERE UnitType='UNIT_VIETNAMESE_VOI_CHIEN';

--Update citizen yield to match BBG Change
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' AND DistrictType='DISTRICT_THANH';

-- Start Bias
UPDATE StartBiasFeatures SET Tier=3 WHERE CivilizationType='CIVILIZATION_VIETNAM' AND FeatureType IN ('FEATURE_JUNGLE', 'FEATURE_FOREST', 'FEATURE_MARSH');

-- 14/10 discount reduced to 35% (20 for diplo quarter) and unique district to 55%
UPDATE Districts SET CostProgressionParam1=35 WHERE DistrictType='DISTRICT_THANH';
UPDATE Districts SET Cost=30 WHERE DistrictType='DISTRICT_THANH';

-- 03/07/24 Vietnam nerf extra 1 movement in neutral/ennemy territory, only for voi chien
-- 01/12/24 1 movement 2 cs everywhere (not doubled in ennemy territory) and removed for voi chien
-- 15/12/24 reverted to 03/07/24 state
UPDATE UnitAbilityModifiers SET UnitAbilityType='ABILITY_VOI_CHIEN' WHERE ModifierId='TRIEU_UNFRIENDLY_MOVEMENT';

-- 15/12/24 Vietnam can now build specialty districts on floodplains
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_VIETNAM_DISTRICT_FLOODPLAINS_DESERT_ONLY', 'MODIFIER_PLAYER_ADJUST_FEAUTE_REQUIRED_FOR_SPECIALTY_DISTRICTS', NULL),
    ('BBG_VIETNAM_DISTRICT_FLOODPLAINS_PLAIN_ONLY', 'MODIFIER_PLAYER_ADJUST_FEAUTE_REQUIRED_FOR_SPECIALTY_DISTRICTS', NULL),
    ('BBG_VIETNAM_DISTRICT_FLOODPLAINS_GRASS_ONLY', 'MODIFIER_PLAYER_ADJUST_FEAUTE_REQUIRED_FOR_SPECIALTY_DISTRICTS', NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_VIETNAM_DISTRICT_FLOODPLAINS_DESERT_ONLY', 'FeatureType', 'FEATURE_FLOODPLAINS'),
    ('BBG_VIETNAM_DISTRICT_FLOODPLAINS_PLAIN_ONLY', 'FeatureType', 'FEATURE_FLOODPLAINS_PLAINS'),
    ('BBG_VIETNAM_DISTRICT_FLOODPLAINS_GRASS_ONLY', 'FeatureType', 'FEATURE_FLOODPLAINS_GRASSLAND');

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_VIETNAM', 'BBG_VIETNAM_DISTRICT_FLOODPLAINS_DESERT_ONLY'),
    ('TRAIT_CIVILIZATION_VIETNAM', 'BBG_VIETNAM_DISTRICT_FLOODPLAINS_PLAIN_ONLY'),
    ('TRAIT_CIVILIZATION_VIETNAM', 'BBG_VIETNAM_DISTRICT_FLOODPLAINS_GRASS_ONLY');

-- 30/03/25 Combat bonus now works on gdr
INSERT INTO TypeTags (Type, Tag) VALUES
    ('ABILITY_TRIEU_FEATURES', 'CLASS_GIANT_DEATH_ROBOT');