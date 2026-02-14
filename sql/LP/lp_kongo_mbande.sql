-- 18/06/23 Remove old modifier for same/foreign continent
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_NZINGA_MBANDE' AND ModifierId='TRAIT_SAME_CONTINENT_YIELD';
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_NZINGA_MBANDE' AND ModifierId='TRAIT_FOREIGN_CONTINENT_YIELD';

INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
	('REQUIRES_OBJECT_1_OR_MORE_TILES_FROM_CAPITAL','REQUIREMENT_PLOT_NEAR_CAPITAL');
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('REQUIRES_OBJECT_1_OR_MORE_TILES_FROM_CAPITAL', 'MinDistance', '1');

-- Disabling Mbande's effect on the capital city
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('REQUIRES_CITY_IS_SAME_CONTINENT', 'REQUIRES_OBJECT_1_OR_MORE_TILES_FROM_CAPITAL');

-- 18/06/23 Mbande gets +2 golds for commercial hubs adjacent to Mbanza
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_MBANDE_COMMERCIAL_HUB_MBANZA', 'BBG_LOC_MBANDE_COMMERCIAL_MBANZA', 'YIELD_GOLD', 2, 'DISTRICT_MBANZA');
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_COMMERCIAL_HUB', 'BBG_MBANDE_COMMERCIAL_HUB_MBANZA');
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId)
   SELECT TraitType, 'BBG_MBANDE_COMMERCIAL_HUB_MBANZA' FROM CivilizationTraits WHERE CivilizationType != 'CIVILIZATION_KONGO' GROUP BY CivilizationType;
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
	('TRAIT_LEADER_RELIGIOUS_CONVERT', 'BBG_MBANDE_COMMERCIAL_HUB_MBANZA');

-- 18/06/23 Mbande gets +2 cultures for theatres adjacent to Mbanza
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_MBANDE_THEATRE_MBANZA', 'BBG_LOC_MBANDE_THEATRE_MBANZA', 'YIELD_CULTURE', 2, 'DISTRICT_MBANZA');
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_THEATER', 'BBG_MBANDE_THEATRE_MBANZA');
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId)
   SELECT TraitType, 'BBG_MBANDE_THEATRE_MBANZA' FROM CivilizationTraits WHERE CivilizationType != 'CIVILIZATION_KONGO' GROUP BY CivilizationType;
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
	('TRAIT_LEADER_RELIGIOUS_CONVERT', 'BBG_MBANDE_THEATRE_MBANZA');
    
-- 18/06/23 Mbande gets +10% culture & gold in cities with Mbanza
-- 19/12/25 Increased to 15%
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIREMENT_CITY_HAS_MBANZA', 'REQUIREMENT_CITY_HAS_DISTRICT');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIREMENT_CITY_HAS_MBANZA', 'DistrictType', 'DISTRICT_MBANZA');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_HAS_MBANZA', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_HAS_MBANZA', 'BBG_REQUIREMENT_CITY_HAS_MBANZA');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MODIFIER_MBANZA_ADDCULTUREYIELD', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER', 'BBG_CITY_HAS_MBANZA'),
    ('BBG_MODIFIER_MBANZA_ADDGOLDYIELD', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER', 'BBG_CITY_HAS_MBANZA');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MODIFIER_MBANZA_ADDCULTUREYIELD', 'Amount', 15),
    ('BBG_MODIFIER_MBANZA_ADDGOLDYIELD', 'Amount', 15);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MODIFIER_MBANZA_ADDCULTUREYIELD', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_MODIFIER_MBANZA_ADDGOLDYIELD', 'YieldType', 'YIELD_GOLD');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_NZINGA_MBANDE', 'BBG_MODIFIER_MBANZA_ADDCULTUREYIELD'),
	('TRAIT_LEADER_NZINGA_MBANDE', 'BBG_MODIFIER_MBANZA_ADDGOLDYIELD');

-- 05/03/2024
-- Mbande civilian units get forest and jungle free movement
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_CIVILIAN_UNITS_IGNORE_WOODS', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_CIVILIAN_UNITS_IGNORE_WOODS', 'AbilityType', 'BBG_IGNORE_WOODS_MBANDE_ABILITY');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_NZINGA_MBANDE', 'BBG_CIVILIAN_UNITS_IGNORE_WOODS');

INSERT INTO Types(Type, Kind) VALUES
    ('BBG_IGNORE_WOODS_MBANDE_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_IGNORE_WOODS_MBANDE_ABILITY', 'CLASS_LANDCIVILIAN');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive, ShowFloatTextWhenEarned, Permanent)  VALUES
    ('BBG_IGNORE_WOODS_MBANDE_ABILITY', 'LOC_BBG_IGNORE_WOODS_MBANDE_ABILITY_NAME', 'LOC_BBG_IGNORE_WOODS_MBANDE_ABILITY_DESCRIPTION', 1, 0, 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_IGNORE_WOODS_MBANDE_ABILITY', 'RANGER_IGNORE_FOREST_MOVEMENT_PENALTY');


-- 18/06/23 Reduced archaelogist cost for Mbande
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_TRAIT_ARCHAEOLOGIST_COST', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_ARCHAEOLOGIST_COST', 'UnitType', 'UNIT_ARCHAEOLOGIST'),
    ('BBG_TRAIT_ARCHAEOLOGIST_COST', 'Amount', '50');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_NZINGA_MBANDE', 'BBG_TRAIT_ARCHAEOLOGIST_COST');

-- 19/12/25 Receives merchant points from Kongo
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_NZINGA_MBANDE', 'TRAIT_DOUBLE_MERCHANT_POINTS');