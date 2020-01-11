DECLARE @sysRefID INT;

SELECT  @sysRefID= Id FROM M4PL_Test.dbo.SYSTM000Ref_Options WHERE SysLookupCode='ValOperationType' and SysOptionName='OR'

INSERT INTO SYSTM000Validation (LangCode,RefTabPageId,ValTableName,ValFieldName,ValRegEx1,ValRegExMessage1,ValRegExLogic1,ValRegExLogic2,ValRegExLogic3,ValRegExLogic4) VALUES
('EN',0,'Job','JobShipFromSitePOCEmail','^([\w\.\-]+@([\w\-]+)((\.(\w){2,3})+))$','Seller Ship POC Email is Invalid ',@sysRefID,@sysRefID,@sysRefID,@sysRefID)


INSERT INTO SYSTM000Validation (LangCode,RefTabPageId,ValTableName,ValFieldName,ValRegEx1,ValRegExMessage1,ValRegExLogic1,ValRegExLogic2,ValRegExLogic3,ValRegExLogic4) VALUES
('EN',0,'Job','JobShipFromSitePOCPhone','^(\([0-9]{3}\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$','Seller Ship POC Number is Invalid ',@sysRefID,@sysRefID,@sysRefID,@sysRefID)




