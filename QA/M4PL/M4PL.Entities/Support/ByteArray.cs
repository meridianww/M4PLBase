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
    public class ByteArray
    {
        public ByteArray()
        {
        }

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

        public long Id { get; set; }
        public string FileName { get; set; }
        public EntitiesAlias Entity { get; set; }

        /// <summary>
        /// To get and set, it should be same as database field name
        /// </summary>
        public string FieldName { get; set; }

        public byte[] Bytes { get; set; }
        public SQLDataTypes Type { get; set; }

        public bool IsPopup { get; set; }

        public string DocumentId
        {
            get
            {
                return string.Concat(FieldName, Id.ToString());
            }
        }

        public string ControlName
        {
            get
            {
                return string.Concat(DocumentId, "ByteArray");
            }
        }

        public string DocumentText { get; set; }
        public string JobGatewayIds { get; set; }
    }
}