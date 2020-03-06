 
--SELECT * FROM [JOBDL010Cargo] WHERE CgoPackagingType IN ( 'PCS' , 'BOX')

--SELECT DISTINCT CgoPackagingType FROM [JOBDL010Cargo] WHERE CgoPackagingType NOT IN ( 'PCS' , 'BOX')

--ALTER TABLE JOBDL010Cargo
--ADD CgoPackagingTypeId INT NULL


--ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoPackagingTypeId_SYSTM000Ref_Options] FOREIGN KEY([CgoPackagingTypeId])
--REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
--GO

--DECLARE @SysRefBoxId INT
--      , @SysRefPcsId INT
--SELECT @SysRefBoxId = Id FROM SYSTM000Ref_Options WHERE SysLookupCode ='PackagingCode' AND SysOptionName = 'BOX'
--SELECT @SysRefPcsId =Id FROM SYSTM000Ref_Options WHERE SysLookupCode ='PackagingCode' AND SysOptionName = 'PCS'
--UPDATE JOBDL010Cargo SET CgoPackagingTypeId = @SysRefBoxId  WHERE CgoPackagingType NOT IN ( 'PCS' , 'BOX')  AND CgoPackagingType IS NOT NULL
--UPDATE JOBDL010Cargo SET CgoPackagingTypeId = @SysRefBoxId  WHERE CgoPackagingType = 'BOX'
--UPDATE JOBDL010Cargo SET CgoPackagingTypeId = @SysRefBoxId  WHERE CgoPackagingType = 'PCS'

--DECLARE @CrgoSOrtOrder INT
--       ,@CrgoLookUpID INT
--SELECT @CrgoSOrtOrder = COUNT(ID)  FROM SYSTM000ColumnsAlias WHERE ColTableName ='JOBCARGO'  
--SELECT @CrgoLookUpID = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'PackagingCode'

--INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
--ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
--VALUES ('EN', 'JobCargo', NULL, 'CgoPackagingTypeId', 'Packaging Type', 'Packaging Type', 'Packaging Type', @CrgoLookUpID, 'PackagingCode', '', @CrgoSOrtOrder + 1, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
--GO

--SELECT * FROM  SYSTM000ColumnsAlias WHERE ColTableName ='JOBCARGO'

--UPDATE SYSTM000ColumnSettingsByUser
--SET ColSortOrder = 'CgoLineItem,CgoPartNumCode,CgoSerialNumber,JobID,CgoPackagingTypeId,CgoTitle,CgoMasterCartonLabel,Id,CgoQtyExpected,CgoQtyUnits,CgoSeverityCode,StatusId,CgoProcessingFlags,EnteredBy,CgoReasonCodeOSD,CgoReasonCodeHold,DateEntered,ChangedBy,CgoWeight,CgoWeightUnits,DateChanged,CgoLength,CgoWidth,CgoHeight,CgoQtyOnHand,CgoVolumeUnits,CgoCubes,CgoQtyDamaged,CgoNotes,CgoQtyOnHold,CgoQTYOrdered,CgoQtyCounted,CgoQtyShortOver,CgoQtyOver,CgoLongitude,CgoLatitude',
--ColNotVisible = 'JobID,CgoProcessingFlags,EnteredBy,DateEntered,ChangedBy,DateChanged,CgoNotes,CgoQtyCounted,CgoPackagingType',
--ColIsDefault = 'Id,JobID,CgoLineItem,CgoPartNumCode,CgoSerialNumber,CgoTitle,CgoSeverityCode,StatusId,CgoReasonCodeOSD,CgoReasonCodeHold,CgoProcessingFlags,EnteredBy,CgoWeight,CgoWeightUnits,DateEntered,ChangedBy,CgoLength,CgoWidth,DateChanged,CgoHeight,CgoQtyExpected,CgoQtyOnHand,CgoVolumeUnits,CgoCubes,CgoQtyDamaged,CgoQtyOnHold,CgoNotes,CgoQtyUnits,CgoQTYOrdered,CgoQtyCounted,CgoQtyShortOver,CgoQtyOver,CgoLongitude,CgoLatitude'
--WHERE ColTableName = 'JOBCARGO'


--ALTER TABLE JOBDL010Cargo
--ADD CgoWeightUnitsId INT NULL

--ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoWeightUnitsId_SYSTM000Ref_Options] FOREIGN KEY([CgoPackagingTypeId])
--REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
--GO

