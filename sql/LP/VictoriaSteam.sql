
-- 04/07/24 England rework, remove the prod bonus on strategics
-- UPDATE ModifierArguments SET Value='1' WHERE ModifierId='VICTORIA_STRATEGIC_RESOURCE' AND Name='Amount';
-- -- 15/06/23 bonus production only working on improved resources
-- UPDATE Modifiers SET SubjectRequirementSetId='PLOT_HAS_STRATEGIC_IMPROVED_REQUIREMENTS' WHERE ModifierId='VICTORIA_STRATEGIC_RESOURCE';

DELETE FROM TraitModifiers WHERE ModifierId='VICTORIA_STRATEGIC_RESOURCE';

-- 15/06/23 remove production bonus with workshop
DELETE FROM Modifiers WHERE ModifierId='VICTORIA_PRODUCTION_WORKSHOP';
-- 20/06/25 production from factory and powerplant reduced to 10
UPDATE ModifierArguments SET Value=5 WHERE Name='Amount' AND ModifierId IN ('VICTORIA_PRODUCTION_FACTORY', 'VICTORIA_PRODUCTION_POWER_PLANT');

-- 04/07/24 England rework : get the % prod toward IZ building from England
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_LEADER_VICTORIA_ALT', 'TRAIT_ADJUST_INDUSTRIAL_ZONE_BUILDINGS_PRODUCTION');

-- 04/07/24 AoS RND give +2 adjency to IZ
-- 04/08/24 Reduced to +1
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, AdjacentDistrict) VALUES
    ('BBG_AOS_ADJENCY_IZ_RND', 'LOC_BBG_AOS_ADJENCY_IZ_RND_DESC', 'YIELD_PRODUCTION', 1, 'DISTRICT_ROYAL_NAVY_DOCKYARD');
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_INDUSTRIAL_ZONE', 'BBG_AOS_ADJENCY_IZ_RND');
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId)
   SELECT TraitType, 'BBG_AOS_ADJENCY_IZ_RND' FROM CivilizationTraits WHERE CivilizationType != 'CIVILIZATION_ENGLAND' GROUP BY CivilizationType;
INSERT INTO ExcludedAdjacencies(TraitType, YieldChangeId) VALUES
	('TRAIT_LEADER_PAX_BRITANNICA', 'BBG_AOS_ADJENCY_IZ_RND'),
	('TRAIT_LEADER_ELIZABETH', 'BBG_AOS_ADJENCY_IZ_RND'),
	('TRAIT_LEADER_ELEANOR_LOYALTY', 'BBG_AOS_ADJENCY_IZ_RND');

-- 04/07/24 Lighthouse give +1 great engineer point (requirement is coded in England.sql)
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_ENGINEER_LIGHTHOUSE_DOCKYARD_GIVER', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', NULL),
    ('BBG_ENGINEER_LIGHTHOUSE_DOCKYARD', 'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT', 'BUILDING_IS_LIGHTHOUSE');
INSERT INTO ModifierArguments (ModifierId , Name , Value) VALUES
    ('BBG_ENGINEER_LIGHTHOUSE_DOCKYARD_GIVER', 'ModifierId', 'BBG_ENGINEER_LIGHTHOUSE_DOCKYARD'),
    ('BBG_ENGINEER_LIGHTHOUSE_DOCKYARD', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER'),
    ('BBG_ENGINEER_LIGHTHOUSE_DOCKYARD', 'Amount', '1');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_VICTORIA_ALT', 'BBG_ENGINEER_LIGHTHOUSE_DOCKYARD_GIVER');


-- 13/04/25 powered building bonus moved from England bonus to Steam
UPDATE TraitModifiers SET TraitType='TRAIT_LEADER_VICTORIA_ALT' WHERE ModifierId LIKE 'TRAIT_POWERED_BUILDINGS_MORE_%';
