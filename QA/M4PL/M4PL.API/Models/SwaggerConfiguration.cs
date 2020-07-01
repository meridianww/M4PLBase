#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Collections.Generic;

namespace M4PL.API.Models
{
    /// <summary>
    /// Swagger Configuration
    /// </summary>
	public class SwaggerConfiguration
    {
        /// <summary>
        /// Swagger ConfigPaths
        /// </summary>
		public IList<string> SwaggerConfigPaths { get; set; }
    }
}