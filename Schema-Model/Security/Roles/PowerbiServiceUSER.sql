﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE ROLE [PowerbiServiceUSER]
AUTHORIZATION [guest]
GO
ALTER ROLE [PowerbiServiceUSER] ADD MEMBER [PowerbiServiceAccount]
GO