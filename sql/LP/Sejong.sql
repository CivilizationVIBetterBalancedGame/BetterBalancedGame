
-- 14/10/23 Sejong culture when getting to a new era equals the science per turn (instead of 2 times)
-- SEJONG_CLASSICAL_SCIENCE_INTO_CULTURE
-- SEJONG_MEDIEVAL_SCIENCE_INTO_CULTURE
-- SEJONG_RENAISSANCE_SCIENCE_INTO_CULTURE
-- SEJONG_INDUSTRIAL_SCIENCE_INTO_CULTURE
-- SEJONG_MODERN_SCIENCE_INTO_CULTURE
-- SEJONG_ATOMIC_SCIENCE_INTO_CULTURE
-- SEJONG_INFORMATION_SCIENCE_INTO_CULTURE
-- SEJONG_FUTURE_SCIENCE_INTO_CULTURE
UPDATE ModifierArguments SET Value=1 WHERE ModifierId LIKE "SEJONG%SCIENCE_INTO_CULTURE" AND Name="Multiplier";