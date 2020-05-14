ALTER TABLE JOBDL040DocumentReference

DROP PK_JOBDL040DocumentReference;
GO

ALTER TABLE JOBDL040DocumentReference ADD JOBDL040DocumentReferenceId BIGINT
GO

UPDATE JOBDL040DocumentReference
SET JOBDL040DocumentReferenceId = Id
GO

ALTER TABLE JOBDL040DocumentReference

DROP COLUMN Id
GO

EXEC sp_rename 'JOBDL040DocumentReference.JOBDL040DocumentReferenceId'
	,'Id'
	,'COLUMN';
GO

ALTER TABLE JOBDL040DocumentReference

ALTER COLUMN Id BIGINT NOT NULL
GO

ALTER TABLE JOBDL040DocumentReference ADD CONSTRAINT PK_JOBDL040DocumentReference PRIMARY KEY (Id);
GO

