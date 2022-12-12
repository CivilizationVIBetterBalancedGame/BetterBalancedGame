INSERT INTO Requirements(RequirementId, RequirementType, Inverse) VALUES
    ('REQUIRES_PLOT_HAS_NO_DLV_BISON_BCC', 'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES', '1'); 
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('REQUIRES_PLOT_HAS_NO_DLV_BISON_BCC', 'ResourceType', 'RESOURCE_DLV_BISON');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BCC_PLOT_IS_GRASSLAND_CITY_REQUIREMENT','REQUIRES_PLOT_HAS_NO_DLV_BISON_BCC');