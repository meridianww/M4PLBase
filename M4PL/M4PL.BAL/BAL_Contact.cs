//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              11/4/2016
//Program Name:                                 Contact
//Purpose:                                      Business Logic specific to Contact
//
//==================================================================================================================================================== 

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;
using M4PL.DataAccess.DAL;

namespace M4PL_BAL
{
    public class BAL_Contact
    {
        /// <summary>
        /// Function to Save contact details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int InsertContactDetails(Contact contact)
        {
            return DAL_Contact.InsertContactDetails(contact);
        }

        /// <summary>
        /// Function to Update contact details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int UpdateContactDetails(Contact contact)
        {
            return DAL_Contact.UpdateContactDetails(contact);
        }

        /// <summary>
        /// Function to Delete contact details
        /// </summary>
        /// <param name="ContactID"></param>
        /// <returns></returns>
        public static int RemoveContact(int ContactID)
        {
            return DAL_Contact.RemoveContact(ContactID);
        }

        /// <summary>
        /// Function to get the details of selected contact
        /// </summary>
        /// <param name="ContactID"></param>
        /// <returns></returns>
        public static Contact GetContactDetails(int ContactID)
        {
            var res = DAL_Contact.GetContactDetails(ContactID);
            if (res != null && res.ConImage != null)
            {
                res.LstImages = res.ConImage.ToList();
                res.ConImage = null;
            }
            return res;
        }

        /// <summary>
        /// Function to get the list of all contacts
        /// </summary>
        /// <returns></returns>
        public static List<Contact> GetAllContacts(int UserId = 0)
        {
            return DAL_Contact.GetAllContacts(UserId);
        }
    }
}
