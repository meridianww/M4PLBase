/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/11/2019
Program Name:                                 CompanyAddress
Purpose:                                      Contains objects related to CompanyAddress
//====================================================================================================================================================*/
using System;

namespace M4PL.Entities.CompanyAddress
{
    public class CompanyAddress
    {
        public long Id { get; set; }
        public long AddOrgId { get; set; }
        public string AddTableName { get; set; }
        public long AddPrimaryRecordId { get; set; }
        public long? AddPrimaryContactId { get; set; }
        public int? AddItemNumber { get; set; }
        public string AddCode { get; set; }
        public string AddTitle { get; set; }
        public int StatusId { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public int? StateId { get; set; }
        public string StateIdName { get; set; }
        public string ZipPostal { get; set; }
        public int? CountryId { get; set; }
        public string CountryIdName { get; set; }
        public int? AddTypeId { get; set; }
        public DateTime DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public DateTime? DateChanged { get; set; }
        public string ChangedBy { get; set; }
    }
}
