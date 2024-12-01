--==============================================================
--******				    POLICIES					  ******
--==============================================================
-- Monks: Cards
INSERT INTO TypeTags(Type, Tag) VALUES
    ('ABILITY_FASCISM_ATTACK_BUFF', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_FASCISM_LEGACY_ATTACK_BUFF', 'CLASS_WARRIOR_MONK'),
    ('ABILITY_TWILIGHT_VALOR_ATTACK_BONUS', 'CLASS_WARRIOR_MONK');

-- 2020/12/20 Pundit proposal accepted to revert Rationalism requirement to +3 (from +4)
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_CAMPUS_HAS_HIGH_ADJACENCY' AND Name='Amount';
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_HOLY_SITE_HAS_HIGH_ADJACENCY' AND Name='Amount';
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_THEATER_SQUARE_HAS_HIGH_ADJACENCY' AND Name='Amount';

-- 2021/08/24 Rationnalism at 13 population
-- /!\ AFFECT FOLLOWING MODIFIERS :
-- FREEMARKET_BUILDING_YIELDS_HIGH_POP, GRANDOPERA_BUILDING_YIELDS_HIGH_POP
-- RATIONALISM_BUILDING_YIELDS_HIGH_POP, SIMULTANEUM_BUILDING_YIELDS_HIGH_POP
UPDATE RequirementArguments SET Value=13 WHERE RequirementId='REQUIRES_CITY_HAS_HIGH_POPULATION' AND Name='Amount';

--5.2.5 buff autocracy (extend bonus to plaza/diplo quarter district AND diplo quarter buildings) -- moved from base
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
    ('POLICY_GOV_AUTOCRACY', 'AUTOCRACY_PLAZA_DISTRICT'),
    ('POLICY_GOV_AUTOCRACY', 'AUTOCRACY_DIPLOMATIC_DISTRICT');

/*--5.2. Disable:
--5.2.5 Communism -- moved from base
INSERT INTO PolicyModifiers(PolicyType, ModifierId)
    SELECT 'POLICY_GOV_COMMUNISM', Modifiers.ModifierId
    FROM Modifiers WHERE ModifierId LIKE 'COMMUNISM%MODIFIER_BBG';
*/


-- Praeorium give +4 Loyalty (from +2)
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='PRAETORIUM_GOVERNORIDENTITY' AND Name='Amount';

-- 28/11/24 Praetorium give +10% production on conquered cities with a gov
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_PRAETORIUM_PRODUCTION_TO_GOV_CONQUERED_CITIES', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER', 'CITY_HAS_GOVERNOR_NOT_FOUNDED');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_PRAETORIUM_PRODUCTION_TO_GOV_CONQUERED_CITIES', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_PRAETORIUM_PRODUCTION_TO_GOV_CONQUERED_CITIES', 'Amount', '10');
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
    ('BBG_PRAETORIUM_PRODUCTION_TO_GOV_CONQUERED_CITIES', 'BBG_PRAETORIUM_PRODUCTION_TO_GOV_CONQUERED_CITIES');