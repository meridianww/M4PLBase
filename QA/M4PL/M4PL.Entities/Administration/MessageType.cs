#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 MessageType
// Purpose:                                      Contains objects related to MessageType
//==========================================================================================================

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Entities for Message Type will contain objects related to Message Type
    /// </summary>
    public class MessageType : BaseModel
    {
        /// <summary>
        /// Gets or sets the message type title.
        /// </summary>
        /// <value>
        /// The SysMsgtypeTitle.
        /// </value>
        public string SysMsgtypeTitle { get; set; }

        /// <summary>
        /// Gets or sets the message type description.
        /// </summary>
        /// <value>
        /// The SysMsgTypeDescription.
        /// </value>
        public byte[] SysMsgTypeDescription { get; set; }

        /// <summary>
        /// Gets or sets the message type header icon.
        /// </summary>
        /// <value>
        /// The SysMsgTypeHeaderIcon.
        /// </value>
        public byte[] SysMsgTypeHeaderIcon { get; set; }

        /// <summary>
        /// Gets or sets the message type icon.
        /// </summary>
        /// <value>
        /// The SysMsgTypeIcon.
        /// </value>
        public byte[] SysMsgTypeIcon { get; set; }
    }
}