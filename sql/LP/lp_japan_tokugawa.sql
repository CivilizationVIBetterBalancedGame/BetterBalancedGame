--15/06/23 Tokugawa gets +1 gold per internal per district (instead of +2 basegame)
-- UPDATE Modifiers SET ModifierType = 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC' WHERE ModifierId = 'TOKUGAWA_POSITIVE_DOMESTIC_GOLD_DISTRICTS';
UPDATE ModifierArguments SET Value=1 WHERE ModifierId='TOKUGAWA_POSITIVE_DOMESTIC_GOLD_DISTRICTS' AND Name='Amount';