
Insert into [dbo].[Event]
select 
20200903
,'Job Reactivation'
,'JR'
,'do-not-reply@dreamorbit.com'
,null
,getdate()
,''
,1
,4
,null
,getdate()
,'2'
,getdate()


insert into dbo.EventEntityRelation
select 20200903
,10001


INSERT INTO dbo.EventSubscriberRelation
select 3
,id
,'prashant.dewangan@dreamorbit.com'
,1
from dbo.EventEntityRelation
where eventid=20200903

INSERT INTO dbo.EventSubscriberRelation
select 3
,id
,NULL
,2
from dbo.EventEntityRelation
where eventid=20200903

INSERT INTO dbo.EventEntityContentDetail
select  id
,'M4PL Order Re-activated Contract # {0}'
,1
,''
from dbo.EventEntityRelation
where eventid=20200903 