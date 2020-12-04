DROP PROCEDURE [dbo].[InsertProjectedCapacityRawData]
DROP TYPE [dbo].[uttProjectedCapacityReport]
CREATE TYPE [dbo].[uttProjectedCapacityReport] AS TABLE(
[ProjectedCapacity] INT NULL,
[Location] [nvarchar](1000) NULL,
[Size] BIGINT NULL
)