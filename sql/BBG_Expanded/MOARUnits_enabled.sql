UPDATE EnabledUniqueUnits SET Enabled = 0;

UPDATE EnabledUniqueUnits SET Enabled = 1 WHERE Type IN ('UNIT_GERMAN_PANZER', 'UNIT_ROMAN_ONAGER');
UPDATE EnabledUniqueUnits SET OwnerType='LEADER_BARBAROSSA' WHERE Type='UNIT_GERMAN_PANZER';
UPDATE EnabledUniqueUnits SET OwnerType='LEADER_JULIUS_CAESAR' WHERE Type='UNIT_ROMAN_ONAGER';

INSERT INTO LeaderTraits (LeaderType, TraitType) SELECT OwnerType, 'TRAIT_CIVILIZATION_'||Type FROM EnabledUniqueUnits WHERE Enabled = 1;

