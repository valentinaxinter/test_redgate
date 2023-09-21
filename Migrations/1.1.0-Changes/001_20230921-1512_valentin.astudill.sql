-- <Migration ID="7718d208-5e60-4a5b-9d8b-456b633ce956" />
GO

PRINT N'Dropping constraints from [dbo].[test_to]'
GO
ALTER TABLE [dbo].[test_to] DROP CONSTRAINT [PK__test_to__3214EC07ECC99638]
GO
PRINT N'Dropping [dbo].[test_to]'
GO
DROP TABLE [dbo].[test_to]
GO
