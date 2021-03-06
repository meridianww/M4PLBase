﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright


//
////====================================================================================================================================================
//// Program Title:                                Meridian 4th Party Logistics(M4PL)
//// Programmer:                                   Prashant Aggarwal
//// Date Programmed:                              20/06/2019
////====================================================================================================================================================

using System;

namespace M4PL.Utilities
{
    /// <summary>
    ///
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public class PropertyMappingAttribute : MappingAttribute
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="PropertyMappingAttribute"/> class.
        /// </summary>
        /// <param name="name">The name.</param>
        public PropertyMappingAttribute(string name)
            : base(name, false, false)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="PropertyMappingAttribute"/> class.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="id">if set to <c>true</c> [identifier].</param>
        /// <param name="identity">if set to <c>true</c> [identity].</param>
        public PropertyMappingAttribute(string name, bool id = false, bool identity = false)
            : base(name, id, identity)
        {
        }
    }
}
