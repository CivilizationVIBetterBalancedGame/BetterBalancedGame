
-- Listening post and counterspy last 50 turns (Online Speed)
UPDATE UnitOperations SET Turns=100 WHERE OperationType='UNITOPERATION_SPY_COUNTERSPY' OR OperationType='UNITOPERATION_SPY_LISTENING_POST';
