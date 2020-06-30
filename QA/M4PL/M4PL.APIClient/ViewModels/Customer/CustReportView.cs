﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              13/10/2017
//Program Name:                                 CustReportView
//Purpose:                                      Represents CustReport Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Customer;

namespace M4PL.APIClient.ViewModels.Customer
{
    public class CustReportView : CustReport
    {
        public CustReportView()
        {
        }

        public CustReportView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}