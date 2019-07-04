/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              20/06/2019
//====================================================================================================================================================*/

using System.Configuration;

namespace M4PL.Utilities
{
	/// <summary>
	/// Class Configuration.
	/// </summary>
	public class Configuration : ConfigurationSection
	{

		/// <summary>
		/// Stores the current configuration section for api settings
		/// </summary>
		private static Configuration _current;

		/// <summary>
		/// Stores the configuration section name
		/// </summary>
		private const string ConfigurationSectionName = "apiSecurity";

		/// <summary>
		/// Stores the path of the Deployment Path where configurations get deployed
		/// </summary>
		private const string Path = "path";

		/// <summary>
		/// Gets the current configuration section.
		/// </summary>
		/// <value>The current.</value>
		public static Configuration Current
		{
			get
			{
				return _current ?? (_current = ConfigurationManager.GetSection(ConfigurationSectionName) as Configuration
					  ?? new Configuration());
			}
		}

		/// <summary>
		/// Gets or sets the deployment path.
		/// </summary>
		/// <value>The deployment path where all the components get deployment.</value>
		[ConfigurationProperty(Path, IsRequired = false, IsKey = false)]
		public string DeploymentPath
		{
			get { return (string)this[Path]; }
			set { this[Path] = value; }
		}
	}
}
