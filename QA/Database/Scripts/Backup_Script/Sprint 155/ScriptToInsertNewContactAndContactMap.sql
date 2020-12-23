
 BEGIN
 BEGIN TRY
        BEGIN TRANSACTION;
		Declare @ContactId bigint 
INSERT INTO dbo.CONTC000Master (ConERPId, ConOrgId, ConCompanyName, ConTitleId, ConLastName, ConFirstName, ConMiddleName, ConEmailAddress, ConEmailAddress2, ConImage, ConJobTitle, ConBusinessPhone, ConBusinessPhoneExt, ConHomePhone, ConMobilePhone, ConFaxNumber, ConBusinessAddress1, ConBusinessAddress2, ConBusinessCity, ConBusinessStateId, ConBusinessZipPostal, ConBusinessCountryId, ConHomeAddress1, ConHomeAddress2, ConHomeCity, ConHomeStateId, ConHomeZipPostal, ConHomeCountryId, ConAttachments, ConWebPage, ConNotes, StatusId, ConTypeId,  ConOutlookId, ConUDF01, ConUDF02, ConUDF03, ConUDF04, ConUDF05, DateEntered, EnteredBy, DateChanged, ChangedBy, ConCompanyId)
VALUES (NULL, 1, NULL, 57, 'Granger', 'Dustin', NULL, 'dgranger@lykescartage.com', NULL, NULL, 'Terminal Manager', '512-933-9060', NULL, NULL, '979-549-1983', NULL, NULL, NULL, NULL, NULL, NULL, 179, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 63, NULL, NULL, NULL, NULL, NULL, NULL, '2020-08-04 06:48:59.553', 'nfujimoto', '2020-08-04 06:51:48.727', 'nfujimoto', 35)


INSERT INTO dbo.CONTC000Master (ConERPId, ConOrgId, ConCompanyName, ConTitleId, ConLastName, ConFirstName, ConMiddleName, ConEmailAddress, ConEmailAddress2, ConImage, ConJobTitle, ConBusinessPhone, ConBusinessPhoneExt, ConHomePhone, ConMobilePhone, ConFaxNumber, ConBusinessAddress1, ConBusinessAddress2, ConBusinessCity, ConBusinessStateId, ConBusinessZipPostal, ConBusinessCountryId, ConHomeAddress1, ConHomeAddress2, ConHomeCity, ConHomeStateId, ConHomeZipPostal, ConHomeCountryId, ConAttachments, ConWebPage, ConNotes, StatusId, ConTypeId, ConOutlookId, ConUDF01, ConUDF02, ConUDF03, ConUDF04, ConUDF05, DateEntered, EnteredBy, DateChanged, ChangedBy, ConCompanyId)
VALUES (NULL, 1, NULL, NULL, 'Lopez', 'Vero', NULL, 'verolopez149@gmail.com', NULL, NULL, 'After Hours Contact', '831-566-2583', NULL, NULL, NULL, NULL, '500 Westridge Drive, Suite 500', NULL, 'Watsonville', 5, '95076', 179, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 63, NULL, NULL, NULL, NULL, NULL, NULL, '2020-07-28 00:34:39.997', 'nfujimoto', NULL, NULL, 91)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, SCOPE_IDENTITY(), 'VendDcLocationContact', 132, 4, 'After Hours Contact', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-28 00:34:51.503', NULL, NULL)




INSERT INTO dbo.CONTC000Master (ConERPId, ConOrgId, ConCompanyName, ConTitleId, ConLastName, ConFirstName, ConMiddleName, ConEmailAddress, ConEmailAddress2, ConImage, ConJobTitle, ConBusinessPhone, ConBusinessPhoneExt, ConHomePhone, ConMobilePhone, ConFaxNumber, ConBusinessAddress1, ConBusinessAddress2, ConBusinessCity, ConBusinessStateId, ConBusinessZipPostal, ConBusinessCountryId, ConHomeAddress1, ConHomeAddress2, ConHomeCity, ConHomeStateId, ConHomeZipPostal, ConHomeCountryId, ConAttachments, ConWebPage, ConNotes, StatusId, ConTypeId, ConOutlookId, ConUDF01, ConUDF02, ConUDF03, ConUDF04, ConUDF05, DateEntered, EnteredBy, DateChanged, ChangedBy, ConCompanyId)
VALUES (NULL, 1, NULL, 57, 'Sower', 'Bob', NULL, 'bob.sowers@daltonlogistics.com', NULL, NULL, 'Customer Service Rep', '314-770-0072', NULL, NULL, NULL, NULL, '4045 Lakefront Ct.', NULL, 'Earth City', 24, '63045', 179, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 63,  NULL, NULL, NULL, NULL, NULL, NULL, '2020-07-28 00:44:11.3', 'nfujimoto', '2020-08-04 05:48:53.807', 'nfujimoto', 25)

