/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ValidationCommands
Purpose:                                      Client to consume M4PL API called ValidationController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    public class ValidationCommands : BaseCommands<ValidationView>, IValidationCommands
    {
        /// <summary>
        /// Route to call validations
        /// </summary>
        public override string RouteSuffix
        {
            get { return "Validations"; }
        }
    }
}