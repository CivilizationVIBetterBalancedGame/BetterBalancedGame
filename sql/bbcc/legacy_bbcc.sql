--============Adding Missing Yields:=============-----
--food
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', 'YIELD_FOOD', Flat_CutOffYieldValues.Amount-2, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_FOOD' = Flat_CutOffYieldValues.YieldType
	WHERE Food<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount-2 > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', 'YIELD_FOOD', Hill_CutOffYieldValues.Amount-2, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_FOOD' = Hill_CutOffYieldValues.YieldType
	WHERE Food<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount-2 > 0;
--prod
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', 'YIELD_PRODUCTION', Flat_CutOffYieldValues.Amount-1, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_PRODUCTION' = Flat_CutOffYieldValues.YieldType
	WHERE Prod<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount-1 > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', 'YIELD_PRODUCTION', Hill_CutOffYieldValues.Amount-1, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_PRODUCTION' = Hill_CutOffYieldValues.YieldType
	WHERE Prod<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount-1 > 0;
--gold
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', 'YIELD_GOLD', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_GOLD' = Flat_CutOffYieldValues.YieldType
	WHERE Gold<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', 'YIELD_GOLD', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_GOLD' = Hill_CutOffYieldValues.YieldType
	WHERE Gold<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
--faith
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', 'YIELD_FAITH', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_FAITH' = Flat_CutOffYieldValues.YieldType
	WHERE Faith<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', 'YIELD_FAITH', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_FAITH' = Hill_CutOffYieldValues.YieldType
	WHERE Faith<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
--culture
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', 'YIELD_CULTURE', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_CULTURE' = Flat_CutOffYieldValues.YieldType
	WHERE Cult<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', 'YIELD_CULTURE', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_CULTURE' = Hill_CutOffYieldValues.YieldType
	WHERE Cult<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
--science
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', 'YIELD_SCIENCE', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_SCIENCE' = Flat_CutOffYieldValues.YieldType
	WHERE Sci<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', 'YIELD_SCIENCE', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_SCIENCE' = Hill_CutOffYieldValues.YieldType
	WHERE Sci<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
--excluded terrains that already provide the correct values
INSERT INTO Flat_SpecialTerrain
SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, yt, tt
	FROM BBCC_Modifiers
	INNER JOIN
	(SELECT Terrain_YieldChanges.TerrainType as tt, Terrain_YieldChanges.YieldType as yt, Flat_CutOffYieldValues.Amount as am
	FROM Terrain_YieldChanges
	INNER JOIN Flat_CutOffYieldValues ON Flat_CutOffYieldValues.YieldType = Terrain_YieldChanges.YieldType
	WHERE YieldChange>=Flat_CutOffYieldValues.Amount
		AND Terrain_YieldChanges.TerrainType NOT LIKE "%HILLS"
		AND Terrain_YieldChanges.TerrainType NOT LIKE "%OCEAN"
		AND Terrain_YieldChanges.TerrainType NOT LIKE "%COAST")
	ON BBCC_Modifiers.TerrainType = tt
	WHERE YieldType = yt AND
		SubjectRequirementSetId LIKE '%ADD%';

INSERT INTO Hill_SpecialTerrain
SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, yt, tt
	FROM BBCC_Modifiers
	INNER JOIN
	(SELECT Terrain_YieldChanges.TerrainType as tt, Terrain_YieldChanges.YieldType as yt, Hill_CutOffYieldValues.Amount as am
	FROM Terrain_YieldChanges
	INNER JOIN Hill_CutOffYieldValues ON Hill_CutOffYieldValues.YieldType = Terrain_YieldChanges.YieldType
	WHERE YieldChange>=Hill_CutOffYieldValues.Amount
		AND Terrain_YieldChanges.TerrainType LIKE "%HILLS")
	ON BBCC_Modifiers.TerrainType = tt
	WHERE YieldType = yt AND
		SubjectRequirementSetId LIKE '%ADD%';
		
--================Building Modifiers and Respective Reqsets==================--------
UPDATE BBCC_Modifiers SET InnerReqSet = REPLACE(ModifierId, 'MODIFIER_','REQSET_VALID_TFR_'), ReqSet_TFR = 'REQSET_TFR_'||TerrainType||'_'||
CASE
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType<>'RESOURCECLASS_STRATEGIC' THEN 'HAS_'||ResourceType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType = 'RESOURCECLASS_STRATEGIC' THEN 'HAS_AND_SEES_'||ResourceType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL AND ResourceType IS NOT NULL THEN 'HAS_'||ResourceType||'_AND_'||FeatureType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL THEN 'HAS_'||FeatureType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceType IS NULL THEN 'HAS_NO_RESOURCE_BBCC'
END
WHERE NOT EXISTS 
	(SELECT * FROM 
		(SELECT * FROM Hill_SpecialTerrain UNION SELECT * FROM Flat_SpecialTerrain) as tmp 
		WHERE tmp.SubjectRequirementSetId = BBCC_Modifiers.SubjectRequirementSetId 
			AND tmp.TerrainType=BBCC_Modifiers.TerrainType);

