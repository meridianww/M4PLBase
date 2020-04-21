/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 EnumTypeModelDescription
//Purpose:                                      Represents description for Enums
//====================================================================================================================================================*/

using System.Collections.ObjectModel;

namespace M4PL.API.Areas.HelpPage.ModelDescriptions
{
    /// <summary>
    /// EnumTypeModelDescription
    /// </summary>
    public class EnumTypeModelDescription : ModelDescription
    {
        /// <summary>
        /// EnumTypeModelDescription
        /// </summary>
        public EnumTypeModelDescription()
        {
            Values = new Collection<EnumValueDescription>();
        }

        /// <summary>
        /// Values
        /// </summary>
        public Collection<EnumValueDescription> Values { get; private set; }
    }
}