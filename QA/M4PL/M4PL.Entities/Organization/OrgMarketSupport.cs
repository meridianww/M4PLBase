/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgMarketSupport
Purpose:                                      Contains objects related to OrgMarketSupport
==========================================================================================================*/

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