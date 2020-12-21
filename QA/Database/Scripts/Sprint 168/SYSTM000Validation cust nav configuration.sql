
 IF NOT EXISTS(SELECT 1 FROM SYSTM000Validation WHERE ValTableName='CustNAVConfiguration' AND ValFieldName='ServiceUrl')
 BEGIN
	 INSERT INTO dbo.SYSTM000Validation (LangCode, ValTableName, RefTabPageId, ValFieldName, ValRequired, ValRequiredMessage, ValUnique, ValUniqueMessage, ValRegExLogic0, ValRegEx1, ValRegExMessage1, ValRegExLogic1, ValRegEx2, ValRegExMessage2, ValRegExLogic2, ValRegEx3, ValRegExMessage3, ValRegExLogic3, ValRegEx4, ValRegExMessage4, ValRegExLogic4, ValRegEx5, ValRegExMessage5, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	 VALUES ('EN', 'CustNAVConfiguration', 1, 'ServiceUrl', 1, 'Service Url is mandatory', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, GETUTCDATE(), NULL, NULL, NULL)
 END
  IF NOT EXISTS(SELECT 1 FROM SYSTM000Validation WHERE ValTableName='CustNAVConfiguration' AND ValFieldName='ServiceUserName')
 BEGIN
	 INSERT INTO dbo.SYSTM000Validation (LangCode, ValTableName, RefTabPageId, ValFieldName, ValRequired, ValRequiredMessage, ValUnique, ValUniqueMessage, ValRegExLogic0, ValRegEx1, ValRegExMessage1, ValRegExLogic1, ValRegEx2, ValRegExMessage2, ValRegExLogic2, ValRegEx3, ValRegExMessage3, ValRegExLogic3, ValRegEx4, ValRegExMessage4, ValRegExLogic4, ValRegEx5, ValRegExMessage5, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	 VALUES ('EN', 'CustNAVConfiguration', 1, 'ServiceUserName', 1, 'Service User Name is mandatory', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, GETUTCDATE(), NULL, NULL, NULL)
 END
  IF NOT EXISTS(SELECT 1 FROM SYSTM000Validation WHERE ValTableName='CustNAVConfiguration' AND ValFieldName='ServicePassword')
 BEGIN
	 INSERT INTO dbo.SYSTM000Validation (LangCode, ValTableName, RefTabPageId, ValFieldName, ValRequired, ValRequiredMessage, ValUnique, ValUniqueMessage, ValRegExLogic0, ValRegEx1, ValRegExMessage1, ValRegExLogic1, ValRegEx2, ValRegExMessage2, ValRegExLogic2, ValRegEx3, ValRegExMessage3, ValRegExLogic3, ValRegEx4, ValRegExMessage4, ValRegExLogic4, ValRegEx5, ValRegExMessage5, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	 VALUES ('EN', 'CustNAVConfiguration', 1, 'ServicePassword', 1, 'Service Password is mandatory', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, GETUTCDATE(), NULL, NULL, NULL)
 END
