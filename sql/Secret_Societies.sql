--==================
-- Sweden
--==================
-- +50% prod to uiniversity replacement in secret societies
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
        VALUES
        ('TRAIT_CIVILIZATION_NOBEL_PRIZE' , 'NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' );
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
        VALUES
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' , null);
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
        VALUES
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'BuildingType' , 'BUILDING_ALCHEMICAL_SOCIETY'),
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'Amount'       , '50');