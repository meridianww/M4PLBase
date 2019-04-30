/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              06/06/2018
Program Name:                                 DeliveryStatus
Purpose:                                      Contains objects related to DeliveryStatus
==========================================================================================================*/

namespace M4PL.Entities.Administration
{
    /// <summary>
    ///  Delivery Status Class to create and maintain Delivery Status Data
    /// </summary>
    public class DeliveryStatus : BaseModel
    {
        public string DeliveryStatusCode { get; set; }

        public string DeliveryStatusTitle { get; set; }

        public int? SeverityId { get; set; }

        public byte[] DeliveryStatusDescription { get; set; }

        public string OrganizationIdName { get; set; }

    }
}
