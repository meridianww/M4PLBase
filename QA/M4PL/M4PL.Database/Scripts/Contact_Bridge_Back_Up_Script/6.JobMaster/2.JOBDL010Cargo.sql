INSERT INTO [dbo].[JOBDL010Cargo]
           ([JobID]
           ,[CgoLineItem]
           ,[CgoPartNumCode]
           ,[CgoTitle]
           ,[CgoSerialNumber]
           ,[CgoMasterLabel]
           ,[CgoPackagingType]
           ,[CgoMasterCartonLabel]
           ,[CgoWeight]
           ,[CgoWeightUnits]
           ,[CgoLength]
           ,[CgoWidth]
           ,[CgoHeight]
           ,[CgoVolumeUnits]
           ,[CgoCubes]
           ,[CgoNotes]
           ,[CgoQtyExpected]
           ,[CgoQtyOnHand]
           ,[CgoQtyDamaged]
           ,[CgoQtyOnHold]
           ,[CgoQtyUnits]
           ,[CgoQTYOrdered]
           ,[CgoQtyCounted]
           ,[CgoQtyShortOver]
           ,[CgoQtyOver]
           ,[CgoLongitude]
           ,[CgoLatitude]
           ,[CgoReasonCodeOSD]
           ,[CgoReasonCodeHold]
           ,[CgoSeverityCode]
           ,[StatusId]
           ,[ProFlags01]
           ,[ProFlags02]
           ,[ProFlags03]
           ,[ProFlags04]
           ,[ProFlags05]
           ,[ProFlags06]
           ,[ProFlags07]
           ,[ProFlags08]
           ,[ProFlags09]
           ,[ProFlags10]
           ,[ProFlags11]
           ,[ProFlags12]
           ,[ProFlags13]
           ,[ProFlags14]
           ,[ProFlags15]
           ,[ProFlags16]
           ,[ProFlags17]
           ,[ProFlags18]
           ,[ProFlags19]
           ,[ProFlags20]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT
            J.Id--jd.Id,
           ,JDL.[CgoLineItem]
           ,JDL.[CgoPartNumCode]
           ,JDL.[CgoTitle]
           ,JDL.[CgoSerialNumber]
           ,JDL.[CgoMasterLabel]
           ,JDL.[CgoPackagingType]
           ,JDL.[CgoMasterCartonLabel]
           ,JDL.[CgoWeight]
           ,JDL.[CgoWeightUnits]
           ,JDL.[CgoLength]
           ,JDL.[CgoWidth]
           ,JDL.[CgoHeight]
           ,JDL.[CgoVolumeUnits]
           ,JDL.[CgoCubes]
           ,JDL.[CgoNotes]
           ,JDL.[CgoQtyExpected]
           ,JDL.[CgoQtyOnHand]
           ,JDL.[CgoQtyDamaged]
           ,JDL.[CgoQtyOnHold]
           ,JDL.[CgoQtyUnits]
           ,JDL.[CgoQTYOrdered]
           ,JDL.[CgoQtyCounted]
           ,JDL.[CgoQtyShortOver]
           ,JDL.[CgoQtyOver]
           ,JDL.[CgoLongitude]
           ,JDL.[CgoLatitude]
           ,JDL.[CgoReasonCodeOSD]
           ,JDL.[CgoReasonCodeHold]
           ,JDL.[CgoSeverityCode]
           ,JDL.[StatusId]
           ,JDL.[ProFlags01]
           ,JDL.[ProFlags02]
           ,JDL.[ProFlags03]
           ,JDL.[ProFlags04]
           ,JDL.[ProFlags05]
           ,JDL.[ProFlags06]
           ,JDL.[ProFlags07]
           ,JDL.[ProFlags08]
           ,JDL.[ProFlags09]
           ,JDL.[ProFlags10]
           ,JDL.[ProFlags11]
           ,JDL.[ProFlags12]
           ,JDL.[ProFlags13]
           ,JDL.[ProFlags14]
           ,JDL.[ProFlags15]
           ,JDL.[ProFlags16]
           ,JDL.[ProFlags17]
           ,JDL.[ProFlags18]
           ,JDL.[ProFlags19]
           ,JDL.[ProFlags20]
           ,JDL.[EnteredBy]
           ,JDL.[DateEntered]
           ,JDL.[ChangedBy]
           ,JDL.[DateChanged] FROM [M4PL_3030_Test].[dbo].[JOBDL010Cargo] JDL
		   INNER JOIN [dbo].[JOBDL000Master] J ON J.[3030Id] = JDL.JobID
		   INNER JOIN [dbo].[PRGRM000Master] P ON P.[Id] = J.ProgramID
		   WHERE P.PrgOrgID = 1 

GO