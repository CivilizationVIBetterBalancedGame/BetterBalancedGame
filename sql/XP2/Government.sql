
-- ==============================================================
-- ******                G O V E R N M E N T               ******
-- ==============================================================
UPDATE Governments SET OtherGovernmentIntolerance=0 WHERE GovernmentType='GOVERNMENT_DIGITAL_DEMOCRACY';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_CORPORATE_LIBERTARIANISM';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_SYNTHETIC_TECHNOCRACY';

-- Replace +2 favor on renaissance wall with monarchy to +2 culture
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE' WHERE ModifierId='MONARCHY_STARFORT_FAVOR';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='MONARCHY_STARFORT_FAVOR';

DELETE FROM ModifierArguments WHERE ModifierId='MONARCHY_STARFORT_FAVOR';
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('MONARCHY_STARFORT_FAVOR', 'BuildingType', 'BUILDING_STAR_FORT'),
    ('MONARCHY_STARFORT_FAVOR', 'YieldType', 'YIELD_CULTURE'),
    ('MONARCHY_STARFORT_FAVOR', 'Amount', '2');


-- ==============================================================
-- ***                  CORPORATE LIBERALISM                  *** 
-- ============================================================== 

-- Corporate Libertarianism Top Ability : 
-- Commercial Hubs provide +25% gold.
-- If the city has a Harbor, an Encampment or an Aerodrome, it receives +50% production on units. 
-- Corporate Libertarianism Bottom Ability : 
-- +5 Oil, Aluminum, and Uranium per turn. Accumulating resources with improvements provide +1/turn. +5 Combat Strength on all units.
DELETE FROM GovernmentModifiers WHERE GovernmentType='GOVERNMENT_CORPORATE_LIBERTARIANISM' AND ModifierId IN ('CORPORATE_LIBERTARIANISM_COMMERCIAL_HUB_PRODUCTION', 'CORPORATE_LIBERTARIANISM_ENCAMPMENT_PRODUCTION');
-- 18/12/25 Commercial Hubs provide +25% gold. 
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_CORPORATE_LIBERALISM_GOLD_CHUB', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER', 'CITY_HAS_COMMERCIAL_HUB');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_CORPORATE_LIBERALISM_GOLD_CHUB', 'YieldType', 'YIELD_GOLD'),
    ('BBG_CORPORATE_LIBERALISM_GOLD_CHUB', 'Amount', 25);
INSERT INTO GovernmentModifiers(GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_CORPORATE_LIBERALISM_GOLD_CHUB');
-- 18/12/25 If the city has a Harbor, an Encampment or an Aerodrome, it receives +50% production on units. 
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_HAS_HARBOR_ENCAMPMENT_OR_AERODROME_REQSET', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_HAS_HARBOR_ENCAMPMENT_OR_AERODROME_REQSET', 'REQUIRES_CITY_HAS_HARBOR'),
    ('BBG_CITY_HAS_HARBOR_ENCAMPMENT_OR_AERODROME_REQSET', 'REQUIRES_CITY_HAS_ENCAMPMENT'),
    ('BBG_CITY_HAS_HARBOR_ENCAMPMENT_OR_AERODROME_REQSET', 'BBG_CITY_HAS_DISTRICT_AERODROME_REQUIREMENT');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_CORPORATE_LIBERALISM_UNIT_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION', 'BBG_CITY_HAS_HARBOR_ENCAMPMENT_OR_AERODROME_REQSET');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_CORPORATE_LIBERALISM_UNIT_PRODUCTION', 'Amount', 50);
