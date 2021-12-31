using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace CosmosDbFun
{
    public class StudentClassRecord
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }

        /// <summary>
        /// ClassId
        /// </summary>
        public string ClassId { get; set; }

        /// <summary>
        /// Assignment list
        /// </summary>
        public List<Assignment> Assignments { get; set; }

    }
}
