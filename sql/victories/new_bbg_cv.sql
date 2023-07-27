--
--  CULTURAL VICTORY CHANGE FROM BBG
--

--==============================================================
--******		C U L T U R E   V I C T O R I E S		  ******
--==============================================================
-- moon landing worth 5x science in culture instead of 10x
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_SCIENCE_RATE' AND Name='Multiplier';
-- computers and environmentalism tourism boosts to 50% (from 25%)
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='COMPUTERS_BOOST_ALL_TOURISM';
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='ENVIRONMENTALISM_BOOST_ALL_TOURISM';
-- base wonder tourism adjusted to 5
UPDATE GlobalParameters SET Value='5' WHERE Name='TOURISM_BASE_FROM_WONDER';
-- Reduce amount of tourism needed for foreign tourist from 200 to 150
UPDATE GlobalParameters SET Value='150' WHERE Name='TOURISM_TOURISM_TO_MOVE_CITIZEN';
-- lower number of turns to move greatworks between cities
UPDATE GlobalParameters SET Value='2' WHERE Name='GREATWORK_ART_LOCK_TIME';
--

-- fix same artist, same archelogist culture and tourism from bing 1 and 1 to being default numbers
UPDATE Building_GreatWorks SET NonUniquePersonYield=4 WHERE BuildingType='BUILDING_HERMITAGE';
UPDATE Building_GreatWorks SET NonUniquePersonTourism=4 WHERE BuildingType='BUILDING_HERMITAGE';
UPDATE Building_GreatWorks SET NonUniquePersonYield=4 WHERE BuildingType='BUILDING_MUSEUM_ART';
UPDATE Building_GreatWorks SET NonUniquePersonTourism=4 WHERE BuildingType='BUILDING_MUSEUM_ART';
UPDATE Building_GreatWorks SET NonUniquePersonYield=6 WHERE BuildingType='BUILDING_MUSEUM_ARTIFACT';
UPDATE Building_GreatWorks SET NonUniquePersonTourism=6 WHERE BuildingType='BUILDING_MUSEUM_ARTIFACT';

-- Relic
UPDATE GreatWorks SET Tourism=4 WHERE GreatWorkObjectType='GREATWORKOBJECT_RELIC';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE YieldType='YIELD_FAITH' AND
  EXISTS(SELECT * FROM GreatWorks WHERE GreatWorkObjectType='GREATWORKOBJECT_RELIC' AND
         GreatWorks.GreatWorkType = GreatWork_YieldChanges.GreatWorkType);

-- Writing
UPDATE GreatWorks SET Tourism=2 WHERE GreatWorkObjectType='GREATWORKOBJECT_WRITING';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE YieldType='YIELD_CULTURE' AND
  EXISTS(SELECT * FROM GreatWorks WHERE GreatWorkObjectType='GREATWORKOBJECT_WRITING' AND
         GreatWorks.GreatWorkType = GreatWork_YieldChanges.GreatWorkType);

-- Music
UPDATE GreatWorks SET Tourism=8 WHERE GreatWorkObjectType='GREATWORKOBJECT_MUSIC';
UPDATE GreatWork_YieldChanges SET YieldChange=12 WHERE YieldType='YIELD_CULTURE' AND
  EXISTS(SELECT * FROM GreatWorks WHERE GreatWorkObjectType='GREATWORKOBJECT_MUSIC' AND
         GreatWorks.GreatWorkType = GreatWork_YieldChanges.GreatWorkType);

-- Artifact
UPDATE GreatWorks SET Tourism=8 WHERE GreatWorkObjectType='GREATWORKOBJECT_ARTIFACT';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE YieldType='YIELD_CULTURE' AND
  EXISTS(SELECT * FROM GreatWorks WHERE GreatWorkObjectType='GREATWORKOBJECT_ARTIFACT' AND
         GreatWorks.GreatWorkType = GreatWork_YieldChanges.GreatWorkType);

-- Artist
UPDATE GreatWorks SET Tourism=4 WHERE GreatWorkObjectType IN
    ('GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_SCULPTURE');
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE YieldType='YIELD_CULTURE' AND
  EXISTS(SELECT * FROM GreatWorks WHERE GreatWorkObjectType IN
    ('GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_SCULPTURE')
  AND GreatWorks.GreatWorkType = GreatWork_YieldChanges.GreatWorkType
  );

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('OPERA_BALLET_BOOST_WRITING_TOURISM', 'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('OPERA_BALLET_BOOST_WRITING_TOURISM', 'GreatWorkObjectType', 'GREATWORKOBJECT_WRITING'),
    ('OPERA_BALLET_BOOST_WRITING_TOURISM', 'ScalingFactor', 200);
INSERT INTO CivicModifiers (CivicType, ModifierId) VALUES
    ('CIVIC_OPERA_BALLET', 'OPERA_BALLET_BOOST_WRITING_TOURISM');

INSERT INTO Modifiers (ModifierId, ModifierType) 
    SELECT 'STEAMPOWER_BOOST_ART_TOURISM_' || GreatWorkObjectTypes.GreatWorkObjectType, 'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM' FROM GreatWorkObjectTypes WHERE GreatWorkObjectType
    IN ('GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_SCULPTURE');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'STEAMPOWER_BOOST_ART_TOURISM_' || GreatWorkObjectTypes.GreatWorkObjectType, 'GreatWorkObjectType', GreatWorkObjectTypes.GreatWorkObjectType FROM GreatWorkObjectTypes WHERE GreatWorkObjectType
    IN ('GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_SCULPTURE');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'STEAMPOWER_BOOST_ART_TOURISM_' || GreatWorkObjectTypes.GreatWorkObjectType, 'ScalingFactor', 150 FROM GreatWorkObjectTypes WHERE GreatWorkObjectType
    IN ('GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_SCULPTURE');

INSERT INTO TechnologyModifiers (TechnologyType, ModifierId)
    SELECT 'TECH_STEAM_POWER', 'STEAMPOWER_BOOST_ART_TOURISM_' || GreatWorkObjectTypes.GreatWorkObjectType FROM GreatWorkObjectTypes WHERE GreatWorkObjectType
    IN ('GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_SCULPTURE');