-- Created by iElden

-- Delete free trader (keep tradetoute capacity)
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_POTTERY_ADD_TRADER' AND Name='Amount';

