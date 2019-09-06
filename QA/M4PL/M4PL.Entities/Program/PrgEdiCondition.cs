/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil Chauhan
Date Programmed:                              20/08/2019
Program Name:                                 PrgEdiCondition
Purpose:                                      Contains objects related to PrgEdiCondition
==========================================================================================================*/

namespace M4PL.Entities.Program
{
    public  class PrgEdiCondition : BaseModel
    {
        /// <summary>
        /// Gets or sets the Program identifier.
        /// </summary>
        /// <value>
        /// The  Parent  Program identifier.
        /// </value>

        public long? PecParentProgramId { get; set; }

        public string PecParentProgramIdName { get; set; }

        /// <summary>
        /// Gets or sets the Edi header  identifier.
        /// </summary>
        /// <value>
        /// The  Edi header identifier.
        /// </value>
        public long? PecProgramId { get; set; }

        public string PecProgramIdName { get; set; }

        /// <summary>
        /// Gets or sets the PecJobField.
        /// </summary>
        /// <value>
        /// The JobField1.
        /// </value>
        public string PecJobField { get; set; }

        /// <summary>
        /// Gets or sets the PecCondition.
        /// </summary>
        /// <value>
        /// The Condition1.
        /// </value>
        public string PecCondition { get; set; }

        /// <summary>
        /// Gets or sets the PerLogical.
        /// </summary>
        /// <value>
        /// The Logical.
        /// </value>
        public string PerLogical { get; set; }

        /// <summary>
        /// Gets or sets the PecJobField2.
        /// </summary>
        /// <value>
        /// The JobField2.
        /// </value>
        public string PecJobField2 { get; set; }

        /// <summary>

        /// <summary>
        /// Gets or sets the PecCondition2
        /// </summary>
        /// <value>
        /// The Condition2.
        /// </value>
        public string PecCondition2 { get; set; }
      
    }
}
