﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustBusinessTermCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustBusinessTermCommands
===================================================================================================================*/

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustBusinessTermCommands;

namespace M4PL.Business.Customer
{
    public class CustBusinessTermCommands : BaseCommands<CustBusinessTerm>, ICustBusinessTermCommands
    {
        /// <summary>
        /// Get list of customer business terms data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<CustBusinessTerm> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific customer business term record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public CustBusinessTerm Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new customer business term record
        /// </summary>
        /// <param name="custBusinessTerm"></param>
        /// <returns></returns>

        public CustBusinessTerm Post(CustBusinessTerm custBusinessTerm)
        {
            return _commands.Post(ActiveUser, custBusinessTerm);
        }

        /// <summary>
        /// Updates an existing customer business term record
        /// </summary>
        /// <param name="custBusinessTerm"></param>
        /// <returns></returns>

        public CustBusinessTerm Put(CustBusinessTerm custBusinessTerm)
        {
            return _commands.Put(ActiveUser, custBusinessTerm);
        }

        /// <summary>
        /// Deletes a specific customer business term record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of customer business term records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public CustBusinessTerm Patch(CustBusinessTerm entity)
        {
            throw new NotImplementedException();
        }
    }
}