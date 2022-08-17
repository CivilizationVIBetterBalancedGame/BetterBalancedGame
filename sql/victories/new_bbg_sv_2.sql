------------------------------------------------------------------------------
--	FILE:	 new_bbg_sv_2.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				SV: FASTEST SETTINGS 										 ******
--==============================================================================================

UPDATE GlobalParameters SET Value='40' WHERE Name='SCIENCE_VICTORY_POINTS_REQUIRED';
UPDATE Projects SET Cost='1200' WHERE ProjectType='PROJECT_LAUNCH_EXOPLANET_EXPEDITION';
UPDATE Projects SET Cost='1200' WHERE ProjectType='PROJECT_LAUNCH_MARS_BASE';
UPDATE Projects SET Cost='500' WHERE ProjectType='PROJECT_ORBITAL_LASER';
UPDATE Projects SET Cost='500' WHERE ProjectType='PROJECT_TERRESTRIAL_LASER';

UPDATE Technologies SET Cost='1200' WHERE TechnologyType='TECH_SEASTEADS';
UPDATE Technologies SET Cost='1200' WHERE TechnologyType='TECH_ADVANCED_AI';
UPDATE Technologies SET Cost='1200' WHERE TechnologyType='TECH_ADVANCED_POWER_CELLS';
UPDATE Technologies SET Cost='1200' WHERE TechnologyType='TECH_CYBERNETICS';
UPDATE Technologies SET Cost='1200' WHERE TechnologyType='TECH_PREDICTIVE_SYSTEMS';
UPDATE Technologies SET Cost='1500' WHERE TechnologyType='TECH_OFFWORLD_MISSION';
