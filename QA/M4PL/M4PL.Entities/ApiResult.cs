/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ApiResult
Purpose:                                      Contains objects related to ApiResult
==========================================================================================================*/

using System.Collections.Generic;

namespace M4PL.Entities
{
    /// <summary>
    ///
    /// </summary>
    /// <typeparam name="TView"></typeparam>
    public class ApiResult<TView>
    {
        public ApiResult()
        {
            Results = new List<TView>();
        }

        /// <summary>
        ///     Response Content
        /// </summary>
        public IList<TView> Results { get; set; }

        /// <summary>
        /// Response status
        /// </summary>
        public bool Status { get; set; }

        public int TotalResults { get; set; }

        public int ReturnedResults { get; set; }
    }
}