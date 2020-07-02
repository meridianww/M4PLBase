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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ValidationCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.ValidationCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.ValidationCommands;

namespace M4PL.Business.Administration
{
    public class ValidationCommands : BaseCommands<Validation>, IValidationCommands
    {
        /// <summary>
        /// Get list of validations data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Validation> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific validation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Validation Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new validation record
        /// </summary>
        /// <param name="validation"></param>
        /// <returns></returns>

        public Validation Post(Validation validation)
        {
            return _commands.Post(ActiveUser, validation);
        }

        /// <summary>
        ///  Updates an existing validation record
        /// </summary>
        /// <param name="validation"></param>
        /// <returns></returns>

        public Validation Put(Validation validation)
        {
            return _commands.Put(ActiveUser, validation);
        }

        /// <summary>
        /// Deletes a specific validation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of validations record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public Validation Patch(Validation entity)
        {
            throw new NotImplementedException();
        }
    }
}