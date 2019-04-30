/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              26/07/2018
Program Name:                                 ScnCargoBCPhotoCommands
Purpose:                                      Client to consume M4PL API called ScnCargoBCPhotoController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnCargoBCPhotoCommands : BaseCommands<ViewModels.Scanner.ScnCargoBCPhotoView>, IScnCargoBCPhotoCommands
    {
        /// <summary>
        /// Route to call ScrCatalogList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnCargoBCPhotos"; }
        }
    }
}