/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Validation
Purpose:                                      Contains objects related to Validation
==========================================================================================================*/

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Validation class to store basic validations for system entities
    /// </summary>
    public class Validation : BaseModel
    {
        /// <summary>
        /// Gets or sets the validation for the specified table name.
        /// </summary>
        /// <value>
        /// The ValTableName.
        /// </value>
        ///
        public string ValTableName { get; set; }

        /// <summary>
        /// Gets or sets the referred table page identifier.
        /// </summary>
        /// <value>
        /// The RefTabPageId.
        /// </value>
        public long? RefTabPageId { get; set; }

        public string RefTabPageIdName { get; set; }

        /// <summary>
        /// Gets or sets the validation for column of the selected table.
        /// </summary>
        /// <value>
        /// The ValFieldName.
        /// </value>
        public string ValFieldName { get; set; }

        /// <summary>
        /// Gets or sets the validation whether the validation is required or not.
        /// </summary>
        /// <value>
        /// The ValRequired.
        /// </value>
        public bool ValRequired { get; set; }

        /// <summary>
        /// Gets or sets the required message, when the column
        /// has required validation option.
        /// </summary>
        /// <value>
        /// The ValRequiredMessage.
        /// </value>
        public string ValRequiredMessage { get; set; }

        /// <summary>
        /// Gets or sets the user input has to be unique or not
        /// </summary>
        /// <value>
        /// The ValUnique.
        /// </value>
        public bool ValUnique { get; set; }

        /// <summary>
        /// Gets or sets the validation message for the user's input uniqueness,
        /// when the column has the unique validation
        /// </summary>
        /// <value>
        /// The ValUniqueMessage.
        /// </value>
        public string ValUniqueMessage { get; set; }

        /// <summary>
        /// Gets or sets logic which has to be perfomed on the user input
        /// </summary>
        /// <value>
        /// The ValRegExLogic5.
        /// </value>
        //public string ValRegExLogic5 { get; set; }
        public int? ValRegExLogic0 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegEx1.
        /// </value>
        public string ValRegEx1 { get; set; }

        /// <summary>
        /// Gets or sets message when the user input fail to match the expected pattern
        /// </summary>
        /// <value>
        /// The ValRegExMessage1.
        /// </value>
        public string ValRegExMessage1 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegExLogic1.
        /// </value>
        public int? ValRegExLogic1 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegEx2.
        /// </value>
        public string ValRegEx2 { get; set; }

        /// <summary>
        /// Gets or sets message when the user input fail to match the expected pattern
        /// </summary>
        /// <value>
        /// The ValRegExMessage2.
        /// </value>
        public string ValRegExMessage2 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegExLogic2.
        /// </value>
        public int? ValRegExLogic2 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegEx3.
        /// </value>
        public string ValRegEx3 { get; set; }

        /// <summary>
        /// Gets or sets message when the user input fail to match the expected pattern
        /// </summary>
        /// <value>
        /// The ValRegExMessage3.
        /// </value>
        public string ValRegExMessage3 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegExLogic3.
        /// </value>
        public int? ValRegExLogic3 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegEx4.
        /// </value>
        public string ValRegEx4 { get; set; }

        /// <summary>
        /// Gets or sets message when the user input fail to match the expected pattern
        /// </summary>
        /// <value>
        /// The ValRegExMessage4.
        /// </value>
        public string ValRegExMessage4 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegExLogic4.
        /// </value>
        public int? ValRegExLogic4 { get; set; }

        /// <summary>
        /// Gets or sets regular expression(defines the pattern) for the user input
        /// </summary>
        /// <value>
        /// The ValRegEx5.
        /// </value>
        public string ValRegEx5 { get; set; }

        /// <summary>
        /// Gets or sets message when the user input fail to match the expected pattern
        /// </summary>
        /// <value>
        /// The ValRegExMessage5.
        /// </value>
        public string ValRegExMessage5 { get; set; }
    }
}