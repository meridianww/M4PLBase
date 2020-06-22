UPDATE PCR
SET PCR.PcrElectronicBilling = 1
From [PRGRM041ProgramCostRate] PCR
INNER JOIN PRGRM043ProgramCostLocations CL ON CL.Id = PCR.ProgramLocationId
Where CL.PclProgramId = 20099

UPDATE PCR
SET PCR.PbrElectronicBilling = 1
From PRGRM040ProgramBillableRate PCR
INNER JOIN PRGRM042ProgramBillableLocations CL ON CL.Id = PCR.ProgramLocationId
Where CL.PblProgramId = 20099