/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScnDriverList
Purpose:                                      Contains objects related to ScnDriverList
==========================================================================================================*/

namespace M4PL.Entities.Scanner
{
    public class ScnDriverList : BaseModel
    {
        public long DriverID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public long? ProgramID { get; set; }
        public string LocationNumber { get; set; }
    }
}
