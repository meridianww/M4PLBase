/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ContactCommands
Purpose:                                      Client to consume M4PL API called ContactController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Contact;

namespace M4PL.APIClient.Contact
{
    /// <summary>
    /// Route to call Contacts
    /// </summary>
    public class ConReportCommands : BaseCommands<ConReportView>, IConReportCommands
    {
        public override string RouteSuffix
        {
            get { return "ConReports"; }
        }
    }
}