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
// Program Name:                                 OrgMarketSupport
// Purpose:                                      Contains objects related to OrgMarketSupport
//==========================================================================================================

namespace M4PL.Entities.Organization
{
    public class OrgMarketSupport : BaseModel
    {
        /// <summary>
        ///
        /// </summary>
        public long? OrgID { get; set; }

        public string OrgIDName { get; set; }

        public int? MrkOrder { get; set; }

        public string MrkCode { get; set; }

        public string MrkTitle { get; set; }

        public byte[] MrkDescription { get; set; }

        public byte[] MrkInstructions { get; set; }
    }
}