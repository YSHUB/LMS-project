using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    public class Code : Common
    {
        public Code() { }

        public Code(string rowState)
        {
            RowState = rowState;
        }

        public Code(string rowState, string[] classcode)
        {
            RowState = rowState;

            foreach (var item in classcode)
            {
                ClassCode += ClassCode != null ? "|" + item : item;
            }
        }

        [Display(Name = "코드 값")]
        public String CodeValue { get; set; }

        [Display(Name = "분류 코드")]
        public String ClassCode { get; set; }

        [Display(Name = "코드 이름")]
        public String CodeName { get; set; }

        [Display(Name = "비고")]
        public String Remark { get; set; }

        [Display(Name ="연번")]
        public int No { get; set; }

        
    }
}
