
-- Harbor gives 1 housing [Lighthouse loses 1]
INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES
    ('DISTRICT_COTHON', 'BBG_HARBOR_HOUSING');

UPDATE ModifierArguments SET Value='25' WHERE ModifierId='COTHON_NAVAL_UNIT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='COTHON_SETTLER_PRODUCTION' AND Name='Amount';

-- Delete Cothon full heal
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='COTHON_HEALFRIENDLY' AND Name='Amount';

-- Delete trade route for gov plaza district.
DELETE FROM TraitModifiers WHERE ModifierId='TRADE_ROUTE_GOVERNMENT_DISTRICT' AND TraitType='TRAIT_LEADER_FOUNDER_CARTHAGE';

-- citizen yields
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' AND DistrictType='DISTRICT_COTHON';

-- 21/08/22 reverted
-- nerf settler PM to +1
-- UPDATE ModifierArguments SET Value='1' WHERE ModifierId='MEDITERRANEAN_COLONIES_EXTRA_MOVEMENT';

-- 30/11/24 Ancient unit gets -5 agaisnt city center, see Base/Units.sql
INSERT INTO TypeTags (Type, Tag) VALUES
    ('UNIT_PHOENICIA_BIREME', 'CLASS_MALUS_CITY_CENTER');



-- 31/07/25 Delete project because bug
DELETE FROM Projects WHERE ProjectType='PROJECT_COTHON_CAPITAL_MOVE';

DELETE FROM TraitModifiers WHERE ModifierId='DISTRICT_COMPLETE_MOVE_CAPITAL';