using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class QuestionBankGubun : Common
	{
		public QuestionBankGubun() { }

		public QuestionBankGubun(string rowState)
		{
			RowState = rowState;
		}

        [Display(Name = "구분번호")]
        public int Thread { get; set; }
        [Display(Name = "구분코드명")] 
        public string GubunCodeName { get; set; }
        [Display(Name = "상위코드")] 
        public int Depth { get; set; }
        [Display(Name = "그룹번호")] 
        public int GroupNo { get; set; }
       
		[Display(Name = "구분번호")]
		public int GubunNo { get; set; }
        [Display(Name = "문제유형")] 
        public string QuestionType { get; set; }
        [Display(Name = "관리레벨")] 
        public string ManageLevel { get; set; }

    }
}
