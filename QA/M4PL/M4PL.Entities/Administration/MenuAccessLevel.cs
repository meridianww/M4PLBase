#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 MenuAccessLevel
// Purpose:                                      Contains objects related to MenuAccessLevel
//==========================================================================================================

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Menu Access level class to create, edit and store the authorizations for the modules based on the user role
    /// </summary>
    public class MenuAccessLevel : BaseModel
    {
        /// <summary>
        /// Gets or sets the Menu access level's sorting order.
        /// </summary>
        /// <value>
        /// The MalOrder.
        /// </value>
        public int? MalOrder { get; set; }

        /// <summary>
        /// Gets or sets the Menu access level's title.
        /// </summary>
        /// <value>
        /// The MalTitle.
        /// </value>
        public string MalTitle { get; set; }
    }
}