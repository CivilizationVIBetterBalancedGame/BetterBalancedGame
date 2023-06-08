
--==============================================================
--******                G O V E R N M E N T               ******
--==============================================================
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

-- 08/06/23 Corporate liberalism gives +5 oil/alu/uranium
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_URANIUM_CPLMOD'),
    ('BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_ALUMINUM_CPLMOD'),
    ('BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_OIL_CPLMOD');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER', 'ResourceType', 'RESOURCE_URANIUM'),
    ('BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER', 'ResourceType', 'RESOURCE_ALUMINUM'),
    ('BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER', 'ResourceType', 'RESOURCE_OIL'),
    ('BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER', 'Amount', 5),
    ('BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER', 'Amount', 5),
    ('BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER', 'Amount', 5);
--Attaching Modifiers to Gov
INSERT INTO GovernmentModifiers(GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_GOV_CORPORATE_LIBERALISM_URANIUM_ACCUMULATION_MODIFIER'),
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_GOV_CORPORATE_LIBERALISM_ALUMINUM_ACCUMULATION_MODIFIER'),
    ('GOVERNMENT_CORPORATE_LIBERTARIANISM', 'BBG_GOV_CORPORATE_LIBERALISM_OIL_ACCUMULATION_MODIFIER');


-- 16/04/23 synthetic technocracy +50% toward many districts/buildings (list in the created table)
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
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_DISTRICT', 'Amount', '50' FROM TmpSyntheticTechnocracyDistricts;
-- Buildings
INSERT INTO Modifiers (ModifierId, ModifierType)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING', 'DistrictType', TmpSyntheticTechnocracyDistricts.DistrictType FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING', 'Amount', '50' FROM TmpSyntheticTechnocracyDistricts;
--Attaching Modifiers to Gov
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
    SELECT 'GOVERNMENT_SYNTHETIC_TECHNOCRACY', 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_DISTRICT' FROM TmpSyntheticTechnocracyDistricts;
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
    SELECT 'GOVERNMENT_SYNTHETIC_TECHNOCRACY', 'BBG_TECHNOCRACY_SYNTHETIC_' || TmpSyntheticTechnocracyDistricts.DistrictType || '_BONUS_PRODUCTION_BUILDING' FROM TmpSyntheticTechnocracyDistricts;

DROP TABLE TmpSyntheticTechnocracyDistricts;
