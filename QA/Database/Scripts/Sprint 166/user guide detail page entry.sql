IF NOT EXISTS(SELECT 1 FROM SYSTM000KnowdlegeDetail WHERE CategoryId=2 AND Name='Landing Page Dashboard.pdf')
BEGIN
	INSERT INTO dbo.SYSTM000KnowdlegeDetail (CategoryId, Name, DisplayName, URL, DateEntered, EnteredBy, StatusId)
	VALUES (2, 'Landing Page Dashboard.pdf', 'Landing Page Dashboard',
	'https://m4pl-Dev.meridianww.com/Video/Document/Landing Page Dashboard.pdf', GETUTCDATE(), 'System', 1)
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000KnowdlegeDetail WHERE CategoryId=2 AND Name='Dashboard Multi-Select Orders Statusing.pdf')
BEGIN
	INSERT INTO dbo.SYSTM000KnowdlegeDetail (CategoryId, Name, DisplayName, URL, DateEntered, EnteredBy, StatusId)
	VALUES (2, 'Dashboard Multi-Select Orders Statusing.pdf', 'Dashboard Multi-Select Orders Statusing',
	'https://m4pl-Dev.meridianww.com/Video/Document/Dashboard Multi-Select Orders Statusing.pdf', GETUTCDATE(), 'System', 1)
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000KnowdlegeDetail WHERE CategoryId=2 AND Name='Job Report Overview.pdf')
BEGIN
	INSERT INTO dbo.SYSTM000KnowdlegeDetail (CategoryId, Name, DisplayName, URL, DateEntered, EnteredBy, StatusId)
	VALUES (2, 'Job Report Overview.pdf', 'Job Report Overview',
	'https://m4pl-Dev.meridianww.com/Video/Document/Job Report Overview.pdf', GETUTCDATE(), 'System', 1)
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000KnowdlegeDetail WHERE CategoryId=2 AND Name='Job Tracking Actions and Gateways.pdf')
BEGIN
	INSERT INTO dbo.SYSTM000KnowdlegeDetail (CategoryId, Name, DisplayName, URL, DateEntered, EnteredBy, StatusId)
	VALUES (2, 'Job Tracking Actions and Gateways.pdf', 'Job Tracking Actions and Gateways',
	'https://m4pl-Dev.meridianww.com/Video/Document/Job Tracking Actions and Gateways.pdf', GETUTCDATE(), 'System', 1)
END
IF NOT EXISTS(SELECT 1 FROM SYSTM000KnowdlegeDetail WHERE CategoryId=2 AND Name='Adding Exceptions.pdf')
BEGIN
	INSERT INTO dbo.SYSTM000KnowdlegeDetail (CategoryId, Name, DisplayName, URL, DateEntered, EnteredBy, StatusId)
	VALUES (2, 'Adding Exceptions.pdf', 'Adding Exceptions',
	'https://m4pl-Dev.meridianww.com/Video/Document/Adding Exceptions.pdf', GETUTCDATE(), 'System', 1)
END



