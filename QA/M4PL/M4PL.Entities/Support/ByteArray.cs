/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ByteArray
Purpose:                                      Contains objects related to ByteArray
==========================================================================================================*/
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
    }
}