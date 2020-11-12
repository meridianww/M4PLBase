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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IJobCommands
// Purpose:                                      Set of rules for JobCommands
//==============================================================================================================

using M4PL.Entities.Administration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.Administration
{
    public interface IUserGuideUploadCommands : IBaseCommands<UserGuidUpload>
    {
        /// <summary>
        /// UploadUserGuide
        /// </summary>
        /// <param name="userGuidUpload"></param>
        /// <returns></returns>
        bool UploadUserGuide(UserGuidUpload userGuidUpload);
        /// <summary>
        /// GenerateKnowdlegeDetail
        /// </summary>
        /// <param name="userGuidUpload"></param>
        /// <returns></returns>
        bool GenerateKnowledgeDetail(UserGuidUpload userGuidUpload);
    }
}
