--==============================================================
--******                RELIGION                          ******
--==============================================================
-- Monks: Gaul CS

INSERT INTO TypeTags(Type, Tag) VALUES
	('ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS', 'CLASS_WARRIOR_MONK');

--==============================================================
--******                  WONDER                          ******
--==============================================================

-- Reduce statue of zeus from 50 to 35
UPDATE ModifierArguments SET Value=35 WHERE ModifierId='STAUEZEUS_ANTI_CAVALRY_PRODUCTION' AND Name='Amount';

--==============================================================
--******                  CITY STATE                      ******
--==============================================================

-- 08/03/24 Venice buff 2 golds per lux instead of 1
UPDATE ModifierArguments SET Value=2 WHERE ModifierId='MINOR_CIV_ANTIOCH_LUXURY_TRADE_ROUTE_BONUS' AND Name='Amount';

-- 08/03/24
-- DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_GENEVA_SCIENCE_AT_PEACE_BONUS';
-- UPDATE ModifierArguments SET Value='BBG_MINOR_CIV_GENEVA_SCIENCE_PER_GREAT_PEOPLE' WHERE ModifierId='MINOR_CIV_GENEVA_UNIQUE_INFLUENCE_BONUS';
-- INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
--     ('BBG_MINOR_CIV_GENEVA_SCIENCE_PER_GREAT_PEOPLE', 'MODIFIER_PLAYER_ADJUST_YIELD_MODIFIER_PER_EARNED_GREAT_PERSON');
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--     ('BBG_MINOR_CIV_GENEVA_SCIENCE_PER_GREAT_PEOPLE', 'Amount', 1),
--     ('BBG_MINOR_CIV_GENEVA_SCIENCE_PER_GREAT_PEOPLE', 'YieldType', 'YIELD_SCIENCE');