INSERT INTO GovernmentModifiers(GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_CORPORATE_LIBERALISM_UNIT_PRODUCTION');
-- 18/12/25 +5 Combat Strength on all Units. 
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_GIVER', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_MODIFIER', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_GIVER', 'AbilityType', 'BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY'),
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_MODIFIER', 'Amount', 5);

INSERT INTO ModifierStrings(ModifierId, Context, Text) VALUES
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_MODIFIER', 'Preview', 'LOC_BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY_DESC');

INSERT INTO Types(Type, Kind) VALUES
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY', 'CLASS_ALL_COMBAT_UNITS');
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive) VALUES
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY', 'LOC_BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY_NAME', 'LOC_BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY_DESC', 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_ABILITY', 'BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_MODIFIER');
INSERT INTO GovernmentModifiers(GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_CORPORATE_LIBERALISM_COMBAT_STRENGTH_GIVER');

-- 08/06/23 Corporate liberalism gives +5 oil/alu/uranium
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_RESOURCE_URANIUM_REQSET'),
    ('BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_RESOURCE_ALUMINUM_REQSET'),
    ('BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'BBG_PLAYER_CAN_SEE_RESOURCE_OIL_REQSET');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER', 'ResourceType', 'RESOURCE_URANIUM'),
    ('BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER', 'ResourceType', 'RESOURCE_ALUMINUM'),
    ('BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER', 'ResourceType', 'RESOURCE_OIL'),
    ('BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER', 'Amount', 5),
    ('BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER', 'Amount', 5),
    ('BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER', 'Amount', 5);
-- Attaching Modifiers to Gov
INSERT INTO GovernmentModifiers(GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER'),
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER'),
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER');



-- ==============================================================
-- ***                  SYNTHETIC TECHNOCRACY                 *** 
-- ============================================================== 

-- Synthetic Technocracy Top Ability : 
-- +10 Power in all cities, and +50% production toward space projects. (from +3 Power, and +30% production toward all projects)
-- Corporate Libertarianism Bottom Ability : 
-- +100% production toward Spaceports if the city has an IZ and Campus (from +50% production toward Spaceport, IZ, Campus, and Harbor Districts and buildings within those districts)

-- 18/12/25 +10 Power in all cities (from +3)
UPDATE ModifierArguments SET Value=10 WHERE ModifierId='SYNTHETIC_TECHNOCRACY_CITY_POWER' AND Name='Amount';

-- 18/12/25 +50% production toward space projects (from +30% toward all projects)
DELETE FROM GovernmentModifiers WHERE ModifierId='SYNTHETIC_TECHNOCRACY_CITY_PROJECT_PRODUCTION';
INSERT INTO Modifiers (ModifierId, ModifierType)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || Projects.ProjectType || '_BONUS_PROD', 'BBG_MODIFIER_PLAYER_CITIES_ADJUST_PROJECT_PRODUCTION' FROM Projects WHERE SpaceRace=1;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || Projects.ProjectType || '_BONUS_PROD', 'ProjectType', Projects.ProjectType FROM Projects WHERE SpaceRace=1;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || Projects.ProjectType || '_BONUS_PROD', 'Amount', 50 FROM Projects WHERE SpaceRace=1;
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
    SELECT 'GOVERNMENT_SYNTHETIC_TECHNOCRACY', 'BBG_TECHNOCRACY_SYNTHETIC_' || Projects.ProjectType || '_BONUS_PROD' FROM Projects WHERE SpaceRace=1;

-- 16/04/23 synthetic technocracy +50% toward many districts/buildings (list in the created table)
-- 18/12/25 Increased to 100%
CREATE TABLE TmpSyntheticTechnocracyDistricts(DistrictType PRIMARY KEY NOT NULL);
INSERT INTO TmpSyntheticTechnocracyDistricts(DistrictType) VALUES
    ('DISTRICT_SPACEPORT'),
    ('DISTRICT_INDUSTRIAL_ZONE'),
    ('DISTRICT_HANSA'),
    ('DISTRICT_OPPIDUM'),
    ('DISTRICT_CAMPUS'),
    ('DISTRICT_OBSERVATORY'),
    ('DISTRICT_SEOWON'),
    ('DISTRICT_HARBOR'),
    ('DISTRICT_COTHON'),
    ('DISTRICT_ROYAL_NAVY_DOCKYARD');
-- Districts
INSERT INTO Modifiers (ModifierId, ModifierType)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_DISTRICT', 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION' FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_DISTRICT', 'DistrictType', TmpSyntheticTechnocracyDistricts.DistrictType FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_DISTRICT', 'Amount', 100 FROM TmpSyntheticTechnocracyDistricts;
-- Buildings
INSERT INTO Modifiers (ModifierId, ModifierType)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING', 'DistrictType', TmpSyntheticTechnocracyDistricts.DistrictType FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING', 'Amount', 100 FROM TmpSyntheticTechnocracyDistricts;
--Attaching Modifiers to Gov
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
    SELECT 'GOVERNMENT_SYNTHETIC_TECHNOCRACY', 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_DISTRICT' FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
    SELECT 'GOVERNMENT_SYNTHETIC_TECHNOCRACY', 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING' FROM TmpSyntheticTechnocracyDistricts;

DROP TABLE TmpSyntheticTechnocracyDistricts;

DELETE FROM GovernmentModifiers WHERE ModifierId IN ('CORPORATE_LIBERTARIANISM_SCIENCE_PENALTY', 'SYNTHETIC_TECHNOCRACY_TOURISM_PENALTY', 'DIGITAL_DEMOCRACY_COMBAT_STRENGTH_PENALTY');

-- ==============================================================
-- ***                    DIGITAL DEMOCRACY                   *** 
-- ============================================================== 

-- Digital Democracy Top Ability: +2 Amenities in all cities and +2 Culture per Specialty District
-- Digital Democracy Bottom Ability: +2 Tourism per specialty district. Tourism from other players is reduced by 50% versus your civilization.

-- 07/06/23 digital democracy gives 2 tourism per district 
-- Districts.TraitType IS NULL remove the creation of modifier for unique district (they work with the original one)
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    SELECT 'BBG_DIGITAL_DEMOCRACY_TOURISM_' || DistrictType || '_MODIFIER', 'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_CHANGE', 'BBG_DISTRICT_IS_' || DistrictType || '_REQSET' FROM Districts WHERE DistrictType NOT IN ('DISTRICT_CITY_CENTER', 'DISTRICT_WONDER') AND Districts.TraitType IS NULL;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_DIGITAL_DEMOCRACY_TOURISM_' || DistrictType || '_MODIFIER', 'Amount', 2 FROM Districts WHERE DistrictType NOT IN ('DISTRICT_CITY_CENTER', 'DISTRICT_WONDER') AND Districts.TraitType IS NULL;
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
    SELECT 'GOVERNMENT_DIGITAL_DEMOCRACY', 'BBG_DIGITAL_DEMOCRACY_TOURISM_' || DistrictType || '_MODIFIER' FROM Districts WHERE DistrictType NOT IN ('DISTRICT_CITY_CENTER', 'DISTRICT_WONDER') AND Districts.TraitType IS NULL;

-- 18/12/25 Tourism from other players is reduced by 50% versus your civilization.
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_DIGITAL_DEMOCRACY_REDUCE_OPPONENT_TOURISM', 'MODIFIER_PLAYER_ADJUST_OVERALL_TOURISM_REDUCTION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_DIGITAL_DEMOCRACY_REDUCE_OPPONENT_TOURISM', 'Modifier', 50);
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_DIGITAL_DEMOCRACY', 'BBG_DIGITAL_DEMOCRACY_REDUCE_OPPONENT_TOURISM');