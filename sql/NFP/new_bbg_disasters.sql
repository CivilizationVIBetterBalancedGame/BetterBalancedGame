-- Reduce chance of total district destroy
-- 17/04/23 old values divided by 2
UPDATE RandomEvent_Damages SET Percentage=25 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_CATASTROPHIC'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=35 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_MEGACOLOSSAL'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_FLOOD_MAJOR'; -- From: 50
UPDATE RandomEvent_Damages SET Percentage=20 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_FLOOD_1000_YEAR'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=20 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_KILIMANJARO_CATASTROPHIC'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=20 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_VESUVIUS_MEGACOLOSSAL'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=15 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_VOLCANO_CATASTROPHIC'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=25 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_VOLCANO_MEGACOLOSSAL'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=5 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_BLIZZARD_SIGNIFICANT'; -- From: 15
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_BLIZZARD_CRIPPLING'; -- From: 50
UPDATE RandomEvent_Damages SET Percentage=5 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_DUST_STORM_GRADIENT'; -- From: 20
UPDATE RandomEvent_Damages SET Percentage=15 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_DUST_STORM_HABOOB'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=5 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_TORNADO_FAMILY'; -- From: 20
UPDATE RandomEvent_Damages SET Percentage=15 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_TORNADO_OUTBREAK'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=5 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_HURRICANE_CAT_4'; -- From: 15
UPDATE RandomEvent_Damages SET Percentage=15 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_HURRICANE_CAT_5'; -- From: 50
UPDATE RandomEvent_Damages SET Percentage=25 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_KRAKATOA_CATASTROPHIC'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=35 WHERE DamageType='DISTRICT_PILLAGED' AND RandomEventType='RANDOM_EVENT_KRAKATOA_MEGACOLOSSAL'; -- From: 80

-- Reduce chance of improvement destroy
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_CATASTROPHIC'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=75 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_MEGACOLOSSAL'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=25 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_FLOOD_MAJOR'; -- From: 50
UPDATE RandomEvent_Damages SET Percentage=40 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_FLOOD_1000_YEAR'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=40 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_KILIMANJARO_CATASTROPHIC'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=40 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_VESUVIUS_MEGACOLOSSAL'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=30 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_VOLCANO_CATASTROPHIC'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_VOLCANO_MEGACOLOSSAL'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_BLIZZARD_SIGNIFICANT'; -- From: 15
UPDATE RandomEvent_Damages SET Percentage=25 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_BLIZZARD_CRIPPLING'; -- From: 50
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_DUST_STORM_GRADIENT'; -- From: 20
UPDATE RandomEvent_Damages SET Percentage=30 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_DUST_STORM_HABOOB'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_TORNADO_FAMILY'; -- From: 20
UPDATE RandomEvent_Damages SET Percentage=30 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_TORNADO_OUTBREAK'; -- From: 75
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_HURRICANE_CAT_4'; -- From: 15
UPDATE RandomEvent_Damages SET Percentage=30 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_HURRICANE_CAT_5'; -- From: 50
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='SPECIFIC_IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_DROUGHT_EXTREME'; -- From: 30
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_KRAKATOA_CATASTROPHIC'; -- From: 80
UPDATE RandomEvent_Damages SET Percentage=75 WHERE DamageType='IMPROVEMENT_DESTROYED' AND RandomEventType='RANDOM_EVENT_KRAKATOA_MEGACOLOSSAL'; -- From: 80

-- 17/04/23 Reduce chance of building destroy
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_CATASTROPHIC';  -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_EYJAFJALLAJOKULL_MEGACOLOSSAL'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_FLOOD_MODERATE'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_FLOOD_MAJOR'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_FLOOD_1000_YEAR'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_KILIMANJARO_GENTLE'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_KILIMANJARO_CATASTROPHIC'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_VESUVIUS_MEGACOLOSSAL'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_VOLCANO_GENTLE'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_VOLCANO_CATASTROPHIC'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_VOLCANO_MEGACOLOSSAL'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=20 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_BLIZZARD_SIGNIFICANT'; -- From 40
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_BLIZZARD_CRIPPLING'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=30 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_DUST_STORM_GRADIENT'; -- From 60
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_DUST_STORM_HABOOB'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=30 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_TORNADO_FAMILY'; -- From 60
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_TORNADO_OUTBREAK'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=20 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_HURRICANE_CAT_4'; -- From 40
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_HURRICANE_CAT_5'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=10 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_NUCLEAR_ACCIDENT_MINOR'; -- From 20
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_NUCLEAR_ACCIDENT_MAJOR'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_KRAKATOA_GENTLE'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_KRAKATOA_CATASTROPHIC'; -- From 100
UPDATE RandomEvent_Damages SET Percentage=50 WHERE DamageType='BUILDING_PILLAGED' AND RandomEventType='RANDOM_EVENT_KRAKATOA_MEGACOLOSSAL'; -- From 100

-- Reduce prod yield from floodplain
UPDATE RandomEvent_Yields SET Percentage=15 WHERE RandomEventType='RANDOM_EVENT_FLOOD_MAJOR' AND YieldType='YIELD_PRODUCTION' AND FeatureType='FEATURE_FLOODPLAINS_GRASSLAND'; -- From: 30
UPDATE RandomEvent_Yields SET Percentage=20 WHERE RandomEventType='RANDOM_EVENT_FLOOD_1000_YEAR' AND YieldType='YIELD_PRODUCTION' AND FeatureType='FEATURE_FLOODPLAINS_GRASSLAND'; -- From: 40
UPDATE RandomEvent_Yields SET Percentage=5 WHERE RandomEventType='RANDOM_EVENT_FLOOD_MAJOR' AND YieldType='YIELD_PRODUCTION' AND FeatureType='FEATURE_FLOODPLAINS_PLAINS'; -- From: 5
UPDATE RandomEvent_Yields SET Percentage=10 WHERE RandomEventType='RANDOM_EVENT_FLOOD_1000_YEAR' AND YieldType='YIELD_PRODUCTION' AND FeatureType='FEATURE_FLOODPLAINS_PLAINS'; -- From: 10

-- Delay heavy chariot on meteors
-- REQUIRE DLC Gran Colombia to boot !
INSERT INTO GoodyHutSubTypes(GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID) VALUES
    ('METEOR_GOODIES', 'METEOR_GRANT_TWO_TECH_BOOSTS', 'LOC_BBG_METOR_GOODIES_FREE_TECH_DESC', 1, 'GOODY_SCIENCE_GRANT_TWO_TECH_BOOSTS');
UPDATE GoodyHutSubTypes SET Weight=99, Turn=30 WHERE GoodyHut='METEOR_GOODIES' AND SubTypeGoodyHut='METEOR_GRANT_GOODIES';

-- 17/04/23 Drought/Meteor/Tornado to 0 frequency
UPDATE RandomEvent_Frequencies SET OccurrencesPerGame=0 WHERE RandomEventType='RANDOM_EVENT_METEOR_SHOWER';
UPDATE RandomEvent_Frequencies SET OccurrencesPerGame=0 WHERE RandomEventType='RANDOM_EVENT_TORNADO_OUTBREAK';
UPDATE RandomEvent_Frequencies SET OccurrencesPerGame=0 WHERE RandomEventType='RANDOM_EVENT_TORNADO_FAMILY';
UPDATE RandomEvent_Frequencies SET OccurrencesPerGame=0 WHERE RandomEventType='RANDOM_EVENT_DROUGHT_MAJOR';
UPDATE RandomEvent_Frequencies SET OccurrencesPerGame=0 WHERE RandomEventType='RANDOM_EVENT_DROUGHT_EXTREME';