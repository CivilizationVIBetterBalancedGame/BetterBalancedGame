--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Australia
--==================
-- Digger gets additional combat strength
UPDATE Units SET Combat=83, BaseMoves=3 WHERE UnitType='UNIT_DIGGER';
-- war production bonus reduced to 0% from 100%, liberation bonus reduced to +50% (from +100%) and 10 turns instead of 20
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_DEFENSIVE_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='TurnsActive';

-- 18/05/2021: UI can be build on hill
INSERT INTO Improvement_ValidTerrains(ImprovementType, TerrainType) VALUES
    ('IMPROVEMENT_OUTBACK_STATION', 'TERRAIN_GRASS_HILLS'),
    ('IMPROVEMENT_OUTBACK_STATION', 'TERRAIN_PLAINS_HILLS');

-- 07/06/2021: UI now give appeal
UPDATE Improvements SET Appeal=1 WHERE ImprovementType='IMPROVEMENT_OUTBACK_STATION';

-- 04/10/22 improves at Indus instead of steam power
UPDATE Adjacency_YieldChanges SET PrereqTech='TECH_INDUSTRIALIZATION' WHERE ID='Pasture_Outback_Production';
UPDATE Adjacency_YieldChanges SET PrereqTech='TECH_INDUSTRIALIZATION' WHERE ID='Outback_Outback_Production';

-- 18/05/2021: More production for pasture at Guild.
-- /!\ PLAYER_HAS_GUILDS_REQUIREMENTS is define is base.sql for Germany /!\
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
    ('BBG_AUSTRALIA_PASTURE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', NULL, NULL),
    ('BBG_AUSTRALIA_PASTURE_PRODUCTION_MODIFIER', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', NULL, 'PLOT_HAS_PASTURE_REQUIREMENTS');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_AUSTRALIA_PASTURE_PRODUCTION', 'ModifierId', 'BBG_AUSTRALIA_PASTURE_PRODUCTION_MODIFIER'),
    ('BBG_AUSTRALIA_PASTURE_PRODUCTION_MODIFIER', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_AUSTRALIA_PASTURE_PRODUCTION_MODIFIER', 'Amount', '1');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_LAND_DOWN_UNDER', 'BBG_AUSTRALIA_PASTURE_PRODUCTION');

--==============================================================
--******				START BIASES					  ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_CATTLE';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_HORSES';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_SHEEP';