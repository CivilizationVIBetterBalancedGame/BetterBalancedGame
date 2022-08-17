-- by: iElden

-- Remove all Babylon Modifiers
DELETE FROM CivilizationTraits WHERE CivilizationType NOT IN ('CIVILIZATION_BARBARIAN', 'CIVILIZATION_SPECTATOR');
DELETE FROM LeaderTraits WHERE LeaderType='LEADER_HAMMURABI';
INSERT INTO LeaderTraits(LeaderType, TraitType)  VALUES
    ('LEADER_HAMMURABI', 'TRAIT_CIVILIZATION_BABYLON');


-- Add Culture Inspiration at 100%, base culture -50%.
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_AF_INSPIRATION_INCREASE', 'MODIFIER_PLAYER_ADJUST_CIVIC_BOOST'),
    ('BBG_AF_CULTURE_DECREASE', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_AF_INSPIRATION_INCREASE', 'Amount', '100'),
    ('BBG_AF_CULTURE_DECREASE', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_AF_CULTURE_DECREASE', 'Amount', '-50');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_BABYLON', 'BBG_AF_INSPIRATION_INCREASE'),
    ('TRAIT_CIVILIZATION_BABYLON', 'BBG_AF_CULTURE_DECREASE');

-- All UD
INSERT INTO LeaderTraits(LeaderType, TraitType)
    SELECT DISTINCT 'LEADER_HAMMURABI', Districts.TraitType
    FROM Districts WHERE Districts.TraitType IS NOT NULL;

-- More UU
INSERT INTO LeaderTraits(LeaderType, TraitType)
    SELECT DISTINCT 'LEADER_HAMMURABI', Units.TraitType
    FROM Units WHERE Units.TraitType IS NOT NULL;

-- More UB
INSERT INTO LeaderTraits(LeaderType, TraitType)
    SELECT DISTINCT 'LEADER_HAMMURABI', Buildings.TraitType
    FROM Buildings WHERE Buildings.TraitType IS NOT NULL;

-- More UI
INSERT INTO LeaderTraits(LeaderType, TraitType)
    SELECT DISTINCT 'LEADER_HAMMURABI', Improvements.TraitType
    FROM Improvements WHERE Improvements.TraitType LIKE 'TRAIT\_CIVILIZATION%' ESCAPE '\' AND Improvements.TraitType!='TRAIT_CIVILIZATION_NO_PLAYER';