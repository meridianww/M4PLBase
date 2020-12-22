UPDATE PRGRM010Ref_GatewayDefaults SET PgdGatewayTitle = 'RS-'+ PgdGatewayTitle WHERE PgdGatewayCode LIKE '%Reschedule%'

UPDATE JOBDL020Gateways SET GwyGatewayTitle = 'RS-'+ GwyGatewayTitle WHERE GwyGatewayCode LIKE '%Reschedule%'