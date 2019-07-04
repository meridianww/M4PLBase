/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              20/06/2019
//====================================================================================================================================================*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Utilities
{
	/// <summary>
	/// This is a base class which provides the basic properties.
	/// </summary>
	public abstract class MappingAttribute : Attribute
	{
		/// <summary>
		/// Gets the name of the field.
		/// </summary>
		/// <value>
		/// The name.
		/// </value>
		public string Name { get; private set; }

		/// <summary>
		/// Gets a value indicating whether this instance is identifier.
		/// </summary>
		/// <value>
		/// <c>true</c> if this instance is identifier; otherwise, <c>false</c>.
		/// </value>
		public bool IsId { get; private set; }

		/// <summary>
		/// Gets a value indicating whether this instance is identity.
		/// </summary>
		/// <value>
		/// <c>true</c> if this instance is identity; otherwise, <c>false</c>.
		/// </value>
		public bool IsIdentity { get; private set; }

		/// <summary>
		/// Initializes a new instance of the <see cref="MappingAttribute"/> class.
		/// </summary>
		/// <param name="name">The name.</param>
		public MappingAttribute(string name)
			: this(name, false, false)
		{
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MappingAttribute"/> class.
		/// </summary>
		/// <param name="name">The name.</param>
		/// <param name="id">if set to <c>true</c> [identifier].</param>
		/// <param name="identity">if set to <c>true</c> [identity].</param>
		public MappingAttribute(string name, bool id = false, bool identity = false)
		{
			Name = name;
			IsId = id;
			IsIdentity = identity;
		}
	}
}
