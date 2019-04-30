/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Filter
Purpose:                                      Contains objects related to Filter
==========================================================================================================*/
namespace M4PL.Entities.Support
{
    public class Filter
    {
        public string FieldName { get; set; }
        public string Value { get; set; }
        public bool CustomFilter { get; set; }
    }
}