set @ContactId = SCOPE_IDENTITY();
INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, @ContactId, 'VendDcLocationContact', 66, 2, 'Customer Service Representative', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-28 00:44:15.593', 'nfujimoto', '2020-08-04 05:48:53.807')


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, @ContactId, 'VendDcLocationContact', 66, 6, 'Account Manager', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-08-04 05:50:58.503', NULL, NULL)




INSERT INTO dbo.CONTC000Master (ConERPId, ConOrgId, ConCompanyName, ConTitleId, ConLastName, ConFirstName, ConMiddleName, ConEmailAddress, ConEmailAddress2, ConImage, ConJobTitle, ConBusinessPhone, ConBusinessPhoneExt, ConHomePhone, ConMobilePhone, ConFaxNumber, ConBusinessAddress1, ConBusinessAddress2, ConBusinessCity, ConBusinessStateId, ConBusinessZipPostal, ConBusinessCountryId, ConHomeAddress1, ConHomeAddress2, ConHomeCity, ConHomeStateId, ConHomeZipPostal, ConHomeCountryId, ConAttachments, ConWebPage, ConNotes, StatusId, ConTypeId, ConOutlookId, ConUDF01, ConUDF02, ConUDF03, ConUDF04, ConUDF05, DateEntered, EnteredBy, DateChanged, ChangedBy, ConCompanyId)
VALUES (NULL, 1, NULL, NULL, 'Pease', 'Jeff', NULL, 'jeff.pease@daltonlogistics.com', NULL, NULL, 'Terminal Manager', '314-770-0072', NULL, NULL, NULL, NULL, '4045 Lakefront Ct.', NULL, 'Earth City', 24, '63045', 179, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 63,  NULL, NULL, NULL, NULL, NULL, NULL, '2020-07-28 00:46:33.16', 'nfujimoto', NULL, NULL, 25)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, SCOPE_IDENTITY(), 'VendDcLocationContact', 66, 3, 'Terminal Manger', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-28 00:46:37.003', NULL, NULL)


INSERT INTO dbo.CONTC000Master (ConERPId, ConOrgId, ConCompanyName, ConTitleId, ConLastName, ConFirstName, ConMiddleName, ConEmailAddress, ConEmailAddress2, ConImage, ConJobTitle, ConBusinessPhone, ConBusinessPhoneExt, ConHomePhone, ConMobilePhone, ConFaxNumber, ConBusinessAddress1, ConBusinessAddress2, ConBusinessCity, ConBusinessStateId, ConBusinessZipPostal, ConBusinessCountryId, ConHomeAddress1, ConHomeAddress2, ConHomeCity, ConHomeStateId, ConHomeZipPostal, ConHomeCountryId, ConAttachments, ConWebPage, ConNotes, StatusId, ConTypeId, ConOutlookId, ConUDF01, ConUDF02, ConUDF03, ConUDF04, ConUDF05, DateEntered, EnteredBy, DateChanged, ChangedBy, ConCompanyId)
VALUES (NULL, 1, NULL, 57, 'Killam', 'Alexander', NULL, 'akillam@mackiemoncton.com', NULL, NULL, 'Warehouse Manager', '506-857-0341', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 179, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 63,  NULL, NULL, NULL, NULL, NULL, NULL, '2020-07-28 02:22:59.673', 'nfujimoto', NULL, NULL, 36)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, SCOPE_IDENTITY(), 'VendDcLocationContact', 64, 4, 'Warehouse Manager', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-28 02:23:07.387', NULL, NULL)

        COMMIT TRANSACTION;  
    END TRY
	BEGIN CATCH
      
       
            ROLLBACK TRANSACTION;  
        
        
      
    END CATCH
END;
