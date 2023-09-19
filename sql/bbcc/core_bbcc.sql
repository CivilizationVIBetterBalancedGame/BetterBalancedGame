--city center
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('REQ_PLOT_IS_CITY_CENTER_BBCC' , 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQ_PLOT_IS_CITY_CENTER_BBCC' , 'DistrictType', 'DISTRICT_CITY_CENTER');
INSERT INTO Requirements(RequirementId, RequirementType, Inverse) VALUES
    ('REQ_PLOT_IS_NO_CITY_CENTER_BBCC' , 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES', '1');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQ_PLOT_IS_NO_CITY_CENTER_BBCC' , 'DistrictType', 'DISTRICT_CITY_CENTER');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('REQSET_PLOT_IS_CITY_CENTER_BBCC', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('REQSET_PLOT_IS_CITY_CENTER_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC');
--Resource Visibility Reqsets
INSERT INTO Requirements(RequirementId, RequirementType, Inverse)
	SELECT 'REQ_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQUIREMENT_PLAYER_HAS_RESOURCE_VISIBILITY', '1'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'REQ_SEES_NO_'||Resources.ResourceType||'_BBCC', 'ResourceType', Resources.ResourceType
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT 'REQSET_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQUIREMENTSET_TEST_ALL'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'REQSET_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQ_SEES_NO_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'REQSET_SEES_NO_'||Resources.ResourceType||'_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('MODIFIER_CITY_GRANT_1_YIELD_FOOD_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC'),
	('MODIFIER_CITY_GRANT_1_YIELD_PRODUCTION_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('MODIFIER_CITY_GRANT_1_YIELD_FOOD_BBCC', 'YieldType', 'YIELD_FOOD'),
	('MODIFIER_CITY_GRANT_1_YIELD_FOOD_BBCC', 'Amount', '1'),
	('MODIFIER_CITY_GRANT_1_YIELD_PRODUCTION_BBCC', 'YieldType', 'YIELD_PRODUCTION'),
	('MODIFIER_CITY_GRANT_1_YIELD_PRODUCTION_BBCC', 'Amount', '1');
--dynamic food
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT 'MODIFIER_CITY_GRANT_1_YIELD_FOOD_NS_'||Resources.ResourceType||'_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_SEES_NO_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'MODIFIER_CITY_GRANT_1_YIELD_FOOD_NS_'||Resources.ResourceType||'_BBCC', 'YieldType', 'YIELD_FOOD'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'MODIFIER_CITY_GRANT_1_YIELD_FOOD_NS_'||Resources.ResourceType||'_BBCC', 'Amount', '1'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
--dynamic prod
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT 'MODIFIER_CITY_GRANT_1_YIELD_PRODUCTION_NS_'||Resources.ResourceType||'_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_SEES_NO_'||Resources.ResourceType||'_BBCC'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'MODIFIER_CITY_GRANT_1_YIELD_PRODUCTION_NS_'||Resources.ResourceType||'_BBCC', 'YieldType', 'YIELD_PRODUCTION'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'MODIFIER_CITY_GRANT_1_YIELD_PRODUCTION_NS_'||Resources.ResourceType||'_BBCC', 'Amount', '1'
	FROM Resources WHERE ResourceClassType='RESOURCECLASS_STRATEGIC';