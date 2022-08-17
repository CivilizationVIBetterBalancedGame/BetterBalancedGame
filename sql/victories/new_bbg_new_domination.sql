------------------------------------------------------------------------------
--	FILE:	 new_bbg_new_domination.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******				V I C T O R Y				  	******
--==============================================================================================

INSERT OR IGNORE INTO Types
	(Type, 													Kind)
	VALUES	
	('VICTORY_TRADITIONAL_DOMINATION' , 					'KIND_VICTORY'),
	('BUILDING_TRADITIONAL_DOMINATION_VICTORY_FLAG' , 		'KIND_BUILDING');	

INSERT OR IGNORE INTO Victories
	(VictoryType, 											Name,												Description,														Blurb,											RequirementSetId,								CriticalPercentage)
	VALUES		
	('VICTORY_TRADITIONAL_DOMINATION' , 					'LOC_VICTORY_TRADITIONAL_DOMINATION_NAME',			'LOC_VICTORY_TRADITIONAL_DOMINATION_DESCRIPTION',					'LOC_VICTORY_TRADITIONAL_DOMINATION_TEXT',		'REQUIREMENTS_TRADITIONAL_DOMINATION_VICTORY',	110);
	
INSERT OR IGNORE INTO Strategies
	(StrategyType, 											VictoryType,							NumConditionsNeeded)
	VALUES		
	('VICTORY_STRATEGY_MILITARY_VICTORY' , 					'VICTORY_TRADITIONAL_DOMINATION',					3);

	
INSERT OR IGNORE INTO Buildings(BuildingType, Name, Description, Cost, AdvisorType, InternalOnly) VALUES
    ('BUILDING_TRADITIONAL_DOMINATION_VICTORY_FLAG' , 'LOC_BUILDING_TRADITIONAL_DOMINATION_VICTORY_FLAG_NAME', 'LOC_BUILDING_TRADITIONAL_DOMINATION_VICTORY_FLAG_DESCRIPTION', 9999, 'ADVISOR_MILITARY', 1);

INSERT OR IGNORE INTO RequirementSets
	(RequirementSetId , 							RequirementSetType)
	VALUES
	('REQUIREMENTS_TRADITIONAL_DOMINATION_VICTORY' , 	'REQUIREMENTSET_TEST_ALL'),	
	('TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS' , 		'REQUIREMENTSET_TEST_ALL');	
	
INSERT OR IGNORE INTO RequirementSetRequirements
	(RequirementSetId , 											RequirementId)
	VALUES
	('REQUIREMENTS_TRADITIONAL_DOMINATION_VICTORY' , 				'TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS_MET'),
	('TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS' , 		'TRADITIONAL_DOMINATION_VICTORY_FLAG');	

INSERT OR IGNORE INTO Requirements
	(RequirementId , 												RequirementType)
	VALUES
	('TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS_MET' , 	'REQUIREMENT_COLLECTION_ANY_MET');
	
INSERT OR IGNORE INTO Requirements
	(RequirementId , 								RequirementType,								Persistent)
	VALUES	
	('TRADITIONAL_DOMINATION_VICTORY_FLAG' , 		'REQUIREMENT_PLAYER_HAS_BUILDING',				1);	
	
INSERT OR IGNORE INTO RequirementArguments
	(RequirementId , 												Name,											Value)
	VALUES
	('TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS_MET' , 	'CollectionType',								'COLLECTION_TEAM_PLAYERS'),
	('TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS_MET' , 	'RequirementSetId',								'TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS'),
	('TRADITIONAL_DOMINATION_VICTORY_FLAG' , 						'BuildingType',									'BUILDING_TRADITIONAL_DOMINATION_VICTORY_FLAG');		

INSERT OR IGNORE INTO RequirementStrings
	(RequirementId , 													Context,								Text)
	VALUES	
	('TRADITIONAL_DOMINATION_VICTORY_PER_TEAM_REQUIREMENTS_MET' , 		'VictoryProgress',						'LOC_VICTORY_TRADITIONAL_DOMINATION_PROGRESS'),	
	('TRADITIONAL_DOMINATION_VICTORY_FLAG' , 							'VictoryProgress',						'LOC_VICTORY_TRADITIONAL_DOMINATION_PROGRESS');	