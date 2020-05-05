IF NOT EXISTS(Select 1 From [dbo].[XCBL_MER000Authentication] Where WebUsername = 'MerElectroluxXcblUser1')
BEGIN
INSERT INTO [dbo].[XCBL_MER000Authentication] (WebUsername, WebPassword, WebHashKey, FtpUsername, FtpPassword, FtpServerInFolderPath, FtpServerOutFolderPath, LocalFilePath, WebContactName, WebContactCompany, WebContactEmail, WebContactPhone1, WebContactPhone2, Enabled)
VALUES ('MerElectroluxXcblUser1', 'ElectroluxMer$xC8L', 'XcblWebServiceMERIDNow', 'meridiantest', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
END