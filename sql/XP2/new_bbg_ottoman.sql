

-- Grand Bazaar buff
UPDATE Building_GreatPersonPoints SET PointsPerTurn=2 WHERE BuildingType='BUILDING_GRAND_BAZAAR';
UPDATE Building_YieldChanges SET YieldChange=6 WHERE BuildingType='BUILDING_GRAND_BAZAAR' AND YieldType='YIELD_GOLD';
-- Grand Bazaar same ability than bank
INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_GRAND_BAZAAR', 'BBG_BANK_TRADEROUTE_FROM_DOMESTIC'),
    ('BUILDING_GRAND_BAZAAR', 'BBG_BANK_TRADEROUTE_TO_DOMESTIC'),
    ('BUILDING_GRAND_BAZAAR', 'BBG_BANK_TRADEROUTE_FROM_INTERNATIONAL'),
    ('BUILDING_GRAND_BAZAAR', 'BBG_BANK_TRADEROUTE_TO_INTERNATIONAL');
-- Grand Bazaar traderoute capacity
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_GRAND_BAZAAR_TRADEROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GRAND_BAZAAR_TRADEROUTE_CAPACITY', 'Amount', '1');
INSERT INTO BuildingModifiers(BuildingType, ModifierId) VALUES
    ('BUILDING_GRAND_BAZAAR', 'BBG_GRAND_BAZAAR_TRADEROUTE_CAPACITY');

-- Give one title governor
INSERT INTO Modifiers(ModifierId, ModifierType, RunOnce, Permanent, SubjectRequirementSetId) VALUES
    ('BBG_GRAND_BAZAAR_GOV_POINT', 'MODIFIER_ALL_PLAYERS_ADJUST_GOVERNOR_POINTS', 1, 1, 'BBG_BUILDING_IS_GRAND_BAZAAR');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GRAND_BAZAAR_GOV_POINT', 'Delta', '1');
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('BBG_BUILDING_IS_GRAND_BAZAAR', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('BBG_BUILDING_IS_GRAND_BAZAAR', 'BBG_BUILDING_IS_GRAND_BAZAAR_REQUIREMENT');
INSERT INTO Requirements(RequirementId , RequirementType) VALUES
	('BBG_BUILDING_IS_GRAND_BAZAAR_REQUIREMENT' , 'REQUIREMENT_PLAYER_HAS_BUILDING');
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('BBG_BUILDING_IS_GRAND_BAZAAR_REQUIREMENT' , 'BuildingType', 'BUILDING_GRAND_BAZAAR');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_BUILDING_GRAND_BAZAAR', 'BBG_GRAND_BAZAAR_GOV_POINT');


--04/10/22 barbary corsaire can go in ocean tiles without cartography
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_BARBARY_CORSAIR_OCEAN_NAVIGATION', 'MODIFIER_PLAYER_UNIT_ADJUST_VALID_TERRAIN');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_BARBARY_CORSAIR_OCEAN_NAVIGATION', 'TerrainType', 'TERRAIN_OCEAN'),
    ('BBG_BARBARY_CORSAIR_OCEAN_NAVIGATION', 'Valid', 1);
INSERT OR IGNORE INTO UnitAbilityModifiers VALUES
    ('ABILITY_CORSAIR', 'BBG_BARBARY_CORSAIR_OCEAN_NAVIGATION');



--05/10/22 river bias
INSERT INTO StartBiasRivers (CivilizationType, Tier) VALUES
    ('CIVILIZATION_OTTOMAN', 3);

--19/03/24 +3 for all siege units instead of +5 against city center
UPDATE ModifierArguments SET Value=3 WHERE ModifierId='GREAT_TURKISH_BOMBARD_STRENGTH';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='GREAT_TURKISH_BOMBARD_STRENGTH';

--=============================================================================================
--=                                       IBRAHIM                                             =
--=============================================================================================

-- 3 turns

-- Default Pasha : +25% Production to all military units in the city. When established in an allied foreign Capital, Alliance leveling rate is increased with the owner.                
UPDATE ModifierArguments SET Value=25 WHERE ModifierId='PASHA_BONUS_UNIT_PRODUCTION';
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_PASHA' WHERE ModifierId='KHASS_ODA_BASHI_ADJUST_ALLIANCE_POINTS';

-- LI Head Falconer : Grant +1culture/faith per population.
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_HEAD_FALCONER';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_IBRAHIM_SCIENCE_PER_POP', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_IBRAHIM_SCIENCE_PER_POP', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_IBRAHIM_SCIENCE_PER_POP', 'Amount', 1);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_HEAD_FALCONER', 'BBG_IBRAHIM_SCIENCE_PER_POP');

-- RI Serasker: Grant all units within 10 tiles of the City Center +10 Strength Combat Strength when attacking defensible District   
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_SERASKER';   
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_SERASKER', 'SERASKER_ADJUST_GOVERNOR_COMBAT_DISTRICT');
    
-- LII Khass-Oda-Bashi : Grant +1science/gold per population.     
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_KHASS_ODA_BASHI';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_IBRAHIM_CULTURE_PER_POP', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_IBRAHIM_CULTURE_PER_POP', 'Amount', 1),
    ('BBG_IBRAHIM_CULTURE_PER_POP', 'YieldType', 'YIELD_CULTURE');
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_KHASS_ODA_BASHI', 'BBG_IBRAHIM_CULTURE_PER_POP');

-- RII Capou Agha : Grant +1 movement for units within 10 range of the city. All friendly units fighting within the city's territory gain +3 Strength Combat Strength.
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CAPOU_AGHA';
UPDATE ModifierArguments SET VAlUE=3 WHERE ModifierId='HEAD_FALCONER_ADJUST_CITY_COMBAT_BONUS'; 
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_IBRAHIM_ADJUST_MOVEMENT_POINTS', 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT', 'PLOT_10_TILES_AWAY_MAX_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_IBRAHIM_ADJUST_MOVEMENT_POINTS', 'Amount', 1);
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='CAPOU_AGHA_ADJUST_GRIEVANCES';
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_CAPOU_AGHA', 'BBG_IBRAHIM_ADJUST_MOVEMENT_POINTS'),
    ('GOVERNOR_PROMOTION_CAPOU_AGHA', 'HEAD_FALCONER_ADJUST_CITY_COMBAT_BONUS');

-- MIII Grand Vizier: Grant +5 housing/amenity.     
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_GRAND_VISIER'; 
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_IBRAHIM_HOUSING', 'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING', 'BBG_DISTRICT_IS_DISTRICT_CITY_CENTER_REQSET'),
    ('BBG_IBRAHIM_AMENITY', 'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY', 'BBG_DISTRICT_IS_DISTRICT_CITY_CENTER_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_IBRAHIM_HOUSING', 'Amount', 5),
    ('BBG_IBRAHIM_AMENITY', 'Amount', 5);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_GRAND_VISIER', 'BBG_IBRAHIM_HOUSING'),
    ('GOVERNOR_PROMOTION_GRAND_VISIER', 'BBG_IBRAHIM_AMENITY');

