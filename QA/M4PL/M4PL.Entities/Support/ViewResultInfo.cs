/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ViewResultInfo
Purpose:                                      Contains objects related to ViewResultInfo
==========================================================================================================*/
namespace M4PL.Entities.Support
{
    public class ViewResultInfo
    {
        public long Id { get; set; }
        public MvcRoute Route { get; set; }
        public DisplayMessage DisplayMessage { get; set; }
    }
}