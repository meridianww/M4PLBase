/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              26/06/2019
//====================================================================================================================================================*/

namespace M4PL.Utilities
{
    public interface ICloneable<T>
    {
        /// <summary>
        /// Creats a copy of this object
        /// </summary>
        /// <returns>The copy</returns>
        T Clone();
    }
}
