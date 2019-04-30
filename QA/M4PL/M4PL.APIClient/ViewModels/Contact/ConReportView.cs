/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 ConReportView
//Purpose:                                      Represents ConReport Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Contact;

namespace M4PL.APIClient.ViewModels.Contact
{
    public class ConReportView : ConReport
    {
        public ConReportView()
        {
        }

        public ConReportView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}