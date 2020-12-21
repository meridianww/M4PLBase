#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Entities
{
	public class BusinessConfiguration
	{
		public List<ConfigurationKeyValuePair> ConfigurationKeyValuePair { get; set; }
		public string AWCCustomerId { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("AWCCustomerId", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string CompletedTransitionStatusId { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("CompletedTransitionStatusId", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string ElectroluxCustomerId { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("ElectroluxCustomerId", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string ElectroluxDeliveryUpdateAPIUrl { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("ElectroluxDeliveryUpdateAPIUrl", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string ElectroluxDeliveryUpdatePassword { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("ElectroluxDeliveryUpdatePassword", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string ElectroluxDeliveryUpdateUserName { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("ElectroluxDeliveryUpdateUserName", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string ElectroluxProgramId { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("ElectroluxProgramId", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string FarEyeAPIUrl { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("FarEyeAPIUrl", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string FarEyeAuthKey { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("FarEyeAuthKey", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string IsFarEyePushRequired { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("IsFarEyePushRequired", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string JobStatusUpdateValidationHours { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("JobStatusUpdateValidationHours", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string NavAPIPassword { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("NavAPIPassword", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string NavAPIUrl { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("NavAPIUrl", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string NavAPIUserName { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("NavAPIUserName", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string NavRateReadFromItem { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("NavRateReadFromItem", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string ServiceProvider { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("ServiceProvider", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string VOCJobWebServiceURL { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("VOCJobWebServiceURL", StringComparison.OrdinalIgnoreCase))?.Value; } }
		public string XCBLEDTType { get { return ConfigurationKeyValuePair?.FirstOrDefault(x => x.KeyName.Equals("XCBLEDTType", StringComparison.OrdinalIgnoreCase))?.Value; } }
        public List<CustomerNavConfiguration> CustomerNavConfiguration => ConfigurationKeyValuePair?.FirstOrDefault().CustomerNavConfiguration;
    }

	public class ConfigurationKeyValuePair
	{
		public string KeyName { get; set; }
		public string Value { get; set; }
		public string Environment { get; set; }
        public List<CustomerNavConfiguration> CustomerNavConfiguration { get; set; }
    }

	public class CustomerNavConfiguration
    {
        public long CustomerId { get; set; }
        public string ServiceUrl { get; set; }
		public string ServiceUserName { get; set; }
		public string ServicePassword { get; set; }

	}
}