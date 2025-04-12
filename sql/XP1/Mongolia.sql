--=========
--Mongolia
--=========
-- 23/04/2021 : Fixed by Firaxis
--INSERT OR IGNORE INTO TypeTags VALUES ('ABILITY_GENGHIS_KHAN_CAVALRY_BONUS', 'CLASS_MONGOLIAN_KESHIG');
-- No longer receives +1 diplo visibility for trading post
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
DELETE FROM DiplomaticVisibilitySources WHERE VisibilitySourceType='SOURCE_TRADING_POST_TRAIT';
DELETE FROM DiplomaticVisibilitySources_XP1 WHERE VisibilitySourceType='SOURCE_TRADING_POST_TRAIT';
DELETE FROM ModifierArguments WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
DELETE FROM Modifiers WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
-- Keshig
UPDATE Units SET RangedCombat=40, Cost=180 WHERE UnitType='UNIT_MONGOLIAN_KESHIG';

INSERT OR IGNORE INTO RequirementSetRequirements VALUES
    ('BUILDING_IS_BARRACKS_STABLE_MILITARITIC_CITY_STATE', 'REQUIRES_CITY_HAS_ORDU_BBG');
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQUIRES_CITY_HAS_ORDU_BBG', 'REQUIREMENT_CITY_HAS_BUILDING');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIRES_CITY_HAS_ORDU_BBG', 'BuildingType', 'BUILDING_ORDU');

-- 30/09/24 Ordu cost 45 prod (online)
UPDATE Buildings SET Cost=90 WHERE BuildingType='BUILDING_ORDU';

UPDATE Building_YieldChanges SET YieldChange=2 WHERE BuildingType='BUILDING_ORDU';


-- 08/04/25 Ordu movement now only works if unit starts turn on flat terrain
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLOT_IS_FLAT' WHERE ModifierId='ORDU_ADJUST_MOVEMENT';