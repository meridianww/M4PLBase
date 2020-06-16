using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Web;

namespace M4PL.Utilities
{
    public static class GoogleMapHelper
    {
        public static decimal GetDistanceFromGoogleMaps(string origin, string desination, ref string googleAPIUrl)
        {
            string baseUrl = ConfigurationManager.AppSettings["GoogleMapAuthDistanceURL"];
            string key = ConfigurationManager.AppSettings["GoogleMapDistanceMatrixAuthKey"];

            string url = baseUrl + "&origins=" + HttpUtility.UrlEncode(origin) + "&destinations=" + HttpUtility.UrlEncode(desination) + "&key=" + key;
            googleAPIUrl = url;
            WebRequest request = WebRequest.Create(url);

            using (WebResponse response = (HttpWebResponse)request.GetResponse())
            {
                using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
                {
                    DataSet dsResult = new DataSet();
                    dsResult.ReadXml(reader);
                    decimal distance = Convert.ToDecimal(dsResult.Tables["distance"].Rows[0]["text"].ToString().Replace(" mi", ""));
                    return distance;
                }
            }
        }

        public static Tuple<string, string> GetLatitudeAndLongitudeFromAddress(string address, ref string googleAPIUrl)
        {
            address = HttpUtility.UrlEncode(address);

            string baseUrl = ConfigurationManager.AppSettings["GoogleMapgeocodeURL"];
            string key = ConfigurationManager.AppSettings["GoogleMapDistanceMatrixAuthKey"];
            string url = baseUrl + address + "&key=" + key;
            googleAPIUrl = url;

            WebRequest request = WebRequest.Create(url);
            using (WebResponse response = (HttpWebResponse)request.GetResponse())
            {
                using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
                {
                    DataSet dsResult = new DataSet();
                    dsResult.ReadXml(reader);
                    string lat = dsResult.Tables["location"].Rows[0]["lat"].ToString();
                    string lng = dsResult.Tables["location"].Rows[0]["lng"].ToString();
                    return Tuple.Create(lat, lng);
                }
            }
        }
    }
}