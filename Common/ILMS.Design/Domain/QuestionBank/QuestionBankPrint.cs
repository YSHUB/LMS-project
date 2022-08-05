using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class QuestionBankPrint : Common
	{
		public QuestionBankPrint() { }

		public QuestionBankPrint(string rowState)
		{
			RowState = rowState;
		}

		public string QAGubun { get; set; }
		public int GubunNo { get; set; }
		public int QuestionBankNo { get; set; }
		[Display(Name ="예제번호")]
		public int ExampleNo { get; set; }

		[Display(Name = "내용")]
		public string Contents { get; set; }

		[Display(Name = "정답여부")]
		public string CorrectAnswerYesNo { get; set; }

		[Display(Name = "")]
		public int AnswerCount { get; set; }

		public int RowNo { get; set; }
		public string QuestionType { get; set; }
		public string SaveFileName { get; set; }

	}
}
