/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrGatewayList
Purpose:                                      Contains objects related to ScrGatewayList
==========================================================================================================*/

namespace M4PL.Entities.Scanner
{
    public class ScrGatewayList : BaseModel
    {
        public long GatewayStatusID { get; set; }
        public long? ProgramID { get; set; }
        public string GatewayCode { get; set; }
    }
}
