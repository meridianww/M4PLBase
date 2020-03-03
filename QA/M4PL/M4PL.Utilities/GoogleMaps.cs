using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace M4PL.Utilities
{
	public static class GoogleMaps
	{
		 static Logger.Logger logger = new Logger.Logger();

		public static decimal GetDistanceFromGoogleMaps(string origin, string desination)
		{

			try
			{
				string baseUrl  = ConfigurationManager.AppSettings["GoogleMapsDistanceURL"];
				string key = ConfigurationManager.AppSettings["GoogleMapsKey"];

				string url = baseUrl + "&origins=" + HttpUtility.UrlEncode(origin) + "&destinations=" + HttpUtility.UrlEncode(desination) + "&key=" + key;
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
			catch (Exception ex)
			{
				logger.Error("Exception occured during fetching the distance between the " + origin + " and " + desination, ex);
				return -1;
			}



		}
	}
}
