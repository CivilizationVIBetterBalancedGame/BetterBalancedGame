--======Mvemba(Old Kongo Leader)======--

/*
--5.1 Founder Belief Bug Fix (scrapped and replaced in 5.4)
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_PLAYER_IS_RELIGIOUS_CONVERT', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'),
	('BBG_REQUIRES_PLAYER_FOUNDED_RELIGION_OR_MVEMBA', 'REQUIREMENT_REQUIREMENTSET_IS_MET');

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_REQSET_FOUNDER_OR_MVEMBA', 'REQUIREMENTSET_TEST_ANY');

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_REQSET_FOUNDER_OR_MVEMBA', 'REQUIRES_PLAYER_FOUNDED_RELIGION'),
	('BBG_REQSET_FOUNDER_OR_MVEMBA', 'BBG_REQUIRES_PLAYER_IS_RELIGIOUS_CONVERT');

INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_PLAYER_IS_RELIGIOUS_CONVERT', 'LeaderType', 'LEADER_MVEMBA'),
	('BBG_REQUIRES_PLAYER_FOUNDED_RELIGION_OR_MVEMBA', 'RequirementSetId', 'BBG_REQSET_FOUNDER_OR_MVEMBA');

UPDATE RequirementSetRequirements SET RequirementId = 'BBG_REQUIRES_PLAYER_FOUNDED_RELIGION_OR_MVEMBA' WHERE RequirementId = 'REQUIRES_PLAYER_FOUNDED_RELIGION' AND RequirementSetId <> 'BBG_REQSET_FOUNDER_OR_MVEMBA';

--5.4 Founder / Reformer Belief Bug Fix (5.1 version allows for DOF and CRUSADE on Kongo if he was converted to one of them)
--Change the religion mechanism works to accomodate for Mvemba
--Creating Reqs for attachment extra step
INSERT INTO Requirements(RequirementId, RequirementType) 
	SELECT 'BBG_FOUNDED_'||Beliefs.BeliefType||'_REQ', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'BBG_FOUNDED_'||Beliefs.BeliefType||'_REQ', 'PropertyName', 'FOUNDER_OF_'||Beliefs.BeliefType
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
--Note: Property is set in Lua
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'BBG_FOUNDED_'||Beliefs.BeliefType||'_REQ', 'PropertyMinimum', '1'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) 
	SELECT 'BBG_FOUNDED_'||Beliefs.BeliefType||'_REQSET', 'REQUIREMENTSET_TEST_ALL'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) 
	SELECT 'BBG_FOUNDED_'||Beliefs.BeliefType||'_REQSET', 'BBG_FOUNDED_'||Beliefs.BeliefType||'_REQ'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT 'BBG_ACTIVATE_'||Beliefs.BeliefType||'_REQ', 'REQUIREMENT_COLLECTION_COUNT_ATLEAST'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'BBG_ACTIVATE_'||Beliefs.BeliefType||'_REQ', 'CollectionType', 'COLLECTION_PLAYER_CITIES'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'BBG_ACTIVATE_'||Beliefs.BeliefType||'_REQ', 'Count', '1'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'BBG_ACTIVATE_'||Beliefs.BeliefType||'_REQ', 'RequirementSetId', 'BBG_FOUNDED_'||Beliefs.BeliefType||'_REQSET'
	FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER');

--UPDATES THE REQS IN THE ORIGINAL BELIEF MODIFIERS
CREATE TABLE KongoTemp(
	BeliefType TEXT, 
	ModifierId TEXT, 
	RequirementSet_NEW TEXT,
	RequirementSet_OLD TEXT,
	PRIMARY KEY(BeliefType, ModifierId)
);

INSERT INTO KongoTemp(BeliefType, ModifierId, RequirementSet_NEW, RequirementSet_OLD)
	SELECT BeliefModifiers.BeliefType, BeliefModifiers.ModifierID, 'BBG_ACTIVATE_'||BeliefModifiers.BeliefType||'_REQSET', Modifiers.SubjectRequirementSetId
	FROM BeliefModifiers INNER JOIN Modifiers ON BeliefModifiers.ModifierID = Modifiers.ModifierId
	WHERE BeliefModifiers.BeliefType IN (SELECT BeliefType FROM Beliefs WHERE BeliefClassType IN ('BELIEF_CLASS_ENHANCER', 'BELIEF_CLASS_FOUNDER'));

CREATE TABLE KongoReqsTemp(
	RequirementSetId TEXT,
	RequirementSetType TEXT,
	RequirementId TEXT
);

INSERT INTO KongoReqsTemp(RequirementSetId, RequirementSetType, RequirementId)
	SELECT KongoTemp.RequirementSet_NEW, RequirementSets.RequirementSetType, CASE 
		WHEN RequirementSetRequirements.RequirementId = 'REQUIRES_PLAYER_FOUNDED_RELIGION' THEN 'BBG_ACTIVATE_'||KongoTemp.BeliefType||'_REQ'
		ELSE RequirementSetRequirements.RequirementId
		END
	FROM KongoTemp 
		INNER JOIN RequirementSets ON KongoTemp.RequirementSet_OLD = RequirementSets.RequirementSetId
		INNER JOIN RequirementSetRequirements ON RequirementSets.RequirementSetId = RequirementSetRequirements.RequirementSetId;

INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT DISTINCT KongoReqsTemp.RequirementSetId, KongoReqsTemp.RequirementSetType FROM KongoReqsTemp;

INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT DISTINCT KongoReqsTemp.RequirementSetId, KongoReqsTemp.RequirementId FROM KongoReqsTemp;

UPDATE Modifiers SET SubjectRequirementSetId = 
	(SELECT reqset FROM 
		(SELECT DISTINCT Modifiers.ModifierId as modid, KongoReqsTemp.RequirementSetId as reqset
			FROM Modifiers 
				INNER JOIN KongoTemp ON Modifiers.ModifierId = KongoTemp.ModifierId
				INNER JOIN KongoReqsTemp ON KongoTemp.RequirementSet_NEW = KongoReqsTemp.RequirementSetId)
	WHERE ModifierId = modid)
WHERE EXISTS
	(SELECT reqset FROM 
		(SELECT DISTINCT Modifiers.ModifierId as modid, KongoReqsTemp.RequirementSetId as reqset
			FROM Modifiers 
				INNER JOIN KongoTemp ON Modifiers.ModifierId = KongoTemp.ModifierId
				INNER JOIN KongoReqsTemp ON KongoTemp.RequirementSet_NEW = KongoReqsTemp.RequirementSetId)
	WHERE ModifierId = modid);

UPDATE Modifiers SET ModifierType = 
	CASE
		WHEN ModifierType = 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER' THEN 'MODIFIER_SINGLE_PLAYER_ATTACH_MODIFIER'
		WHEN ModifierType = 'MODIFIER_ALL_UNITS_ATTACH_MODIFIER' THEN 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER'
		WHEN ModifierType = 'MODIFIER_ALL_DISTRICTS_ATTACH_MODIFIER' THEN 'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER'
		ELSE ModifierType
	END
WHERE Modifiers.ModifierId IN (SELECT DISTINCT ModifierId FROM KongoTemp WHERE RequirementSet_OLD NOT NULL);
--Create Mvemba or Founder Condition
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('BBG_REQUIRES_PLAYER_IS_RELIGIOUS_CONVERT', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_PLAYER_IS_RELIGIOUS_CONVERT', 'LeaderType', 'LEADER_MVEMBA');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_REQSET_FOUNDER_OR_MVEMBA', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_REQSET_FOUNDER_OR_MVEMBA', 'REQUIRES_PLAYER_FOUNDED_RELIGION'),
	('BBG_REQSET_FOUNDER_OR_MVEMBA', 'BBG_REQUIRES_PLAYER_IS_RELIGIOUS_CONVERT');
--Create a pre modifier to player, then attach this to beliefs
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) 
	SELECT 'PRE_'||KongoTemp.ModifierId||'_BBG', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'BBG_REQSET_FOUNDER_OR_MVEMBA'
	FROM KongoTemp WHERE KongoTemp.RequirementSet_OLD NOT NULL;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'PRE_'||KongoTemp.ModifierId||'_BBG', 'ModifierId', KongoTemp.ModifierId
	FROM KongoTemp WHERE KongoTemp.RequirementSet_OLD NOT NULL;

UPDATE BeliefModifiers SET ModifierID = 
	(SELECT 'PRE_'||modid||'_BBG' FROM 
		(SELECT ModifierId as modid FROM KongoTemp WHERE RequirementSet_OLD NOT NULL) 
	WHERE ModifierID = modid)
WHERE
	EXISTS
	(SELECT 'PRE_'||modid||'_BBG' FROM 
		(SELECT ModifierId as modid FROM KongoTemp WHERE RequirementSet_OLD NOT NULL) 
	WHERE ModifierID = modid);

DROP TABLE KongoTemp;
DROP TABLE KongoReqsTemp;
*/
-- Mvemba military unit get forest and jungle free move instead of Ngao
DELETE FROM UnitAbilityModifiers WHERE ModifierId='NAGAO_FOREST_MOVEMENT';

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_MILITARY_UNITS_IGNORE_WOODS', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_MILITARY_UNITS_IGNORE_WOODS', 'AbilityType', 'BBG_IGNORE_WOODS_ABILITY');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_RELIGIOUS_CONVERT', 'BBG_MILITARY_UNITS_IGNORE_WOODS');

