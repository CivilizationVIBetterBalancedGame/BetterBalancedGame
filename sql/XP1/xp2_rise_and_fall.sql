-- Warlord's Throne extra resource stockpile
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES
	('BUILDING_GOV_CONQUEST' , 'BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId , OwnerRequirementSetId)
	VALUES
	('BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE' , 'MODIFIER_PLAYER_ADJUST_RESOURCE_STOCKPILE_CAP' , NULL , NULL);
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE' , 'Amount' , '30');
--Warlord's Throne +2 revealed strategics/turn (abstract, robust to reveal tech change in Resources Table)
--Creating Modifiers
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_'||REPLACE(Resources.ResourceType, 'RESOURCE_','')||'_CPLMOD'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER', 'ResourceType', Resources.ResourceType
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER', 'Amount', 2
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';
--Attaching Modifiers to Warlor's Throne
INSERT INTO BuildingModifiers(BuildingType, ModifierId)
	SELECT 'BUILDING_GOV_CONQUEST', 'BUILDING_GOV_CONQUEST_'||Resources.ResourceType||'_ACCUMULATION_MODIFIER'
	FROM Resources WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC';	

--==================
-- Cree
--==================
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_SKIRMISHER' WHERE Unit='UNIT_CREE_OKIHTCITAW';


--==================
-- Mapuche
--==================
-- Malon Raiders become Courser replacement and territory bonus replaced with +1 movement
UPDATE Units SET Combat=48 , Cost=230 , Maintenance=3 , BaseMoves=6 , PrereqTech='TECH_CASTLES' , MandatoryObsoleteTech='TECH_SYNTHETIC_MATERIALS' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitReplaces WHERE CivUniqueUnitType='UNIT_MAPUCHE_MALON_RAIDER';
INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 'UNIT_COURSER');
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CAVALRY' WHERE Unit='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitAbilityModifiers WHERE ModifierId='MALON_RAIDER_TERRITORY_COMBAT_BONUS';
-- Malons cost Horses
INSERT OR IGNORE INTO Units_XP2 (UnitType , ResourceCost)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 20);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
