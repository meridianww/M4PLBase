﻿using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using System.Collections.Generic;

namespace M4PL.Business.XCBL
{
    public interface IXCBLCommands : IBaseCommands<Entities.XCBL.XCBLToM4PLRequest>
    {
        long PostXCBLSummaryHeader(XCBLToM4PLRequest xCBLToM4PLRequisitionRequest);
        OrderResponse ProcessElectroluxOrderRequest(ElectroluxOrderDetails electroluxOrderDetails);
        DeliveryUpdateResponse ProcessElectroluxOrderDeliveryUpdate(DeliveryUpdate deliveryUpdate, long jobId);
        List<DeliveryUpdateProcessingData> GetDeliveryUpdateProcessingData();
        DeliveryUpdate GetDeliveryUpdateModel(long jobId);
        bool UpdateDeliveryUpdateProcessingLog(DeliveryUpdateProcessingData deliveryUpdateProcessingData);
    }
}