INSERT INTO Types(Type, Kind) VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags(Type, Tag) VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_RECON'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_MELEE'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_RANGED'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_ANTI_CAVALRY'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_LIGHT_CAVALRY'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_HEAVY_CAVALRY'),
    ('BBG_IGNORE_WOODS_ABILITY', 'CLASS_SIEGE');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive, ShowFloatTextWhenEarned, Permanent)  VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'LOC_BBG_IGNORE_WOODS_ABILITY_NAME', 'LOC_BBG_IGNORE_WOODS_ABILITY_DESCRIPTION', 1, 0, 1);
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_IGNORE_WOODS_ABILITY', 'RANGER_IGNORE_FOREST_MOVEMENT_PENALTY');


-- 18/06/23 Moved relic bonus from kongo to Mvemba only
UPDATE TraitModifiers SET TraitType='TRAIT_LEADER_RELIGIOUS_CONVERT' WHERE ModifierId='TRAIT_GREAT_WORK_FAITH_RELIC';
UPDATE TraitModifiers SET TraitType='TRAIT_LEADER_RELIGIOUS_CONVERT' WHERE ModifierId='TRAIT_GREAT_WORK_FOOD_RELIC';
UPDATE TraitModifiers SET TraitType='TRAIT_LEADER_RELIGIOUS_CONVERT' WHERE ModifierId='TRAIT_GREAT_WORK_PRODUCTION_RELIC';
UPDATE TraitModifiers SET TraitType='TRAIT_LEADER_RELIGIOUS_CONVERT' WHERE ModifierId='TRAIT_GREAT_WORK_GOLD_RELIC';

--=======Kongo(Civilization)==========--
-- +100% prod towards archealogists
INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_CIVILIZATION_NKISI', 'TRAIT_ARCHAEOLOGIST_PROD_BBG');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
	('TRAIT_ARCHAEOLOGIST_PROD_BBG', 'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('TRAIT_ARCHAEOLOGIST_PROD_BBG', 'UnitType', 'UNIT_ARCHAEOLOGIST'),
	('TRAIT_ARCHAEOLOGIST_PROD_BBG', 'Amount', '100');

-- NGao 3PM
-- 16/04/23 Revert
-- UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_KONGO_SHIELD_BEARER';

-- Put back writer point.
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_NKISI', 'TRAIT_DOUBLE_WRITER_POINTS');

-- +4 faith for each sculture and artifact
UPDATE ModifierArguments SET Value='4' WHERE Name='YieldChange' AND ModifierId IN ('TRAIT_GREAT_WORK_FAITH_SCULPTURE', 'TRAIT_GREAT_WORK_FAITH_ARTIFACT');


