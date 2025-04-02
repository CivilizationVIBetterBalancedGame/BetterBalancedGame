--==============================================================
--******                C O N G R E S S                   ******
--==============================================================

UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_WORLD_IDEOLOGY';
UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_MIGRATION_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_GLOBAL_ENERGY_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_ESPIONAGE_PACT';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_HERITAGE_ORG';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_PUBLIC_WORKS';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_DEFORESTATION_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_MODERN' WHERE ResolutionType='WC_RES_ARMS_CONTROL';
DELETE FROM Resolutions WHERE ResolutionType='WC_RES_PUBLIC_RELATIONS';



DELETE FROM ModifierArguments WHERE ModifierId='APPLY_RES_UNIT_COMBAT_DEBUFF';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('APPLY_RES_UNIT_COMBAT_DEBUFF','ModifierId', 'WC_RES_UNIT_COMBAT_DEBUFF');

--================================================
--******             TradeRoute             ******
--================================================
-- 01/10/24 : A fix so it gives gold to the one that send the traderoute to the one that won the congress
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS' WHERE ModifierId='INCREASES_TRADE_TO_GOLD';

-- 15/07/2022: B now reduces golds for traders form/to target by 4 (possible negative)
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_TO_PLAYERS', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL'),
	('BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_FROM_PLAYERS', 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_APPLY_DECREASES_TRADE_TO_GOLD_TO_PLAYER', 'MODIFIER_CONGRESS_ATTACH_MODIFIER_TO_PLAYERTYPE'),
    ('BBG_APPLY_DECREASES_TRADE_TO_GOLD_FROM_PLAYER', 'MODIFIER_CONGRESS_ATTACH_MODIFIER_TO_PLAYERTYPE');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_TO_PLAYERS', 'YieldType', 'YIELD_GOLD'),
    ('BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_TO_PLAYERS', 'Amount', -4),
    ('BBG_APPLY_DECREASES_TRADE_TO_GOLD_TO_PLAYER', 'ModifierId', 'BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_TO_PLAYERS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_FROM_PLAYERS', 'YieldType', 'YIELD_GOLD'),
    ('BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_FROM_PLAYERS', 'Amount', -4),
    ('BBG_APPLY_DECREASES_TRADE_TO_GOLD_FROM_PLAYER', 'ModifierId', 'BBG_DECREASES_INTERNATIONAL_TRADE_ROUTE_GOLD_FROM_PLAYERS');
	
INSERT INTO ResolutionEffects(ResolutionEffectId, ResolutionType, WhichEffect, ModifierId) VALUES
    (26, 'WC_RES_TRADE_TREATY', 2, 'BBG_APPLY_DECREASES_TRADE_TO_GOLD_TO_PLAYER'),
    (27, 'WC_RES_TRADE_TREATY', 2, 'BBG_APPLY_DECREASES_TRADE_TO_GOLD_FROM_PLAYER');

-- UPDATE Modifiers SET RunOnce='True' WHERE ModifierId='APPLY_INTERNATIONAL_MAJOR_TRADE_ROUTES_DISABLED';
DELETE FROM ResolutionEffects WHERE ResolutionEffectId=25;

--================================================
--******              UnitCost              ******
--================================================
--10/03/2024 Rework prod congress values from 100/50 to 50/25 %
UPDATE ModifierArguments SET Value='-50' WHERE ModifierId='WC_RES_UNIT_PRODUCTION_YIELD_DEBUFF' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='WC_RES_UNIT_PRODUCTION_YIELD_BUFF' AND Name='Amount';

--================================================
--******            BorderControl           ******
--================================================

-- 01/10/24 : A now allow to buy 50% cheaper tiles
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_APPLY_CHEAPER_TILES_BUY', 'MODIFIER_CONGRESS_ATTACH_MODIFIER_TO_PLAYERTYPE'),
    ('BBG_CHEAPER_TILES_BUY', 'MODIFIER_PLAYER_CITIES_ADJUST_PLOT_PURCHASE_COST');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_APPLY_CHEAPER_TILES_BUY', 'ModifierId', 'BBG_CHEAPER_TILES_BUY'),
    ('BBG_CHEAPER_TILES_BUY', 'Amount', -50);

UPDATE ResolutionEffects SET ModifierId='BBG_APPLY_CHEAPER_TILES_BUY' WHERE ResolutionEffectId='80';

--================================================
--******           CombatStrength           ******
--================================================

-- 30/11/24 Reduced to -+5
UPDATE ModifierArguments SET Value=3 WHERE ModifierId='WC_RES_UNIT_COMBAT_BUFF';
UPDATE ModifierArguments SET Value=-3 WHERE ModifierId='WC_RES_UNIT_COMBAT_DEBUFF';

