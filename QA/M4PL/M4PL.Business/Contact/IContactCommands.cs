/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IContactCommands
Purpose:                                      Set of rules for ContactCommands
=============================================================================================================*/

namespace M4PL.Business.Contact
{
    /// <summary>
    /// Performs basic CRUD operation on the  Contact Entity
    /// </summary>
    public interface IContactCommands : IBaseCommands<Entities.Contact.Contact>
    {
        Entities.Contact.Contact PutContactCard(Entities.Contact.Contact contact);
        Entities.Contact.Contact PostContactCard(Entities.Contact.Contact contact);

        bool CheckContactLoggedIn(long contactId);
    }
}