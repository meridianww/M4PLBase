#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kamal
// Date Programmed:                              12/11/2020
// Program Name:                                 UserGuideUploadCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.UserGuideUploadCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Administration.UserGuideUploadCommands;


namespace M4PL.Business.Administration
{
    public class UserGuideUploadCommands : BaseCommands<UserGuidUpload>, IUserGuideUploadCommands
    {
        public bool UploadUserGuide(UserGuidUpload userGuidUpload)
        {
            try
            {
                string directoryPath = ConfigurationManager.AppSettings["UserGuideFileDirectory"];
                if (!Directory.Exists(directoryPath))
                    return false;

                if (!string.IsNullOrEmpty(directoryPath))
                {
                    string filePath = string.Format(@"{0}/{1}", directoryPath, userGuidUpload.DocumentName);
                    if (File.Exists(filePath))
                        File.Delete(filePath);

                    using (File.Create(filePath)) { }
                    File.WriteAllBytes(filePath, userGuidUpload.FileContent);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception exp)
            {
                return false;
            }
        }
        /// <summary>
        /// GenerateKnowdlegeDetail
        /// </summary>
        /// <param name="userGuidUpload"></param>
        /// <returns></returns>
        public bool GenerateKnowledgeDetail(UserGuidUpload userGuidUpload)
        {
            return _commands.GenerateKnowledgeDetail(userGuidUpload);
        }
        #region common functiality 
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public UserGuidUpload Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<UserGuidUpload> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public UserGuidUpload Patch(UserGuidUpload entity)
        {
            throw new NotImplementedException();
        }

        public UserGuidUpload Post(UserGuidUpload entity)
        {
            throw new NotImplementedException();
        }

        public UserGuidUpload Put(UserGuidUpload entity)
        {
            throw new NotImplementedException();
        }
        #endregion
    }
}
