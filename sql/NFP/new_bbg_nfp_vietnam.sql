
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

-- Nerf PM of UU
UPDATE Units SET BaseMoves=2 WHERE UnitType='UNIT_VIETNAMESE_VOI_CHIEN';

--Update citizen yield to match BBG Change
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' AND DistrictType='DISTRICT_THANH';

-- Start Bias
UPDATE StartBiasTerrains SET Tier=3 WHERE CivilizationType='CIVILIZATION_VIETNAM' AND TerrainType IN ('FEATURE_JUNGLE', 'FEATURE_FOREST', 'FEATURE_MARSH');