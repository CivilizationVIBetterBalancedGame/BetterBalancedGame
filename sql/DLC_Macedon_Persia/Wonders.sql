-- Apadana +1 envoy instead of 2
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='APADANA_AWARD_TWO_INFLUENCE_TOKEN_MODIFIER';

-- Halicarnassus Mausoleum : 200 > 250
UPDATE Buildings SET Cost=500 WHERE BuildingType='BUILDING_HALICARNASSUS_MAUSOLEUM';