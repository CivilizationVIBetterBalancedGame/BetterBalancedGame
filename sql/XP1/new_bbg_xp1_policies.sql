--==============================================================
--******				    POLICIES					  ******
--==============================================================

-- 2020/12/20 Pundit proposal accepted to revert Rationalism requirement to +3 (from +4)
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_CAMPUS_HAS_HIGH_ADJACENCY' AND Name='Amount';
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_HOLY_SITE_HAS_HIGH_ADJACENCY' AND Name='Amount';
UPDATE RequirementArguments SET Value=3 WHERE RequirementId='REQUIRES_THEATER_SQUARE_HAS_HIGH_ADJACENCY' AND Name='Amount';

-- 2021/08/24 Rationnalism at 13 population
-- /!\ AFFECT FOLLOWING MODIFIERS :
-- FREEMARKET_BUILDING_YIELDS_HIGH_POP, GRANDOPERA_BUILDING_YIELDS_HIGH_POP
-- RATIONALISM_BUILDING_YIELDS_HIGH_POP, SIMULTANEUM_BUILDING_YIELDS_HIGH_POP
UPDATE RequirementArguments SET Value=13 WHERE RequirementId='REQUIRES_CITY_HAS_HIGH_POPULATION' AND Name='Amount';