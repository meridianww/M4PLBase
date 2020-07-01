/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 DeleteInfo
Purpose:                                      Contains objects related to DeleteInfo
==========================================================================================================*/
namespace M4PL.Entities.Support
{
    public class DeleteInfo
    {
        public long Id { get; set; }
        public long? ParentId { get; set; }
        public EntitiesAlias Entity { get; set; }
        public EntitiesAlias? ParentEntity { get; set; }
        public string Name { get; set; }
    }
}
