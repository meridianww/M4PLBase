
INSERT INTO dbo.JobCardMappingByUser(USERID)
SELECT Id FROM SYSTM000OpnSezMe WHERE StatusId=1

UPDATE JobCardMappingByUser SET
NotScheduleInTransit=1
,NotScheduleOnHand =1
,NotScheduleOnTruck =1
,NotScheduleReturn =1
,SchedulePastDueInTransit=1 
,SchedulePastDueOnHand =1
,SchedulePastDueOnTruck=1
,SchedulePastDueReturn =1
,ScheduleForTodayInTransit=1
,ScheduleForTodayOnHand =1
,ScheduleForTodayOnTruck=1
,ScheduleForTodayReturn =1
,xCBLAddressChanged =1
,xCBL48HoursChanged =1
,NoPODCompletion =1