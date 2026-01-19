UPDATE ConfigEnabledUniqueUnits SET Enabled = 0;

UPDATE ConfigEnabledUniqueUnits SET Enabled = 1 WHERE Type IN ('UNIT_GERMAN_PANZER', 'UNIT_ROMAN_ONAGER');
UPDATE ConfigEnabledUniqueUnits SET OwnerType='LEADER_BARBAROSSA' WHERE Type='UNIT_GERMAN_PANZER';
UPDATE ConfigEnabledUniqueUnits SET OwnerType='LEADER_JULIUS_CAESAR' WHERE Type='UNIT_ROMAN_ONAGER';

