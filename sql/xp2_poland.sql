--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Poland
--==================
--RequirementSet For FOUNDER Belief
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('RELIGION_HAS_FOUNDER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_SACRED_PLACES_CPLMOD');
--RequirementSet For ENHANCER Belief
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('RELIGION_HAS_ENHANCER_BELIEF_REQUIREMENTS_CPLMOD' , 'REQUIRES_BELIEF_HOLY_WATERS_CPLMOD');
--Checks for FOUNDER Belief
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_BELIEF_SACRED_PLACES_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
--Checks for ENHANCER Belief
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_BELIEF_HOLY_WATERS_CPLMOD' , 'REQUIREMENT_PLAYER_FOUNDED_RELIGION_WITH_BELIEF');
--RequirementArguments
--FOUNDER	
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES('REQUIRES_BELIEF_SACRED_PLACES_CPLMOD' , 'BeliefType' , 'BELIEF_SACRED_PLACES');
--ENHANCER
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_BELIEF_HOLY_WATERS_CPLMOD' , 'BeliefType' , 'BELIEF_HOLY_WATERS');