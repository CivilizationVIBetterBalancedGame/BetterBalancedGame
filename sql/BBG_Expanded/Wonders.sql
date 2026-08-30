-- ========================================================================
-- =                              WONDERS                                 =
-- ========================================================================

-- ------ Porcelain Tower -----
-- -- Lux only gives +4 Amenities, from +6. 
-- UPDATE Resources SET Happiness = 4 WHERE ResourceType = 'RESOURCE_PORCELAIN';
-- -- only 2 excemplars of the luxury resource are granted, down from 3.
-- UPDATE ModifierArguments SET Value = 2 WHERE ModifierId = 'PORCELAIN_TOWER_CITY_FREE_PORCELAIN' AND Name = 'Amount';