------------------------------------------------------------------------------
--	FILE:	 new_bbg_base_units.sql
--	AUTHOR:  Pebbleton
--	PURPOSE: ADD +4 base strength to all units which were affected by oligarchy, must be loaded after all unit changes
------------------------------------------------------------------------------
--=======================================================================
--******                        MELEE                              ******
--=======================================================================

-- 06/07/26 oligarchy rework 
UPDATE Units SET Combat=Combat+4 WHERE PromotionClass='PROMOTION_CLASS_MELEE';
UPDATE Units SET Combat=Combat+4 WHERE PromotionClass='PROMOTION_CLASS_ANTI_CAVALRY';
UPDATE Units SET Combat=Combat+4 WHERE PromotionClass='PROMOTION_CLASS_NAVAL_MELEE';
UPDATE Units SET Combat=Combat+4 WHERE PromotionClass='PROMOTION_CLASS_NIHANG';
UPDATE Units SET Combat=Combat+4 WHERE PromotionClass='PROMOTION_CLASS_MONK';


-- 06/07/26 increse units base strength by +4 for all oligarchy units, but add a -4 modifier until philosophy is unlocked
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_PLAYER_DOES_NOT_HAVE_POLITICAL_PHILOSOPHY_REQSET', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_PLAYER_DOES_NOT_HAVE_POLITICAL_PHILOSOPHY_REQSET', 'BBG_PLAYER_DOES_NOT_HAVE_POLITICAL_PHILOSOPHY_REQUIREMENT');
INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
    ('BBG_PLAYER_DOES_NOT_HAVE_POLITICAL_PHILOSOPHY_REQUIREMENT', 'REQUIREMENT_PLAYER_HAS_CIVIC', 1);
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_PLAYER_DOES_NOT_HAVE_POLITICAL_PHILOSOPHY_REQUIREMENT', 'CivicType', 'CIVIC_POLITICAL_PHILOSOPHY');

INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) VALUES
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BBG_PLAYER_DOES_NOT_HAVE_POLITICAL_PHILOSOPHY_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER', 'Amount', '-4');

INSERT INTO ModifierStrings (ModifierId , Context , Text) VALUES
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER', 'Preview', 'LOC_BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY_DESC');

INSERT INTO Types (Type, Kind) VALUES
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY', 'CLASS_MELEE'),
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY', 'CLASS_ANTI_CAVALRY'),
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY', 'CLASS_NAVAL_MELEE'),
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY', 'CLASS_WARRIOR_MONK');

INSERT INTO UnitAbilities(UnitAbilityType, Name, Description) VALUES
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY', 'LOC_BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY_NAME', 'LOC_BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY_DESC');
INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
    ('BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER_ABILITY', 'BBG_OLIGARCHY_UNIT_BASE_STRENGTH_REDUCER');
