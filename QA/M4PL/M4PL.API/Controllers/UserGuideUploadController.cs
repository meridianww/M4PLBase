#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kamal
//Date Programmed:                              12/12/2020
//Program Name:                                 UserGuideUpload
//Purpose:                                      End point to interact with UserGuideUpload module
//====================================================================================================================================================*/


using M4PL.API.Filters;
using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// UserGuideUploadController
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/UserGuideUpload")]
    public class UserGuideUploadController : ApiController
    {
        private readonly IUserGuideUploadCommands _userGuideUploadCommands;
        /// <summary>
        /// UserGuideUploadController
        /// </summary>
        /// <param name="userGuideUploadCommands"></param>
        public UserGuideUploadController(IUserGuideUploadCommands userGuideUploadCommands)
        {
            _userGuideUploadCommands = userGuideUploadCommands;
        }

        /// <summary>
        /// Uploads PDF files i.e. User Guide
        /// </summary>
        /// <param name="userGuidUpload"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("UploadUserGuide")]
        public bool UploadUserGuide()
        {
            UserGuidUpload userGuidUpload = new UserGuidUpload();
            var streamProvider = new MultipartMemoryStreamProvider();
            var strByteArray = HttpContext.Current.Request.Form["application/json"];
            var postedFile = HttpContext.Current.Request.Files["PostedFile"];
            if (!string.IsNullOrEmpty(strByteArray) && postedFile != null && postedFile.ContentLength > 0)
            {
                using (BinaryReader binaryReader = new BinaryReader(postedFile.InputStream))
                {
                    int bytesToRead = postedFile.ContentLength;
                    userGuidUpload.DocumentName = postedFile.FileName;
                    userGuidUpload.FileContent = binaryReader.ReadBytes(bytesToRead);
                }
            }

            return _userGuideUploadCommands.UploadUserGuide(userGuidUpload);
        }
        /// <summary>
        /// Insert Knowledge details by PDF name
        /// </summary>
        /// <param name="userGuidUpload"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("GenerateKnowledgeDetail")]
        public bool GenerateKnowledgeDetail(UserGuidUpload userGuidUpload)
        {
            _userGuideUploadCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _userGuideUploadCommands.GenerateKnowledgeDetail(userGuidUpload);
        }
    }
}
