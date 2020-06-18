/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 ContactView
//Purpose:                                      Represents Contact Details
//====================================================================================================================================================*/

using System;

namespace M4PL.APIClient.ViewModels.Contact
{
    /// <summary>
    ///    To show details of contacts
    /// </summary>
    public class ContactView : Entities.Contact.Contact
    {
        private string _businessAddress;


        public string BussinessAdress
        {
            get
            {
                _businessAddress = ConBusinessAddress1 + Environment.NewLine;

                if (!string.IsNullOrWhiteSpace(ConBusinessAddress2))
                    _businessAddress += ConBusinessAddress2 + Environment.NewLine;

                if (!string.IsNullOrWhiteSpace(ConBusinessCity))
                    _businessAddress += ConBusinessCity + ", ";

                _businessAddress += ConBusinessStateIdName + " " + ConBusinessZipPostal + Environment.NewLine + ConBusinessCountryIdName;

                return _businessAddress;
            }
        }
    }
}