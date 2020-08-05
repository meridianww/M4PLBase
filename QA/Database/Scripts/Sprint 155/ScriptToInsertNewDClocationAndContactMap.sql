 BEGIN
 BEGIN TRY
        BEGIN TRANSACTION;
	
Declare @dclocationId bigint 

--First DC Location
INSERT INTO dbo.VEND040DCLocations (VdcVendorID, VdcItemNumber, VdcLocationCode, VdcCustomerCode, VdcLocationTitle, VdcContactMSTRID, StatusId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (10032, 2, 'SANTX', NULL, 'Terminal Manager - SANTX', NULL, 1, 'nfujimoto', '2020-08-04 06:46:51.41', NULL, NULL)

 set  @dclocationId = SCOPE_IDENTITY();

INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, 10135, 'VendDcLocationContact', @dclocationId, 5, 'After Hours Contact', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-31 04:32:44.7', NULL, NULL)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, 10774, 'VendDcLocationContact', @dclocationId, 4, 'Account Manager', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-31 04:32:05.937', NULL, NULL)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, 10214, 'VendDcLocationContact', @dclocationId, 3, 'Terminal Manager', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-31 04:31:21.97', NULL, NULL)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, 10135, 'VendDcLocationContact',@dclocationId, 2, 'Customer Service Representative', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-31 04:30:17.497', NULL, NULL)


--Second DC Location
INSERT INTO dbo.VEND040DCLocations (VdcVendorID, VdcItemNumber, VdcLocationCode, VdcCustomerCode, VdcLocationTitle, VdcContactMSTRID, StatusId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (10032, 3, 'AUSTX', NULL, 'Terminal Manager', NULL, 1, 'nfujimoto', '2020-08-04 06:51:53.313', NULL, NULL)


set  @dclocationId = SCOPE_IDENTITY();
INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, 10774, 'VendDcLocationContact', @dclocationId, 5, 'After Hours Contact', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-31 04:38:17.62', NULL, NULL)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, 10774, 'VendDcLocationContact', @dclocationId, 4, 'Account Manager', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-31 04:37:40.84', NULL, NULL)


INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
VALUES (1, 10138, 'VendDcLocationContact', @dclocationId, 2, 'Customer Service Representative', 20033, 63, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-31 04:34:02.91', NULL, NULL)

        COMMIT TRANSACTION;  
    END TRY
	BEGIN CATCH
      
       
            ROLLBACK TRANSACTION;  
        
        
      
    END CATCH
END;
