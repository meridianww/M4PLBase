
CREATE TABLE SYSTM000KnowdlegeCategoryType
(
	CategoryTypeId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	CategoryType NVARCHAR(30)
)

ALTER TABLE SYSTM000VideoCategory
ADD CategoryTypeId INT NULL

sp_rename SYSTM000VideoCategory,SYSTM000KnowdlegeCategory
sp_rename SYSTM000VideoDetail,SYSTM000KnowdlegeDetail

INSERT INTO SYSTM000KnowdlegeCategoryType VALUES ('Video')
INSERT INTO SYSTM000KnowdlegeCategoryType VALUES('Document')

UPDATE SYSTM000KnowdlegeCategory SET CategoryTypeId=1

insert into SYSTM000KnowdlegeCategory
values (2,'M4PL','M4PL',2)