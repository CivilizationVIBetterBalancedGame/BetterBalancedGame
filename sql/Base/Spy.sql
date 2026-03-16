
-- Listening post and counterspy last 50 turns (Online Speed)
UPDATE UnitOperations SET Turns=100 WHERE OperationType='UNITOPERATION_SPY_COUNTERSPY' OR OperationType='UNITOPERATION_SPY_LISTENING_POST';

-- Neutralize governor and sabotage production to 6 turns (Online Speed)
-- 16/03/26 Reduce neutralize governor and sabotage production to 5 turns (Online Speed)
UPDATE UnitOperations SET Turns=10 WHERE OperationType='UNITOPERATION_SPY_NEUTRALIZE_GOVERNOR' OR OperationType='UNITOPERATION_SPY_SABOTAGE_PRODUCTION';

-- 05/01/26 Deleted Breach Dam
DELETE FROM UnitOperations WHERE OperationType='UNITOPERATION_SPY_BREACH_DAM';
DELETE FROM UnitPromotions WHERE UnitPromotionType='PROMOTION_SPY_SATCHEL_CHARGES';