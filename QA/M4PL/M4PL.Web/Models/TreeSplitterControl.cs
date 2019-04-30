/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 TreeSplitterControl
//Purpose:                                      Represents description for TreeSplitterControl
//====================================================================================================================================================*/

using M4PL.Entities.Support;

namespace M4PL.Web.Models
{
    public class TreeSplitterControl
    {
        public MvcRoute MenuRoute { get; set; }

        public MvcRoute TreeRoute { get; set; }

        public string SecondPaneControlName { get; set; }

        public MvcRoute ContentRoute { get; set; }
    }
}