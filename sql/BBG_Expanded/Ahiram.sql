-- ========================================================================
-- =                              AHIRAM                                  =
-- ========================================================================

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_AHIRAM_TRADEROUTE_LUXURY_PROD', 'MODIFIER_PLAYER_CITIES_TRADE_ROUTE_YIELD_PER_LOCAL_LUXURY_RESOURCE_FOR_INTERNATIONAL'),
    ('BBG_AHIRAM_TRADEROUTE_LUXURY_GOLD', 'MODIFIER_PLAYER_CITIES_TRADE_ROUTE_YIELD_PER_LOCAL_LUXURY_RESOURCE_FOR_INTERNATIONAL');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_AHIRAM_TRADEROUTE_LUXURY_PROD', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_AHIRAM_TRADEROUTE_LUXURY_PROD', 'Amount', 0.5),
    ('BBG_AHIRAM_TRADEROUTE_LUXURY_GOLD', 'YieldType', 'YIELD_GOLD'),
    ('BBG_AHIRAM_TRADEROUTE_LUXURY_GOLD', 'Amount', 2);

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES', 'BBG_AHIRAM_TRADEROUTE_LUXURY_PROD'),
    ('TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES', 'BBG_AHIRAM_TRADEROUTE_LUXURY_GOLD');


-- ==========================================================
-- =                      ROYAL TOMB                        =
-- ==========================================================

DELETE FROM TraitModifiers WHERE TraitType='MOD_LIME_ATTACH_TOMB_SCIENCE_BUFF';

UPDATE Buildings SET Maintenance=0 WHERE BuildingType='LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB';