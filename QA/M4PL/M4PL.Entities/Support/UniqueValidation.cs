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
// Program Name:                                 UniqueValidation
// Purpose:                                      Contains objects related to UniqueValidation
//==========================================================================================================
namespace M4PL.Entities.Support
{
    /// <summary>
    /// Model for Unique Validation
    /// </summary>
    public class UniqueValidation
    {
        /// <summary>
        /// Get or Set Entity by EntitiesAlias enum
        /// </summary>
        public EntitiesAlias Entity { get; set; }
        /// <summary>
        /// Get or Set for Record Id
        /// </summary>
        public long RecordId { get; set; }
        /// <summary>
        /// Get or Set for Field Name
        /// </summary>
        public string FieldName { get; set; }
        /// <summary>
        /// Get or Set For Field Value
        /// </summary>
        public string FieldValue { get; set; }
        /// <summary>
        /// Get or Set For Parent Filter
        /// </summary>
        public string ParentFilter { get; set; }
        /// <summary>
        /// Get or Set For Parent Id
        /// </summary>
        public long? ParentId { get; set; }
        /// <summary>
        /// Get or Set For is validate or not
        /// </summary>
        public bool isValidate { get; set; }
    }
}