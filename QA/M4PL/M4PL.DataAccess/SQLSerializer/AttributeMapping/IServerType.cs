#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
    /// <summary>
    ///     Base class for server types, Database server type property
    ///     should be implemented in all derived classes.
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
        ServerTypes DatabaseServerType { get; set; }
    }
}