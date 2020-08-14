#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.HelperClasses
{
	public static class FarEyeHelper
	{
		public static bool SentOrderStatusUpdateToFarEye(DeliveryUpdate deliveryUpdate)
		{
			string electroluxOrderStatusUpdateJson = string.Empty;
			string farEyeUpdateURL = string.Empty;
			string farEyeApiKey = string.Empty;
			if (!M4PBusinessContext.ComponentSettings.IsElectroluxDeliveryUpdateProduction)
			{
				farEyeUpdateURL = string.Format("{0}/Connector/v1/meridian/trackingUpdates", M4PBusinessContext.ComponentSettings.FarEyeUpdateTestAPIURL);
				farEyeApiKey = string.Format("bearer {0}", M4PBusinessContext.ComponentSettings.FarEyeUpdateTestAPIKey);
			}
			else
			{
				farEyeUpdateURL = string.Format("{0}/Connector/v1/meridian/trackingUpdates", M4PBusinessContext.ComponentSettings.FarEyeUpdateProductionAPIURL);
				farEyeApiKey = string.Format("bearer {0}", M4PBusinessContext.ComponentSettings.FarEyeUpdateProductionAPIKey);
			}

			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(farEyeUpdateURL);
			request.KeepAlive = false;
			request.ContentType = "application/json";
			request.Method = "POST";
			request.Headers.Add(HttpRequestHeader.Authorization, farEyeApiKey);
			using (var streamWriter = new StreamWriter(request.GetRequestStream()))
			{
				electroluxOrderStatusUpdateJson = Newtonsoft.Json.JsonConvert.SerializeObject(deliveryUpdate);
				streamWriter.Write(electroluxOrderStatusUpdateJson);
			}

			WebResponse response = request.GetResponse();
			using (Stream electroluxDeliveryUpdateResponseStream = response.GetResponseStream())
			{
				using (TextReader electroluxDeliveryUpdateResponseReader = new StreamReader(electroluxDeliveryUpdateResponseStream))
				{
					string electroluxDeliveryUpdateResponseString = electroluxDeliveryUpdateResponseReader.ReadToEnd();
				}
			}

			return true;
		}
	}
}
