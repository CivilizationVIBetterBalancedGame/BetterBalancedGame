------------------------------------------------------------------------------
-- FILE: new_bbg_catherine_magnificient.sql
-- AUTHOR: iElden, D. / Jack The Narrator
-- PURPOSE: Database leader related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******  CATHERINE THE MAGNIFICIENT(LY OPed)  ******
--==============================================================================================

UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLAYER_HAS_CIVIC_MEDIEVAL_FAIRES_REQSET' WHERE ModifierType='MODIFIER_PLAYER_ALLOW_PROJECT_CATHERINE';
-- UPDATE ModifierArguments SET Value='40' WHERE ModifierId='PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_EXCESS_LUXURIES' AND Name='Amount';
-- UPDATE ModifierArguments SET Value='40' WHERE ModifierId='PROJECT_COMPLETION_GRANT_TOURISM_BASED_ON_EXCESS_LUXURIES' AND Name='Amount';


-- 15/07/2022: Magnificence castel/theater gives culture to improved strategic adjacent
--REQUIRES_PLOT_HAS_IMPROVED_STRATEGIC exists only in GS, recreate
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQUIRES_PLOT_HAS_IMPROVED_STRATEGIC', 'REQUIREMENT_PLOT_IMPROVED_RESOURCE_CLASS_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQUIRES_PLOT_HAS_IMPROVED_STRATEGIC', 'ResourceClassType', 'RESOURCECLASS_STRATEGIC');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType) VALUES
    ('BBG_PLOT_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS',  'REQUIREMENTSET_TEST_ALL'); 
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId) VALUES
    ('BBG_PLOT_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS',  'PLOT_ADJACENT_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS_MET'); 
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId) VALUES
    ('BBG_PLOT_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS',  'REQUIRES_PLOT_HAS_IMPROVED_STRATEGIC'); 
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MAGNIFICENCES_CULTURE_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_PLOT_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MAGNIFICENCES_CULTURE_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_MAGNIFICENCES_CULTURE_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU', 'Amount', '2');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_MAGNIFICENCES', 'BBG_MAGNIFICENCES_CULTURE_STRATEGIC_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU');

-- 15/07/2022: Magnificence castel/theater gives culture to improved bonus adjacent
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_HAS_IMPROVED_BONUS', 'REQUIREMENT_PLOT_IMPROVED_RESOURCE_CLASS_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_HAS_IMPROVED_BONUS', 'ResourceClassType', 'RESOURCECLASS_BONUS');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType) VALUES
    ('BBG_PLOT_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS',  'REQUIREMENTSET_TEST_ALL'); 
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId) VALUES
    ('BBG_PLOT_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS',  'PLOT_ADJACENT_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS_MET'); 
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId) VALUES
    ('BBG_PLOT_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS',  'BBG_REQUIRES_PLOT_HAS_IMPROVED_BONUS'); 
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MAGNIFICENCES_CULTURE_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'BBG_PLOT_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MAGNIFICENCES_CULTURE_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_MAGNIFICENCES_CULTURE_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU', 'Amount', '2');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_MAGNIFICENCES', 'BBG_MAGNIFICENCES_CULTURE_BONUS_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU');
