﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL.Entities;
using M4PL_BAL;

namespace M4PL_API.Controllers
{
	public class UserController : ApiController
	{
		// GET api/<controller>
		public List<User> Get()
		{
			return BAL_User.GetAllUserAccounts();
		}

		//GET api/<controller>/5
		public User Get(int UserID)
		{
			return BAL_User.GetUserAccount(UserID);
		}

		// POST api/<controller>
		public int Post(User value)
		{
			return BAL_User.SaveUserAccount(value);
		}

		// PUT api/<controller>/5
		public int Put(int UserID, User value)
		{
			return BAL_User.SaveUserAccount(value);
		}

		// DELETE api/<controller>/5
		public int Delete(int UserID)
		{
			return BAL_User.RemoveUserAccount(UserID);
		}

		public User GetLogin(string emailId, string password)
		{
			return new User
			{
				Email = emailId,
				IsValidUser = BAL_User.AuthenticateUser(emailId, password)
			};
		}


	}
}