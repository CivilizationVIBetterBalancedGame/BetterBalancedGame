--==================
-- Yongle
--==================
-- 5.2.5 Yongle nerf Pop require remain the same but reduce science/culture from 1 per pop to +0.5/+0.3 (double the inner science/culture per pop) and reduce gold from 2 to 1
-- 14/10/23 from 0.5/0.3 to 0.7/0.5
UPDATE ModifierArguments SET Value='0.7' WHERE ModifierId='YONGLE_SCIENCE_POPULATION' AND Name='Amount';
UPDATE ModifierArguments SET Value='0.5' WHERE ModifierId='YONGLE_CULTURE_POPULATION' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='YONGLE_GOLD_POPULATION' AND Name='Amount';

-- 14/10/23 doubled project yield
-- 25/10/23 nerf project yield to 60%
UPDATE Project_YieldConversions SET PercentOfProductionRate=60 WHERE ProjectType='PROJECT_LIJIA_FOOD';
UPDATE Project_YieldConversions SET PercentOfProductionRate=60 WHERE ProjectType='PROJECT_LIJIA_FAITH';
UPDATE Project_YieldConversions SET PercentOfProductionRate=120 WHERE ProjectType='PROJECT_LIJIA_GOLD';