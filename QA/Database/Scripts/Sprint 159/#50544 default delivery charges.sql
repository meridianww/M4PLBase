
UPDATE PPBBillRate SET PPBBillRate.PbrElectronicBilling =1
FROM PRGRM040ProgramBillableRate PPBBillRate
INNER JOIN PRGRM042ProgramBillableLocations PBLlocation ON PBLlocation.Id = PPBBillRate.ProgramLocationId
INNER JOIN PRGRM000Master PM ON PM.Id = PBLlocation.PblProgramID AND PM.PrgCustID=10007
WHERE LEFT(PbrCode, 2) = '44' AND RIGHT(PbrCode,3) = 'DEL'


UPDATE JOBSHEET SET PrcElectronicBilling = 1 
FROM JOBDL061BillableSheet JOBSHEET 
INNER JOIN JOBDL000Master JOB ON JOB.Id = JOBSHEET.JobID
INNER JOIN PRGRM000Master PM ON PM.Id = JOB.ProgramID AND PM.PrgCustID=10007
WHERE LEFT(PrcChargeCode, 2) = '44' AND RIGHT(PrcChargeCode,3) = 'DEL'
