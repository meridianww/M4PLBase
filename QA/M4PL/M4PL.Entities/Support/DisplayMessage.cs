/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 DisplayMessage
Purpose:                                      Contains objects related to DisplayMessage
==========================================================================================================*/

using M4PL.Utilities;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Entities.Support
{
    public class DisplayMessage
    {
        /// <summary>
        /// Display Message class provides the generic information related of the fields in the module
        /// </summary>
        public DisplayMessage()
        {
            Operations = new List<Operation>();
        }

        public DisplayMessage(DisplayMessage displayMessage)
        {
            LangCode = displayMessage.LangCode;
            MessageType = displayMessage.MessageType;
            Code = displayMessage.Code;
            ScreenTitle = displayMessage.ScreenTitle;
            Title = displayMessage.Title;
            Description = displayMessage.Description;
            Instruction = displayMessage.Instruction;
            HeaderIcon = displayMessage.HeaderIcon;
            MessageTypeIcon = displayMessage.MessageTypeIcon;
            Operations = displayMessage.Operations;
            Route = displayMessage.Route;
        }

        /// <summary>
        /// Gets or sets the language type.
        /// </summary>
        /// <value>
        /// The LangCode.
        /// </value>
        public string LangCode { get; set; }

        /// <summary>
        /// Gets or sets the message type.
        /// </summary>
        /// <value>
        /// The MessageType.
        /// </value>
        public string MessageType { get; set; }

        /// <summary>
        /// Gets or sets the type of message.
        /// </summary>
        /// <value>
        /// The Code.
        /// </value>
        public string Code { get; set; }

        /// <summary>
        /// Gets or sets the screen title.
        /// </summary>
        /// <value>
        /// The ScreenTitle.
        /// </value>
        public string ScreenTitle { get; set; }

        /// <summary>
        /// Gets or sets the display type.
        /// </summary>
        /// <value>
        /// The Title.
        /// </value>
        public string Title { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The Description.
        /// </value>
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets the instruction.
        /// </summary>
        /// <value>
        /// The Instruction.
        /// </value>
        public string Instruction { get; set; }

        /// <summary>
        /// Gets or sets the header icon.
        /// </summary>
        /// <value>
        /// The HeaderIcon.
        /// </value>
        public byte[] HeaderIcon { get; set; }

        /// <summary>
        /// Gets or sets the Message Type icon.
        /// </summary>
        /// <value>
        /// The MessageTypeIcon.
        /// </value>
        public byte[] MessageTypeIcon { get; set; }

        /// <summary>
        /// Gets or sets the type of message operation.
        /// </summary>
        /// <value>
        /// The MessageOperation.
        /// </value>
        public string MessageOperation { get; set; }

        public IList<Operation> Operations { get; set; }

        public List<string> OperationIds
        {
            get
            {
                return !string.IsNullOrEmpty(MessageOperation) ? MessageOperation.SplitComma().ToList() : new List<string>();
            }
        }

        public MvcRoute Route { get; set; }
        public string CloseType { get; set; }
        public string GatewayStatusCode { get; set; }
        public string JobOriginActual { get; set; }
    }
}