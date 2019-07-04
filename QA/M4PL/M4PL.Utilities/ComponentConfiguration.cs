/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              20/06/2019
//====================================================================================================================================================*/

using System;
using System.Configuration;
using System.IO;

namespace M4PL.Utilities
{
	/// <summary>
	/// This is a config settings for the component
	/// </summary>
	/// <typeparam name="T">Configuration section of the component</typeparam>
	public abstract class ComponentConfiguration<T> where T : ConfigurationSection, new()
	{
		/// <summary>
		/// Stores the component settings
		/// </summary>
		private static T _componentSettings;

		/// <summary>
		/// Gets the component settings.
		/// </summary>
		/// <value>
		/// The component settings.
		/// </value>
		public static T ComponentSettings
		{
			get
			{
				if (_componentSettings == null)
				{
					SetComponentConfiguration();
				}

				return _componentSettings;
			}
		}

		/// <summary>
		/// Initializes the <see cref="ComponentConfiguration{T}"/> class.
		/// </summary>
		static ComponentConfiguration()
		{
			SetComponentConfiguration();
		}

		/// <summary>
		/// Sets the component configuration.
		/// </summary>
		private static void SetComponentConfiguration()
		{
			try
			{
				var assemblyFileInfo = new FileInfo(typeof(T).Assembly.Location);
				string assemplyName = assemblyFileInfo.Name.Substring(0, assemblyFileInfo.Name.Length - assemblyFileInfo.Extension.Length);
				var componentConfigFileName = string.Concat(AppDomain.CurrentDomain.BaseDirectory,
															"\\", Configuration.Current.DeploymentPath, "\\",
															assemplyName,
															".config");

				ConfigurationSection componentConfigSection = null;
				if (File.Exists(componentConfigFileName))
				{
					componentConfigSection = ConfigurationManager.OpenMappedMachineConfiguration(new ConfigurationFileMap(componentConfigFileName)).Sections.Get(typeof(T).Name);
				}

				_componentSettings = componentConfigSection as T;

				if (_componentSettings == null)
				{
					_componentSettings = new T();
				}
			}
			catch (Exception ex)
			{
				throw;
			}
		}

		/// <summary>
		/// Gets the configuration value.
		/// </summary>
		/// <param name="ComponentSettings">The component settings.</param>
		/// <returns>true if [Log Verbose], false otherwise </returns>
		private static bool GetConfigValue(T ComponentSettings)
		{
			if (ComponentSettings == null) return false;

			System.Reflection.PropertyInfo propertyInfo = ComponentSettings.GetType().GetProperty("LogVerbose");
			if (propertyInfo == null)
				return false;

			bool? value = propertyInfo.GetValue(ComponentSettings) as bool?;
			return value.HasValue ? value.Value : false;
		}
	}
}
