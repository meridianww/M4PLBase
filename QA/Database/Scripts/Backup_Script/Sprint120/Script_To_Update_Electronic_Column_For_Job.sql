Update Job
SET Job.JobElectronicInvoice = Prg.PrgElectronicInvoice
From JOBDL000Master Job
INNER JOIN PRGRM000Master Prg ON Prg.Id = Job.ProgramID
Where Prg.PrgElectronicInvoice = 1