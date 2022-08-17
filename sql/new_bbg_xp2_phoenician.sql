-- Created by iElden

-- Delete Cothon full heal
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='COTHON_HEALFRIENDLY' AND Name='Amount';

-- Delete trade route for gov plaza district.
DELETE FROM TraitModifiers WHERE ModifierId='TRADE_ROUTE_GOVERNMENT_DISTRICT' AND TraitType='TRAIT_LEADER_FOUNDER_CARTHAGE';

-- nerf settler PM to +1
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='MEDITERRANEAN_COLONIES_EXTRA_MOVEMENT';