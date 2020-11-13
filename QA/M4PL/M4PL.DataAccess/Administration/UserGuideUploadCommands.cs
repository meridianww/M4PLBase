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
// Date Programmed:                              12/11/2020
// Program Name:                                 UserGuideUploadCommands
// Purpose:                                      Contains commands to perform CRUD on User Guide upload PDF Documents
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class UserGuideUploadCommands : BaseCommands<UserGuidUpload>
    {
        public static bool GenerateKnowledgeDetail(UserGuidUpload userGuidUpload)
        {
            bool result = false;
            var response = 0;
            var fileName = string.Empty;
            int fileExtPos = userGuidUpload.DocumentName.LastIndexOf(".");
            if (fileExtPos >= 0)
                fileName = userGuidUpload.DocumentName.Substring(0, fileExtPos);
            var parameters = new[]
            {
                new Parameter("@DocumentName", userGuidUpload.DocumentName),
                new Parameter("@Url", userGuidUpload.Url),
                new Parameter("@FileName", fileName)
            };

            try
            {
                response = SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.InsKnowledgeDetail, parameters, true, true);
                if (response > 0)
                    result = true;
            }
            catch (Exception exp)
            {
                result = false;
            }
            return result;
        }
    }
}
