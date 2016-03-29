//------------------------------------------------------------------------------ 
// <copyright file="IModel.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Data;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    /// This interface should be implemented by all models. 
    /// It does not specify any methods that need to be implemented.
    /// Its sole purpose is to give all model implementations a common type.
    /// </summary>
    public interface IModel : IServerType
    {
        /// <summary>
        ///     Gets a value indicating whether current object 
        ///     is a new object or existing object. 
        /// </summary>
        bool IsNew
        {
            get;
        }
    }
}
