--==============================================================
--******                RELIGION                          ******
--==============================================================
-- Monks: Relax Requirement to Shrine
DELETE FROM Unit_BuildingPrereqs
    WHERE Unit = 'UNIT_WARRIOR_MONK' AND PrereqBuilding = 'BUILDING_PRASAT';


--=======================================================================
--******                       CITY STATE                          ******
--=======================================================================

-- Bandar Brunei +2 golds flat for external
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MINOR_CIV_JAKARTA_UNIQUE_INFLUENCE_BONUS_GOLD', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_IS_SUZERAIN'),
    ('BBG_MINOR_CIV_JAKARTA_GOLD_BONUS', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL', NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MINOR_CIV_JAKARTA_UNIQUE_INFLUENCE_BONUS_GOLD', 'ModifierId', 'BBG_MINOR_CIV_JAKARTA_GOLD_BONUS'),
    ('BBG_MINOR_CIV_JAKARTA_GOLD_BONUS', 'YieldType', 'YIELD_GOLD'),
    ('BBG_MINOR_CIV_JAKARTA_GOLD_BONUS', 'Amount', '2');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('MINOR_CIV_JAKARTA_TRAIT', 'BBG_MINOR_CIV_JAKARTA_UNIQUE_INFLUENCE_BONUS_GOLD');


--=======================================================================
--******                         WONDERS                           ******
--=======================================================================
INSERT INTO WonderTerrainFeature_BBG(WonderType, TerrainClassType, FeatureType, Other) VALUES
    ('FEATURE_HA_LONG_BAY', NULL, NULL, 'WATER');