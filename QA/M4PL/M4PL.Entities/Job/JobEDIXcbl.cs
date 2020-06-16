/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              19/02/2020
Program Name:                                 JobEDIXcbl
Purpose:                                      Contains objects related to JobEDIXcbl
==========================================================================================================*/

using System;

namespace M4PL.Entities.Job
{
    public class JobEDIXcbl : BaseModel
    {
        /// <summary>
        /// Gets Or Sets Id
        /// </summary>
        //public long Id { get; set; }

        /// <summary>
        /// Gets Or Sets JobId
        /// </summary>
        public long JobId { get; set; }

        /// <summary>
        /// Gets Or EdtCode
        /// </summary>
        public string EdtCode { get; set; }

        /// <summary>
        /// Gets Or Sets EdtTitle
        /// </summary>
        public string EdtTitle { get; set; }

        /// <summary>
        /// Gets Or Sets EdtData
        /// </summary>
        public string EdtData { get; set; }

        /// <summary>
        /// Gets Or Sets EdtTypeId
        /// </summary>
        public int EdtTypeId { get; set; }

        /// <summary>
        /// Gets Or Sets TransactionDate
        /// </summary>
        public DateTime? TransactionDate { get; set; }
    }
}
