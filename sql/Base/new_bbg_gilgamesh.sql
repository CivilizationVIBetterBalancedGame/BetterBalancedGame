------------------------------------------------------------------------------
--	FILE:	 new_bbg_gilgamesh.sql
--	AUTHOR:  iElden, D. / Jack The Narrator
--	PURPOSE: Database leader related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******			GILGAMESH					 	  ******
--==============================================================================================
-- Delete some old Traits as they are buggy :( 
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_ADVENTURES_ENKIDU' and ModifierId='TRAIT_ADJUST_JOINTWAR_PLUNDER'; -- Coded on the lua front
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_ADVENTURES_ENKIDU' and ModifierId='TRAIT_ADJUST_JOINTWAR_EXPERIENCE'; -- Coded on the lua front
-- In case heroes mode is enabled, this needs to be re-inserted.
-- Arguably, this makes Gilga OP in heroes, but that's okay.
INSERT OR IGNORE INTO Traits (TraitType , Name , Description) VALUES
   ('TRAIT_LEADER_ADVENTURES_ENKIDU', 'TRAIT_LEADER_ADVENTURES_ENKIDU_NAME', 'TRAIT_LEADER_ADVENTURES_ENKIDU_DESCRIPTION' );

-- Give the Barb modifier + Levy Discount + Add combat experience
INSERT INTO TraitModifiers
		(TraitType,									ModifierId)
VALUES	('TRAIT_LEADER_ADVENTURES_ENKIDU', 			'TRAIT_BARBARIAN_CAMP_GOODY'),
--		('TRAIT_LEADER_ADVENTURES_ENKIDU', 			'TRAIT_GILGAMESH_COMBAT_EXPERIENCE'),
		('TRAIT_LEADER_ADVENTURES_ENKIDU', 			'TRAIT_LEVY_DISCOUNT');

INSERT INTO Modifiers
		(ModifierId,										ModifierType,														SubjectRequirementSetId)
VALUES	('TRAIT_GILGAMESH_COMBAT_EXPERIENCE',				'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_EXPERIENCE_MODIFIER',			NULL);

INSERT INTO ModifierArguments
		(ModifierId,										Name,						Value)
VALUES	('TRAIT_GILGAMESH_COMBAT_EXPERIENCE',				'Amount',					25);

-- Sumerian War Carts as a starting unit in Ancient is coded on the lua front
