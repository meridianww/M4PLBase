/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobGatewayComplete
Purpose:                                      Contains objects related to JobGatewayComplete
==========================================================================================================*/
namespace M4PL.Entities.Support
{
    public class JobGatewayComplete : SysRefModel
    {   
        public long JobID { get; set; }
        public long? ProgramID { get; set; }
        public string GwyGatewayCode { get; set; }
        public string GwyGatewayTitle { get; set; }
        public string GwyShipStatusReasonCode { get; set; }
        public string GwyShipApptmtReasonCode { get; set; }
    }
}