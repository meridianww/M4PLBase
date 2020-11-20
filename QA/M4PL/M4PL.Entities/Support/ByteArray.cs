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
// Program Name:                                 ByteArray
// Purpose:                                      Contains objects related to ByteArray
//==========================================================================================================
namespace M4PL.Entities.Support
{
    /// <summary>
    /// Model for ByteArray
    /// </summary>
    public class ByteArray
    {
        /// <summary>
        /// Constructor for ByteArray
        /// </summary>
        public ByteArray()
        {
        }
        /// <summary>
        /// Overloaded Constructor for ByteArray to intilize the properties details
        /// </summary>
        public ByteArray(ByteArray byteArray)
        {
            Id = byteArray.Id;
            FieldName = byteArray.FieldName;
            FileName = byteArray.FileName;
            Entity = byteArray.Entity;
            Type = byteArray.Type;
            IsPopup = byteArray.IsPopup;
            JobGatewayIds = byteArray.JobGatewayIds;
        }
        /// <summary>
        /// Get or Set for Id 
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Get or Set for File Name 
        /// </summary>
        public string FileName { get; set; }
        /// <summary>
        /// Get or Set for Entity 
        /// </summary>
        public EntitiesAlias Entity { get; set; }

        /// <summary>
        /// To get and set, it should be same as database field name
        /// </summary>
        public string FieldName { get; set; }
        /// <summary>
        /// Get or Set for Bytes 
        /// </summary>
        public byte[] Bytes { get; set; }
        /// <summary>
        /// Get or Set for Type of data 
        /// </summary>
        public SQLDataTypes Type { get; set; }
        /// <summary>
        /// Get or Set for is Popup or not
        /// </summary>
        public bool IsPopup { get; set; }
        /// <summary>
        /// Get for Document Id 
        /// </summary>
        public string DocumentId
        {
            get
            {
                return string.Concat(FieldName, Id.ToString());
            }
        }
        /// <summary>
        /// Get for Control Name 
        /// </summary>
        public string ControlName
        {
            get
            {
                return string.Concat(DocumentId, "ByteArray");
            }
        }
        /// <summary>
        /// Get or Set for Document Text 
        /// </summary>
        public string DocumentText { get; set; }
        /// <summary>
        /// Get or Set for Job Gateway Ids 
        /// </summary>
        public string JobGatewayIds { get; set; }
    }
}