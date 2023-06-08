
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


-- 07/06/23 digital democracy gives 2 tourism per district 
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    SELECT 'BBG_DIGITAL_DEMOCRACY_TOURISM_' || DistrictType || '_MODIFIER', 'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_CHANGE', 'BBG_DISTRICT_IS_' || DistrictType || '_REQSET' FROM Districts WHERE DistrictType NOT IN ('DISTRICT_CITY_CENTER', 'DISTRICT_WONDER');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_DIGITAL_DEMOCRACY_TOURISM_' || DistrictType || '_MODIFIER', 'Amount', 1 FROM Districts WHERE DistrictType NOT IN ('DISTRICT_CITY_CENTER', 'DISTRICT_WONDER');

INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
    SELECT 'GOVERNMENT_DIGITAL_DEMOCRACY', 'BBG_DIGITAL_DEMOCRACY_TOURISM_' || DistrictType || '_MODIFIER' FROM Districts WHERE DistrictType NOT IN ('DISTRICT_CITY_CENTER', 'DISTRICT_WONDER');