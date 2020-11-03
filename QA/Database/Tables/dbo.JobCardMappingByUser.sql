

CREATE TABLE JobCardMappingByUser
(
  ID BIGINT PRIMARY KEY IDENTITY(1,1) NOT NULL,
  UserID BIGINT NOT NULL FOREIGN KEY REFERENCES [dbo].[SYSTM000OpnSezMe](Id),
  NotScheduleInTransit BIT,
  NotScheduleOnHand BIT,
  NotScheduleOnTruck BIT,
  NotScheduleReturn BIT,
  SchedulePastDueInTransit BIT,
  SchedulePastDueOnHand BIT,
  SchedulePastDueOnTruck BIT,
  SchedulePastDueReturn BIT,
  ScheduleForTodayInTransit BIT,
  ScheduleForTodayOnHand BIT,
  ScheduleForTodayOnTruck BIT,
  ScheduleForTodayReturn BIT,
  xCBLAddressChanged BIT,
  xCBL48HoursChanged BIT,
  NoPODCompletion BIT,
)