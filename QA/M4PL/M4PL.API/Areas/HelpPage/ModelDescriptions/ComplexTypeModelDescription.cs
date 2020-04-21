/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 ComplexTypeModelDescription
//Purpose:                                      Represents description for complex type
//====================================================================================================================================================*/

using System.Collections.ObjectModel;

namespace M4PL.API.Areas.HelpPage.ModelDescriptions
{
    /// <summary>
    /// ComplexTypeModelDescription
    /// </summary>
    public class ComplexTypeModelDescription : ModelDescription
    {
        /// <summary>
        /// ComplexTypeModelDescription
        /// </summary>
        public ComplexTypeModelDescription()
        {
            Properties = new Collection<ParameterDescription>();
        }

        /// <summary>
        /// Properties
        /// </summary>
        public Collection<ParameterDescription> Properties { get; private set; }
    }
}