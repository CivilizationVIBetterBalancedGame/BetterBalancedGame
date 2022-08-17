-- Author: iElden

-- Carnivals don't require population
UPDATE Districts SET RequiresPopulation=0 WHERE DistrictType IN ('DISTRICT_STREET_CARNIVAL', 'DISTRICT_WATER_STREET_CARNIVAL');

-- Up Minas by +5/+5 to match battleship up
UPDATE Units SET Combat=75, RangedCombat=85 WHERE UnitType='UNIT_BRAZILIAN_MINAS_GERAES';

-- New UI : Serraria
--INSERT INTO Types(Type, Kind) VALUES
--    ('BBG_TRAIT_IMPROVEMENT_SERRARIA', 'KIND_TRAIT'),
--    ('BBG_IMPROVEMENT_SERRARIA', 'KIND_IMPROVEMENT');
--INSERT INTO Traits(TraitType) VALUES
--    ('BBG_TRAIT_IMPROVEMENT_SERRARIA');
--INSERT INTO CivilizationTraits(CivilizationType, TraitType) VALUES
--    ('CIVILIZATION_BRAZIL', 'BBG_TRAIT_IMPROVEMENT_SERRARIA');
--
--CREATE TEMPORARY TABLE tmp
--    AS SELECT * FROM Improvements WHERE ImprovementType='IMPROVEMENT_LUMBER_MILL';
--UPDATE tmp SET ImprovementType='BBG_IMPROVEMENT_SERRARIA', TraitType='BBG_TRAIT_IMPROVEMENT_SERRARIA', Name='LOC_BBG_IMPROVEMENT_SERRARIA_NAME', Description='LOC_BBG_IMPROVEMENT_SERRARIA_DESC';
--INSERT INTO Improvements SELECT * from tmp;
--DROP TABLE tmp;
--
--INSERT INTO Improvement_ValidBuildUnits VALUES
--    ('BBG_IMPROVEMENT_SERRARIA', 'UNIT_BUILDER', 1, 0);
--INSERT INTO Improvement_ValidFeatures (ImprovementType, FeatureType) VALUES
--    ('BBG_IMPROVEMENT_SERRARIA', 'FEATURE_JUNGLE');
--INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
--    ('BBG_IMPROVEMENT_SERRARIA', 'YIELD_PRODUCTION', 1);
--INSERT INTO Improvement_BonusYieldChanges (Id, ImprovementType, YieldType, BonusYieldChange, PrereqTech, PrereqCivic) VALUES
--    (3020, 'BBG_IMPROVEMENT_SERRARIA', 'YIELD_PRODUCTION', 1, NULL, 'CIVIC_MERCANTILISM'),
--    (3021, 'BBG_IMPROVEMENT_SERRARIA', 'YIELD_PRODUCTION', 1, 'TECH_STEEL', NULL),
--    (3022, 'BBG_IMPROVEMENT_SERRARIA', 'YIELD_PRODUCTION', 1, 'TECH_CYBERNETICS', NULL);
--INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement) VALUES
--    ('BBG_SerrariaIZProduction', 'LOC_BBG_DISTRICT_SERRARIA_PRODUCTION', 'YIELD_PRODUCTION', 1, 1, 'BBG_IMPROVEMENT_SERRARIA');
--INSERT INTO District_Adjacencies VALUES ('DISTRICT_INDUSTRIAL_ZONE', 'BBG_SerrariaIZProduction');