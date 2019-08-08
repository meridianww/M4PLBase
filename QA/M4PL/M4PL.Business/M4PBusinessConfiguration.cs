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
