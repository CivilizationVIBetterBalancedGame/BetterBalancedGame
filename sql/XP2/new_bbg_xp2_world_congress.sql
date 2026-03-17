-- ==============================================================
-- ******                C O N G R E S S                   ******
-- ==============================================================

UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_WORLD_IDEOLOGY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_GLOBAL_ENERGY_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_ESPIONAGE_PACT';
UPDATE Resolutions SET EarliestEra='ERA_MODERN' WHERE ResolutionType='WC_RES_ARMS_CONTROL';
DELETE FROM Resolutions WHERE ResolutionType='WC_RES_PUBLIC_RELATIONS';


DELETE FROM ModifierArguments WHERE ModifierId='APPLY_RES_UNIT_COMBAT_DEBUFF';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('APPLY_RES_UNIT_COMBAT_DEBUFF','ModifierId', 'WC_RES_UNIT_COMBAT_DEBUFF');

-- ================================================
-- ******             Trade Policy           ******
-- ================================================

-- 02/01/26 Trade Policy : Min era is now Start (from Medieval) 
UPDATE Resolutions SET EarliestEra=NULL WHERE ResolutionType='WC_RES_TRADE_TREATY';
-- 02/01/26 Max era is now Future (from Information)
UPDATE Resolutions SET LatestEra='ERA_FUTURE' WHERE ResolutionType='WC_RES_TRADE_TREATY';

-- 01/10/24 : A fix so it gives gold to the one that send the traderoute to the one that won the congress
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS' WHERE ModifierId='INCREASES_TRADE_TO_GOLD';

