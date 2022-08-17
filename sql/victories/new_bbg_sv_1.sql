------------------------------------------------------------------------------
--	FILE:	 new_bbg_sv_1.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				SV: FAST SETTINGS 											 ******
--==============================================================================================

-- 4.6.0: SV balance

-- Future tech are now not random.
UPDATE Technologies_XP2 SET HiddenUntilPrereqComplete=0 WHERE TechnologyType='TECH_FUTURE_TECH';
UPDATE Technologies_XP2 SET RandomPrereqs=0, HiddenUntilPrereqComplete=0;
UPDATE Technologies SET UITreeRow=1 WHERE TechnologyType='TECH_SMART_MATERIALS';
UPDATE Technologies SET UITreeRow=2 WHERE TechnologyType='TECH_PREDICTIVE_SYSTEMS';
UPDATE Technologies SET UITreeRow=-1 WHERE TechnologyType='TECH_ADVANCED_POWER_CELLS';
UPDATE Technologies SET UITreeRow=-2 WHERE TechnologyType='TECH_ADVANCED_AI';
UPDATE Technologies SET UITreeRow=-1, Cost=2300 WHERE TechnologyType='TECH_CYBERNETICS';
UPDATE Technologies SET UITreeRow=1, Cost=2300 WHERE TechnologyType='TECH_SEASTEADS';
INSERT INTO TechnologyPrereqs(Technology, PrereqTech) VALUES
    ('TECH_FUTURE_TECH', 'TECH_OFFWORLD_MISSION'),
    ('TECH_OFFWORLD_MISSION', 'TECH_SEASTEADS'),
    ('TECH_OFFWORLD_MISSION', 'TECH_CYBERNETICS'),
    ('TECH_SEASTEADS', 'TECH_SMART_MATERIALS'),
    ('TECH_SEASTEADS', 'TECH_PREDICTIVE_SYSTEMS'),
    ('TECH_CYBERNETICS', 'TECH_ADVANCED_AI'),
    ('TECH_CYBERNETICS', 'TECH_ADVANCED_POWER_CELLS'),
    ('TECH_ADVANCED_AI', 'TECH_ROBOTICS'),
    ('TECH_ADVANCED_POWER_CELLS', 'TECH_ROBOTICS'),
    ('TECH_ADVANCED_POWER_CELLS', 'TECH_NUCLEAR_FUSION'),
    ('TECH_SMART_MATERIALS', 'TECH_NANOTECHNOLOGY'),
    ('TECH_PREDICTIVE_SYSTEMS', 'TECH_NANOTECHNOLOGY');

-- Science ministery up
UPDATE ModifierArguments SET Value=3 WHERE ModifierId='GOV_PROJECT_ABILITY' AND Name='Amount';

-- Production cost adjustments
UPDATE Districts SET Cost=1600 WHERE DistrictType='DISTRICT_SPACEPORT';
UPDATE Projects SET Cost=1000 WHERE ProjectType='PROJECT_LAUNCH_EARTH_SATELLITE';