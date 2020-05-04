

UPDATE DST

SET StateName = ( SELECT StateName

               FROM  M4PL_Staging.dbo.SYSTM000Ref_States AS SUB

               WHERE DST.StateAbbr = SUB.StateAbbr

                    )

FROM M4PL_Production.dbo.SYSTM000Ref_States AS DST


