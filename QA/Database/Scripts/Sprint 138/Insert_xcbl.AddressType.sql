
IF NOT EXISTS(SELECT TOP 1 1 FROM XCBL.AddressType WHERE AddressTypeName = 'Consignee')
BEGIN
INSERT INTO [Xcbl].[AddressType]
           ([AddressTypeId]
           ,[AddressTypeName])
     VALUES
           (1
           ,'Consignee')
END


IF NOT EXISTS(SELECT TOP 1 1 FROM XCBL.AddressType WHERE AddressTypeName = 'InterConsignee')
BEGIN
INSERT INTO [Xcbl].[AddressType]
           ([AddressTypeId]
           ,[AddressTypeName])
     VALUES
           (2
           ,'InterConsignee')
END

IF NOT EXISTS(SELECT TOP 1 1 FROM XCBL.AddressType WHERE AddressTypeName = 'ShipFrom')
BEGIN
INSERT INTO [Xcbl].[AddressType]
           ([AddressTypeId]
           ,[AddressTypeName])
     VALUES
           (3
           ,'ShipFrom')
END


IF NOT EXISTS(SELECT TOP 1 1 FROM XCBL.AddressType WHERE AddressTypeName = 'BillTo')
BEGIN
INSERT INTO [Xcbl].[AddressType]
           ([AddressTypeId]
           ,[AddressTypeName])
     VALUES
           (4
           ,'BillTo')
END