#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.Support
{
    public class CompanyCorpAddress
    {
        /// <summary>
        /// Gets or sets the Address1.
        /// </summary>
        /// <value>
        /// The MessageType.
        /// </value>
        public string Address1 { get; set; }

        /// <summary>
        /// Gets or sets the Address2.
        /// </summary>
        /// <value>
        /// The MessageType.
        /// </value>
        public string Address2 { get; set; }
        /// <summary>
        /// Gets or sets the City.
        /// </summary>
        /// <value>
        /// The Code.
        /// </value>
        public string City { get; set; }
        /// <summary>
        /// Gets or sets the ZipPostal.
        /// </summary>
        /// <value>
        /// The Code.
        /// </value>
        public string ZipPostal { get; set; }

        /// <summary>
        /// Gets or sets StateId.
        /// </summary>
        /// <value>
        /// The ScreenTitle.
        /// </value>
        public int StateId { get; set; }

        /// <summary>
        /// Gets or sets the CountryId type.
        /// </summary>
        /// <value>
        /// The Title.
        /// </value>
        public int CountryId { get; set; }
    }
}
