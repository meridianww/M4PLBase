
SELECT StatusId,* FROM PRGRM000Master WHERE StatusId=1 AND PrgCustID=10007
AND PrgProjectCode IN(
'Builder'
,'Vanity Tops'
,'Selling Center'
,'Home Delivery'
,'Designer Choice') AND PrgPhaseCode IS NULL

EXEC InsReturnReschdule 10012