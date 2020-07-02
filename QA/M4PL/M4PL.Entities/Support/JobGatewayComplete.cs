#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobGatewayComplete
// Purpose:                                      Contains objects related to JobGatewayComplete
//==========================================================================================================
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
        public int GatewayTypeId { get; set; }
        public string UpdatedValue { get; set; }
        public string ActualValue { get; set; }

    }
}