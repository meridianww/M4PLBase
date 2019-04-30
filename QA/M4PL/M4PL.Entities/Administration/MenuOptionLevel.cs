/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 MenuOptionLevel
Purpose:                                      Contains objects related to MenuOptionLevel
==========================================================================================================*/

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Entities of Column Alias will contain objects related to  Column Alias
    /// </summary>
    public class MenuOptionLevel : BaseModel
    {
        /// <summary>
        /// Gets or sets the Menu option level identifier.
        /// </summary>
        /// <value>
        /// The MolOrder identifier.
        /// </value>
        public int? MolOrder { get; set; }

        /// <summary>
        /// Gets or sets the Menu option level title.
        /// </summary>
        /// <value>
        /// The MolMenuLevelTitle.
        /// </value>
        public string MolMenuLevelTitle { get; set; }

        /// <summary>
        /// Gets or sets the whether the menu should be default.
        /// </summary>
        /// <value>
        /// The MolMenuAccessDefault.
        /// </value>
        public int MolMenuAccessDefault { get; set; }

        public string MolMenuAccessDefaultName { get; set; }

        /// <summary>
        /// Gets or sets the whether the menu should be readonly or editable.
        /// </summary>
        /// <value>
        /// The MolMenuAccessOnly.
        /// </value>
        public bool MolMenuAccessOnly { get; set; }
    }
}