UPDATE BBCC_Modifiers SET InnerReqSet = REPLACE(ModifierId, 'MODIFIER_','REQSET_VALID_TFR_');
--Building Reqsets
INSERT INTO RequirementSets
	SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, 'REQUIREMENTSET_TEST_ALL'
	FROM BBCC_Modifiers;
INSERT INTO RequirementSets
	SELECT DISTINCT BBCC_Modifiers.InnerReqSet, 'REQUIREMENTSET_TEST_ANY'
	FROM BBCC_Modifiers;
INSERT INTO RequirementSets
	SELECT DISTINCT BBCC_Modifiers.ReqSet_TFR, 'REQUIREMENTSET_TEST_ALL'
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--populating tripplets terrain, feature, requirements with concrete reqs
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT ReqSet_TFR, 
	CASE
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType<>'RESOURCECLASS_STRATEGIC' THEN 'REQ_HAS_'||ResourceType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType = 'RESOURCECLASS_STRATEGIC' THEN 'REQ_HAS_AND_SEES_'||ResourceType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL AND ResourceType IS NOT NULL THEN 'REQ_HAS_'||ResourceType||'_AND_'||FeatureType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL THEN 'REQ_HAS_NO_'||FeatureType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceType IS NULL THEN 'REQ_HAS_NO_RESOURCE_BBCC'
	END
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT ReqSet_TFR, 'REQ_PLOT_HAS_'||TerrainType||'_BBCC'
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--creating tfr requirements
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.ReqSet_TFR,'REQSET_','REQ_'), 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.ReqSet_TFR,'REQSET_','REQ_'), 'RequirementSetId', BBCC_Modifiers.ReqSet_TFR
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--inserting them into innerreqsets
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT InnerReqSet, REPLACE(BBCC_Modifiers.ReqSet_TFR,'REQSET_','REQ_')
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--creating req out of inner reqsets
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.InnerReqSet,'REQSET_','REQ_'), 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	FROM BBCC_Modifiers;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.InnerReqSet,'REQSET_','REQ_'), 'RequirementSetId', BBCC_Modifiers.InnerReqSet
	FROM BBCC_Modifiers;
--populating final requirementset
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, 'REQ_PLOT_IS_CITY_CENTER_BBCC'
	FROM BBCC_Modifiers;
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, REPLACE(BBCC_Modifiers.InnerReqSet,'REQSET_','REQ_')
	FROM BBCC_Modifiers;
/*
INSERT INTO RequirementSetRequirements
	SELECT SubjectRequirementSetId, 'REQ_PLOT_HAS_NO_'||TerrainType||'_BBCC' 
	FROM (SELECT * FROM Hill_SpecialTerrain UNION SELECT * FROM Flat_SpecialTerrain);
*/
--Finalizing the modifiers after the requirements are done
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT DISTINCT BBCC_Modifiers.ModifierId, 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', BBCC_Modifiers.SubjectRequirementSetId
	FROM BBCC_Modifiers;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT BBCC_Modifiers.ModifierId, 'YieldType', BBCC_Modifiers.YieldType
	FROM BBCC_Modifiers;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT BBCC_Modifiers.ModifierId, 'Amount', BBCC_Modifiers.Amount
	FROM BBCC_Modifiers;
--Inserting into traits
INSERT INTO TraitModifiers(TraitType, ModifierId)
	SELECT DISTINCT 'TRAIT_LEADER_MAJOR_CIV', BBCC_Modifiers.ModifierId
	FROM BBCC_Modifiers;
INSERT INTO TraitModifiers(TraitType, ModifierId)
	SELECT DISTINCT 'MINOR_CIV_DEFAULT_TRAIT', BBCC_Modifiers.ModifierId
	FROM BBCC_Modifiers;

DROP TABLE BBCC;
DROP TABLE BBCC_Modifiers;
DROP TABLE Hill_SpecialTerrain;
DROP TABLE Flat_SpecialTerrain;
DROP TABLE Flat_CutOffYieldValues;
DROP TABLE Hill_CutOffYieldValues;
