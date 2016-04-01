//------------------------------------------------------------------------------ 
// <copyright file="IModel.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    ///     Base class for server types, Database server type property 
    ///     should be implemented in all derived classes.
    ///     
    ///     Created By : Subin K.J             	Create Date : 07/08/2013
    ///     Modified By : Name              Modified Date : mm/dd/yyyy
    ///     ----------------------------------------------------------
    ///     Change Comment
    ///     ----------------------------------------------------------
    /// </summary>
    public interface IServerType
    {
        /// <summary>
        ///     Gets or sets type of server attached 
        ///     with this dto or business model.
        /// </summary>
        ServerTypes DatabaseServerType
        {
            get;
            set;
        }
    }
}
