using M4PL.Entities;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient
{
    public class API_Organization
    {
        /// <summary>
        /// Function to get all Organizations data
        /// </summary>
        /// <returns></returns>
        public static List<Organization> GetAllOrganizations()
        {
            DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(List<Organization>));
            using (WebClient syncClient = new WebClient())
            {
                using (MemoryStream memo = new MemoryStream(Encoding.Unicode.GetBytes(syncClient.DownloadString(@M4PL_Constants.M4PL_API + "Organization"))))
                {
                    return (List<Organization>)serializer.ReadObject(memo);
                }
            }
        }
    }
}
