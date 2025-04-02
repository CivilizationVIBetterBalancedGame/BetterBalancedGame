-- Commercial Hubs no longer get adjacency from rivers
INSERT OR IGNORE INTO ExcludedAdjacencies (TraitType , YieldChangeId) VALUES
    ('TRAIT_CIVILIZATION_ADJACENT_DISTRICTS' , 'River_Gold');

-- Samurai come at Feudalism now
-- Implemented by Firaxis
-- 26/02/25 Moved to Mercenaries
UPDATE Units SET PrereqCivic='CIVIC_MERCENARIES', PrereqTech=NULL WHERE UnitType='UNIT_JAPANESE_SAMURAI';

-- 02/07/24 Nerf combat strenght from +5  to +3
UPDATE ModifierArguments SET Value = '3' WHERE ModifierId = 'HOJO_TOKIMUNE_SHALLOW_WATER_COMBAT_BONUS' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = '3' WHERE ModifierId = 'HOJO_TOKIMUNE_COASTAL_COMBAT_BONUS' AND Name = 'Amount';

--26/02/25 Culture from electronic factory is now base bonus of the building
DELETE FROM BuildingModifiers WHERE ModifierId='ELECTRONICSFACTORY_CULTURE';
INSERT INTO Building_YieldChanges (BuildingType, YieldType, YieldChange) VALUES
    ('BUILDING_ELECTRONICS_FACTORY', 'YIELD_CULTURE', 4);