using System;
using System.Collections.Generic;
using System.Text;

namespace CosmosDbFun
{
    public class Assignment
    {
        /// <summary>
        /// Assignment Id
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// Grade
        /// </summary>
        public decimal Grade { get; set; }

        /// <summary>
        /// Is Assignment Late
        /// </summary>
        public bool IsLate { get; set; }
    }
}
