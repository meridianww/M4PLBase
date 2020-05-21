using System;
using System.ComponentModel;
using System.Configuration;
using System.Reflection;

namespace M4PL.Business
{
	public class M4PBusinessConfiguration : ConfigurationSection
	{
		/// <summary>
		/// Initializes a new instance of the <see cref="M4PBusinessConfiguration"/> class
		/// </summary>
		public M4PBusinessConfiguration()
		{
		}

		#region Properties

		/// <summary>
		/// Gets the value of NavAPIUrl.
		/// </summary>
		[ConfigurationProperty("NavAPIUrl")]
		public string NavAPIUrl
		{
			get
			{
				return (string)this["NavAPIUrl"];
			}
		}

		/// <summary>
		/// Gets the value of NavAPIUserName.
		/// </summary>
		[ConfigurationProperty("NavAPIUserName")]
		public string NavAPIUserName
		{
			get
			{
				return (string)this["NavAPIUserName"];
			}
		}

		/// <summary>
		/// Gets the value of NavAPIPassword.
		/// </summary>
		[ConfigurationProperty("NavAPIPassword")]
		public string NavAPIPassword
		{
			get
			{
				return (string)this["NavAPIPassword"];
			}
		}


		/// <summary>
		/// Gets the value of GetVOCJobURL.
		/// </summary>
		[ConfigurationProperty("GetVOCJobURL")]
		public string GetVOCJobURL
		{
			get
			{
				return (string)this["GetVOCJobURL"];
			}
		}

		/// <summary>
		/// Gets the value of NavRateReadFromItem.
		/// </summary>
		[ConfigurationProperty("NavRateReadFromItem")]
		public bool NavRateReadFromItem
		{
			get
			{
				return (bool)this["NavRateReadFromItem"];
			}
		}

		/// <summary>
		/// Gets the value of ElectroluxProgramId.
		/// </summary>
		[ConfigurationProperty("ElectroluxProgramId")]
		public long ElectroluxProgramId
		{
			get
			{
				return (long)this["ElectroluxProgramId"];
			}
		}
		
		/// <summary>
		/// Gets the value of ElectroluxCustomerId.
		/// </summary>
		[ConfigurationProperty("ElectroluxCustomerId")]
		public long ElectroluxCustomerId
		{
			get
			{
				return (long)this["ElectroluxCustomerId"];
			}
		}

		/// <summary>
		/// Gets the value of AWCCustomerId.
		/// </summary>
		[ConfigurationProperty("AWCCustomerId")]
		public long AWCCustomerId
		{
			get
			{
				return (long)this["AWCCustomerId"];
			}
		}

		/// <summary>
		/// Gets the value of IsElectroluxDeliveryUpdateProduction.
		/// </summary>
		[ConfigurationProperty("IsElectroluxDeliveryUpdateProduction")]
		public bool IsElectroluxDeliveryUpdateProduction
		{
			get
			{
				return (bool)this["IsElectroluxDeliveryUpdateProduction"];
			}
		}

		/// <summary>
		/// Gets the value of ElectroluxDeliveryUpdateAPIUrl.
		/// </summary>
		[ConfigurationProperty("ElectroluxDeliveryUpdateProductionAPIUrl")]
		public string ElectroluxDeliveryUpdateProductionAPIUrl
		{
			get
			{
				return (string)this["ElectroluxDeliveryUpdateProductionAPIUrl"];
			}
		}

		/// <summary>
		/// Gets the value of ElectroluxDeliveryUpdateTestAPIUrl.
		/// </summary>
		[ConfigurationProperty("ElectroluxDeliveryUpdateTestAPIUrl")]
		public string ElectroluxDeliveryUpdateTestAPIUrl
		{
			get
			{
				return (string)this["ElectroluxDeliveryUpdateTestAPIUrl"];
			}
		}

		/// <summary>
		/// Gets the value of ElectroluxDeliveryUpdateTestAPIUsername.
		/// </summary>
		[ConfigurationProperty("ElectroluxDeliveryUpdateTestAPIUsername")]
		public string ElectroluxDeliveryUpdateTestAPIUsername
		{
			get
			{
				return (string)this["ElectroluxDeliveryUpdateTestAPIUsername"];
			}
		}

		/// <summary>
		/// Gets the value of ElectroluxDeliveryUpdateTestAPIPassword.
		/// </summary>
		[ConfigurationProperty("ElectroluxDeliveryUpdateTestAPIPassword")]
		public string ElectroluxDeliveryUpdateTestAPIPassword
		{
			get
			{
				return (string)this["ElectroluxDeliveryUpdateTestAPIPassword"];
			}
		}

		/// <summary>
		/// Gets the value of ElectroluxDeliveryUpdateProductionAPIUsername.
		/// </summary>
		[ConfigurationProperty("ElectroluxDeliveryUpdateProductionAPIUsername")]
		public string ElectroluxDeliveryUpdateProductionAPIUsername
		{
			get
			{
				return (string)this["ElectroluxDeliveryUpdateProductionAPIUsername"];
			}
		}

		/// <summary>
		/// Gets the value of ElectroluxDeliveryUpdateProductionAPIPassword.
		/// </summary>
		[ConfigurationProperty("ElectroluxDeliveryUpdateProductionAPIPassword")]
		public string ElectroluxDeliveryUpdateProductionAPIPassword
		{
			get
			{
				return (string)this["ElectroluxDeliveryUpdateProductionAPIPassword"];
			}
		}

		/// <summary>
		/// Gets the value of XCBLEDTType.
		/// </summary>
		[ConfigurationProperty("XCBLEDTType")]
		public int XCBLEDTType
		{
			get
			{
				return (int)this["XCBLEDTType"];
			}
		}
		
		/// <summary>
		/// Gets the value of ServiceProvider.
		/// </summary>
		[ConfigurationProperty("ServiceProvider")]
		public string ServiceProvider
		{
			get
			{
				return (string)this["ServiceProvider"];
			}
		}

		/// <summary>
		/// Gets the value of M4PLApplicationURL.
		/// </summary>
		[ConfigurationProperty("M4PLApplicationURL")]
		public string M4PLApplicationURL
		{
			get
			{
				return (string)this["M4PLApplicationURL"];
			}
		}

		#endregion Properties

		#region Public Methods

		/// <summary>
		/// GetEnumDescription
		/// </summary>
		/// <param name="value">value</param>
		/// <returns>string</returns>
		public static string GetEnumDescription(Enum value)
		{
			if (value == null)
			{
				throw new ArgumentNullException("value");
			}

			FieldInfo fi = value.GetType().GetField(value.ToString());
			DescriptionAttribute[] attributes =
				(DescriptionAttribute[])fi.GetCustomAttributes(
				typeof(DescriptionAttribute),
				false);

			if (attributes != null &&
				attributes.Length > 0)
				return attributes[0].Description;
			else
				return value.ToString();
		}

		#endregion Public Methods
	}
}
