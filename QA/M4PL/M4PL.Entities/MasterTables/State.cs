/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 State
Purpose:                                      Contains objects related to State
==========================================================================================================*/
using System;

namespace M4PL.Entities.MasterTables
{
    public class State
    {
        public int Id { get; set; }
        public string StateAbbr { get; set; }
        public string StateName { get; set; }
        public string Country { get; set; }
        public bool StateIsDefault { get; set; }
        public int StatusId { get; set; }
        public DateTime DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public DateTime? DateChanged { get; set; }
        public string ChangedBy { get; set; }
        public int StateCountryId { get; set; }
    }
}