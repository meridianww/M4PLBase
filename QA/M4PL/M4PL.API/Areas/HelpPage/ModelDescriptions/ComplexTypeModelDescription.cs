#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Collections.ObjectModel;

namespace M4PL.API.Areas.HelpPage.ModelDescriptions
{
	public class ComplexTypeModelDescription : ModelDescription
	{
		public ComplexTypeModelDescription()
		{
			Properties = new Collection<ParameterDescription>();
		}

		public Collection<ParameterDescription> Properties { get; private set; }
	}
}