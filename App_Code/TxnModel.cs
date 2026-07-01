using System;

namespace CMS.Models
{
    public class TxnModel
    {
        public int txn_id { get; set; }
        public string mobile { get; set; }
        public decimal amount { get; set; }
        public string status { get; set; }
        public string created_on { get; set; }
    }
}