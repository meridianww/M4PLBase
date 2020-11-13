#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kamal
// Date Programmed:                              11/12/2020
// Program Name:                                 IUserGuideUploadCommands
// Purpose:                                      Set of rules for UserGuideUploadCommands
//=============================================================================================================

using M4PL.APIClient.ViewModels.Administration;
namespace M4PL.APIClient.Administration
{
    public interface IUserGuideUploadCommands : IBaseCommands<UserGuidUploadView>
    {
        bool UploadUserGuide(UserGuidUploadView userGuidUploadView);
        bool GenerateKnowledgeDetail(UserGuidUploadView userGuidUploadView);
    }
}