-- 02/01/26 A Vote now also give +2 gold per trade route received to the chosen player
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_APPLY_INCREASE_TRADE_GOLD_FROM_OTHERS', 'MODIFIER_CONGRESS_ATTACH_MODIFIER_TO_PLAYERTYPE'),
    ('BBG_INCREASE_TRADE_GOLD_FROM_OTHERS', 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_FROM_OTHERS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_APPLY_INCREASE_TRADE_GOLD_FROM_OTHERS', 'ModifierId', 'BBG_INCREASE_TRADE_GOLD_FROM_OTHERS'),
    ('BBG_INCREASE_TRADE_GOLD_FROM_OTHERS', 'YieldType', 'YIELD_GOLD'),
    ('BBG_INCREASE_TRADE_GOLD_FROM_OTHERS', 'Amount', 2);

INSERT INTO ResolutionEffects(ResolutionEffectId, ResolutionType, WhichEffect, ModifierId) VALUES
    (22, 'WC_RES_TRADE_TREATY', 1, 'BBG_APPLY_INCREASE_TRADE_GOLD_FROM_OTHERS');

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

-- ================================================
-- ******              UnitCost              ******
-- ================================================
-- 10/03/2024 Rework prod congress values from 100/50 to 50/25 %
UPDATE ModifierArguments SET Value='-50' WHERE ModifierId='WC_RES_UNIT_PRODUCTION_YIELD_DEBUFF' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='WC_RES_UNIT_PRODUCTION_YIELD_BUFF' AND Name='Amount';

-- ================================================
-- ******            BorderControl           ******
-- ================================================

-- 01/10/24 : A now allow to buy 50% cheaper tiles
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_APPLY_CHEAPER_TILES_BUY', 'MODIFIER_CONGRESS_ATTACH_MODIFIER_TO_PLAYERTYPE'),
    ('BBG_CHEAPER_TILES_BUY', 'MODIFIER_PLAYER_CITIES_ADJUST_PLOT_PURCHASE_COST');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_APPLY_CHEAPER_TILES_BUY', 'ModifierId', 'BBG_CHEAPER_TILES_BUY'),
    ('BBG_CHEAPER_TILES_BUY', 'Amount', -50);

UPDATE ResolutionEffects SET ModifierId='BBG_APPLY_CHEAPER_TILES_BUY' WHERE ResolutionEffectId='80';

-- 02/01/25 : Max era is now industrial
UPDATE Resolutions SET LatestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_BORDER_CONTROL';


-- ================================================
-- ******           CombatStrength           ******
-- ================================================

-- 30/11/24 Reduced to -+5
UPDATE ModifierArguments SET Value=3 WHERE ModifierId='WC_RES_UNIT_COMBAT_BUFF';
UPDATE ModifierArguments SET Value=-3 WHERE ModifierId='WC_RES_UNIT_COMBAT_DEBUFF';


-- ================================================
-- ******           WORLD_RELIGION           ******
-- ================================================

-- 02/01/26 Deleted
DELETE FROM Resolutions WHERE ResolutionType='WC_RES_WORLD_RELIGION';
DELETE FROM ResolutionEffects WHERE ResolutionType='WC_RES_WORLD_RELIGION';


-- ================================================
-- ******      Urban Development Treaty      ******
-- ================================================

-- 02/01/26 Urban Development Treaty : Max era is now Industrial (from Modern) 
UPDATE Resolutions SET LatestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_URBAN_DEVELOPMENT';

-- 02/01/26 B Vote now allow buildings production but with a 50% production malus (from no buildings can be created in this district)
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_URBAN_MALUS_PRODUCTION_DISTRICT', 'MODIFIER_ALL_CITIES_ADJUST_DISTRICT_BUILDING_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_URBAN_MALUS_PRODUCTION_DISTRICT', 'Amount', -50);
DELETE FROM ResolutionEffects WHERE ResolutionType='WC_RES_URBAN_DEVELOPMENT' AND ModifierId='BAN_DISTRICT_BUILDING';
INSERT INTO ResolutionEffects(ResolutionEffectId, ResolutionType, WhichEffect, ModifierId) VALUES
    (105, 'WC_RES_URBAN_DEVELOPMENT', 2, 'BBG_URBAN_MALUS_PRODUCTION_DISTRICT');

-- ================================================
-- ******              Patronage             ******
-- ================================================
    
-- 02/01/26 Patronage : Max era is now Future (from Modern)
UPDATE Resolutions SET LatestEra='ERA_FUTURE' WHERE ResolutionType='WC_RES_PATRONAGE';

-- ================================================
-- ******          Military Advisory         ******
-- ================================================

-- 02/01/26 Military Advisory : Max era is now Future (from Modern)
UPDATE Resolutions SET LatestEra='ERA_FUTURE' WHERE ResolutionType='WC_RES_MILITARY_ADVISORY';


-- ================================================
-- ******          Migration Treaty          ******
-- ================================================

-- 02/01/26 Migration Treaty : Min era is now Start (from Medieval)
UPDATE Resolutions SET EarliestEra=NULL WHERE ResolutionType='WC_RES_MIGRATION_TREATY';
-- 02/01/26 Max era is now Renaissance (from Information)
UPDATE Resolutions SET LatestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_MIGRATION_TREATY';

-- ================================================
-- ******        PUBLIC WORKS PROGRAM        ******
-- ================================================

UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_PUBLIC_WORKS';

-- 02/01/26 Public Works Program : Max era is now Future (from Information)
UPDATE Resolutions SET LatestEra='ERA_FUTURE' WHERE ResolutionType='WC_RES_PUBLIC_WORKS';

-- ================================================
-- ******        Deforestation Treaty        ******
-- ================================================

-- 02/01/26 Deforestation Treaty : Min era is now Renaissance (from Industrial) 
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_DEFORESTATION_TREATY';

-- 02/01/26 Deforestation Treaty : Max era is now Future (from Information)
UPDATE Resolutions SET LatestEra='ERA_FUTURE' WHERE ResolutionType='WC_RES_DEFORESTATION_TREATY';


-- ================================================
-- ******        Heritage Organisation       ******
-- ================================================  

UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_HERITAGE_ORG';

-- 02/01/26 Heritage Organization : B Vote is now -50% to chose type of Great Work (from no tourism)
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_HERITAGE_MALUS_TOURISM', 'MODIFIER_PLAYER_ADJUST_GREAT_WORK_OBJECT_TOURISM');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_HERITAGE_MALUS_TOURISM', 'Amount', -50);
DELETE FROM ResolutionEffects WHERE ResolutionType='WC_RES_HERITAGE_ORG' AND ModifierId='NO_TOURISM_FROM_GREAT_WORK_OBJECT';
INSERT INTO ResolutionEffects(ResolutionEffectId, ResolutionType, WhichEffect, ModifierId) VALUES
    (45, 'WC_RES_HERITAGE_ORG', 2, 'BBG_HERITAGE_MALUS_TOURISM');