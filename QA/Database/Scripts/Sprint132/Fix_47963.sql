
UPDATE msgType SET msgType.SysMsgtypeTitle = 'View/Edit'
FROM SYSMS010Ref_MessageTypes msgType
INNER JOIN [SYSTM000Ref_Options] refOp
ON  msgType.SysRefId= refOp.Id
WHERE  msgType.LangCode = 'EN' AND refOp.SysLookupCode = 'OperationType' and refOp.SysOptionName = 'Edit'