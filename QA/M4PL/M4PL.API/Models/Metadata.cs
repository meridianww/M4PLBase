/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 Metadata
//Purpose:                                      Represents Metadata(provides information about other data)
//====================================================================================================================================================*/

using System.Collections.Generic;
using System.Linq;
using System.Net.Http;

namespace M4PL.API.Models
{
    /// <summary>
    /// Metadata
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class Metadata<T>
    {
        /// <summary>
        /// Metadata
        /// </summary>
        public Metadata()
        {
        }

        /// <summary>
        /// Metadata
        /// </summary>
        /// <param name="httpResponse"></param>
        /// <param name="isIQueryable"></param>
        public Metadata(HttpResponseMessage httpResponse, bool isIQueryable)
        {
            if ((httpResponse.Content != null) && httpResponse.IsSuccessStatusCode)
            {
                TotalResults = 1;
                ReturnedResults = 1;
                Status = true;

                if (isIQueryable)
                {
                    IEnumerable<T> enumResponseObject;
                    httpResponse.TryGetContentValue(out enumResponseObject);
                    Results = enumResponseObject.ToList();
                    ReturnedResults = enumResponseObject.Count();
                }
                else
                {
                    T responseObject;
                    httpResponse.TryGetContentValue(out responseObject);
                    Results = new List<T> { responseObject };
                    Status = true;
                }
            }
            else
            {
                Status = false;
                ReturnedResults = 0;
            }
        }

        /// <summary>
        ///     Response status
        /// </summary>
        public bool Status { get; set; }

        /// <summary>
        ///     Response Content
        /// </summary>
        public IList<T> Results { get; set; }

        /// <summary>
        /// TotalResults
        /// </summary>
        public int TotalResults { get; set; }

        /// <summary>
        /// ReturnedResults
        /// </summary>
        public int ReturnedResults { get; set; }
    }
}