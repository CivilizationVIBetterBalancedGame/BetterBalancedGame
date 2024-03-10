--==============================================================================================
--******				GOVERNMENT						   ******
--==============================================================================================
-- fascism attack bonus works on defense now too
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_ATTACK_BUFF';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_LEGACY_ATTACK_BUFF';

UPDATE Governments SET OtherGovernmentIntolerance=0 WHERE GovernmentType='GOVERNMENT_DEMOCRACY';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_FASCISM';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_COMMUNISM';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='COLLECTIVIZATION_INTERNAL_TRADE_PRODUCTION' AND Name='Amount';

-- Government slot
UPDATE Government_SlotCounts SET NumSlots=1 WHERE GovernmentType='GOVERNMENT_MERCHANT_REPUBLIC' AND GovernmentSlotType='SLOT_DIPLOMATIC';
UPDATE Government_SlotCounts SET NumSlots=2 WHERE GovernmentType='GOVERNMENT_MERCHANT_REPUBLIC' AND GovernmentSlotType='SLOT_WILDCARD';

--11/12/22 Communism -1 red card +1 yellow card
UPDATE Government_SlotCounts SET NumSlots=2 WHERE GovernmentType='GOVERNMENT_COMMUNISM' AND GovernmentSlotType='SLOT_MILITARY';
UPDATE Government_SlotCounts SET NumSlots=4 WHERE GovernmentType='GOVERNMENT_COMMUNISM' AND GovernmentSlotType='SLOT_ECONOMIC';

--11/12/22
--11/12/22 Collectivization also give +4 gold per traderoute
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_COLLECTIVIZATION_TRADE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_COLLECTIVIZATION_TRADE_GOLD', 'YieldType', 'YIELD_GOLD'),
    ('BBG_COLLECTIVIZATION_TRADE_GOLD', 'Amount', '4');
INSERT INTO PolicyModifiers(PolicyType, ModifierId) VALUES
    ('POLICY_COLLECTIVIZATION', 'BBG_COLLECTIVIZATION_TRADE_GOLD');

-- 15/10/23 Theocracy discount from 15 to 10%
-- 10/03/24 Reverted
-- UPDATE ModifierArguments SET Value=10 WHERE ModifierId='THEOCRACY_FAITH_PURCHASE' and Name='Amount';

-- 10/03/24 Autocracy gives 1 food and production to monument if the city have at least one district
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MONUMENT_FOOD_AUTOCRACY_1_DISTRICT', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', 'CITY_HAS_1_SPECIALTY_DISTRICT'),
    ('BBG_MONUMENT_PRODUCTION_AUTOCRACY_1_DISTRICT', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', 'CITY_HAS_1_SPECIALTY_DISTRICT');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_MONUMENT_FOOD_AUTOCRACY_1_DISTRICT', 'BuildingType', 'BUILDING_MONUMENT'),
    ('BBG_MONUMENT_FOOD_AUTOCRACY_1_DISTRICT', 'YieldType', 'YIELD_FOOD'),
    ('BBG_MONUMENT_FOOD_AUTOCRACY_1_DISTRICT', 'Amount', '1'),
    ('BBG_MONUMENT_PRODUCTION_AUTOCRACY_1_DISTRICT', 'BuildingType', 'BUILDING_MONUMENT'),
    ('BBG_MONUMENT_PRODUCTION_AUTOCRACY_1_DISTRICT', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_MONUMENT_PRODUCTION_AUTOCRACY_1_DISTRICT', 'Amount', '1');
INSERT INTO GovernmentModifiers (GovernmentType, ModifierId) VALUES
    ('GOVERNMENT_AUTOCRACY', 'BBG_MONUMENT_FOOD_AUTOCRACY_1_DISTRICT'),
    ('GOVERNMENT_AUTOCRACY', 'BBG_MONUMENT_PRODUCTION_AUTOCRACY_1_DISTRICT');
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
    ('POLICY_GOV_AUTOCRACY', 'BBG_MONUMENT_FOOD_AUTOCRACY_1_DISTRICT'),
    ('POLICY_GOV_AUTOCRACY', 'BBG_MONUMENT_PRODUCTION_AUTOCRACY_1_DISTRICT');