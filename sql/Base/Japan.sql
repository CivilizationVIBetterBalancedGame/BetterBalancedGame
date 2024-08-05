-- Commercial Hubs no longer get adjacency from rivers
INSERT OR IGNORE INTO ExcludedAdjacencies (TraitType , YieldChangeId)
    VALUES
    ('TRAIT_CIVILIZATION_ADJACENT_DISTRICTS' , 'River_Gold');
-- Samurai come at Feudalism now
-- Implemented by Firaxis
-- UPDATE Units SET PrereqCivic='CIVIC_FEUDALISM' , PrereqTech=NULL WHERE UnitType='UNIT_JAPANESE_SAMURAI';

-- 02/07/24 Nerf combat strenght from +5  to +3
UPDATE ModifierArguments SET Value = '3' WHERE ModifierId = 'HOJO_TOKIMUNE_SHALLOW_WATER_COMBAT_BONUS' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = '3' WHERE ModifierId = 'HOJO_TOKIMUNE_COASTAL_COMBAT_BONUS' AND Name = 'Amount';