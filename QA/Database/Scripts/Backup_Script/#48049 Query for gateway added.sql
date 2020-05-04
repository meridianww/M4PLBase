DECLARE @ID INT
DECLARE @MaxSOrtOrderID INT
SELECT @ID =
ID FROM SYSTM000Ref_Lookup WHERE LkupCode ='OperationType'

SELECT @MaxSOrtOrderID = MAX(SysSortOrder) FROM SYSTM000Ref_Options WHERE SysLookupCode ='OperationType'
 
INSERT INTO SYSTM000Ref_Options VALUES (@ID,'OperationType','Gateways',@MaxSOrtOrderID +1 ,0,0,1,GETDATE(),NULL,NULL,NULL) 
SELECT @ID = MAX(ID) FROM SYSTM000Ref_Options WHERE SysLookupCode ='OperationType'
INSERT INTO [SYSMS010Ref_MessageTypes] values ('EN',@ID,'Gateways',NULL,NULL,NULL,1,GETDATE(),NULL,NULL,NULL)


 




