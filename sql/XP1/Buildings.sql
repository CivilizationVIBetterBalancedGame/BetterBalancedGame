--==============================================================
--******			  	B U I L D I N G S	 		  	  ******
--==============================================================
--Wonders
-- Taj Mahal +10% gold for all your cities if you are in golden age
INSERT INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId) VALUES
	('TAJ_MAHAL_GOLD_MODIFIER_IN_ALL_CITIES', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER', 'PLAYER_HAS_GOLDEN_AGE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TAJ_MAHAL_GOLD_MODIFIER_IN_ALL_CITIES', 'YieldType', 'YIELD_GOLD'),
    ('TAJ_MAHAL_GOLD_MODIFIER_IN_ALL_CITIES', 'Amount', '10');
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_TAJ_MAHAL', 'TAJ_MAHAL_GOLD_MODIFIER_IN_ALL_CITIES');

--5.1 Kotoku Allows Monk Buy SQL
INSERT INTO Unit_BuildingPrereqs(Unit, PrereqBuilding, NumSupported) VALUES
	('UNIT_WARRIOR_MONK', 'BUILDING_KOTOKU_IN', '-1');
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_CITY_HAS_KOTOKU', 'REQUIREMENT_CITY_HAS_BUILDING');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_CITY_HAS_KOTOKU', 'BuildingType','BUILDING_KOTOKU_IN');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_CITY_HAS_KOTOKU_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_CITY_HAS_KOTOKU_REQSET', 'BBG_REQUIRES_CITY_HAS_KOTOKU');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_KOTOKU_ALLOW_MONK_BUY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 'BBG_CITY_HAS_KOTOKU_REQSET');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_KOTOKU_ALLOW_MONK_BUY', 'Tag', 'CLASS_WARRIOR_MONK');
INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
	('BUILDING_KOTOKU_IN', 'BBG_KOTOKU_ALLOW_MONK_BUY');

-- scott research station can be built and works in tundra
INSERT OR IGNORE INTO Building_ValidTerrains (BuildingType, TerrainType) VALUES
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA'),
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA_HILLS');
UPDATE RequirementArguments SET Value='TERRAIN_TUNDRA' WHERE RequirementId='REQUIRES_CITY_HAS_5_SNOW' AND Name='TerrainType';
-- St. Basil gives 1 relic
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_ST_BASILS_CATHEDRAL', 'WONDER_GRANT_RELIC_BBG');


--12/06/23 Water Park building buff
-- Ferris wheel tourism from 2 to 6
UPDATE ModifierArguments SET Value=6 WHERE Name='FERRIS_WHEEL_TOURISM';
-- Aquatics Center: +6 Tourism for each wonder built in this city on or adjacent to coast (from +2)
UPDATE ModifierArguments SET Value=6 WHERE Name='AQUATICS_CENTER_WONDER_TOURISM';

--18/12/23 Artemis -1 food/housing
UPDATE Buildings SET Housing=2 WHERE BuildingType='BUILDING_TEMPLE_ARTEMIS';
UPDATE Building_YieldChanges SET YieldChange=3 WHERE BuildingType='BUILDING_TEMPLE_ARTEMIS' AND YieldType='YIELD_FOOD';
