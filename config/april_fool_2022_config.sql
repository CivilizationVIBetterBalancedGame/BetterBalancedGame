-- by: iElden

-- Create table to avoid config conflict.
CREATE TABLE EldenGameModeApril2022DomainOverrides(
    ParameterValue TEXT PRIMARY KEY NOT NULL,
    PlayerId INTEGER,
    ParameterId TEXT NOT NULL,
    DomainOverride TEXT
);

-- Create Players:Domain with only valid Leaders (Babylon and Spec if exist)
CREATE TEMPORARY TABLE Tmp_Players AS
    SELECT * FROM Players WHERE Domain='Players:Expansion2_Players' AND LeaderType IN ('LEADER_HAMMURABI', 'LEADER_SPECTATOR');
UPDATE Tmp_Players SET Domain='Players:Elden_AprilFool2022';
INSERT INTO Players SELECT * FROM Tmp_Players;
DROP TABLE Tmp_Players;


INSERT INTO Queries(QueryId, SQL) VALUES
    ('EldenGameModeApril2022DomainOverrides',
     'SELECT ParameterId, DomainOverride FROM EldenGameModeApril2022DomainOverrides WHERE ParameterValue = ?1 and (PlayerId = ?2 or PlayerId is null)');

INSERT INTO QueryParameters(QueryId, "Index", ConfigurationGroup, ConfigurationId) VALUES
    ('EldenGameModeApril2022DomainOverrides', '1', 'Game', 'BBG_GAMEMODE_BABYLON'),
    ('EldenGameModeApril2022DomainOverrides', '2', 'Player', 'PLAYER_ID');

INSERT INTO EldenGameModeApril2022DomainOverrides(ParameterValue, PlayerId, ParameterId, DomainOverride) VALUES
    ('1', NULL, 'PlayerLeader', 'Players:Elden_AprilFool2022'),
    ('true', NULL, 'PlayerLeader', 'Players:Elden_AprilFool2022');

INSERT INTO DomainOverrideQueries(QueryId, ParameterIdField, DomainField) VALUES
    ('EldenGameModeApril2022DomainOverrides', 'ParameterId', 'DomainOverride');