/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 UniqueValidation
Purpose:                                      Contains objects related to UniqueValidation
==========================================================================================================*/
namespace M4PL.Entities.Support
{
    public class UniqueValidation
    {
        public EntitiesAlias Entity { get; set; }
        public long RecordId { get; set; }
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public string ParentFilter { get; set; }
        public long? ParentId { get; set; }
        public bool isValidate { get; set; }
    }
}