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