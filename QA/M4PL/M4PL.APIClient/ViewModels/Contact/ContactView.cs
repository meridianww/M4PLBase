#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              13/10/2017
// Program Name:                                 ContactView
// Purpose:                                      Represents Contact Details
//====================================================================================================================================================

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