--DECLARE @CrgoSortOrder1 INT
--       ,@CrgoLookUpID1 INT
--SELECT @CrgoSOrtOrder1 = COUNT(ID)  FROM SYSTM000ColumnsAlias WHERE ColTableName ='JOBCARGO'  
--SELECT @CrgoLookUpID1 = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'UnitWeight'

--INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
--ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
--VALUES ('EN', 'JobCargo', NULL, 'CgoWeightUnitsId', 'Weight Units', 'Weight Units', 'Weight Units', @CrgoLookUpID1, 'UnitWeight', '', @CrgoSOrtOrder1 + 1, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
--GO

--ALTER TABLE JOBDL010Cargo
--ADD CgoVolumeUnitsId INT NULL

--ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoVolumeUnitsId_SYSTM000Ref_Options] FOREIGN KEY([CgoPackagingTypeId])
--REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
--GO
--DECLARE @CrgoSortOrder2 INT
--       ,@CrgoLookUpID2 INT
--SELECT @CrgoSOrtOrder2 = COUNT(ID)  FROM SYSTM000ColumnsAlias WHERE ColTableName ='JOBCARGO'  
--SELECT @CrgoLookUpID2 = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'UnitVolume'

--INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
--ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
--VALUES ('EN', 'JobCargo', NULL, 'CgoVolumeUnitsId', 'Volume Units', 'Volume Units', 'Volume Units', @CrgoLookUpID2, 'UnitVolume', '', @CrgoSOrtOrder2 + 1, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
--GO

--ALTER TABLE JOBDL010Cargo
--ADD CgoQtyUnitsId INT NULL

--ALTER TABLE [dbo].[JOBDL010Cargo]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL010Cargo_CgoQtyUnitsId_SYSTM000Ref_Options] FOREIGN KEY([CgoPackagingTypeId])
--REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
--GO
--DECLARE @CrgoSortOrder3 INT
--       ,@CrgoLookUpID3 INT
--SELECT @CrgoSOrtOrder3 = COUNT(ID)  FROM SYSTM000ColumnsAlias WHERE ColTableName ='JOBCARGO'  
--SELECT @CrgoLookUpID3 = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'CargoUnit'

--INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, 
--ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
--VALUES ('EN', 'JobCargo', NULL, 'CgoQtyUnitsId', 'Quantity Unit', 'Quantity Units', 'Quantity Units', @CrgoLookUpID3, 'CargoUnit', '', @CrgoSOrtOrder3 + 1, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
--GO

--UPDATE SYSTM000ColumnSettingsByUser
--SET ColSortOrder = 'CgoLineItem,CgoPartNumCode,CgoSerialNumber,JobID,CgoPackagingTypeId,CgoWeightUnitsId,CgoVolumeUnitsId,CgoQtyUnitsId,CgoTitle,CgoMasterCartonLabel,Id,CgoQtyExpected,CgoSeverityCode,StatusId,CgoProcessingFlags,EnteredBy,CgoReasonCodeOSD,CgoReasonCodeHold,DateEntered,ChangedBy,CgoWeight,DateChanged,CgoLength,CgoWidth,CgoHeight,CgoQtyOnHand,CgoCubes,CgoQtyDamaged,CgoNotes,CgoQtyOnHold,CgoQTYOrdered,CgoQtyCounted,CgoQtyShortOver,CgoQtyOver,CgoLongitude,CgoLatitude',
--ColNotVisible = 'JobID,CgoProcessingFlags,EnteredBy,DateEntered,ChangedBy,DateChanged,CgoNotes,CgoQtyCounted,CgoPackagingType,CgoVolumeUnits,CgoWeightUnits,CgoQtyUnits',
--ColIsDefault = 'Id,JobID,CgoLineItem,CgoPartNumCode,CgoSerialNumber,CgoTitle,CgoSeverityCode,StatusId,CgoReasonCodeOSD,CgoReasonCodeHold,CgoProcessingFlags,EnteredBy,CgoWeight,DateEntered,ChangedBy,CgoLength,CgoWidth,DateChanged,CgoHeight,CgoQtyExpected,CgoQtyOnHand,CgoCubes,CgoQtyDamaged,CgoQtyOnHold,CgoNotes,CgoQTYOrdered,CgoQtyCounted,CgoQtyShortOver,CgoQtyOver,CgoLongitude,CgoLatitude'
--WHERE ColTableName = 'JOBCARGO'

--UPDATE SYSTM000ColumnsAlias SET ColIsDefault =0 where ColTableName ='jobcargo' AND ColColumnName IN ('CgoPackagingType','CgoWeightUnits','CgoVolumeUnits','CgoQtyUnits')

 