
-- 23/04/2021 iElden: Implemented by Firaxis
--DELETE FROM ModifierArguments WHERE ModifierId='TRAIT_CULTURE_FROM_INTERNATIONAL_TRADE_ROUTES';
--INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--    ('TRAIT_CULTURE_FROM_INTERNATIONAL_TRADE_ROUTES', 'YieldType', 'YIELD_CULTURE'),
--    ('TRAIT_CULTURE_FROM_INTERNATIONAL_TRADE_ROUTES', 'Amount', 2);
--
--DELETE FROM ModifierArguments WHERE ModifierId='TRAIT_CULTURE_FROM_INCOMING_TRADE_ROUTES';
--INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--    ('TRAIT_CULTURE_FROM_INCOMING_TRADE_ROUTES', 'YieldType', 'YIELD_CULTURE'),
--    ('TRAIT_CULTURE_FROM_INCOMING_TRADE_ROUTES', 'Amount', 2);

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_CULTURE_TO_INTERNATIONAL_TRADE_ROUTES', 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_CULTURE_TO_INTERNATIONAL_TRADE_ROUTES', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_CULTURE_TO_INTERNATIONAL_TRADE_ROUTES', 'Amount', '1'),
    ('BBG_CULTURE_TO_INTERNATIONAL_TRADE_ROUTES', 'Domestic', '0');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_RADIO_ORANJE', 'BBG_CULTURE_TO_INTERNATIONAL_TRADE_ROUTES');

UPDATE StartBiasRivers SET Tier=2 WHERE CivilizationType='CIVILIZATION_NETHERLANDS';
UPDATE StartBiasTerrains SET Tier=3 WHERE CivilizationType='CIVILIZATION_NETHERLANDS' AND TerrainType='TERRAIN_COAST';

-- Polder
INSERT INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement, AdjacentDistrict, ObsoleteTech) VALUES
    ('BBG_Polder_production_polder', 'Placeholder', 'YIELD_PRODUCTION', 1, 2, 'IMPROVEMENT_POLDER', NULL, 'TECH_REPLACEABLE_PARTS'),
    ('BBG_Polder_production_harbor', 'Placeholder', 'YIELD_PRODUCTION', 1, 1, NULL, 'DISTRICT_HARBOR', NULL);
INSERT INTO Improvement_Adjacencies(ImprovementType, YieldChangeId) VALUES
    ('IMPROVEMENT_POLDER', 'BBG_Polder_production_polder'),
    ('IMPROVEMENT_POLDER', 'BBG_Polder_production_harbor');
