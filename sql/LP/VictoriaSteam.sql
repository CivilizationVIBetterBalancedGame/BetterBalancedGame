UPDATE ModifierArguments SET Value='1' WHERE ModifierId='VICTORIA_STRATEGIC_RESOURCE' AND Name='Amount';

-- 15/06/23 bonus production only working on improved resources
UPDATE Modifiers SET SubjectRequirementSetId='PLOT_HAS_STRATEGIC_IMPROVED_REQUIREMENTS' WHERE ModifierId='VICTORIA_STRATEGIC_RESOURCE';

-- 15/06/23 remove production bonus with workshop
DELETE FROM Modifiers WHERE ModifierId='VICTORIA_PRODUCTION_WORKSHOP';